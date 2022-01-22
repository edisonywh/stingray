import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stingray/auth.dart';

class LoginPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = useMemoized(() => GlobalKey<FormState>());

    final username = useState("");
    final password = useState("");
    final submitting = useState(false);

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                autocorrect: false,
                onChanged: (value) {
                  username.value = value;
                },
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Username can't be empty";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
                left: 16,
                right: 16,
              ),
              child: TextFormField(
                autocorrect: false,
                onChanged: (value) {
                  password.value = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Password can't be empty";
                  }
                  return null;
                },
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Builder(
                    builder: (context) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            submitting.value = true;
                            AuthResult result = await Auth.login(
                              username: username.value,
                              password: password.value,
                            );

                            if (result.result == Result.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result.message),
                                ),
                              );
                            } else {
                              Navigator.pop(context);
                            }
                            submitting.value = false;
                          }
                        },
                        child: submitting.value
                            ? SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : Text("Login"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
