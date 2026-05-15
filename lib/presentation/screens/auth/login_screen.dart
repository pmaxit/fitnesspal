import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/core/services/auth_service.dart';
import 'package:fitnesspal/presentation/screens/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isDarkMode;
  const LoginScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    try {
      await AuthService().signInWithEmail(_emailController.text, _passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _googleLogin() async {
    setState(() => _isLoading = true);
    try {
      await AuthService().signInWithGoogle();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google login failed')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _appleLogin() async {
    setState(() => _isLoading = true);
    try {
      await AuthService().signInWithApple();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Apple login failed')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: bgCard,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppColors.accent.withOpacity(0.2), blurRadius: 40, spreadRadius: 10),
                    ],
                  ),
                  child: Icon(LucideIcons.activity, size: 64, color: AppColors.accent),
                ),
                const SizedBox(height: 32),
                Text('Welcome Back', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, color: fg1)),
                const SizedBox(height: 8),
                Text('Sign in to continue your wellness journey', style: TextStyle(color: fg2, fontSize: 16)),
                const SizedBox(height: 40),
                
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: fg1),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: fg2),
                    filled: true,
                    fillColor: bgCard,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: border)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.accent)),
                    prefixIcon: Icon(LucideIcons.mail, color: fg2),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: fg1),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: fg2),
                    filled: true,
                    fillColor: bgCard,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: border)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.accent)),
                    prefixIcon: Icon(LucideIcons.lock, color: fg2),
                  ),
                ),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Divider(color: border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR', style: TextStyle(color: fg2, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(child: Divider(color: border)),
                  ],
                ),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: _socialButton(
                        icon: LucideIcons.chrome,
                        label: 'Google',
                        onTap: _isLoading ? null : _googleLogin,
                        bgCard: bgCard,
                        border: border,
                        fg1: fg1,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _socialButton(
                        icon: LucideIcons.apple,
                        label: 'Apple',
                        onTap: _isLoading ? null : _appleLogin,
                        bgCard: bgCard,
                        border: border,
                        fg1: fg1,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: TextStyle(color: fg2)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen(isDarkMode: widget.isDarkMode)));
                      },
                      child: const Text('Register', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton({required IconData icon, required String label, required VoidCallback? onTap, required Color bgCard, required Color border, required Color fg1}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgCard,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: fg1, size: 20),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: fg1, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
