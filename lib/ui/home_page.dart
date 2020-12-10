import 'package:bloc_asg/bloc/article_bloc.dart';
import 'package:bloc_asg/bloc/article_event.dart';
import 'package:bloc_asg/bloc/article_state.dart';
import 'package:bloc_asg/data/api_result_model.dart';
import 'package:bloc_asg/ui/article_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'about_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ArticleBloc articleBloc;

  @override
  void initState() {
    super.initState();
    articleBloc = BlocProvider.of<ArticleBloc>(context);
    articleBloc.add(FetchArticlesEvent());
  }
  int totalCount=0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Material(
            child: Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.info),
                    onPressed: () {
                      navigateToAoutPage(context);
                    },
                  )
                ],
              ),
              body: Container(
                child: BlocListener<ArticleBloc, ArticleState>(
                  listener: (context, state) {
                    if (state is ArticleErrorState) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                        ),
                      );
                    }
                  },
                  child: BlocBuilder<ArticleBloc, ArticleState>(
                    builder: (context, state) {
                      if (state is ArticleInitialState) {
                        return buildLoading();
                      } else if (state is ArticleLoadingState) {
                        return buildLoading();
                      } else if (state is ArticleLoadedState) {
                        return buildArticleList(state.articles,totalCount);
                      } else if (state is ArticleErrorState) {
                        return buildErrorUi(state.message);
                      }
                    },
                  ),
                ),
              ),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      totalCount=2;
                      articleBloc.add(FetchArticlesEvent());
                    },
                    child: Text('A'),
                    backgroundColor: Colors.green,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      totalCount=3;
                      articleBloc.add(FetchArticlesEvent());
                    },
                    child: Text('B'),
                    backgroundColor: Colors.green,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      totalCount=0;
                      articleBloc.add(FetchArticlesEvent());
                    },
                    child: Text('C'),
                    backgroundColor: Colors.green,
                  )
                ],
              ),

            ),
          );
        },
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget buildArticleList(List<Articles> articles,int totalCount) {
    return ListView.builder(
      itemCount: totalCount==0?articles.length:totalCount,
      itemBuilder: (ctx, pos) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: ListTile(
              leading: ClipOval(
                child: Hero(
                  tag: articles[pos].urlToImage,
                  child: Image.network(
                    articles[pos].urlToImage,
                    fit: BoxFit.cover,
                    height: 70.0,
                    width: 70.0,
                  ),
                ),
              ),
              title: Text(articles[pos].title),
              subtitle: Text(articles[pos].publishedAt),
            ),
            onTap: () {
              navigateToArticleDetailPage(context, articles[pos]);
            },
          ),
        );
      },
    );
  }

  void navigateToArticleDetailPage(BuildContext context, Articles article) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ArticleDetailPage(
        article: article,
      );
    }));
  }

  void navigateToAoutPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AboutPage();
    }));
  }
}