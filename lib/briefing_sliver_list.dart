import 'dart:async';

import 'package:briefing/bloc/bloc_article.dart';
import 'package:briefing/briefing_card.dart';
import 'package:briefing/model/article.dart';
import 'package:flutter/material.dart';

class BriefingSliverList extends StatefulWidget {
  const BriefingSliverList({Key key}) : super(key: key);

  @override
  _BriefingSliverListState createState() => _BriefingSliverListState();
}

class _BriefingSliverListState extends State<BriefingSliverList> {
  ArticleListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ArticleListBloc();
  }

  Future<void> _onRefresh() async {
    _bloc.refresh();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        StreamBuilder<List<Article>>(
            stream: _bloc.articleListObservable,
            initialData: List(),
            builder: (context, snapshot) {
              debugPrint("!!!snapshot state: ${snapshot.connectionState}!!!");
              if (snapshot.hasData && snapshot.data.length > 0) {
                return Column(
                  children: <Widget>[
                    StreamBuilder<String>(
                        stream: _bloc.categoryObservable,
                        builder: (context, snapshot) {
                          return Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0)),
                            elevation: 1.0,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 12.0),
                              height: 30.0,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: categories.keys
                                    .map(
                                      (category) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: ChoiceChip(
                                            selectedColor:
                                                Theme.of(context).accentColor,
                                            label: Text(category),
                                            selected: snapshot.data == category,
                                            onSelected: (val) {
                                              _bloc.categorySink.add(category);
                                            }),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                        }),
                    ListView.separated(
                        padding: EdgeInsets.all(12.0),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider();
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return BriefingCard(
                              article: snapshot.data.elementAt(index));
                        }),
                  ],
                );
              } else if (snapshot.hasError) {
                debugPrint("!!!snapshot error ${snapshot.error.toString()}");
                return Center(
                  child: GestureDetector(
                      onTap: _onRefresh,
                      child: ErrorWidget(message: ['${snapshot.error}'])),
                );
              } else {
                return Center(
                    child: Container(
                        margin: EdgeInsets.all(12.0),
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator()));
              }
            }),
      ]),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final List<String> message;

  const ErrorWidget({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.cloud_off,
              size: 55.0, color: Theme.of(context).errorColor),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Woops...',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(fontWeight: FontWeight.w600)),
          ),
          Text(
            message.join('\n'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subhead,
          ),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final Stream<bool> _isLoading;

  const LoadingWidget(this._isLoading);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _isLoading,
      initialData: true,
      builder: (context, snapshot) {
        debugPrint("_bloc.isLoading: ${snapshot.data}");
        return snapshot.data
            ? Center(
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
