import 'dart:ui';

import 'LoginScreen.dart';
import '../widgets/customAppBar.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AproposScreen extends StatefulWidget {
  static const routeName = '/aPropos.dart';

  AproposScreen({Key key}) : super(key: key);

  @override
  _AproposScreenState createState() => _AproposScreenState();
}

class _AproposScreenState extends State<AproposScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  final _formKeyEN = GlobalKey<FormState>();
  TextEditingController _controllerEN = TextEditingController();

  FieldPath fieldPath = FieldPath.fromString('contenu');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      FirebaseFirestoreWeb()
          .collection('Aproposdemoi')
          .doc('KCFtWvJBDHA2HCMvdzVS')
          .get()
          .then((value) => _controller.text = value.get('contenu'));
    });

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      FirebaseFirestoreWeb()
          .collection('Aproposdemoi')
          .doc('D0plamtC78pQSgjgJaJW')
          .get()
          .then((value) => _controllerEN.text = value.get('contenu'));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerEN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leadingWidth: 100,
          leading: CustomAppBar(),
          title: Text(
            'A propos de nous',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'myriad',
              fontSize: 25,
              color: Color.fromRGBO(209, 62, 150, 1),
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('fond.jpg'),
            fit: BoxFit.cover,
          )),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
            child: Container(
              decoration:
                  new BoxDecoration(color: Colors.grey.withOpacity(0.1)),
              child: Container(
                color: Colors.white54,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: Text("Texte en français",
                                style: TextStyle(
                                  color: Color.fromRGBO(209, 62, 150, 1),
                                  fontSize: 20,
                                ))),
                        Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                    gapPadding: 5),
                              ),
                              cursorHeight: 18,
                              cursorColor: Colors.black87,
                              maxLines: 23,
                              controller: _controller,
                              textInputAction: TextInputAction.newline,
                              validator: (text) {
                                if (text.isEmpty || text == null) {
                                  return 'Remplissez ';
                                } else
                                  return null;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: Text("Texte en anglais",
                                style: TextStyle(
                                  color: Color.fromRGBO(209, 62, 150, 1),
                                  fontSize: 20,
                                ))),
                        Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Form(
                            key: _formKeyEN,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black87),
                                    gapPadding: 5),
                              ),
                              cursorHeight: 18,
                              cursorColor: Colors.black87,
                              maxLines: 23,
                              controller: _controllerEN,
                              textInputAction: TextInputAction.newline,
                              validator: (text) {
                                if (text.isEmpty || text == null) {
                                  return 'Remplissez ';
                                } else
                                  return null;
                              },
                            ),
                          ),
                        ),
                        /*SizedBox(
                          height: 20,
                        ),*/
                        TextButton(
                          onPressed: () {
                            FirebaseFirestoreWeb()
                                .collection('Aproposdemoi')
                                .doc('D0plamtC78pQSgjgJaJW')
                                .update({fieldPath: _controllerEN.text});
                            FirebaseFirestoreWeb()
                                .collection('Aproposdemoi')
                                .doc('KCFtWvJBDHA2HCMvdzVS')
                                .update({fieldPath: _controller.text}).then(
                                    (_) {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(206, 63, 143, 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                'Enregistrer',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
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
        ),
      );
    } else
      return LoginScreen();
  }
}
