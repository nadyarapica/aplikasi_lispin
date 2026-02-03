import 'package:aplikasi_lispin/screen/admin/dasboard/admin_dasboard.dart';
import 'package:aplikasi_lispin/screen/admin/dasboard/peminjam_dasboard.dart';
import 'package:aplikasi_lispin/screen/petugas/peminjaman_petugas_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService authService = AuthService();
  bool isLoading = false;

  // =====================
  // VALIDATOR
  // =====================
  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }

    final emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Password hanya boleh angka';
    }

    if (value.length < 6) {
      return 'Password minimal 6 angka';
    }

    return null;
  }

  // =====================
  // LOGIN
  // =====================
  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    try {
      final error = await authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (error != null) {
        throw Exception('Email atau password salah');
      }

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User tidak ditemukan');
      }

      final userData = await Supabase.instance.client
          .from('users')
          .select('role')
          .eq('id_user', user.id)
          .single();

      final role = userData['role'].toString().toLowerCase();

      if (!mounted) return;

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else if (role == 'petugas') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PeminjamanPetugasPage()),
        );
      } else if (role == 'peminjam') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DasboardPeminjam()),
        );
      } else {
        throw Exception('Role tidak dikenali');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // =====================
  // UI (ASLI)
  // =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset('assets/images/logo_lispin.jpeg', width: 100),
                const SizedBox(height: 70),

                Container(
                  width: 280,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 25,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFBE55),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      // EMAIL
                      TextFormField(
                        controller: emailController,
                        autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                        validator: emailValidator,
                        decoration: InputDecoration(
                          hintText: 'email',
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle:
                              const TextStyle(fontSize: 11),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // PASSWORD
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                        validator: passwordValidator,
                        decoration: InputDecoration(
                          hintText: 'password',
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle:
                              const TextStyle(fontSize: 11),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: 90,
                        height: 32,
                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(
                                          strokeWidth: 2),
                                )
                              : const Text(
                                  'Login',
                                  style:
                                      TextStyle(fontSize: 13),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
