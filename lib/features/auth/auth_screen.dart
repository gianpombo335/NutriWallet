import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/providers.dart';
import '../../data/repositories/auth_repository.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _registering = true;
  bool _busy = false;
  bool _resending = false;
  bool _obscurePassword = true;
  String? _pendingConfirmationEmail;
  int _cooldownSeconds = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || _cooldownSeconds > 0) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _busy = true);
    try {
      final auth = ref.read(authRepositoryProvider);
      final result = _registering
          ? await auth.register(_emailController.text, _passwordController.text)
          : await auth.signIn(_emailController.text, _passwordController.text);
      if (!mounted) return;
      if (result.requiresEmailConfirmation) {
        setState(() {
          _pendingConfirmationEmail = result.email;
          _passwordController.clear();
          _confirmPasswordController.clear();
        });
        return;
      }
      if (!result.isSuccess) {
        _showError(result.error ?? 'Unable to continue. Please try again.');
        return;
      }
      ref.invalidate(currentProfileProvider);
      final profile = await ref
          .read(profileDaoProvider)
          .findByEmail(result.email!);
      if (!mounted) return;
      context.go(profile == null ? '/setup' : '/home');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to continue. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
    if (message.startsWith('Too many attempts')) _startRateLimitCooldown();
  }

  void _continueToSignIn() {
    final email = _pendingConfirmationEmail;
    setState(() {
      _pendingConfirmationEmail = null;
      _registering = false;
      if (email != null) _emailController.text = email;
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  Future<void> _resendConfirmation() async {
    if (_resending || _cooldownSeconds > 0) return;
    final email = _pendingConfirmationEmail;
    if (email == null) return;
    setState(() => _resending = true);
    try {
      await ref.read(authRepositoryProvider).resendSignupConfirmation(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('A new confirmation link was sent to $email.'),
          ),
        );
      }
    } catch (error) {
      final message = error is AuthException
          ? friendlyAuthErrorMessage(error.message)
          : 'Could not resend the email. Check your connection and try again.';
      _showError(message);
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  void _startRateLimitCooldown() {
    _cooldownTimer?.cancel();
    if (!mounted) return;
    setState(() => _cooldownSeconds = 60);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _cooldownSeconds <= 1) {
        timer.cancel();
        if (mounted) setState(() => _cooldownSeconds = 0);
        return;
      }
      setState(() => _cooldownSeconds--);
    });
  }

  @override
  Widget build(BuildContext context) {
    final usesCloudAuth =
        ref.watch(authRepositoryProvider) is SupabaseAuthRepository;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.page),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _brandHeader(context),
                  const SizedBox(height: 32),
                  if (_pendingConfirmationEmail case final email?)
                    _confirmationCard(context, email)
                  else
                    _authForm(context, usesCloudAuth),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _brandHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: const Color(0xFFDDEBE3),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Icon(
            Icons.eco_rounded,
            size: 38,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 12),
        Text('NutriWallet', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(
          'Plan well. Spend wisely. Eat better.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: AppColors.neutralGray),
        ),
      ],
    );
  }

  Widget _authForm(BuildContext context, bool usesCloudAuth) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _registering ? 'Create your account' : 'Welcome back',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                _registering
                    ? usesCloudAuth
                          ? 'Sign up to save your plan and sync across sessions.'
                          : 'Your account and meal plan stay on this device.'
                    : 'Sign in to continue to your meal plan.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.neutralGray),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                autocorrect: false,
                validator: _validateEmail,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.item),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: _registering
                    ? TextInputAction.next
                    : TextInputAction.done,
                autofillHints: [
                  _registering
                      ? AutofillHints.newPassword
                      : AutofillHints.password,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your password.';
                  }
                  if (_registering && value.length < 8) {
                    return 'Use at least 8 characters.';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  if (!_registering) _submit();
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  helperText: _registering ? 'Use at least 8 characters' : null,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip: _obscurePassword
                        ? 'Show password'
                        : 'Hide password',
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              if (_registering) ...[
                const SizedBox(height: AppSpacing.item),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm your password.';
                    }
                    return value != _passwordController.text
                        ? 'Passwords do not match.'
                        : null;
                  },
                  onFieldSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
              ],
              const SizedBox(height: 22),
              FilledButton(
                onPressed: _busy || _cooldownSeconds > 0 ? null : _submit,
                child: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _cooldownSeconds > 0
                            ? 'Try again in ${_cooldownSeconds}s'
                            : _registering
                            ? 'Create account'
                            : 'Sign in',
                      ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _busy ? null : _toggleMode,
                child: Text(
                  _registering
                      ? 'Already have an account? Sign in'
                      : 'New to NutriWallet? Create an account',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirmationCard(BuildContext context, String email) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFFDDEBE3),
              child: Icon(
                Icons.mark_email_read_outlined,
                color: AppColors.primaryGreen,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Check your inbox',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'We sent a confirmation link to:',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              email,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Confirm your email, then return here to sign in and finish setting up your meal plan.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.neutralGray),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: _busy ? null : _continueToSignIn,
              icon: const Icon(Icons.verified_outlined),
              label: const Text("I've confirmed — sign in"),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _resending || _cooldownSeconds > 0
                  ? null
                  : _resendConfirmation,
              icon: _resending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.mark_email_unread_outlined),
              label: Text(
                _cooldownSeconds > 0
                    ? 'Try again in ${_cooldownSeconds}s'
                    : 'Resend confirmation email',
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _busy || _resending ? null : _useDifferentEmail,
              child: const Text('Use a different email'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  void _toggleMode() {
    final email = _emailController.text;
    _formKey.currentState?.reset();
    _emailController.text = email;
    setState(() {
      _registering = !_registering;
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  void _useDifferentEmail() {
    setState(() {
      _pendingConfirmationEmail = null;
      _registering = true;
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }
}
