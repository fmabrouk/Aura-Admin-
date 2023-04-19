import 'package:aura_administration/screens/tagsScreen.dart';

import 'screens/conditionScreen.dart';
import 'screens/politiqueScreen.dart';

import 'screens/aProposScreen.dart';

import 'screens/LoginScreen.dart';

import './providers/UserProvider.dart';
import './providers/articleProvider.dart';
import './providers/commentProvider.dart';
import './providers/markerProvider.dart';
import './providers/tagProvider.dart';
import './screens/editArticleScreen.dart';
import './screens/espaceCommentaireScreens.dart';
import './screens/espaceUtilisateurScreens.dart';
import './screens/listeArticle.dart';
import './screens/marqueursScreens.dart';
import './screens/previewScreen.dart';
import 'package:firebase_core/firebase_core.dart';
//On importe le matériel dart qui contient les principaux widget nécessaires
import 'package:flutter/material.dart';
// On importe notre page index
import 'screens/indexScreens.dart';
//import 'screens/ListePhoto.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyByblHEKIGhvlApW-3SVHzZNzqkoDABxjU",
          authDomain: "l3as1-8cefe.firebaseapp.com",
          databaseURL: "https://l3as1-8cefe-default-rtdb.firebaseio.com",
          projectId: "l3as1-8cefe",
          storageBucket: "l3as1-8cefe.appspot.com",
          messagingSenderId: "381192590305",
          appId: "1:381192590305:web:859498a71ba413fea2f8a0",
          measurementId: "G-0SPTN3B6QP"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ArticleProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CommentaireProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TagProvider(),
        ),
        ChangeNotifierProvider(create: (ctx) => MarkerProvider()),
        ChangeNotifierProvider(create: (ctx) => UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title:
            //On attribue ce nom à l'onglet de la page web
            'Administration Aura',
        home: FutureBuilder(
            future: _fbApp,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('You have an error ! ${snapshot.error.toString()}');
                return Text('Something went wrong!');
              } else if (snapshot.hasData) {
                return IndexScreens();
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            }),
        initialRoute: '/',
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          IndexScreens.routeName: (ctx) => IndexScreens(),
          ListArticleScreen.routeName: (ctx) => ListArticleScreen(),
          EditArticleScreen.routeName: (ctx) => EditArticleScreen(),
          PreviewScreen.routeName: (ctx) => PreviewScreen(),
          MarqueursScreens.routeName: (ctx) => MarqueursScreens(),
          EspaceCommentaireScreens.routeName: (ctx) =>
              EspaceCommentaireScreens(),
          ListeUtilisateurs.routeName: (ctx) => ListArticleScreen(),
          AproposScreen.routeName: (ctx) => AproposScreen(),
          PolitqueScreen.routeName: (ctx) => PolitqueScreen(),
          ConditionScreen.routeName: (ctx) => ConditionScreen(),
          ListTagsScreen.routeName: (ctx) => ListTagsScreen(),
        },
      ),
    );
  }
}
