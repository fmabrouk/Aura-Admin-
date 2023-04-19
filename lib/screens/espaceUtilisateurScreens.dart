import '../widgets/ItemUtilisateur.dart';
import 'LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/User.dart';
import '../providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

class ListeUtilisateurs extends StatefulWidget {
  static const routeName = "/listeUtilisateur.dart";

  @override
  _ListeUtilisateursState createState() => _ListeUtilisateursState();
}

class _ListeUtilisateursState extends State<ListeUtilisateurs> {
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      /// Initialise la liste d'utilisateur
      Provider.of<UserProvider>(context, listen: false).fetchAndSetUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<UserCustom> _users = Provider.of<UserProvider>(context).users;
  
    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leadingWidth: 100,
          leading: TextButton(
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false).clear();
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(
                    Icons.double_arrow_rounded,
                    color: Colors.black45,
                    size: 30,
                  ),
                ),
                Text(
                  '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'mmyriad',
                    fontSize: 15,
                    color: Color.fromRGBO(209, 62, 150, 1),
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            'Espace Utilisateur',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'myriad',
              fontSize: 22,
              color: Color.fromRGBO(209, 62, 150, 1),
            ),
          ),
          centerTitle: true,
        ),
        body: Scrollbar(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.all(25),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 90,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black87),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<UserProvider>(context, listen: false)
                                  .sortByEmail();
                            },
                            child: Container(
                              height: 100,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              child: Center(
                                  child: Text(
                                'Adresse mail',
                                style: TextStyle(fontSize: 18),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<UserProvider>(context, listen: false)
                                  .sortByName();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              child: Center(
                                  child: Text(
                                'Nom',
                                style: TextStyle(fontSize: 18),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<UserProvider>(context, listen: false)
                                  .sortByPrenom();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              child: Center(
                                  child: Text(
                                'Prénom',
                                style: TextStyle(fontSize: 18),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.all(25),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (context, index) => ItemUtilisateur(
                              users: _users,
                              index: index,
                            )),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else
      return LoginScreen();
  }
}
