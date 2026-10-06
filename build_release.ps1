param(
    [ValidateSet('apk', 'appbundle')]
    [string]$Artifact = 'apk',
    [string]$BuildName = '1.0.0',
    [ValidatePattern('^[1-9][0-9]*$')]
    [string]$BuildNumber = '1'
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($env:SUPABASE_URL)) {
    throw 'SUPABASE_URL is required to build a release artifact.'
}

if ([string]::IsNullOrWhiteSpace($env:SUPABASE_ANON_KEY)) {
    throw 'SUPABASE_ANON_KEY is required to build a release artifact.'
}

if ($env:SUPABASE_URL -notmatch '^https://[^/]+\.supabase\.co$') {
    throw 'SUPABASE_URL must be an HTTPS Supabase project URL.'
}

$requiredSigningVariables = @(
    'NUTRIWALLET_KEYSTORE_PATH',
    'NUTRIWALLET_KEYSTORE_PASSWORD',
    'NUTRIWALLET_KEY_ALIAS',
    'NUTRIWALLET_KEY_PASSWORD'
)
foreach ($variable in $requiredSigningVariables) {
    if ([string]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable($variable))) {
        throw "$variable is required for a production release build."
    }
}

if (!(Test-Path -LiteralPath $env:NUTRIWALLET_KEYSTORE_PATH -PathType Leaf)) {
    throw 'NUTRIWALLET_KEYSTORE_PATH does not point to a keystore file.'
}

$buildTarget = if ($Artifact -eq 'appbundle') { 'appbundle' } else { 'apk' }
$env:NUTRIWALLET_RELEASE_BUILD = 'true'

flutter pub get

flutter build $buildTarget --release `
    --build-name=$BuildName `
    --build-number=$BuildNumber `
    --dart-define="SUPABASE_URL=$env:SUPABASE_URL" `
    --dart-define="SUPABASE_ANON_KEY=$env:SUPABASE_ANON_KEY"

$artifactPath = if ($Artifact -eq 'appbundle') {
    'build\app\outputs\bundle\release\app-release.aab'
} else {
    'build\app\outputs\flutter-apk\app-release.apk'
}

if (!(Test-Path -LiteralPath $artifactPath -PathType Leaf)) {
    throw "Release artifact was not created: $artifactPath"
}

$artifact = Get-Item -LiteralPath $artifactPath
if ($artifact.Length -le 0) {
    throw "Release artifact is empty: $artifactPath"
}

if ($Artifact -eq 'apk') {
    $apksigner = Get-Command apksigner -ErrorAction SilentlyContinue
    if ($null -eq $apksigner) {
        $sdkRoots = @(
            $env:ANDROID_SDK_ROOT,
            $env:ANDROID_HOME,
            "$env:LOCALAPPDATA\Android\Sdk"
        ) | Where-Object { $_ -and (Test-Path -LiteralPath $_) }
        $apksignerPath = $sdkRoots |
            ForEach-Object {
                Get-ChildItem -LiteralPath $_ -Filter apksigner.bat -Recurse `
                    -ErrorAction SilentlyContinue
            } |
            Select-Object -First 1
        if ($null -eq $apksignerPath) {
            throw 'apksigner is required to verify the release APK.'
        }
        $apksigner = @{ Source = $apksignerPath.FullName }
    }
    $certificate = & $apksigner.Source verify --verbose --print-certs $artifactPath |
        Out-String
    if ($LASTEXITCODE -ne 0) {
        throw 'The release APK signature could not be verified.'
    }
    if ($certificate -match 'Android Debug') {
        throw 'Release APK is signed with the Android debug certificate.'
    }
} else {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [System.IO.Compression.ZipFile]::OpenRead($artifactPath)
    try {
        $entryNames = $archive.Entries.FullName
        foreach ($requiredEntry in @(
            'BundleConfig.pb',
            'base/manifest/AndroidManifest.xml'
        )) {
            if ($entryNames -notcontains $requiredEntry) {
                throw "Release App Bundle is missing $requiredEntry."
            }
        }
    } finally {
        $archive.Dispose()
    }
    $bundletool = Get-Command bundletool -ErrorAction SilentlyContinue
    if ($null -ne $bundletool) {
        & $bundletool.Source validate --bundle=$artifactPath
        if ($LASTEXITCODE -ne 0) {
            throw 'bundletool rejected the release App Bundle.'
        }
    } else {
        Write-Warning 'bundletool is not installed; App Bundle validation used ZIP structure only.'
    }
}

Write-Output "Artifact: $artifactPath"
Write-Output "Size: $($artifact.Length) bytes"
Write-Output "SHA-256: $((Get-FileHash -LiteralPath $artifactPath -Algorithm SHA256).Hash)"
