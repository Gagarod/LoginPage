import 'package:flutter/material.dart';

class CustomTField extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final IconData prefixIcon;
  final String label;
  final bool obsecure;
  TextEditingController tcontroller;
  final FormFieldValidator<String> validator;
  CustomTField({
    this.prefixIcon,
    this.label,
    // this.controller,
    this.obsecure = false,
    this.validator, this.onSaved,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.symmetric(vertical: size.height * 0.01),
      padding: EdgeInsets.symmetric(horizontal: 20,),
      width: size.width * 0.92,
      child: Center(
        child: TextFormField(
          textAlign: TextAlign.center,
          onSaved: onSaved,
          validator: validator,
          autofocus: true,
          obscureText: obsecure,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          
          decoration: InputDecoration(
            fillColor: Colors.grey[800],
                          filled: true,
                          prefixIcon: Icon(
                            prefixIcon,
                            color: Colors.white,
                          ),
            labelStyle: TextStyle(
              // fontWeight: FontWeight.bold,
              // fontSize: 20,
              color: Colors.grey,
            ),
            labelText: label,
            focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
            enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
            border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
          ),
        ),
      ),
    );
  }
}
