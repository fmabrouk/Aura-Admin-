import 'package:flutter/material.dart';

class CustomMarker {
  /// Identifiant du marqueur
  final String id;

  /// Latitude du marqueur
  final double latitude;

  /// Longitude du marqueur
  final double longitude;

  /// Identifiant de l'article lié au marqueur
  final String idArticle;

  /// Etat du marqueur si selectionné ou non
  bool isVisible;

  /// Etat du marqueur s'il est liké ou non
  bool isFavorite;

  CustomMarker(
      {@required this.id,
      @required this.latitude,
      @required this.longitude,
      @required this.idArticle,
      this.isVisible= false,
      this.isFavorite= false});
    
  Map<String, dynamic> toJson() => {
        'longitude': this.longitude,
        'idArticle': this.idArticle,
        'latitude': this.latitude,
      };
}
