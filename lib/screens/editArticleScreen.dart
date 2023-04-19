import 'package:firebase_auth/firebase_auth.dart';
import '../models/tag.dart';
import '../providers/tagProvider.dart';
import '../screens/previewScreen.dart';
import '../widgets/customAppBar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../models/customMarker.dart';
import 'package:flutter/material.dart';
import 'LoginScreen.dart';

/// Page de modification d'un article.
/// @args article Article à modifier
/// @args marker CustomMarker à modifier
class EditArticleScreen extends StatefulWidget {
  final Article article;
  final CustomMarker marker;

  static const routeName = '/edit.dart';

  EditArticleScreen({Key key, this.article, this.marker}) : super(key: key);

  @override
  _EditArticleScreenState createState() => _EditArticleScreenState();
}

class _EditArticleScreenState extends State<EditArticleScreen> {
  /// Article à éditer
  Article article;

  /// Marker à changer
  CustomMarker marker;

  /// Titre de l'article
  TextEditingController title = TextEditingController();

  /// Titre de l'article en anglais
  TextEditingController titleEN = TextEditingController();

  /// Description de l'article
  TextEditingController text = TextEditingController();

  /// Date de l'oeuvre
  TextEditingController date = TextEditingController();

  /// Nom des architectes de l'oeuvre
  TextEditingController architecte = TextEditingController();

  /// Nom des architectes des opérations connexes  de l'oeuvre
  TextEditingController operation = TextEditingController();

  /// Nom de l'architecte du patrimoine de l'oeuvre
  TextEditingController patrimoine = TextEditingController();

  /// Site
  TextEditingController lieu = TextEditingController();

  /// Liste de mots-clefs correspondant
  List<String> tags;

  /// Architecte associé
  TextEditingController associe = TextEditingController();

  /// Architecte transformation
  TextEditingController transformation = TextEditingController();

  /// Architecte des Monuments Historiques
  TextEditingController monument = TextEditingController();

  /// Architecte de projet
  TextEditingController projet = TextEditingController();

  /// Architecte local
  TextEditingController local = TextEditingController();

  /// Chef de projet
  TextEditingController chef = TextEditingController();

  /// Ingenieur
  TextEditingController ingenieur = TextEditingController();

  /// Paysagiste
  TextEditingController paysagiste = TextEditingController();

  /// Urbaniste
  TextEditingController urbaniste = TextEditingController();

  /// Artiste
  TextEditingController artiste = TextEditingController();

  /// Eclairagiste
  TextEditingController eclairagiste = TextEditingController();

  /// Conservateur du musée
  TextEditingController musee = TextEditingController();

  /// Année d'installation à Paris
  TextEditingController installation = TextEditingController();

  /// Dimensions
  TextEditingController dimensions = TextEditingController();

  /// Expositions
  TextEditingController expositions = TextEditingController();

  /// Surface
  TextEditingController surface = TextEditingController();

  /// Surface à construire
  TextEditingController construire = TextEditingController();

  /// Surface d'exposition
  TextEditingController surfaceExpo = TextEditingController();

  /// Texte en anglais
  TextEditingController textEn = TextEditingController();

  /// Lien de l'image de l'article
  TextEditingController photo = TextEditingController();

  /// Latitude du point
  double latitude;

  /// Longtitude du point
  double longitude;

  /// Liste de mots clefs de l'article
  List<Tag> _listChip = [];

  /// Clé du formulaire
  final _formKey = GlobalKey<FormState>();

  /// Fichier audio
  PlatformFile audio;

  ///Fichier image
  PlatformFile image;

  /// Fichier audio anglais
  PlatformFile audioEN;

  /// Indique si le widget a déja été initialisé ou non
  bool isInit = false;

  /// Indique si l'on doit efface l'audio ou non
  bool deleteAudio = false;

  /// Indique si l'on doit efface l'image ou non
  bool deleteImage = false;

