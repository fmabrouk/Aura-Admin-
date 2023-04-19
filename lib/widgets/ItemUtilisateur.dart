import '../models/User.dart';
import '../providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemUtilisateur extends StatelessWidget {
  /// Index
  final int index;

  /// Liste d'utilisateur
  final List<UserCustom> users;

  const ItemUtilisateur({Key key, this.index, this.users}) : super(key: key);

  /// Creation de l'alerte
  /// Supprime l'utilisateur si confirmé
  _showAlertDialog(BuildContext context, UserCustom userCustom) {
    /// set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Annuler",
        style: TextStyle(color: Colors.black),
      ),
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
        Provider.of<UserProvider>(context, listen: false).delete(userCustom);
        Navigator.pop(context);
      },
    );

    /// set up the AlertDialog
    String eMail = userCustom.eMail;
    AlertDialog alert = AlertDialog(
      title: Text(
        "Suppression d'utilisateur",
        style: TextStyle(
          color: Color.fromRGBO(209, 62, 150, 1),
        ),
      ),
      content:
          RichText(
        text: TextSpan(
          text: 'Êtes-vous sûr de vouloir supprimer cet utilisateur? \n',
          children: <TextSpan>[
            TextSpan(
                text: eMail, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    /// show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black87,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 10,
                ),
                /// Adresse mail de l'utilisateur
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(3),
                    margin: EdgeInsets.all(3),
                    child: Center(
                      child: index < users.length && users[index].eMail != null
                          ? Text(
                              users[index].eMail,
                            )
                          : Text(''),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                /// Nom de l'utilisateur
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(3),
                    margin: EdgeInsets.all(3),
                    child: Center(
                      child: index < users.length
                          ? Text(
                              users[index].nom,
                            )
                          : Text(''),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                /// Prénom de l'utilisateur
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(3),
                    margin: EdgeInsets.all(3),
                    child: Center(
                      child: index < users.length && users[index].eMail != null
                          ? Text(
                              users[index].prenom,
                            )
                          : Text(''),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _showAlertDialog(context, users[index]);
                    }),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
