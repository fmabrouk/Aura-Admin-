import 'package:aura_administration/models/tag.dart';
import 'package:uuid/uuid.dart';

import '../screens/editTagScreen.dart';
import '../screens/indexScreens.dart';
import '../screens/tagsScreen.dart';
import 'package:flutter/material.dart';

/// Page représentant les options possibles pour les articles (ajouter ou lister)
class TagIndex extends StatelessWidget {
  const TagIndex({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          centerTitle: true,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('fond.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.white54,
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Container(
                    child: TextButton(
                        onPressed: () {
                          Tag nvTag = new Tag(
                              id: Uuid().v4(),
                              label: '',
                              labelEN: '',
                              definition: '',
                              definitionEN: '');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditTagScreen(
                                      tag: nvTag, fromEdit: false))); // CHANGER
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color.fromRGBO(206, 63, 143, 0.9),
                          ),
                          child: Center(
                            child: Text(
                              'Ajouter un mot-clé',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 23),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, ListTagsScreen.routeName);
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color.fromRGBO(206, 63, 143, 0.9),
                          ),
                          child: Center(
                            child: Text(
                              'Liste des mots-clés',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 23),
                            ),
                          ),
                        )),
                  ),
                  /* SizedBox(
              height: 100,
            ),*/
                  Container(
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 50,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, IndexScreens.routeName);
                        }),
                  ),
                ],
              ),
            )));
  }
}
