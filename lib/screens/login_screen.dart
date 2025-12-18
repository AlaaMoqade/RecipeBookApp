import 'package:flutter/material.dart';
import 'package:recipe_gsg/screens/signup_screen.dart';
import 'package:recipe_gsg/services/db_service.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'package:recipe_gsg/utils/app_colors.dart';
import 'package:recipe_gsg/utils/text_styles.dart';
import 'package:recipe_gsg/widget/app_buttom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final user =
        await DBService.getUserByEmail(_emailController.text.trim());

    if (user == null) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('المستخدم غير موجود')),
      );
      return;
    }

    if (user.password != _passwordController.text.trim()) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة المرور خاطئة')),
      );
      return;
    }

    await SharedPrefs.login(user.email);
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
            top: MediaQuery.of(context).size.height * 0.10, // نزلناه لتحت
            left: MediaQuery.of(context).size.width * 0.07,
            right: MediaQuery.of(context).size.width * 0.07,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ---- Image ----
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    'https://cdn.vectorstock.com/i/1000v/20/61/user-sign-orange-icon-on-black-vector-13392061.jpg',
                    width: double.infinity,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 40),

                /// ---- Title ----
                Center(
                  child: Text(
                    'Login',
                    style: AppTextStyles.heading2
                        .copyWith(color: Colors.white),
                  ),
                ),

                const SizedBox(height: 40),

                /// ---- Email ----
                Text(
                  'البريد الإلكتروني',
                  style: AppTextStyles.body1Bold
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('البريد الإلكتروني'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'أدخل البريد الإلكتروني';
                    }
                    if (!value.contains('@')) {
                      return 'أدخل بريد إلكتروني صحيح';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 36),

                /// ---- Password ----
                Text(
                  'كلمة المرور',
                  style: AppTextStyles.body1Bold
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(
                    'كلمة المرور',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.gray,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'أدخل كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                /// ---- Button ----
                AppButton(
                  text: 'Login',
                  isLoading: _loading,
                  onPressed: _login,
                ),

                const SizedBox(height: 50),

                /// ---- Sign up ----
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟',
                      style: AppTextStyles.body1Bold
                          .copyWith(color: Colors.white70),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'إنشاء حساب',
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
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.white54),
      ),
      suffixIcon: suffixIcon,
    );
  }
}
