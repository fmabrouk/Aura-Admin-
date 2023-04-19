import 'LoginScreen.dart';
import 'listeArticle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/article.dart';
import '../models/customMarker.dart';
import '../providers/articleProvider.dart';
import '../providers/markerProvider.dart';
import '../providers/tagProvider.dart';
import '../screens/indexScreens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class PreviewScreen extends StatefulWidget {
  static const routeName = '/preview.dart';
  // Article à modifier/créer
  final Article article;
  // Marqueur à modifier/créer
  final CustomMarker marker;

  //fichier image
  final PlatformFile image;
  // /Fichier audio
  final PlatformFile audio;
  // Nom du fichier à supprimer dans la bdd
  final String audioToDelete;
  // Indique si l'on a modifié l'audio
  final bool diffAudio;

  // Nom du fichier à supprimer dans la bdd
  final String imageToDelete;
  // Indique si l'on a modifié l'image
  final bool diffImage;
  // Indique si l'on modifie l'article ou non
  final bool fromEdit;

  const PreviewScreen(
      {Key key,
      this.article,
      this.marker,
      this.image,
      this.imageToDelete = '',
      this.diffImage = false,
      this.audio,
      this.audioToDelete = '',
      this.diffAudio = false,
      this.fromEdit = false})
      : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _trad = false;

  bool _audioState = false;

  Future<void> _uploadString(PlatformFile file) async {
    try {
      FirebaseStorage.instance
          .ref('gs://l3as1-8cefe.appspot.com/${file.name}')
          .putData(file.bytes)
          .then((_) {
        print('Audio ajouté');
      });
    } on firebase_core.FirebaseException catch (e) {}
  }

  Future<void> _uploadString2(PlatformFile file) async {
    try {
      FirebaseStorage.instance
          .ref('gs://l3as1-8cefe.appspot.com/${file.name}')
          .putData(file.bytes)
          .then((_) {
        print('Image ajouté');
      });
    } on firebase_core.FirebaseException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    /// Liste de texte avec introdution
    List<String> intro = Provider.of<ArticleProvider>(context, listen: false)
        .getIntro(widget.article, _trad);

    /// Liste  des labels
    List<String> labels = Provider.of<TagProvider>(context, listen: false)
        .listLabel(widget.article.tags);

    ///Liste de texte séparant les phrases en gras ou non
    List<String> gras = Provider.of<ArticleProvider>(context, listen: false)
        .getBold(intro.length == 1 ? intro[0] : intro[1]);

    ///Texte représentant la signature
    String sign =
        Provider.of<ArticleProvider>(context, listen: false).getSign(gras.last);

    if (gras.last.contains('&signature')) {
      var _end = gras.last.split('&signature');
      gras.removeLast();
      gras.add(_end[0]);
    }

    /// Mets en gras les String de gras lorsque [i] est impaire
    List<Widget> _addBoldToText() {
      List<Text> l = [];
      if (gras.length > 1) {
        for (var i = 1; i < gras.length; i++) {
          if (i % 2 == 1) {
            l.add(Text(
              gras[i],
              style: TextStyle(
                fontFamily: 'myriad',
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ));
          } else {
            l.add(Text(
              gras[i],
              style: TextStyle(
                fontFamily: 'myriad',
                fontSize: 17,
              ),
            ));
          }
        }
      }
      return l;
    }

    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leadingWidth: 100,
          leading: Container(),
          title: Text(
            'Preview',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'myriad',
              fontSize: 25,
              color: Color.fromRGBO(209, 62, 150, 1),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Scrollbar(
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height - kToolbarHeight,
              width: double.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8 -
                          kToolbarHeight,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black)),
                      width: 350,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ///Affiche Header
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ///Affiche button Favori
                                    Center(
                                      child: IconButton(
                                        iconSize: 26,
                                        color: Colors.white,
                                        icon: Icon(
                                          Icons.favorite_rounded,
                                          color: Colors.black45,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),

                                    /// Affiche Button 'Play'
                                    if (!_audioState)
                                      Center(
                                        child: IconButton(
                                            iconSize: 26,
                                            icon: Icon(
                                              Icons.play_arrow,
                                              color: Colors.black45,
                                            ),
                                            onPressed: () {}),
                                      ),

                                    SizedBox(
                                      width: 10,
                                    ),

                                    GestureDetector(
                                        child: Container(
                                            width: 30,
                                            child: Text(_trad ? 'ENG' : 'FR')),
                                        onTap: () => {
                                              setState(
                                                () {
                                                  _trad = !_trad;
                                                },
                                              ),
                                            }),
                                  ],
                                ),

                                /// Affiche button Commentaire
                                TextButton(
                                  child: Row(
                                    children: [
                                      Text(
                                        'DISCUSS',
                                        style: TextStyle(
                                            fontFamily: 'myriad',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color.fromRGBO(
                                                209, 62, 150, 1)),
                                      ),
                                      Icon(
                                        Icons.double_arrow_rounded,
                                        color: Colors.black45,
                                      )
                                    ],
                                  ),
                                  onPressed:

                                      ///  switchToComm,
                                      () {},
                                )
                              ],
                            ),
                            width: double.infinity,
                            height: 40,
                          ),

                          /// Affiche Body
                          Expanded(
                            child: Container(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: 20,
                                      child: IconButton(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          color: Colors.black45,
                                          iconSize: 35,
                                          icon: Icon(
                                            Icons.chevron_left,
                                            color: Colors.black45,
                                          ),
                                          onPressed: () {}),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: GestureDetector(
                                          onScaleUpdate:
                                              (ScaleUpdateDetails details) {},
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              /// Affiche titre de l'article
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                padding: EdgeInsets.all(10),
                                                child:
                                                    Text(widget.article.title,
                                                        style: TextStyle(
                                                          fontFamily: 'myriad',
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                              ),

                                              /// Affiche l'introduction de l'article
                                              if (intro.length == 2)
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  margin: EdgeInsets.all(10),
                                                  child: Text(
                                                    intro[0],
                                                    style: TextStyle(
                                                      fontFamily: 'myriad',
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),

                                              Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 20, 0, 0),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  child: Text(
                                                    labels.join(' / '),
                                                    style: TextStyle(
                                                        fontFamily: 'myriad',
                                                        fontSize: 14,
                                                        color: Colors.black38,
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  )),

                                              /// Affiche les architectes
                                              if (widget.article.architecte
                                                  .isNotEmpty)
                                                _buildInfo(
                                                    widget.article.architecte,
                                                    'Architecte ',
                                                    'Architect '),

                                              /// Affiche les architectes associes
                                              if (widget
                                                  .article.associe.isNotEmpty)
                                                _buildInfo(
                                                    widget.article.associe,
                                                    'Architecte associé ',
                                                    'Architecte associé '),

                                              /// Affiche les architecte transformation
                                              if (widget.article.transformation
                                                  .isNotEmpty)
                                                _buildInfo(
                                                    widget
                                                        .article.transformation,
                                                    'Architecte transformation ',
                                                    'Architecte transformation '),

                                              /// Affiche les architecte des monuments historiques
                                              if (widget
                                                  .article.monument.isNotEmpty)
                                                _buildInfo(
                                                    widget.article.monument,
                                                    'Architecte des Monuments Historiques ',
                                                    'Architecte des Monuments Historiques '),

                                              /// Affiche les architectes de projet
                                              if (widget
                                                  .article.projet.isNotEmpty)
                                                _buildInfo(
                                                    widget.article.projet,
                                                    'Architecte de projet ',
                                                    'Architect de projet '),

                                              /// Affiche architecte local
                                              if (widget
                                                  .article.local.isNotEmpty)
                                                _buildInfo(
                                                    widget.article.local,
                                                    'Architecte local ',
                                                    'Architecte local '),

                                              /// Affiche les architectes des opérations connexes
                                              if (widget
                                                  .article.operation.isNotEmpty)
                                                _buildInfo(
                                                    widget.article.operation,
                                                    'Architecte des opérations connexes ',
                                                    'Architecte des opérations connexes '),

                                              /// Affiche les architectes du patrimoine
                                              if (widget.article.patrimoine
                                                  .isNotEmpty)
                                                _buildInfo(
                                                    widget.article.patrimoine,
                                                    'Architecte du patrimoine ',
                                                    'Architecte du patrimoine '),

                                              /// Affiche le chef de projet
                                              if (widget
                                                  .article.chef.isNotEmpty)
                                                _buildInfo(
                                                    widget.article.chef,
                                                    'Chef de projet ',
                                                    'Chef de projet '),

                                              /// Affiche l'ingenieur
                                              if (widget
                                                  .article.ingenieur.isNotEmpty)
                                                _buildInfo(
                                                    widget.article.ingenieur,
                                                    'Ingénieur ',
                                                    'Ingénieur '),

                                              /// Affiche le paysagiste
                                              if (widget.article.paysagiste
                                                  .isNotEmpty)
                                                _buildInfo(
                                                    widget.article.paysagiste,
                                                    'Paysagiste ',
                                                    'Paysagiste '),

                                              /// Affiche l'urbaniste
                                              if (widget
                                                  .article.urbaniste.isNotEmpty)
                                                _buildInfo(
                                                    widget.article.urbaniste,
                                                    'Urbaniste ',
                                                    'Urbaniste '),

                                              /// Affiche l'artiste
                                              if (widget
                                                  .article.artiste.isNotEmpty)
                                                _buildInfo(
                                                    widget.article.artiste,
                                                    'Artiste ',
                                                    'Artiste '),

                                              /// Affiche l'eclairagiste
                                              if (widget.article.eclairagiste
                                                  .isNotEmpty)
                                                _buildInfo(
                                                    widget.article.eclairagiste,
                                                    'Eclairagiste ',
                                                    'Eclairagiste '),

                                              /// Affiche le conservateur du musée
                                              if (widget
                                                  .article.musee.isNotEmpty)
                                                _buildInfo(
                                                    widget.article.musee,
                                                    'Conservateur du musée ',
                                                    'Conservateur du musée '),

                                              /// Affiche le site
                                              if (widget
                                                  .article.lieu.isNotEmpty)
                                                _buildInfo(widget.article.lieu,
                                                    'Adresse ', 'Adresse '),

                                              /// Affiche la date
                                              if (widget
                                                  .article.date.isNotEmpty)
                                                _buildInfo(widget.article.date,
                                                    'Année ', 'Année '),

                                              /// Affiche l'année d'installation à Paris
                                              if (widget.article.installation
                                                  .isNotEmpty)
                                                _buildInfo(
                                                    widget.article.installation,
                                                    'Année d\'installation à Paris',
                                                    'Année d\'installation à Paris'),

                                              /// Affiche les dimensions
                                              if (widget.article.dimensions
                                                  .isNotEmpty)
                                                _buildInfo(
                                                    widget.article.dimensions,
                                                    'Dimensions ',
                                                    'Dimensions '),

                                              /// Affiche les Expositions
                                              if (widget.article.expositions
                                                  .isNotEmpty)
                                                _buildInfo(
                                                    widget.article.expositions,
                                                    'Expositions ',
                                                    'Expositions '),

                                              /// Affiche la surface
                                              if (widget
                                                  .article.surface.isNotEmpty)
                                                _buildInfo(
                                                    widget.article.surface,
                                                    'Surface ',
                                                    'Surface '),

                                              /// Affiche la surface à construire
                                              if (widget.article.construire
                                                  .isNotEmpty)
                                                _buildInfo(
                                                    widget.article.construire,
                                                    'Surface à construire ',
                                                    'Surface à construire '),

                                              /// Affiche la surface d'exposition
                                              if (widget.article.surfaceExpo
                                                  .isNotEmpty)
                                                _buildInfo(
                                                    widget.article.surfaceExpo,
                                                    'Surface d\'exposition ',
                                                    'Surface d\'exposition '),

                                              /// Affiche la surface d'exposition
                                              if (widget
                                                  .article.photo.isNotEmpty)
                                                _buildPhoto(),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Divider(
                                                thickness: 2,
                                                color: Colors.black54,
                                                endIndent: 20,
                                                indent: 20,
                                              ),

                                              ///Affiche la description de l'article
                                              Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        gras[0],
                                                        style: TextStyle(
                                                          fontFamily: 'myriad',
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      ..._addBoldToText(),
                                                      if (widget.article.text
                                                          .contains(
                                                              '&signature'))
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            sign,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'myriad',
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        )
                                                    ],
                                                  )),

                                              SizedBox(
                                                height: 30,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width > 1000
                          ? 700
                          : MediaQuery.of(context).size.width * 0.8,
                      height: 90,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  child: Text(
                                    'Annuler',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'myriad',
                                      fontSize: 17,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                            Expanded(child: Container(), flex: 1),
                            Expanded(
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextButton(
                                    child: Text(
                                      'Valider',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'myriad',
                                        fontSize: 17,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (widget.diffAudio &&
                                          widget.fromEdit &&
                                          widget.audioToDelete.isNotEmpty) {
                                        FirebaseStorage.instance
                                            .ref(
                                                'gs://l3as1-8cefe.appspot.com/${widget.audioToDelete}')
                                            .delete();
                                      }

                                      if (widget.audio != null &&
                                          widget.fromEdit) {
                                        _uploadString(widget.audio);
                                      }

                                      if (widget.diffImage &&
                                          widget.fromEdit &&
                                          widget.imageToDelete.isNotEmpty) {
                                        FirebaseStorage.instance
                                            .ref(
                                                'gs://l3as1-8cefe.appspot.com/${widget.imageToDelete}')
                                            .delete();
                                      }

                                      if (widget.image != null &&
                                          widget.fromEdit) {
                                        _uploadString2(widget.image);
                                      }

                                      if (widget.fromEdit) {
                                        FirebaseFirestore.instance
                                            .collection('articles')
                                            .doc(widget.article.id)
                                            .update(widget.article.toJson());
                                        FirebaseFirestore.instance
                                            .collection('markers')
                                            .doc(widget.marker.id)
                                            .update(widget.marker.toJson());

                                        Navigator.of(context).popUntil(
                                            ModalRoute.withName(
                                                ListArticleScreen.routeName));
                                      } else {
                                        if (widget.audio != null) {
                                          _uploadString(widget.audio);
                                        }
                                        if (widget.image != null) {
                                          _uploadString2(widget.image);
                                        }
                                        Provider.of<ArticleProvider>(context,
                                                listen: false)
                                            .addArticle(widget.article);

                                        Provider.of<MarkerProvider>(context,
                                                listen: false)
                                            .addMarker(widget.marker);

                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                ListArticleScreen.routeName,
                                                ModalRoute.withName(
                                                    IndexScreens.routeName));
                                      }
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else
      return LoginScreen();
  }

  Container _buildInfo(info, fr, eng) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              fr,
              style: TextStyle(
                fontFamily: 'myriad',
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            child: Text(info,
                style: TextStyle(
                    fontFamily: 'myriad',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          )
        ],
      ),
    );
  }

  Container _buildPhoto() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "Photo ",
              style: TextStyle(
                fontFamily: 'myriad',
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            child: Text("www.lienweb.fr",
                style: TextStyle(
                    fontFamily: 'myriad',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          )
        ],
      ),
    );
  }
}
