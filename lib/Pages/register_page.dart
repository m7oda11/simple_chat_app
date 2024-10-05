import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../BLOCs/Auth_Bloc/auth_events.dart';
import '../BLOCs/Auth_Bloc/auth_states.dart';
import '../BLOCs/Auth_Bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Register'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                // Navigate to home after successful registration
                Navigator.of(context).pushReplacementNamed('/chat');
              }
              if (state is AuthError) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Error")),
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/SVGs/register.svg",
                    height: MediaQuery.sizeOf(context).height * 0.3,
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        fillColor: Colors.grey.withOpacity(0.15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        contentPadding: const EdgeInsets.all(15),
                        filled: true,
                        labelText: 'Email'),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        fillColor: Colors.grey.withOpacity(0.15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        contentPadding: const EdgeInsets.all(15),
                        filled: true,
                        labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String email = _emailController.text;
                      String password = _passwordController.text;

                      if (email.isNotEmpty && password.isNotEmpty) {
                        // Dispatch the register event to AuthBloc
                        context.read<AuthBloc>().add(
                              SignUpRequested(email, password),
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please fill in all fields')),
                        );
                      }
                    },
                    child: const Text('Register'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
