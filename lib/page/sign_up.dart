import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:note_app/controller/auth_controller.dart';

class SignUp extends GetWidget<AuthController> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(hintText: "Full Name"),
                controller: nameController,
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Email"),
                controller: emailController,
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: "Password"),
                obscureText: true,
                controller: passwordController,
              ),
              TextButton(
                child: const Text("Sign Up"),
                onPressed: () {
                  controller.createUser(nameController.text,
                      emailController.text, passwordController.text);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
