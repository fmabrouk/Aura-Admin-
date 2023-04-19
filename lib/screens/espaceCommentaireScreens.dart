import 'LoginScreen.dart';
import '../widgets/ItemCommentaire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/customAppBar.dart';
import '../models/CommentaireModel.dart';
import '../models/article.dart';
import '../providers/articleProvider.dart';
import '../providers/commentProvider.dart';
import 'package:flutter/material.dart'; //On importe le matériel dart qui contient les principaux widget nécessaires
import 'package:provider/provider.dart';

/// Page de la liste des commentaires
class EspaceCommentaireScreens extends StatefulWidget {
  static const routeName = "/listeCommentaires.dart";
  @override
  _EspaceCommentaireScreensState createState() =>
      _EspaceCommentaireScreensState();
}

class _EspaceCommentaireScreensState extends State<EspaceCommentaireScreens> {
  GlobalKey key = GlobalKey();

  /// Indique s'il le widget a déjà été build ou non
  bool isInit = false;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      /// Initialise les articles et commentaires
      Provider.of<ArticleProvider>(context, listen: false).fetchAndSetArticle();
      Provider.of<CommentaireProvider>(context, listen: false)
          .fetchAndSetComment();
    }
    isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Article> _articlesData =
        Provider.of<ArticleProvider>(context).articles;
    List<CommentaireModel> _commentairesData =
        Provider.of<CommentaireProvider>(context).commentaires;

    _articlesData.sort((a, b) => a.title.compareTo(b.title));

    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(

          /// Permet de faire apparaître la bande de titre en haut de la page
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leadingWidth: 100,
            leading: CustomAppBar(),
            title: Text(
              'Espace Commentaire',
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
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 0.8,

                  /// ARTICLES
                  child: ListView.builder(
                      itemCount: _articlesData.length,
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) => Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Provider.of<ArticleProvider>(context,
                                              listen: false)
                                          .switchIsOpen(_articlesData[index]);
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.all(2),
                                    child: Center(
                                      child: Text(
                                        _articlesData[index].title,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'myriad',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),

                                /// COMMENTAIRES
                                ItemCommentaire(
                                  commentairesData: _commentairesData,
                                  articlesData: _articlesData,
                                  index: index,
                                  isOpen: _articlesData[index].isOpen,
                                ),
                                Divider(
                                  thickness: 2,
                                ),
                              ],
                            ),
                          )),
                ),
              ),
            ),
          ));
    } else
      return LoginScreen();
  }
}
