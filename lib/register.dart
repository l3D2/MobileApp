import 'package:food_pj/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formstate = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final db = FirebaseFirestore.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cfpassword = TextEditingController();

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up",
              style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.blueAccent,
        ),
        body: DecoratedBox(
            decoration: const BoxDecoration(
              image: const DecorationImage(
                image: AssetImage(
                    'assets/img/background.png'), // Your background image path
                fit: BoxFit.cover, // Adjust fit behavior (e.g., BoxFit.fill)
              ),
            ),
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formstate,
              child: ListView(
                children: <Widget>[
                  const Center(
                    child: Text(
                      'Swizky Foods',
                      style: TextStyle(fontSize: 40.0,fontWeight: FontWeight.bold,color: Colors.white,),
                    )
                  ),
                  buildEmailField(),
                  buildPasswordField(),
                  buildCfPasswordField(),
                  const SizedBox(height: 10,),
                  const Divider(color: Colors.blueGrey),
                  const SizedBox(height: 10,),
                  buildNameField(),
                  buildAddressField(),
                  buildPhoneField(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildRegisterButton()
                    ],
                  )
                ],
              ),
            )));
  }

  ElevatedButton buildRegisterButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.app_registration),
      label: const Text('Register'),
      onPressed: () async {
        print('Register new account');
        if (_formstate.currentState!.validate()){
          print(email.text);
          print(password.text);
          final user = await auth.createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());
          await user.user!.sendEmailVerification();
          Map<String,dynamic> data = {
            'email' : email.text,
            'name' : _name.text,
            'address' : _address.text,
            'phone' : _phone.text,
            'lat' : null,
            'lng' : null
          };
          try {
            DocumentReference ref = await db.collection('user_info').add(data);
            print('Save registration = ' + ref.id);
          }catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error save registration $e'),duration: const Duration(milliseconds: 500))
            );
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Check your email to verify your account.'),
              duration: Duration(milliseconds: 500)
            ),
          );
          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => const LoginPage()),(Route route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill information every form'),
              duration: Duration(milliseconds: 500)
            ),
          );
        }
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: password,
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
      style: const TextStyle(color: Colors.black, fontSize: 20),
    );
  }

  TextFormField buildCfPasswordField() {
    return TextFormField(
      controller: cfpassword,
      validator: (value) {
        if (value!.length < 8) {
          return 'Please Enter more than 8 Character';
        }else if (value != password.text) {
          return 'Password not match';
        }else if (value.length < 8 && value != password.text) {
          return 'Password not match and more than 8 characters';
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
      style: const TextStyle(color: Colors.black, fontSize: 20),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: email,
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
      style: const TextStyle(color: Colors.black, fontSize: 20,),
    );
  }

  bool validateEmail(String value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    return (!regex.hasMatch(value)) ? false : true;
  }
  
  TextFormField buildNameField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please fill in Name field';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Name',
        icon: Icon(Icons.person),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 20,),
    );
  }
  
  TextFormField buildAddressField() {
    return TextFormField(
      controller: _address,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please fill in Address field';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Address',
        icon: Icon(Icons.home),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 20,),
    );
  }
  
  TextFormField buildPhoneField() {
    return TextFormField(
      controller: _phone,
      validator: (value) {
        if (value!.length < 10) {
          return 'กรอกเบอร์โทรให้ครบ 10 หลัก';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Phone',
        icon: Icon(Icons.phone),
        hintText: '0123456789'
      ),
      style: const TextStyle(color: Colors.black, fontSize: 20,),
    );
  }
  
}
