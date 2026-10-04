import 'package:supabase_flutter/supabase_flutter.dart';

class AuthResult {
  const AuthResult.success(this.email)
    : error = null,
      requiresEmailConfirmation = false;
  const AuthResult.confirmationRequired(this.email)
    : error = null,
      requiresEmailConfirmation = true;
  const AuthResult.failure(this.error)
    : email = null,
      requiresEmailConfirmation = false;

  final String? email;
  final String? error;
  final bool requiresEmailConfirmation;
  bool get isSuccess => email != null && !requiresEmailConfirmation;
}

abstract interface class AuthRepository {
  String? get currentEmail;
  Future<AuthResult> register(String email, String password);
  Future<AuthResult> signIn(String email, String password);
  Future<void> resendSignupConfirmation(String email);
  Future<void> signOut();
}

class CloudAuthResponse {
  const CloudAuthResponse({required this.email, required this.hasSession});

  final String? email;
  final bool hasSession;
}

abstract interface class CloudAuthGateway {
  String? get currentEmail;
  Future<CloudAuthResponse> signUp(String email, String password);
  Future<CloudAuthResponse> signIn(String email, String password);
  Future<void> resendSignupConfirmation(String email);
  Future<void> signOut();
}

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(SupabaseClient client)
    : this.withGateway(_SupabaseAuthGateway(client));

  SupabaseAuthRepository.withGateway(this._gateway);

  final CloudAuthGateway _gateway;

  @override
  String? get currentEmail => _gateway.currentEmail;

  @override
  Future<AuthResult> register(String email, String password) async {
    final normalized = _normalizeEmail(email);
    if (normalized == null || password.length < 8) {
      return const AuthResult.failure(
        'Check your email and use at least 8 characters for your password.',
      );
    }
    try {
      final response = await _gateway.signUp(normalized, password);
      if (!response.hasSession) {
        return AuthResult.confirmationRequired(response.email ?? normalized);
      }
      return AuthResult.success(response.email ?? normalized);
    } catch (error) {
      return AuthResult.failure(
        error is AuthException
            ? friendlyAuthErrorMessage(error.message)
            : 'Unable to create account. Check your details and try again.',
      );
    }
  }

  @override
  Future<AuthResult> signIn(String email, String password) async {
    final normalized = _normalizeEmail(email);
    if (normalized == null || password.isEmpty) {
      return const AuthResult.failure('Invalid email or password.');
    }
    try {
      final response = await _gateway.signIn(normalized, password);
      if (!response.hasSession) {
        return const AuthResult.failure(
          'Confirm your email address before signing in.',
        );
      }
      return AuthResult.success(response.email ?? normalized);
    } catch (error) {
      return AuthResult.failure(
        error is AuthException
            ? friendlyAuthErrorMessage(error.message)
            : 'Invalid email or password.',
      );
    }
  }

  @override
  Future<void> resendSignupConfirmation(String email) async {
    final normalized = _normalizeEmail(email);
    if (normalized == null) throw const FormatException('Malformed email');
    await _gateway.resendSignupConfirmation(normalized);
  }

  @override
  Future<void> signOut() => _gateway.signOut();
}

class _SupabaseAuthGateway implements CloudAuthGateway {
  _SupabaseAuthGateway(this._client);

  final SupabaseClient _client;

  @override
  String? get currentEmail => _client.auth.currentUser?.email;

  @override
  Future<CloudAuthResponse> signUp(String email, String password) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    return CloudAuthResponse(
      email: response.user?.email,
      hasSession: response.session != null,
    );
  }

  @override
  Future<CloudAuthResponse> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return CloudAuthResponse(
      email: response.user?.email,
      hasSession: response.session != null,
    );
  }

  @override
  Future<void> resendSignupConfirmation(String email) async {
    await _client.auth.resend(type: OtpType.signup, email: email);
  }

  @override
  Future<void> signOut() => _client.auth.signOut();
}

String? _normalizeEmail(String value) {
  final normalized = value.trim().toLowerCase();
  return normalized.contains('@') && normalized.length >= 5 ? normalized : null;
}

String friendlyAuthErrorMessage(String message) {
  final normalized = message.toLowerCase();
  if (normalized.contains('already registered') ||
      normalized.contains('already exists')) {
    return 'An account with this email already exists. Try signing in.';
  }
  if (normalized.contains('signup') && normalized.contains('disabled')) {
    return 'Account creation is disabled for this project.';
  }
  if (normalized.contains('rate limit') || normalized.contains('too many')) {
    return 'Too many attempts. Wait a moment and try again.';
  }
  if (normalized.contains('failed host lookup') ||
      normalized.contains('socketexception') ||
      normalized.contains('no address associated with hostname')) {
    return 'Cannot reach Supabase. Check the device internet connection and try again.';
  }
  if (normalized.contains('email') && normalized.contains('confirm')) {
    return 'Confirm your email address before signing in.';
  }
  if (normalized.contains('password')) {
    return 'That password was rejected. Use at least 8 characters.';
  }
  if (normalized.contains('api key') || normalized.contains('invalid key')) {
    return 'The Supabase project key is invalid. Rebuild with the current public key.';
  }
  if (message.trim().isEmpty) {
    return 'Unable to contact authentication. Check your connection and try again.';
  }
  return 'Authentication failed: ${message.trim()}';
}
