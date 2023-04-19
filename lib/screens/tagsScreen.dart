import 'package:aura_administration/screens/editTagScreen.dart';

import '../models/tag.dart';
import '../providers/tagProvider.dart';
import 'indexScreens.dart';
import 'LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class ListTagsScreen extends StatefulWidget {
  static const routeName = '/listeTags.dart';

  ListTagsScreen({Key key}) : super(key: key);

  @override
  _ListTagsScreenState createState() => _ListTagsScreenState();
}

class _ListTagsScreenState extends State<ListTagsScreen> {

  List<Tag> _tags = [];

  @override
  Widget build(BuildContext context) {
    var tags = Provider.of<TagProvider>(context).tags;

    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leadingWidth: 100,
          leading: TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(IndexScreens.routeName);
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
              ],
            ),
          ),
          title: Text(
            'Liste des mots-clés',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'myriad',
              fontSize: 25,
              color: Color.fromRGBO(209, 62, 150, 1),
            ),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('tags').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {

              _tags.clear();
              snapshot.data.docs.forEach((element) {
                _tags.add(
                    Tag(id: element.id, label: element.get('label'), definition: element.get('definition'), labelEN: element.get('labelEN'), definitionEN: element.get('definitionEN')));
              });

              _tags.sort((a, b) => a.label.compareTo(b.label));

              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - kToolbarHeight,
                  width: double.infinity,
                  color: Colors.white,
                  child: Scrollbar(
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: EdgeInsets.all(7),
                                margin: EdgeInsets.all(8),
                                child: ListView.builder(
                                  itemCount: _tags.length,
                                  itemBuilder: (ctx, index) => Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: Colors.black54),
                                        borderRadius: BorderRadius.circular(3)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            child: Text(
                                              _tags[index].label,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'myriad'),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditTagScreen(
                                                          tag: Tag(
                                                            id: _tags[index].id,
                                                            label: _tags[index].label,
                                                            labelEN: _tags[index].labelEN,
                                                            definition: _tags[index].definition,
                                                            definitionEN: _tags[index].definitionEN,
                                                          ),
                                                          fromEdit: true,
                                                        )));
                                          },
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),

                                        ///	BOUTON SUPPRIMER onPressed appelle la fonction showAlertDialog
                                        IconButton(
                                            color: Colors.red,
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              showAlertDialog(
                                                  context, _tags[index]);
                                            }),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()));
          },
        ),
      );
    } else
      return LoginScreen();
  }

  showAlertDialog(BuildContext context, tag) {
    /// FONCTION POUR FAIRE L'ALERTE

    Widget continueButton = TextButton(
      child: Text("Supprimer",
          style: TextStyle(
            color: Colors.red,
          )),
      onPressed: () async {
        await FirebaseFirestoreWeb()
            .collection("tags")
            .doc(tag.id)
            .delete()
            .then((value) {
          print('delete tag');
        });
        Navigator.of(context).pop(true);
      },
    );

    ///WIDGET POUR LE BOUTON ANNULER
    Widget abortButton = TextButton(
      child: Text(
        "Annuler",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Container(
        child: Text(
          tag.label,
          style: TextStyle(
            color: Color.fromRGBO(209, 62, 150, 1),
          ),
        ),
      ),
      /// CE QUE CONTIENT L'ALERTE
      content: Text(
          "Êtes-vous sûr de vouloir supprimer définitivement ce tag ?"),
      actions: [
        abortButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
