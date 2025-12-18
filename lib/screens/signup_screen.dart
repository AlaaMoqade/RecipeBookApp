import 'package:flutter/material.dart';
import 'package:recipe_gsg/models/user.dart';
import 'package:recipe_gsg/services/db_service.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'package:recipe_gsg/utils/app_colors.dart';
import 'package:recipe_gsg/utils/text_styles.dart';
import 'package:recipe_gsg/widget/app_buttom.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _loading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    await DBService.init();

    final existingUser =
        await DBService.getUserByEmail(_emailController.text.trim());

    if (existingUser != null) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('هذا البريد مستخدم بالفعل')),
      );
      return;
    }

    final newUser = User(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    await DBService.insertUser(newUser);
    await SharedPrefs.login(newUser.email);

    setState(() => _loading = false);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.12, // نزلناه لتحت شوي
            left: MediaQuery.of(context).size.width * 0.07,
            right: MediaQuery.of(context).size.width * 0.07,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                Center(
                  child: Text(
                    'Sign Up',
                    style: AppTextStyles.heading2.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 40),

                
                Text(
                  'الاسم الكامل',
                  style: AppTextStyles.body1Bold.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16), // مسافة أكبر
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration('الاسم'),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'أدخل اسمك' : null,
                ),
                const SizedBox(height: 36),

                Text(
                  'البريد الإلكتروني',
                  style: AppTextStyles.body1Bold.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('البريد الإلكتروني'),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'أدخل بريدك الإلكتروني';
                    }
                    if (!value.contains('@')) {
                      return 'أدخل بريدًا إلكترونيًا صالحًا';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 36),

                Text(
                  'كلمة المرور',
                  style: AppTextStyles.body1Bold.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration(
                    'كلمة المرور',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'أدخل كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                AppButton(
                  text: 'Sign Up',
                  isLoading: _loading,
                  onPressed: _signUp,
                ),
                const SizedBox(height: 50),

               
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'هل لديك حساب؟',
                      style: AppTextStyles.body1Bold
                          .copyWith(color: Colors.white70),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'تسجيل الدخول',
                        style: AppTextStyles.body1Bold
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      suffixIcon: suffixIcon,
    );
  }
}
