import '../models/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/CommentaireModel.dart';
import 'package:flutter/material.dart';

class CommentaireProvider with ChangeNotifier {
  List<CommentaireModel> _commentaires = [];

  Future<void> fetchAndSetComment() async {
    final List<CommentaireModel> _liste = [];
    final List<UserCustom> _listeUser = [];
    await FirebaseFirestore.instance.collection('utilisateur').get().then(
        (QuerySnapshot querySnapshot) => querySnapshot.docs.forEach((element) {
              _listeUser.add(UserCustom(
                id: element.id,
                nom: element.get('name'),
                prenom: element.get('prenom'),
                eMail: element.get('eMail'),
                passeword: element.get('password'),
                dateNaissance: element.get('dateNaissance'),
                phone: element.get('phone'),
                sexe: element.get('sexe'),
              ));
            }));

    await FirebaseFirestore.instance
        .collection('commentaire')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((QueryDocumentSnapshot element) {
        UserCustom user = _listeUser.firstWhere((user) {
          return user.id == element.get('idAuteur');
        });
        _liste.add(CommentaireModel(
            identifiant: element.id,
            contenu: element.get('contenu'),
            date: element.get('date') == null
                ? DateTime.now()
                : DateTime.fromMicrosecondsSinceEpoch(
                    element.get('date').microsecondsSinceEpoch),
            idArticle: element.get('idArticle'),
            auteur: user));
      });
    });
    _commentaires = [..._liste];

    notifyListeners();
  }

  /// @return Renvoi une liste de commentaires
  List<CommentaireModel> get commentaires {
    return [..._commentaires];
  }

  ///  Liste des commentaire d'un article
  List<CommentaireModel> commentaireFrom(String idArticle) {
    var com = [
      ..._commentaires
          .where((element) => element.idArticle == idArticle)
          .toList()
    ];

    com.sort((a, b) => a.date.compareTo(b.date));

    return com;
  }

  CommentaireModel markerToCommentaire(String id) {
    return _commentaires
        .firstWhere(((commentaire) => commentaire.identifiant == id));
  }

  /// Ajoute un commentaire dans la liste
  void add(CommentaireModel commentaire) {
    _commentaires.add(commentaire);
    notifyListeners();
  }

  /// Supprime un commentaire
  void delete(CommentaireModel commentaire) {
    FirebaseFirestore.instance
        .collection('commentaire')
        .doc(commentaire.identifiant)
        .delete();
    _commentaires.removeWhere(
        (element) => element.identifiant == commentaire.identifiant);
    notifyListeners();
  }
}
