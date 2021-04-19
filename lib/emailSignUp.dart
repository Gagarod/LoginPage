import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/login.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'googleSignIn.dart';
import 'home.dart';
import 'CustomField.dart';

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 32);
    path.quadraticBezierTo(width / 2, height, width, height - 32);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class emailSignUp extends StatefulWidget {
  @override
  _emailSignUpState createState() => _emailSignUpState();
}

class _emailSignUpState extends State<emailSignUp> {
  bool isLoading = false;
  bool signedUp = false;
  bool isHidden = true;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =FirebaseDatabase.instance.reference().child("Users");
  // TextEditingController emailController = TextEditingController();
  // TextEditingController nameController = TextEditingController();
  // TextEditingController contactController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String name,email,contact;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          elevation: 0.0,
          title: Text(
            'TCS',
            style: TextStyle(
              fontFamily: 'CinzelDecorative',
              fontSize: size.width * 0.095,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipPath(
                clipper:
                    CustomShape(), // this is my own class which extendsCustomClipper
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                  ),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(children: <Widget>[                
                    CustomTField(
                      prefixIcon:Icons.person, 
                      label: "Enter User Name",
                      onSaved: (input){
                          name=input;
                        },
                      validator:(value) {
                          if (value.isEmpty) {
                            return 'Enter User Name';
                          }
                          return null;
                        } ,
                    ),
                    CustomTField(
                      prefixIcon: Icons.phone,
                      label: "Enter Mobile Number",
                      onSaved: (input){
                          contact=input;
                        },
                      validator: (value) {
                          return value.length!=10?"*10 digit phone no.":null;
                        }
                    ),
                    
                    CustomTField(
                      prefixIcon: Icons.email,
                      label: "Enter Email Address",
                      onSaved: (input){
                          email=input;
                        },
                      validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter an Email Address';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
                      padding:EdgeInsets.symmetric(horizontal: 20, ),
                      width: size.width * 0.92,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        obscureText: isHidden,
                        controller: passwordController,
                        style: TextStyle(color: Colors.white,fontSize: 18),
                        decoration: InputDecoration(
                          fillColor: Colors.grey[800],
                          filled: true,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          suffix: InkWell(
                            onTap: _togglePasswordView,
                            child: Icon(
                              isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                          labelText: "Enter Password",
                          labelStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Password';
                          } else if (value.length < 6) {
                            return 'Password must be atleast 6 characters!';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Container(
                              width: size.width * 0.6,
                              child: RaisedButton(
                                padding: EdgeInsets.all(size.width * 0.02),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                color: Colors.white,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() async {
                                      await _formKey.currentState.save();
                                      isLoading = true;
                                    });
                                    
                                    registerToFb();
                                  }
                                },
                                child: Text('SIGN UP'),
                              ),
                            ),
                    )
                  ])),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account ? ",
                      style: TextStyle(color: Colors.white)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => EmailLogIn()),
                      );
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
                child: Row(children: [
                  buildDivider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  buildDivider()
                ]),
              ),
              Container(
                width: size.width * 0.6,
                child: SignInButton(
                  Buttons.Google,
                  padding: EdgeInsets.all(size.height * 0.01),
                  text: "Sign Up with Google",
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.white),
                  ),
                  onPressed: () {
                    signInWithGoogle(context);
                  },
                ),
              ),
              SizedBox(
                height: size.width * 0.05,
              )
            ],
          ),
        ));
  }

  void _togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  registerToFb() async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              // email: emailController.text, 
              email: this.email, 
              password: passwordController.text)
          .then((result) {
        isLoading = false;
        dbRef.child(result.user.uid).set({
          // "email": emailController.text,
          // "name": nameController.text,
          // "phone":contactController.text,
          "email": email,
          "name": name,
          "phone":contact,
        }).then((res) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(uid: result.user.uid)),
          );
        });
      });
    } on FirebaseException catch (err) {
      if (err.code == 'email-already-in-use') {
        isLoading = false;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text(err.message),
                actions: [
                  ElevatedButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    } catch (e) {
      isLoading = false;
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    // nameController.dispose();
    // emailController.dispose();
    passwordController.dispose();
  
  }
}

Expanded buildDivider() {
  return Expanded(
    child: Divider(
      height: 1.5,
      color: Color(0xFFD9D9D9),
    ),
  );
}
