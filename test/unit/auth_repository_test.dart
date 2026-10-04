import 'package:flutter_test/flutter_test.dart';

import 'package:nutriwallet/data/repositories/auth_repository.dart';

void main() {
  test('malformed cloud sign-in returns a plain-language failure', () async {
    final repository = SupabaseAuthRepository.withGateway(
      _FakeCloudAuthGateway(),
    );

    final result = await repository.signIn('not-an-email', 'short');

    expect(result.isSuccess, isFalse);
    expect(result.error, 'Invalid email or password.');
  });

  test('maps common Supabase signup errors to actionable messages', () {
    expect(
      friendlyAuthErrorMessage('User already registered'),
      'An account with this email already exists. Try signing in.',
    );
    expect(
      friendlyAuthErrorMessage('Email confirmation required'),
      'Confirm your email address before signing in.',
    );
  });

  test('cloud signup without a session requires email confirmation', () async {
    final gateway = _FakeCloudAuthGateway(
      signupResponse: const CloudAuthResponse(email: null, hasSession: false),
    );
    final repository = SupabaseAuthRepository.withGateway(gateway);

    final result = await repository.register(
      ' New@Example.com ',
      'password123',
    );

    expect(result.isSuccess, isFalse);
    expect(result.requiresEmailConfirmation, isTrue);
    expect(result.email, 'new@example.com');
    expect(gateway.signupEmail, 'new@example.com');
  });

  test('cloud signup with a session completes authentication', () async {
    final repository = SupabaseAuthRepository.withGateway(
      _FakeCloudAuthGateway(
        signupResponse: const CloudAuthResponse(
          email: 'person@example.com',
          hasSession: true,
        ),
      ),
    );

    final result = await repository.register(
      'person@example.com',
      'password123',
    );

    expect(result.isSuccess, isTrue);
    expect(result.requiresEmailConfirmation, isFalse);
    expect(result.email, 'person@example.com');
  });

  test('cloud sign-in requires a session before continuing', () async {
    final repository = SupabaseAuthRepository.withGateway(
      _FakeCloudAuthGateway(
        signinResponse: const CloudAuthResponse(
          email: 'person@example.com',
          hasSession: false,
        ),
      ),
    );

    final result = await repository.signIn('person@example.com', 'password123');

    expect(result.isSuccess, isFalse);
    expect(result.error, 'Confirm your email address before signing in.');
  });

  test('cloud sign-in does not apply signup password length rules', () async {
    final gateway = _FakeCloudAuthGateway();
    final repository = SupabaseAuthRepository.withGateway(gateway);

    final result = await repository.signIn('person@example.com', 'short');

    expect(result.isSuccess, isTrue);
    expect(gateway.signinPassword, 'short');
  });

  test('confirmation resend normalizes the email address', () async {
    final gateway = _FakeCloudAuthGateway();
    final repository = SupabaseAuthRepository.withGateway(gateway);

    await repository.resendSignupConfirmation(' Person@Example.com ');

    expect(gateway.resendEmail, 'person@example.com');
  });
}

class _FakeCloudAuthGateway implements CloudAuthGateway {
  _FakeCloudAuthGateway({
    this.signupResponse = const CloudAuthResponse(
      email: 'person@example.com',
      hasSession: true,
    ),
    this.signinResponse = const CloudAuthResponse(
      email: 'person@example.com',
      hasSession: true,
    ),
  });

  final CloudAuthResponse signupResponse;
  final CloudAuthResponse signinResponse;
  String? signupEmail;
  String? signinPassword;
  String? resendEmail;

  @override
  String? get currentEmail => null;

  @override
  Future<CloudAuthResponse> signUp(String email, String password) async {
    signupEmail = email;
    return signupResponse;
  }

  @override
  Future<CloudAuthResponse> signIn(String email, String password) async {
    signinPassword = password;
    return signinResponse;
  }

  @override
  Future<void> resendSignupConfirmation(String email) async {
    resendEmail = email;
  }

  @override
  Future<void> signOut() async {}
}
