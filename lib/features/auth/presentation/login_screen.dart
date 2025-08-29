import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invennico_fbp/core/utils/theme/app_theme_assets.dart';
import 'package:invennico_fbp/core/utils/theme/app_theme_color.dart';
import 'package:invennico_fbp/core/utils/theme/theme_changer.dart';
import 'package:invennico_fbp/core/widgets/form_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedRole;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Background Image
          Image.asset(
            AppThemeAssets.themedBackground(context),
            fit: BoxFit.cover,
          ),

          /// Form Content (Centered)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// mode button
                    ElevatedButton(
                      onPressed: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemeColors.primaryColor(context), // button color
                        foregroundColor: AppThemeColors.negativePrimaryColor(context), // text/icon color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // optional rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14), // height
                      ),
                      child: Icon(Icons.motion_photos_on,color: AppThemeColors.negativePrimaryColor(context))
                    ),
                    const SizedBox(height: 12),

                    /// Email
                    FormWidgets.validatedTextField(
                      context: context,
                      isLabel: false,
                      controller: _email,
                      label: "Email",
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                      v == null || v.isEmpty ? "Enter email" : null,
                    ),
                    const SizedBox(height: 12),

                    /// Password
                    FormWidgets.validatedTextField(
                      context: context,
                      isLabel: false,
                      controller: _password,
                      label: "Password",
                      validator: (v) =>
                      v == null || v.isEmpty ? "Enter password" : null,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 12),

                    /// Dropdown (Role)
                    FormWidgets.validatedDropdown<String>(
                      context: context,
                      isLabel: false,
                      value: _selectedRole,
                      label: "Role",
                      items: const [
                        DropdownMenuItem(value: "user", child: Text("User")),
                        DropdownMenuItem(value: "admin", child: Text("Admin")),
                      ],
                      validator: (v) =>
                      v == null ? "Please select a role" : null,
                      onChanged: (val) {
                        setState(() => _selectedRole = val);
                      },
                    ),

                    const SizedBox(height: 24),

                    /// Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppThemeColors.primaryColor(context), // button color
                          foregroundColor: AppThemeColors.negativePrimaryColor(context), // text/icon color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // optional rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14), // height
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
