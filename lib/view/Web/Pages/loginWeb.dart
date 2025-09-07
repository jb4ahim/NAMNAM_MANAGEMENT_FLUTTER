import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:namnam/l10n/app_localizations.dart';
import 'package:namnam/core/Utility/appcolors.dart';
import 'package:namnam/view/Web/widgets/proceedBtn.dart';
import 'package:namnam/view/Web/widgets/custom_toast.dart';
import 'package:namnam/view/Web/widgets/modern_text_field.dart';
import 'package:namnam/core/Utility/Preferences.dart';
import 'package:namnam/viewmodel/login_view_model.dart';
import 'package:provider/provider.dart';
 
class LoginWebPage extends StatefulWidget {
  const LoginWebPage({super.key});

  @override
  State<LoginWebPage> createState() => _LoginWebPageState();
}

class _LoginWebPageState extends State<LoginWebPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
      
      final success = await loginViewModel.login(
        _emailController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        // Get preferences provider and save login data
        final prefProvider = Provider.of<PrefProvider>(context, listen: false);
        prefProvider.setUserEmail(_emailController.text);
        
        // Save access token if available
        if (loginViewModel.loginResponse?.accessToken != null) {
          prefProvider.setAccessToken(loginViewModel.loginResponse!.accessToken!);
        }
        
        // Save user ID if available
        if (loginViewModel.loginResponse?.userId != null) {
          final userId = int.tryParse(loginViewModel.loginResponse!.userId!);
          if (userId != null) {
            prefProvider.setuserId(userId);
          }
        }
        
        prefProvider.login();
        
        // Show success toast
        ToastManager.show(
          context: context,
          message: loginViewModel.message.isNotEmpty 
            ? loginViewModel.message 
            : AppLocalizations.of(context)!.loginSuccess,
          type: ToastType.success,
        );
        
        // Navigate to home page after successful login
        context.go('/home');
      } else if (mounted) {
        // Show error toast
        ToastManager.show(
          context: context,
          message: loginViewModel.message.isNotEmpty 
            ? loginViewModel.message 
            : 'Login failed. Please try again.',
          type: ToastType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Appcolors.appPrimaryColor.withOpacity(0.1),
              Appcolors.appPrimaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width > 1200 ? 1000 : 800,
              maxHeight: size.height * 0.9,
            ),
            child: Card(
              elevation: 20,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // Left side - Decorative
                    if (size.width > 800)
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              bottomLeft: Radius.circular(24),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Appcolors.appPrimaryColor,
                                Appcolors.appPrimaryColor.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Image.asset(
                                  "assets/logo/namnam_white_logo.png",
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                l10n.appTitle,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Management Platform",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Invite Only",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Right side - Login Form
                    Expanded(
                      flex: size.width > 800 ? 1 : 2,
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Consumer<LoginViewModel>(
                          builder: (context, loginViewModel, child) {
                            return Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (size.width <= 800) ...[
                                    Image.asset(
                                      "assets/logo/namnam_white_logo.png",
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      l10n.appTitle,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Appcolors.appPrimaryColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Management Platform",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 32),
                                  ],

                                  // Email Field
                                  ModernTextField(
                                    controller: _emailController,
                                    label: l10n.email,
                                    hint: l10n.enterEmail,
                                    type: ModernTextFieldType.email,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return l10n.required;
                                      }
                                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return l10n.invalidEmail;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  // Password Field
                                  ModernTextField(
                                    controller: _passwordController,
                                    label: l10n.password,
                                    hint: l10n.enterPassword,
                                    type: ModernTextFieldType.password,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return l10n.required;
                                      }
                                      if (value.length < 6) {
                                        return l10n.invalidPassword;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),

                                  // Forgot Password Link
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        // TODO: Navigate to forgot password page
                                      },
                                      child: Text(
                                        l10n.forgotPassword,
                                        style: TextStyle(color: Appcolors.appPrimaryColor),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // Login Button
                                  ProceedBtn(
                                    text: l10n.login,
                                    color: Appcolors.appPrimaryColor,
                                    onPressed: loginViewModel.isLoading ? null : _handleLogin,
                                    isLoading: loginViewModel.isLoading,
                                    borderRadius: 12.0,
                                  ),
                                  const SizedBox(height: 24),

                                  // Invite Only Notice
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.orange.shade200),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.orange.shade600,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            "This is an invite-only platform. Contact your administrator for access.",
                                            style: TextStyle(
                                              color: Colors.orange.shade700,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