  /// Indique si l'on doit efface l'audio anglais ou non
  bool deleteAudioEN = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      /// Initialise le provider
      await Provider.of<TagProvider>(context, listen: false).fetchAndSetTag();
      Provider.of<TagProvider>(context, listen: false)
          .iniLabel(widget.article.tags);
    });
    article = widget.article;
    marker = widget.marker;
    title.text = widget.article.title;
    titleEN.text = widget.article.titleEN;
    text.text = widget.article.text;
    date.text = widget.article.date;
    architecte.text = widget.article.architecte;
    operation.text = widget.article.operation;
    patrimoine.text = widget.article.patrimoine;
    lieu.text = widget.article.lieu;
    longitude = widget.marker.longitude;
    latitude = widget.marker.latitude;
    associe.text = widget.article.associe;
    transformation.text = widget.article.transformation;
    monument.text = widget.article.monument;
    projet.text = widget.article.projet;
    local.text = widget.article.local;
    chef.text = widget.article.chef;
    ingenieur.text = widget.article.ingenieur;
    paysagiste.text = widget.article.paysagiste;
    urbaniste.text = widget.article.urbaniste;
    artiste.text = widget.article.artiste;
    eclairagiste.text = widget.article.eclairagiste;
    musee.text = widget.article.musee;
    installation.text = widget.article.installation;
    dimensions.text = widget.article.dimensions;
    expositions.text = widget.article.expositions;
    surface.text = widget.article.surface;
    construire.text = widget.article.construire;
    surfaceExpo.text = widget.article.surfaceExpo;
    textEn.text = widget.article.textEn;
    photo.text = widget.article.photo;
  }

  @override
  void dispose() {
    title.dispose();
    titleEN.dispose();
    text.dispose();
    date.dispose();
    architecte.dispose();
    operation.dispose();
    patrimoine.dispose();
    lieu.dispose();
    associe.dispose();
    transformation.dispose();
    monument.dispose();
    projet.dispose();
    local.dispose();
    chef.dispose();
    ingenieur.dispose();
    paysagiste.dispose();
    urbaniste.dispose();
    artiste.dispose();
    eclairagiste.dispose();
    musee.dispose();
    installation.dispose();
    dimensions.dispose();
    expositions.dispose();
    surface.dispose();
    construire.dispose();
    surfaceExpo.dispose();
    textEn.dispose();
    photo.dispose();
    super.dispose();
  }

  /// Permet de sélectionner un fichier audio
  void pickFile() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.audio);

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        audio = file;
      });
    } else {
      /// User canceled the picker
    }

    setState(() {
      deleteAudio = false;
    });
  }

  /// Permet de sélectionner un image
  void pickFile3() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        image = file;
      });
    } else {
      /// User canceled the picker
    }

    setState(() {
      deleteImage = false;
    });
  }

  /// Permet de sélectionner un fichier audio
  void pickFile2() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.audio);

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        audioEN = file;
      });
    } else {
      /// User canceled the picker
    }

    setState(() {
      deleteAudioEN = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tagsData = Provider.of<TagProvider>(context);
    List<Tag> _isVisible = tagsData.listVisible();

    /// Représente une étiquette
    Widget _buildChip(Tag item) {
      return GestureDetector(
        onTap: () {
          setState(() {
            item.isVisible = !item.isVisible;
            if (item.isVisible)
              _isVisible.contains(item)
                  ? _isVisible.remove(item)
                  : _isVisible.add(item);
          });
        },
        child: Container(
          child: Text(
            item.label,
            style: TextStyle(
                color: item.isVisible
                    ? Colors.white
                    : Color.fromRGBO(209, 62, 150, 1),
                fontSize: 17),
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color:
                item.isVisible ? Color.fromRGBO(209, 62, 150, 1) : Colors.white,
            border: Border.all(
                color: item.isVisible
                    ? Colors.white.withOpacity(0.0)
                    : Color.fromRGBO(209, 62, 150, 1)),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }

    /// Construit toutes les étiquettes
    List<GestureDetector> _buildAllChip() {
      List<GestureDetector> _chips = [];
      if (_listChip.isEmpty)
        for (var i = 0; i < tagsData.tags.length; i++) {
          _chips.add(_buildChip(tagsData.tags[i]));
        }
      else
        for (var i = 0; i < _listChip.length; i++) {
          _chips.add(_buildChip(_listChip[i]));
        }
      return _chips;
    }

    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leadingWidth: 100,
            leading: CustomAppBar(),
            title: Text(
              widget.article.title,
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
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding:
                        EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('Titre de l\'article* :',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            /// Permet de mettre un champ formulaire
                            decoration: InputDecoration(
                              hintText: 'Ex: Université de Paris Descartes',
                              border: OutlineInputBorder(),
                            ),
                            controller: title,
                            textInputAction: TextInputAction.next,
                            validator: (text) {
                              if (text.isEmpty || text == null) {
                                return 'Entrez le titre';
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
                            child: Text('Titre de l\'article en anglais :',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Ex : University of Paris Descartes',
                              border: OutlineInputBorder(),
                            ),
                            controller: titleEN,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text(
                                '''Entrez les coordonnées de la nouvelle balise* :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Ex: 48.862725',
                              labelText: 'Latitude',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: widget.marker.latitude.toString(),
                            validator: (input) {
                              if (input == null || input.isEmpty) {
                                return 'Entrez la latitude';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]')),
                            ],
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              setState(() {
                                latitude = double.parse(value);
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Ex: 2.287592',
                              labelText: 'Longitude',
                              border: OutlineInputBorder(),
                            ),
                            initialValue: widget.marker.longitude.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]')),
                            ],
                            textInputAction: TextInputAction.next,
                            validator: (input) {
                              if (input == null || input.isEmpty) {
                                return 'Entrez la longitude';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                longitude = double.parse(value);
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Année :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Ex: 1971',
                              labelText: 'Année',
                              border: OutlineInputBorder(),
                            ),
                            controller: date,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Année d'installation à Paris :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Ex: 1971',
                              labelText: 'Année d\'installation à Paris',
                              border: OutlineInputBorder(),
                            ),
                            controller: installation,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Dimensions :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Dimensions',
                              border: OutlineInputBorder(),
                            ),
                            controller: dimensions,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Expositions :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Expositions',
                              border: OutlineInputBorder(),
                            ),
                            controller: expositions,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Surface :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Surface',
                              border: OutlineInputBorder(),
                            ),
                            controller: surface,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Surface à construire :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Surface à construire',
                              border: OutlineInputBorder(),
                            ),
                            controller: construire,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Surface d'exposition :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Surface d\exposition',
                              border: OutlineInputBorder(),
                            ),
                            controller: surfaceExpo,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Adresse de l'oeuvre :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Ex: 107 Rue de Rivoli, 75001',
                              labelText: 'Adresse de l\'oeuvre',
                              border: OutlineInputBorder(),
                            ),
                            controller: lieu,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Nom de l'architecte de l'oeuvre :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom architecte',
                              border: OutlineInputBorder(),
                            ),
                            controller: architecte,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Nom de l'architecte associé :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom architecte associé',
                              border: OutlineInputBorder(),
                            ),
                            controller: associe,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text(
                                '''Nom de l'architecte transformation :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom architecte transformation',
                              border: OutlineInputBorder(),
                            ),
                            controller: transformation,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text(
                                '''Nom de l'architecte des Monuments Historiques :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText:
                                  'Nom architecte des Monuments Historiques',
                              border: OutlineInputBorder(),
                            ),
                            controller: monument,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Nom de l'architecte de projet :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom architecte de projet',
                              border: OutlineInputBorder(),
                            ),
                            controller: projet,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Nom de l'architecte local :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom architecte local',
                              border: OutlineInputBorder(),
                            ),
                            controller: local,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Nom du chef de projet :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom chef de projet',
                              border: OutlineInputBorder(),
                            ),
                            controller: chef,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Nom de l'ingénieur :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom ingénieur',
                              border: OutlineInputBorder(),
                            ),
                            controller: ingenieur,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Nom du paysagiste :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom paysagiste',
                              border: OutlineInputBorder(),
                            ),
                            controller: paysagiste,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Nom de l'urbaniste :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom urbaniste',
                              border: OutlineInputBorder(),
                            ),
                            controller: urbaniste,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Nom de l'artiste :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom artiste',
                              border: OutlineInputBorder(),
                            ),
                            controller: artiste,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Nom de l'eclairagiste :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom eclairagiste',
                              border: OutlineInputBorder(),
                            ),
                            controller: eclairagiste,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('''Nom du conservateur du musée :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom conservateur musée',
                              border: OutlineInputBorder(),
                            ),
                            controller: musee,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text(
                                '''Nom de  l\'architectes des opérations connexes :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText:
                                  'Nom de l\'architecte des opérations connexes',
                              border: OutlineInputBorder(),
                            ),
                            controller: operation,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text(
                                '''Nom de l'architecte du patrimoine de l'oeuvre :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText:
                                  'Nom architecte du patrimoine de l\'oeuvre',
                              border: OutlineInputBorder(),
                            ),
                            controller: patrimoine,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text(
                                '''Entrez le texte correspondant à la nouvelle balise :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            maxLines: 10,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: text,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text(
                                '''Entrez le texte de l'article en anglais :''',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          TextFormField(
                            maxLines: 10,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: textEn,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('Fichier image :',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          Container(
                              child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Color.fromRGBO(206, 63, 143, 1),
                                ),
                                child: TextButton(
                                  onPressed: pickFile3,
                                  child: Text(
                                    'Selectionner un fichier image',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    deleteImage
                                        ? ''
                                        : image != null
                                            ? image.name
                                            : widget.article.image != null
                                                ? widget.article.image
                                                : '',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              if ((image != null ||
                                      widget.article.image.isNotEmpty) &&
                                  !deleteImage)
                                IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        deleteImage = true;
                                        image = null;
                                      });
                                    })
                            ],
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('Fichier audio :',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          Container(
                              child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Color.fromRGBO(206, 63, 143, 1),
                                ),
                                child: TextButton(
                                  onPressed: pickFile,
                                  child: Text(
                                    'Selectionner un fichier audio',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    deleteAudio
                                        ? ''
                                        : audio != null
                                            ? audio.name
                                            : widget.article.audio != null
                                                ? widget.article.audio
                                                : '',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              if ((audio != null ||
                                      widget.article.audio.isNotEmpty) &&
                                  !deleteAudio)
                                IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        deleteAudio = true;
                                        audio = null;
                                      });
                                    })
                            ],
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text('Fichier audio anglais :',
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'myriad')),
                          ),
                          Container(
                              child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Color.fromRGBO(206, 63, 143, 1),
                                ),
                                child: TextButton(
                                  onPressed: pickFile2,
                                  child: Text(
                                    'Selectionner un fichier audio',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(
                                    deleteAudioEN
                                        ? ''
                                        : audioEN != null
                                            ? audioEN.name
                                            : widget.article.audioEN != null
                                                ? widget.article.audioEN
                                                : '',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              if ((audioEN != null ||
                                      widget.article.audioEN.isNotEmpty) &&
                                  !deleteAudioEN)
                                IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        deleteAudioEN = true;
                                        audioEN = null;
                                      });
                                    })
                            ],
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.all(2),
                            child: Text(
                              'Mots cles associés (1 au minimum) :',
                              style:
                                  TextStyle(fontSize: 20, fontFamily: 'myriad'),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: SingleChildScrollView(
                              child: Scrollbar(
                                child: ClipRRect(
                                  child: Wrap(
                                    spacing: 10,
                                    children: _buildAllChip(),
                                    runSpacing: 8,
                                  ),
                                ),
                              ),
                            ),
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

                                    /// style: ButtonStyle(),
                                    child: Text(
                                      'Aperçu',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontFamily: 'myriad'),
                                    ),
                                    onPressed: () {
                                      List<String> tags = [];
                                      _isVisible.forEach((element) {
                                        tags.add(element.id);
                                      });

                                      if (_formKey.currentState.validate()) {
                                        if (image != null)
                                          print('image.name  =  ' + image.name);
                                        print('wwidget.article  =  ' +
                                            widget.article.image);

                                        if (audio != null)
                                          print('audio.name  =  ' + audio.name);
                                        print('wwidget.article  =  ' +
                                            widget.article.audio);

                                        if (audioEN != null)
                                          print('audioEN.name  =  ' +
                                              audioEN.name);
                                        print('wwidget.article  =  ' +
                                            widget.article.audioEN);

                                        Article a = new Article(
                                          id: article.id,
                                          title: title.text,
                                          titleEN: titleEN.text,
                                          date: date.text,
                                          lieu: lieu.text,
                                          operation: operation.text,
                                          artiste: artiste.text,
                                          associe: associe.text,
                                          chef: chef.text,
                                          construire: construire.text,
                                          dimensions: dimensions.text,
                                          eclairagiste: eclairagiste.text,
                                          expositions: expositions.text,
                                          ingenieur: ingenieur.text,
                                          installation: installation.text,
                                          local: local.text,
                                          monument: monument.text,
                                          musee: musee.text,
                                          paysagiste: paysagiste.text,
                                          projet: projet.text,
                                          surface: surface.text,
                                          surfaceExpo: surfaceExpo.text,
                                          transformation: transformation.text,
                                          urbaniste: urbaniste.text,
                                          patrimoine: patrimoine.text,
                                          text: text.text,
                                          image: deleteImage
                                              ? ''
                                              : image != null
                                                  ? image.name
                                                  : article.image.isNotEmpty
                                                      ? article.image
                                                      : '',
                                          audio: deleteAudio
                                              ? ''
                                              : audio != null
                                                  ? audio.name
                                                  : article.audio.isNotEmpty
                                                      ? article.audio
                                                      : '',
                                          audioEN: deleteAudioEN
                                              ? ''
                                              : audioEN != null
                                                  ? audioEN.name
                                                  : article.audioEN.isNotEmpty
                                                      ? article.audioEN
                                                      : '',
                                          textEn: textEn.text,
                                          tags: tags,
                                          architecte: architecte.text,
                                          photo: photo.text,
                                        );
                                        CustomMarker m = new CustomMarker(
                                            id: marker.id,
                                            latitude: latitude,
                                            longitude: longitude,
                                            idArticle: article.id);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PreviewScreen(
                                                    article: a,
                                                    marker: m,
                                                    image: image,
                                                    diffImage: a.image !=
                                                        article.image,
                                                    imageToDelete:
                                                        article.image,
                                                    audio: audio,
                                                    diffAudio: a.audio !=
                                                        article.audio,
                                                    audioToDelete:
                                                        article.audio,
                                                    fromEdit: true,
                                                  )),
                                        );
                                      }
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ));
    } else
      return LoginScreen();
  }
}
