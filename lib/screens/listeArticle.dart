import 'indexScreens.dart';
import 'LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/article.dart';
import '../providers/markerProvider.dart';
import '../screens/editArticleScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class ListArticleScreen extends StatefulWidget {
  static const routeName = '/listeArticle.dart';

  ListArticleScreen({Key key}) : super(key: key);

  @override
  _ListArticleScreenState createState() => _ListArticleScreenState();
}

class _ListArticleScreenState extends State<ListArticleScreen> {
  FieldPath fieldPath = FieldPath.fromString("favoris");
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      Provider.of<MarkerProvider>(context, listen: false).fetchAndSetMarker();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> articles;

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
            'Liste Des Articles',
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
          stream: FirebaseFirestore.instance.collection('articles').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              articles = snapshot.data.docs;
              articles.sort((a, b) => a
                  .get('title')
                  .toString()
                  .compareTo(b.get('title').toString()));
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
                                  itemCount: articles.length,
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
                                              articles[index].get('title') +
                                                  ", " +
                                                  articles[index]
                                                      .get('architecte') +
                                                  ", " +
                                                  articles[index].get('date'),
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
                                            List<String> tags =
                                                List<String>.from(
                                                    articles[index]
                                                        .get('tags'));

                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditArticleScreen(
                                                          marker: Provider.of<
                                                                      MarkerProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .articleToMarker(
                                                                  articles[
                                                                          index]
                                                                      .id),
                                                          article: Article(
                                                            id: articles[index]
                                                                .id,
                                                            title: articles[
                                                                    index]
                                                                .get('title'),
                                                            titleEN: articles[
                                                                    index]
                                                                .get('titleEN'),
                                                            architecte: articles[
                                                                    index]
                                                                .get(
                                                                    'architecte'),
                                                            artiste: articles[
                                                                    index]
                                                                .get('artiste'),
                                                            associe: articles[
                                                                    index]
                                                                .get('associe'),
                                                            /*image: articles[
                                                                    index]
                                                                .get('image'),*/
                                                            audio: articles[
                                                                    index]
                                                                .get('audio'),
                                                            audioEN: articles[
                                                                    index]
                                                                .get('audioEN'),
                                                            chef:
                                                                articles[index]
                                                                    .get(
                                                                        'chef'),
                                                            construire: articles[
                                                                    index]
                                                                .get(
                                                                    'construire'),
                                                            date:
                                                                articles[index]
                                                                    .get(
                                                                        'date'),
                                                            dimensions: articles[
                                                                    index]
                                                                .get(
                                                                    'dimensions'),
                                                            eclairagiste: articles[
                                                                    index]
                                                                .get(
                                                                    'eclairagiste'),
                                                            expositions: articles[
                                                                    index]
                                                                .get(
                                                                    'expositions'),
                                                            ingenieur: articles[
                                                                    index]
                                                                .get(
                                                                    'ingenieur'),
                                                            installation: articles[
                                                                    index]
                                                                .get(
                                                                    'installation'),
                                                            lieu:
                                                                articles[index]
                                                                    .get(
                                                                        'lieu'),
                                                            local: articles[
                                                                    index]
                                                                .get('local'),
                                                            monument: articles[
                                                                    index]
                                                                .get(
                                                                    'monument'),
                                                            musee: articles[
                                                                    index]
                                                                .get('musee'),
                                                            operation: articles[
                                                                    index]
                                                                .get(
                                                                    'operation'),
                                                            patrimoine: articles[
                                                                    index]
                                                                .get(
                                                                    'patrimoine'),
                                                            paysagiste: articles[
                                                                    index]
                                                                .get(
                                                                    'paysagiste'),
                                                            projet: articles[
                                                                    index]
                                                                .get('projet'),
                                                            surface: articles[
                                                                    index]
                                                                .get('surface'),
                                                            surfaceExpo: articles[
                                                                    index]
                                                                .get(
                                                                    'surfaceExpo'),
                                                            tags: tags,
                                                            text:
                                                                articles[index]
                                                                    .get(
                                                                        'text'),
                                                            textEn: articles[
                                                                    index]
                                                                .get('textEn'),
                                                            transformation:
                                                                articles[index].get(
                                                                    'transformation'),
                                                            urbaniste: articles[
                                                                    index]
                                                                .get(
                                                                    'urbaniste'),
                                                            photo: articles[
                                                                    index]
                                                                .get('photo'),
                                                          ),
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
                                                  context, articles[index]);
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

  showAlertDialog(BuildContext context, article) {
    /// FONCTION POUR FAIRE L'ALERTE

    Widget continueButton = TextButton(
      child: Text("Supprimer",
          style: TextStyle(
            color: Colors.red,
          )),
      onPressed: () async {
        List<String> _listFavori;

        var marker = await FirebaseFirestoreWeb()
            .collection("markers")
            .get()
            .then((value) => value.docs.firstWhere(
                (element) => element.get('idArticle') == article.id));
        await FirebaseFirestoreWeb()
            .collection('utilisateur')
            .get()
            .then((value) => value.docs.forEach((element) async {
                  var x = element.get('favoris');

                  _listFavori = [...x];
                  if (_listFavori.contains(marker.id)) {
                    _listFavori.remove(marker.id);
                    await FirebaseFirestoreWeb()
                        .collection('utilisateur')
                        .doc(element.id)
                        .update({fieldPath: _listFavori}).then(
                            (value) => print('supp favori'));
                  }
                  _listFavori.clear();
                }));

        await FirebaseFirestoreWeb()
            .collection("markers")
            .doc(marker.id)
            .delete()
            .then((value) {
          print('delete marker');
        });

        await FirebaseFirestoreWeb()
            .collection('commentaire')
            .get()
            .then((value) => value.docs.forEach((element) {
                  if (element.get('idArticle') == article.id) {
                    FirebaseFirestoreWeb()
                        .collection('commentaire')
                        .doc(element.id)
                        .delete()
                        .then((value) {
                      print('delete commentaire');
                    });
                  }
                }));

        if (article.get('audio').isNotEmpty)
          await FirebaseStorage.instance
              .ref('gs://l3as1-8cefe.appspot.com/${article.get('audio')}')
              .delete();
        if (article.get('image').isNotEmpty)
          await FirebaseStorage.instance
              .ref('gs://l3as1-8cefe.appspot.com/${article.get('image')}')
              .delete();

        await FirebaseFirestoreWeb()
            .collection("articles")
            .doc(article.id)
            .delete()
            .then((value) {
          print('delete article');
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
          article.get('title'),
          style: TextStyle(
            color: Color.fromRGBO(209, 62, 150, 1),
          ),
        ),
      ),

      /// CE QUE CONTIENT L'ALERTE
      content: Text(
          "Êtes-vous sûr de vouloir supprimer définitivement cet article ?"),
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
