import 'package:aura_administration/screens/tagsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/tag.dart';
import '../widgets/customAppBar.dart';
import 'package:uuid/uuid.dart';
import '../providers/tagProvider.dart';
/// On importe le matériel dart qui contient les principaux widget nécessaires
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTagScreen extends StatefulWidget {
  static const routeName = '/formulaireArticle.dart';
  final Tag tag;

  bool fromEdit;

  EditTagScreen({Key key, this.tag, this.fromEdit}) : super(key: key);
  @override
  _EditTagScreenState createState() => _EditTagScreenState();
}

class  _EditTagScreenState extends State<EditTagScreen> {

  ///  Tag à editer
  Tag tag;

  /// Label du tag
  TextEditingController label = TextEditingController();

  /// Definition du tag
  TextEditingController definition = TextEditingController();

  ///  Label en anglais
  TextEditingController labelEN = TextEditingController();

  /// Definition en anglais
  TextEditingController definitionEN = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      Provider.of<TagProvider>(context, listen: false).fetchAndSetTag();
    });
    label.text = widget.tag.label;
    definition.text = widget.tag.definition;
    labelEN.text = widget.tag.labelEN;
    definitionEN.text = widget.tag.definitionEN;
  }

  @override
  void dispose() {
    label.dispose();
    labelEN.dispose();
    definition.dispose();
    definitionEN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tagsData = Provider.of<TagProvider>(context);
    List<Tag> _isVisible = tagsData.listVisible();

    var listTag = Provider.of<TagProvider>(context).tags;

    // Ajouter un mot clé
    void add(String label, String definition, String labelEN, String definitionEN) async {
      Tag _tag = Tag(id: Uuid().v4(), label: label, definition: definition, definitionEN: definitionEN, labelEN: labelEN);

      await FirebaseFirestore.instance
          .collection('tags')
          .doc(_tag.id)
          .set(_tag.toJson());

      Navigator.of(context).popUntil(
        ModalRoute.withName(ListTagsScreen.routeName));
    }

    void modifTag(String label,String labelEN, String definition, String definitionEN) async{
      Tag mdtag = new Tag(id: widget.tag.id, label: label, labelEN: labelEN, definition: definition, definitionEN: definitionEN);
      FirebaseFirestore.instance
        .collection('tags')
        .doc(widget.tag.id)
        .update(mdtag.toJson());

      Navigator.of(context).popUntil(
        ModalRoute.withName(ListTagsScreen.routeName));
    }

    Widget _formulaireTags() {
      return Center(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(3),
                  margin: EdgeInsets.all(2),
                  child: Text('Label du mot-clé:',
                      style: TextStyle(fontSize: 20, fontFamily: 'myriad')),
                ),
                TextFormField(
                  /// Permet de mettre un champ formulaire
                  decoration: InputDecoration(
                    hintText: 'Ex: Semi-transparence',
                    border: OutlineInputBorder(),
                  ),
                  controller: label,
                  textInputAction: TextInputAction.next,
                  validator: (text) {
                    if (text.isEmpty || text == null) {
                      return 'Entrez le label';
                    } else
                      return null;
                  },
                ),



                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  margin: EdgeInsets.all(2),
                  child: Text('''Définition du mot-clé:''',
                      style: TextStyle(fontSize: 20, fontFamily: 'myriad')),
                ),
                TextFormField(
                  maxLines: 7,
                  decoration: InputDecoration(
                    hintText: 'Définition du mot clé ...',
                    border: OutlineInputBorder(),
                  ),
                  controller: definition,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  margin: EdgeInsets.all(2),
                  child: Text('''Label du mot-clé en anglais:''',
                      style: TextStyle(fontSize: 20, fontFamily: 'myriad')),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Ex: Semi-transparency',
                    border: OutlineInputBorder(),
                  ),
                  controller: labelEN,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  margin: EdgeInsets.all(2),
                  child: Text('''Définition du mot-clé en anglais :''',
                      style: TextStyle(fontSize: 20, fontFamily: 'myriad')),
                ),
                TextFormField(
                  maxLines: 7,
                  decoration: InputDecoration(
                    hintText: 'La même définition en anglais ...',
                    border: OutlineInputBorder(),
                  ),
                  controller: definitionEN,
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 75,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color.fromRGBO(206, 63, 143, 0.9),
                      ),
                      child: TextButton(
                          child: Text(
                            'Valider',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'myriad'),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              !widget.fromEdit
                                  ?add(label.text, definition.text, definitionEN.text, labelEN.text)
                                  :modifTag(label.text,labelEN.text, definition.text, definitionEN.text);

                              label.clear();
                              definition.clear();
                              labelEN.clear();
                              definitionEN.clear(); 
                            }
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
        /// Permet de faire apparaître la bande de titre en haut de la page
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leadingWidth: 100,
          leading: CustomAppBar(),
          title: Text(
            'Formulaire mot-clé',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'myriad',
              fontSize: 25,
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
              child: SingleChildScrollView(child: _formulaireTags())),
        ),
      );
    } else
      return LoginScreen();
  }
}
