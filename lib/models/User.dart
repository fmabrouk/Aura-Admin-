import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserCustom {
  final String id;
  final String nom;
  final String prenom;
  final String dateNaissance;
  final String eMail;
  final String phone;
  final String passeword;
  final bool isAdmin;
  final String sexe;

  const UserCustom({
    this.isAdmin=false,
    this.id,
    this.nom,
    this.prenom,
    this.dateNaissance,
    this.eMail,
    this.phone,
    this.passeword,
    this.sexe,
  });

  factory UserCustom.fromDoc(DocumentSnapshot doc) {
    return UserCustom(
        id: doc.id,
        nom: doc['nom'],
        prenom: doc['prenom'],
        eMail: doc['eMail'],
        dateNaissance: doc['dateNaissance'],
        phone: doc['phone'],
        passeword: doc['password'],
        sexe: doc['sexe']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'dateNaissance': dateNaissance,
      'eMail': eMail,
      'phone': phone,
      'passeword': passeword,
      'sexe': sexe,
    };
  }

  factory UserCustom.fromMap(Map<String, dynamic> map, String id) {
    return UserCustom(
      id: id,
      nom: map['nom'],
      prenom: map['prenom'],
      dateNaissance: map['dateNaissance'],
      eMail: map['eMail'],
      phone: map['phone'],
      passeword: map['passeword'],
    );
  }

  String toJson() => json.encode(toMap());

}
