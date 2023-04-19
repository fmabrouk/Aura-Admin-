import 'dart:ui';

import 'indexScreens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../crypt/encrypt.dart';
import '../models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Permet d'afficher la fenêtre de connexion
class LoginScreen extends StatefulWidget {
  static const routeName = '/Login.dart';
  const LoginScreen({Key key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  User user;

  /// false si l'utilisateur veut voir son message
  bool _isSecret = true;
  String _email, _password;

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      /// Logging in the user w/ Firebase
      UserCredential userC = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);

      FirebaseFirestore.instance
          .collection('utilisateur')
          .doc(userC.user.uid)
          .update({'password': encrypt(_password)});
      UserCustom userCustom;

      FirebaseFirestore.instance.collection('utilisateur').get().then(
          (QuerySnapshot querySnapshot) =>
              querySnapshot.docs.forEach((QueryDocumentSnapshot element) {
                if (element.id == userC.user.uid) {
                  userCustom = UserCustom(
                      id: element.id,
                      nom: element.get('name'),
                      prenom: element.get('prenom'),
                      eMail: element.get('eMail'),
                      phone: element.get('phone'),
                      dateNaissance: element.get('dateNaissance'),
                      passeword: element.get('password'),
                      sexe: element.get('sexe'),
                      isAdmin: element.get('isAdmin'));
                  if (userCustom.isAdmin) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IndexScreens()),
                    );
                  }
                }
              }));
    }
  }

  final RegExp emailRegex = RegExp(r"[a-z0-9\._-]+@[a-z0-9\._-]+\.[a-z]+");

  /// affichage du formulaire pour saisir le mail
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'myriad',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.0),
        Center(
          child: TextFormField(
            validator: (input) => !input.contains('@') || input.isEmpty
                ? 'Votre email est invalide'
                : null,
            onSaved: (input) => _email = input,
            controller: myController,
            onChanged: (input) {
              setState(() {
                _email = myController.text;
              });
            },
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'myriad',
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Color.fromRGBO(209, 62, 150, 1),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              hintText: 'Ex: john.doe@domain.tld',
            ),
          ),
        ),
      ],
    );
  }

  /// affichage du formulaire pour saisir le mot de passe
  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mot de Passe',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'myriad',
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.0),
        Center(
          child: TextFormField(
            obscureText: _isSecret,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'myriad',
            ),
            decoration: InputDecoration(
              suffixIcon: InkWell(
                onTap: () => setState(() => _isSecret = !_isSecret),
                child:
                    Icon(!_isSecret ? Icons.visibility : Icons.visibility_off),
              ),
              contentPadding: EdgeInsets.all(14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Color.fromRGBO(209, 62, 150, 1),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              hintText: 'Ex: gh!D4Yhd',
            ),
            onChanged: (value) => setState(() => _password = value),
            validator: (input) => input.length < 6
                ? 'Entrer un mot de passe avec 6 caractères minimum.'
                : null,
            onSaved: (input) => _password = input,
          ),
        ),
      ],
    );
  }

  /// affichage du formulaire de saisie du mot de passe
  Widget _buildForgotPasswordBtn() {
    return Container(
      margin: EdgeInsets.all(3),
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        },
        child: Text(
          'Mot de passe oublié?',
          style: TextStyle(color: Colors.black87, fontFamily: 'myriad'),
        ),
      ),
    );
  }

  /// affichage du mot de passe se connecter
  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width * 0.4,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(209, 62, 150, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            elevation: 5,
            padding: EdgeInsets.all(15.0),
          ),
          child: Text(
            'Se connecter',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'myriad',
            ),
          ),
          onPressed: () {
            _submit();
          }),
    );
  }

  /// affichage de la page de connexion avec les différents composants
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('fond.jpg'),
                    fit: BoxFit.cover,
                  )),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Colors.grey.withOpacity(0.1)),
                      child: Container(
                        color: Colors.white54,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6 < 450
                            ? 450
                            : MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width * 0.8 > 650
                            ? 650
                            : MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'AURA',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(209, 62, 150, 1),
                                          fontFamily: 'myriad',
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 15.0,
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10.0),
                                      _buildEmailTF(),
                                      SizedBox(
                                        height: 30.0,
                                      ),
                                      _buildPasswordTF(),
                                      _buildForgotPasswordBtn(),
                                      _buildLoginBtn(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
