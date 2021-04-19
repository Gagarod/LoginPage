import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/emailSignUp.dart';
import 'home.dart';

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

class EmailLogIn extends StatefulWidget {
  @override
  _EmailLogInState createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isHidden = true;
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.92,
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              fillColor: Colors.grey[800],
                              filled: true,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.white,
                              ),
                              hintText: "Enter Email Address",
                              hintStyle: TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter Email Address';
                              } else if (!value.contains('@')) {
                                return 'Please enter a valid email address!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding:EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          width: size.width * 0.92,
                          child: TextFormField(
                            obscureText: isHidden,
                            controller: passwordController,
                            style: TextStyle(color: Colors.white),
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
                              // suffixIcon: Icon(Icons.visibility,color: Colors.white,),
                              hintText: "Enter Password",
                              hintStyle: TextStyle(color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
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
                          padding: EdgeInsets.all(20.0),
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Container(
                                  width: size.width * 0.6,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      // side: BorderSide(color: Colors.white),
                                    ),
                                    color: Colors.white,
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        logInToFb();
                                      }
                                    },
                                    child: Text('LOG IN'),
                                  ),
                                ),
                        )
                      ])),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account ? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => emailSignUp()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.width * 0.1,
                  )
                ],
              ),
            ],
          ),
        ));
  }

  void _togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  void logInToFb() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      isLoading = false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(uid: result.user.uid)),
      );
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });
      print(err.message);
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
    });
  }
}
