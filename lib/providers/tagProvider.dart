import '../models/article.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/tag.dart';

class TagProvider with ChangeNotifier {
  List<Tag> _tags = [];

  /// Initialise _articles avec les données stockées dans la base de donnée
  Future<void> fetchAndSetTag() async {
    final List<Tag> _liste = [];

    await FirebaseFirestore.instance
        .collection('tags')
        .get()
        .then((QuerySnapshot querySnapshot) =>
          querySnapshot.docs.forEach((QueryDocumentSnapshot element) {
          _liste.add(Tag(
            id: element.id, 
            label: element.get ('label'),
            labelEN: element.get('labelEN'),
            definition: element.get('definition'),
            definitionEN: element.get('definitionEN')
          ));
        }))
        .onError((error, stackTrace)=> error);

    _liste.sort((a, b) => a.label.compareTo(b.label));
    _tags = [..._liste];
    notifyListeners();
  }





  /// @return Renvoi la liste d'étiquettes
  List<Tag> get tags {
    return [..._tags];
  }

  /// Mets l'attribut isVisble de tout les étiquettes à false
  void isNotVisibleAll() {
    for (var i = 0; i < _tags.length; i++) {
      _tags[i].isVisible = false;
    }
    notifyListeners();
  }

  /// @args - text
  /// @return Renvoi une liste d'étiquettes contenant 'text' dans son label
  List<Tag> listSearch(String text) {
    List<Tag> list = [];

    for (var i = 0; i < _tags.length; i++) {
      if (_tags[i].label == text) {
        if (_tags[i].definition == text)
          list.add(_tags[i]);
      }
    }
    return list;
  }

  /// @return Renvoi une liste d'étiquette avec leurs attribut isVisible à true
  List<Tag> listVisible() {
    List<Tag> _list = [];
    for (var i = 0; i < _tags.length; i++) {
      if (_tags[i].isVisible == true) _list.add(_tags[i]);
    }
    return _list;
  }

  /// Renvoi la liste de mots clefs d'un article
  List<String> listLabel(List<String> article) {
    List<String> l = [];

    for (var i = 0; i < article.length; i++) {
      for (var j = 0; j < _tags.length; j++) {
        if (_tags[j].id == article[i]) l.add(_tags[j].label);
      }
    }

    return l;
  }

  /// vide la liste
  void reset() {
    _tags.clear();
    notifyListeners();
  }

  /// Initialise la liste d'article selon les mots cles d'un article
  void iniLabel(List<String> tags) {
    for (var i = 0; i < _tags.length; i++) {
      for (var j = 0; j < tags.length; j++) {
        if (_tags[i].id == tags[j]) {
          _tags[i].isVisible = true;
        }
      }
    }
  }


  void add(String label, String definition, String labelEN, String definitionEN) async {
    Tag _tag = Tag(id: Uuid().v4(), label: label,labelEN: labelEN, definition: definition, definitionEN: definitionEN);
    _tags.add(_tag);

    print('ADD');
    notifyListeners();
  }


  void delete(Tag tag) async {
    tags.remove(tag);
    print('REMOVE');

    notifyListeners();
  }
}
