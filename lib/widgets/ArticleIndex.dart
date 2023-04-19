import '../screens/listeArticle.dart';
import '../screens/marqueursScreens.dart';
import 'package:flutter/material.dart';

/// Page représentant les options possibles pour les articles (ajouter ou lister)
class ArticleIndex extends StatelessWidget {
  const ArticleIndex({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MarqueursScreens()));
                  },
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(206, 63, 143, 0.9),
                    ),
                    child: Center(
                      child: Text(
                        'Ajouter un article',
                        style: TextStyle(color: Colors.white, fontSize: 23),
                      ),
                    ),
                  )),
            ),
            Container(
              child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ListArticleScreen.routeName);
                  },
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(206, 63, 143, 0.9),
                    ),
                    child: Center(
                      child: Text(
                        'Listes des articles',
                        style: TextStyle(color: Colors.white, fontSize: 23),
                      ),
                    ),
                  )),
            ),
          ],
        ));
  }
}
