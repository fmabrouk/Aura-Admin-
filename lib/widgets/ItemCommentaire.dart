import '../models/CommentaireModel.dart';
import '../models/article.dart';
import '../providers/commentProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemCommentaire extends StatelessWidget {
  const ItemCommentaire({
    Key key,
    @required List<CommentaireModel> commentairesData,
    @required List<Article> articlesData,
    @required int index,
    @required bool isOpen,
  })  : _commentairesData = commentairesData,
        _articlesData = articlesData,
        this.index = index,
        this.isOpen = isOpen,
        super(key: key);

  final List<CommentaireModel> _commentairesData;
  final List<Article> _articlesData;
  final int index;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    List<CommentaireModel> _commentOfArticle = _commentairesData
        .where((element) => element.idArticle == _articlesData[index].id)
        .toList();

    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Text('Nombre de commentaires: ' +
              _commentairesData
                  .where(
                      (element) => element.idArticle == _articlesData[index].id)
                  .toList()
                  .length
                  .toString()),
        ),
        Container(
          height: isOpen ? null : 0,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _commentOfArticle.length,
            itemBuilder: (ctx, i) => Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Text(
                              DateFormat('yyyy-MM-dd kk:mm')
                                  .format(_commentOfArticle[i].date)
                                  .toString(),
                              style: TextStyle(
                                  fontFamily: 'myriad',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Container(
                            child: Text(
                              _commentOfArticle[i].auteur.nom,
                              style: TextStyle(
                                  fontFamily: 'myriad',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Container(
                            child: Text(
                              _commentOfArticle[i].auteur.prenom,
                              style: TextStyle(
                                  fontFamily: 'myriad',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showAlertDialog(context, _commentOfArticle[i]);
                              })
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(4),
                        child: Text(
                          _commentOfArticle[i].contenu,
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'myriad',
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  endIndent: 30,
                  indent: 30,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

showAlertDialog(BuildContext context, CommentaireModel commentaireModel) {
  /// set up the buttons
  Widget cancelButton = TextButton(
    child: Text(
      "Annuler",
      style: TextStyle(color: Colors.black),
    ),
    // style: ButtonStyle(backgroundColor: Colors.white),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text(
      "Confirmer",
      style: TextStyle(color: Colors.red),
    ),
    onPressed: () {
      Provider.of<CommentaireProvider>(context, listen: false)
          .delete(commentaireModel);
      Navigator.pop(context);
    },
  );

  /// show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Suppression de commentaire",
          style: TextStyle(color: Color.fromRGBO(209, 62, 150, 1)),
        ),
        content: Text("Êtes-vous sûr de vouloir supprimer ce commentaire? "),
        actions: [
          cancelButton,
          SizedBox(
            width: 10,
          ),
          continueButton,
        ],
      );
    },
  );
}
