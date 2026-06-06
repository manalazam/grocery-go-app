import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool _hide1 = true;
  bool _hide2 = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2EAE5)),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: cs.primary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D1F14),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Join GroceryGo and start shopping smarter",
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7C72)),
                ),
                const SizedBox(height: 28),

                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2EAE5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _sectionLabel("Full name"),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _name,
                          decoration: InputDecoration(
                            hintText: "e.g. Sarah Ahmed",
                            prefixIcon: Icon(Icons.person_outline_rounded, color: cs.primary, size: 20),
                          ),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? "Name is required" : null,
                        ),
                        const SizedBox(height: 16),

                        _sectionLabel("Email address"),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "you@example.com",
                            prefixIcon: Icon(Icons.mail_outline_rounded, color: cs.primary, size: 20),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return "Email is required";
                            if (!v.contains("@")) return "Enter a valid email";
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _sectionLabel("Password"),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _pass,
                          obscureText: _hide1,
                          decoration: InputDecoration(
                            hintText: "At least 6 characters",
                            prefixIcon: Icon(Icons.lock_outline_rounded, color: cs.primary, size: 20),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _hide1 = !_hide1),
                              icon: Icon(
                                _hide1 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: const Color(0xFF9AB0A5),
                                size: 20,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Password is required";
                            if (v.length < 6) return "Minimum 6 characters";
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        _sectionLabel("Confirm password"),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _confirm,
                          obscureText: _hide2,
                          decoration: InputDecoration(
                            hintText: "Repeat your password",
                            prefixIcon: Icon(Icons.lock_outline_rounded, color: cs.primary, size: 20),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _hide2 = !_hide2),
                              icon: Icon(
                                _hide2 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: const Color(0xFF9AB0A5),
                                size: 20,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return "Confirm your password";
                            if (v != _pass.text) return "Passwords do not match";
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;
                            Navigator.pop(context);
                          },
                          child: const Text("Create account"),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Color(0xFF6B7C72), fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF16A34A),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Text(
                          "Sign in",
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
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

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374840),
      ),
    );
  }
}