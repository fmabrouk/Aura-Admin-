import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import '../models/User.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  List<UserCustom> _users = [];

  /// Initialise _articles avec les données stockées dans la base de donnée
  Future<void> fetchAndSetUser() async {
    await FirebaseFirestore.instance.collection('utilisateur').get().then(
        (QuerySnapshot querySnapshot) =>
            querySnapshot.docs.forEach((QueryDocumentSnapshot element) {
              UserCustom userCustom = UserCustom(
                id: element.id,
                nom: element.get('name'),
                prenom: element.get('prenom'),
                dateNaissance: element.get('dateNaissance'),
                eMail: element.get('eMail'),
                passeword: element.get('password'),
                phone: element.get('phone'),
                sexe: element.get('sexe'),
              );

              if (userCustom != null) {
                _users.add(userCustom);
              }
            }));
    notifyListeners();
  }

  /// Récupere la liste d'utilisateur
  List<UserCustom> get users {
    return [..._users];
  }

  ///  Renvoi l'utilisateur en fonction de l'id reçu
  UserCustom searchUser(String id) {
    return _users.firstWhere(((article) => article.id == id));
  }

  /// Ajoute un utlisateur
  void addUser(UserCustom at) {
    _users.add(at);
    notifyListeners();
  }

  /// Surpprime l'utilisateur de la base de donnée et l'enleve de la liste
  void delete(UserCustom user) {
    FirebaseFirestoreWeb()
        .collection('commentaire')
        .get()
        .then((value) => value.docs.forEach((element) {
              if (element.get('idAuteur') == user.id) {
                FirebaseFirestoreWeb()
                    .collection('commentaire')
                    .doc(element.id)
                    .delete();
              }
            }));

    FirebaseFirestore.instance
        .collection('utilisateur')
        .doc(user.id)
        .delete();
    _users.remove(user);

    notifyListeners();
  }

  /// Vide la liste
  void clear() {
    _users.clear();
  }

  /// Trie la liste en fonction de l'adresse mail
  void sortByEmail() {
    _users.sort((a, b) => a.eMail.compareTo(b.eMail));
    notifyListeners();
  }

  /// Trie la liste en fonction du nom
  void sortByName() {
    _users.sort((a, b) => a.nom.compareTo(b.nom));
    notifyListeners();
  }

  /// Trie la liste en fonction du prénom
  void sortByPrenom() {
    _users.sort((a, b) => a.prenom.compareTo(b.prenom));
    notifyListeners();
  }
}
