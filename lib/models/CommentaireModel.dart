import '../models/User.dart';
import 'package:flutter/material.dart';

class CommentaireModel {
  final String identifiant;
  final String contenu;
  final UserCustom auteur;
  final String idArticle;
  final DateTime date;

  const CommentaireModel({
    @required this.identifiant,
    @required this.auteur,
    @required this.date,
    @required this.idArticle,
    this.contenu = '',
  });
}