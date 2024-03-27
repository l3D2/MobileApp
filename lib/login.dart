import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_pj/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formstate = GlobalKey<FormState>();
  String? email;
  String? password;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          // color: Colors.black,
          child: const Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Image(
                image: AssetImage('assets/img/logo.png'),
                width: 200,
                height: 200,
              ),
              Text(
                'SWIZKY FOODS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60), // มุมมนด้านบนซ้าย
                    topRight: const Radius.circular(60), // มุมมนด้านบนขวา
                  ),
                ),
                child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _formstate,
                    child: Column(
                      children: <Widget>[
                        const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                // fontFamily: 'Prompt',
                                fontSize: 35,
                                fontWeight: FontWeight.w900,
                                color: Color.fromARGB(255, 245, 95, 41)),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.only(
                                top: 10, right: 20, left: 20),
                            children: [
                              emailTextFormField(),
                              passwordTextFormField(),
                              const SizedBox(
                                height: 20,
                              ),
                              loginButton(),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    "Don't have an account yet?",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    child: const Text(
                                      'Sing up',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 254, 2, 48)),
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, '/register');
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )))),
      ],
    ));
  }

  ElevatedButton registerButton(BuildContext context) {
    return ElevatedButton(
      // ignore: prefer_const_constructors
      child: Text('Register new account'),
      onPressed: () {
        print('Goto  Regis pagge');
        Navigator.pushNamed(context, '/register');
      },
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
        child: const Text('Login', style: TextStyle(color: Colors.white),),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
        ),
        onPressed: () async {
          if (_formstate.currentState!.validate()) {
            print('Valid Form');
            _formstate.currentState!.save();
            try {
              await auth.signInWithEmailAndPassword(
                      email: email!, password: password!)
                  .then((value) {
                if (value.user!.emailVerified) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login Pass"),duration: Duration(milliseconds: 500)));
                  Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => const Homepage()),(Route route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please verify email"),duration: Duration(milliseconds: 500)));
                }
              }).catchError((reason) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Login or Password Invalid"),duration: Duration(milliseconds: 500),));
              });
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                print('No user found for that email.');
              } else if (e.code == 'wrong-password') {
                print('Wrong password provided for that user.');
              }
            }
          } else {
            print('Invalid Form');
          }
        });
  }

  TextFormField passwordTextFormField() {
    return TextFormField(
      onSaved: (value) {
        password = value!.trim();
      },
      validator: (value) {
        if (value!.length < 8) {
          return 'Please Enter more than 8 Character';
        } else {
          return null;
        }
      },
      obscureText: true,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        labelText: 'Password',
        icon: Icon(Icons.lock),
      ),
    );
  }

  TextFormField emailTextFormField() {
    return TextFormField(
      onSaved: (value) {
        email = value!.trim();
      },
      validator: (value) {
        if (!validateEmail(value!)) {
          return 'Please fill in E-mail field';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        icon: Icon(Icons.email),
        hintText: 'x@x.com',
      ),
    );
  }

  bool validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    return (!regex.hasMatch(value)) ? false : true;
  }
}
