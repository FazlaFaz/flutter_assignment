import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'config.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colors.dart';
import 'constants.dart';

class SignupScreen extends StatefulWidget {


  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;



  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> _userType = <String>[
    'Admin',
    'Employee'
  ];
  var selectedType;


  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset:true,
      body: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,

              children:<Widget>[
                Stack(
                  children: [
                    Image.asset(bgImage,
                        height: height * 0.40,
                        width: width,
                        fit: BoxFit.cover
                    ),

                    Container(
                      height: height * 0.45,
                      width: width,
                      // color: Colors.black54,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: [0.3,0.8],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.white,
                          ],),
                      ) ,

                    ),

                    Positioned(

                      bottom: 20,// 20 points above from bottom
                      left: 0,
                      right: 0,

                      child: Center(
                        child: RichText(
                            textAlign: TextAlign.center,
                            text:TextSpan(
                                style: TextStyle(
                                  fontSize: 25.0,fontWeight: FontWeight.w600,color: primaryColor,
                                ),
                                text:appName + "\n",
                                children: [
                                  TextSpan(
                                    text: slogan,style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16.0,
                                  ),

                                  ) ,
                                ]

                            )
                        ),
                      ),
                    ),

                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left:10.0,top: 8.0),
                  child: Container(child: Text(
                    " $signupString  ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                    decoration:BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.3),
                            Colors.transparent,//opacity using for shading
                          ],),
                        border: Border(left: BorderSide(color: primaryColor,width: 5))
                    ),

                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.account_circle_sharp,size: 30.0,color: primaryColor,),
                      SizedBox(width: 10.0,height: 10.0,),
                      new DropdownButton<String>(

                        items: _userType.map((String value) {
                          return new DropdownMenuItem<String>(

                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (selectedUserType){
                          setState(() {
                            selectedType=selectedUserType;
                          });


                        },
                        value: selectedType,
                        isExpanded:false,
                        hint: Text("Choose User Type", style: TextStyle(
                          color: primaryColor,
                        ),),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),//or only left 10.0,right 10.0 instead of symmetric
                  child: TextFormField(
                    controller: _emailController,
                    style: TextStyle(fontSize: 22, color: Colors.black),
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)
                      ),
                      prefixIcon: Icon(Icons.email,color: primaryColor,),
                      hintText: "Email Address",
                      hintStyle: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                    onSaved: (value)
                    {

                      //_emailController = value!;
                    },
                    validator: (email)
                    {
                      if(email!.isEmpty) {
                        return "Please Enter your Email";
                      }
                      else if(!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email))
                        return "It's not a valid Email";

                      return null;

                    },
                    keyboardType: TextInputType.emailAddress,

                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),//or only left 10.0,right 10.0 instead of symmetric
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(fontSize: 22, color: Colors.black),
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)
                      ) ,
                      prefixIcon: Icon(Icons.lock_open,color: primaryColor,),
                      hintText: "Password",
                      hintStyle: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                    onSaved: (value){
                     // _password = value!;

                    },
                    validator: (password){
                      if(password!.isEmpty)
                        return "Please Enter a Password";
                      else if(password.length < 8 || password.length > 15)
                        return "Password length is incorrect";
                      return null;
                    },

                  ),
                ),




                Center(
                    child: SizedBox(
                      height: height*0.08,
                      width: width-40,
                      child: RaisedButton(
                        color: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20.0))),
                        onPressed: ()  {
                           _firebaseAuth.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text).then((value)
                           {
                             FirebaseFirestore.instance.collection('UserData').doc(value.user!.uid).set(
                                 {"email" : value.user!.email });
                           });
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>
                             HomePage()
                           ));

                        },
                        child: Text("Sign Up",
                          style: TextStyle(fontSize: 22.0,color: Colors.white,fontWeight: FontWeight.w600),),),
                    )),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?"),
                    FlatButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                        LoginScreen()
                      ));
                    },
                        child: Text(
                            "login to Account",style:TextStyle(color: primaryColor,fontSize: 16.0))),
                  ],
                ),
              ],

            ),
          ),
        ),
      ),
    );


  }

}
