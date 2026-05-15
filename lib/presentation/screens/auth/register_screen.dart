import 'package:flutter/material.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/core/services/auth_service.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/core/models/user_profile.dart';

class RegisterScreen extends StatefulWidget {
  final bool isDarkMode;
  const RegisterScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController(text: '28');
  final _heightController = TextEditingController(text: '67');
  final _weightController = TextEditingController(text: '178');
  final _goalWeightController = TextEditingController(text: '168');
  final _calorieController = TextEditingController(text: '2100');
  final _sleepController = TextEditingController(text: '8');
  
  String _activityLevel = 'Moderate';
  String _fitnessExp = 'Intermediate';
  bool _isVegetarian = false;
  
  bool _isLoading = false;

  void _register() async {
    setState(() => _isLoading = true);
    try {
      final cred = await AuthService().registerWithEmail(_emailController.text, _passwordController.text);
      if (cred?.user != null) {
        final userId = cred!.user!.uid;
        
        // Save initial user profile
        final profile = UserProfile(
          id: userId,
          name: _nameController.text.isNotEmpty ? _nameController.text : 'New User',
          initials: _nameController.text.isNotEmpty ? _nameController.text.substring(0, 1).toUpperCase() : 'U',
          bio: '',
          goals: ['Stay healthy'],
          weightLb: double.tryParse(_weightController.text) ?? 150.0,
          age: int.tryParse(_ageController.text) ?? 25,
          heightInches: int.tryParse(_heightController.text) ?? 65,
          activityLevel: _activityLevel,
          goalWeightLb: double.tryParse(_goalWeightController.text) ?? 140.0,
          calorieTarget: int.tryParse(_calorieController.text) ?? 2000,
          sleepGoalHr: int.tryParse(_sleepController.text) ?? 8,
          fitnessExperience: _fitnessExp,
          isVegetarian: _isVegetarian,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        // Ensure FirestoreService uses this user ID
        FirestoreService().userId = userId;
        await FirestoreService().saveUserProfile(profile);
        
        if (mounted) Navigator.pop(context); // Go back to root (Login screen will detect auth state)
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
      }
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: fg1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Account', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, color: fg1)),
              const SizedBox(height: 8),
              Text('Tell us a bit about yourself to personalize your experience.', style: TextStyle(color: fg2, fontSize: 16)),
              const SizedBox(height: 32),
              
              _buildSectionTitle('Account Details', fg1),
              _buildTextField('Email', _emailController, bgCard, border, fg1, fg2),
              _buildTextField('Password', _passwordController, bgCard, border, fg1, fg2, obscure: true),
              _buildTextField('Full Name', _nameController, bgCard, border, fg1, fg2),
              
              const SizedBox(height: 24),
              _buildSectionTitle('Body Stats', fg1),
              Row(
                children: [
                  Expanded(child: _buildTextField('Age', _ageController, bgCard, border, fg1, fg2, isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Height (in)', _heightController, bgCard, border, fg1, fg2, isNumber: true)),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildTextField('Weight (lb)', _weightController, bgCard, border, fg1, fg2, isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Goal Weight', _goalWeightController, bgCard, border, fg1, fg2, isNumber: true)),
                ],
              ),
              
              const SizedBox(height: 24),
              _buildSectionTitle('Preferences & Goals', fg1),
              _buildDropdown('Activity Level', ['Sedentary', 'Light', 'Moderate', 'Active', 'Very Active'], _activityLevel, (v) => setState(() => _activityLevel = v!), bgCard, border, fg1, fg2),
              _buildDropdown('Fitness Experience', ['Beginner', 'Intermediate', 'Advanced'], _fitnessExp, (v) => setState(() => _fitnessExp = v!), bgCard, border, fg1, fg2),
              
              Row(
                children: [
                  Expanded(child: _buildTextField('Calorie Target', _calorieController, bgCard, border, fg1, fg2, isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Sleep Goal (hr)', _sleepController, bgCard, border, fg1, fg2, isNumber: true)),
                ],
              ),
              
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text('Vegetarian', style: TextStyle(color: fg1)),
                value: _isVegetarian,
                onChanged: (v) => setState(() => _isVegetarian = v ?? false),
                activeColor: AppColors.accent,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text('Complete Registration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color fg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: fg)),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, Color bgCard, Color border, Color fg1, Color fg2, {bool obscure = false, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: fg1),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: fg2),
          filled: true,
          fillColor: bgCard,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.accent)),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, ValueChanged<String?> onChanged, Color bgCard, Color border, Color fg1, Color fg2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: fg1)))).toList(),
        onChanged: onChanged,
        dropdownColor: bgCard,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: fg2),
          filled: true,
          fillColor: bgCard,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.accent)),
        ),
      ),
    );
  }
}
