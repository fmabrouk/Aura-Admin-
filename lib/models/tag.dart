import 'package:flutter/material.dart';

class Tag {
  /// Identifiant de l'étiquette
  final String id;

  /// Label de l'étiquette
  final String label;

  /// Label de l'étiquette en anglais
  final String labelEN;

  /// Definition du tag
  final String definition;

  /// Définition du tag en anglais
  final String definitionEN;

  /// Si l'etiquette est activée ou non
  bool isVisible;

  Tag({
    @required this.id, 
    @required this.label, 
    @required this.labelEN, 
    @required this.definition, 
    @required this.definitionEN, 
    this.isVisible = false});

  Map<String, dynamic> toJson() => {
    'label':this.label,
    'labelEN': this.labelEN,
    'definition':this.definition,
    'definitionEN': this.definitionEN,
  };
}
