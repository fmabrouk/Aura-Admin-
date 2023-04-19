import 'dart:ui';
import 'package:aura_administration/screens/tagsScreen.dart';
import 'package:aura_administration/widgets/TagIndex.dart';

import 'conditionScreen.dart';
import 'politiqueScreen.dart';
import 'aProposScreen.dart';
import '../widgets/ArticleIndex.dart';
import 'LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/espaceCommentaireScreens.dart';
import 'package:flutter/material.dart';

import 'espaceUtilisateurScreens.dart';

class IndexScreens extends StatefulWidget {
  static const routeName = '/index.dart';
  @override
  _IndexScreensState createState() => _IndexScreensState();
}

class _IndexScreensState extends State<IndexScreens> {
  bool _isArticle = false;

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
        /// Permet de faire apparaître la bande de titre en haut de la page
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leadingWidth: 100,
          leading: Container(),
          title: Text(
            'Administration Aura',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'myriad',
              fontSize: 25,
              color: Color.fromRGBO(209, 62, 150, 1),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.all(10),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.grey[400],
                    size: 30,
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                ),
              ),
            )
          ],
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
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!_isArticle) ...[
                            Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _isArticle = !_isArticle;
                                            });
                                          },
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Color.fromRGBO(
                                                  206, 63, 143, 0.9),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Articles',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23),
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      child: TextButton(
                                          onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        TagIndex()),
                                              ),
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Color.fromRGBO(
                                                  206, 63, 143, 0.9),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Mots-clés',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23),
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      child: TextButton(
                                          onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EspaceCommentaireScreens()),
                                              ),
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Color.fromRGBO(
                                                  206, 63, 143, 0.9),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Commentaires',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23),
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      child: TextButton(
                                          onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ListeUtilisateurs()),
                                              ),
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Color.fromRGBO(
                                                  206, 63, 143, 0.9),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Utilisateurs',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23),
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                AproposScreen.routeName);
                                          },
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Color.fromRGBO(
                                                  206, 63, 143, 0.9),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'A propos de nous',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23),
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                PolitqueScreen.routeName);
                                          },
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Color.fromRGBO(
                                                  206, 63, 143, 0.9),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Politique de confidentialité',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23),
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                ConditionScreen.routeName);
                                          },
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Color.fromRGBO(
                                                  206, 63, 143, 0.9),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Conditions générales d\'utilisations',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23),
                                              ),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )),
                          ] else
                            (ArticleIndex()),
                          if (_isArticle)
                            Container(
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 50,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isArticle = !_isArticle;
                                  });
                                },
                              ),
                            )
                        ]),
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
