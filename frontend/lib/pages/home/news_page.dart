// ignore_for_file: prefer_const_constructors, prefer_is_empty,must_be_immutable, prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontend/api/api_service.dart';
import 'package:frontend/components/app_bar.dart';
import 'package:frontend/components/news_title.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/models/bubble_model.dart';

class NewsPage extends StatefulWidget {
  NewsPage(
      {Key? key,
      this.news,
      this.query,
      this.topic,
      this.user_id,
      this.topicNum,
      this.topicStepNum})
      : super(key: key);
  List<dynamic>? news;
  String? query;
  String? topic;
  String? user_id;
  int? topicNum;
  int? topicStepNum;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Map> data = [];
  List<Widget> list = [];

  List<Widget> getNewsList(Size size) {
    for (var i = 0; i < data.length; i++) {
      list.add(
        newsTitle(size, data[i]['title'], data[i]['navigate']),
      );
    }
    return list;
  }

  Future<void> getNews(dynamic query) async {
    data.clear();
    if (widget.news?.length == 0) {
      List<dynamic> news = await ApiService().getNews(query);
      // print("page: ${news.length}");
      for (var i = 0; i < news.length; i++) {
        data.add({
          'title': news[i]['title'],
          'navigate': () async {
            Uri url = Uri.parse('https://flutter.dev');
            if (!await launchUrl(url)) throw 'Could not launch $url';
          }
        });
      }
    } else {
      // print("* ${widget.news}");
      // List<dynamic> newsList = [{'news_id': '626e6285c188d66ffcca22e3'},{'news_id':'626e6291c188d66ffcca22e7'}];
      // print(widget.news!.length);
      for (var i = 0; i < widget.news!.length; i++) {
        List<dynamic> news =
            await ApiService().getNewsID(widget.news![i]["news_id"]);
        // print(news);
        data.add({
          'title': news[0]["title"],
          'url': news[0]["url"],
          'summary': news[0]["summary"],
          'navigate': () async {
            await addBubble(widget.user_id, widget.news![i]["news_id"],
                widget.query, query);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return NavigatorPage(
                    index: 5,
                    user_id: widget.user_id,
                    news_id: widget.news![i]["news_id"],
                    topicNum: widget.topicNum,
                    topicStepNum: widget.topicStepNum,
                  );
                },
              ),
            );
          },
        });
      }
    }
  }

  Future<void> addBubble(
      dynamic user_id, dynamic news_id, dynamic query, dynamic topic) async {
    List<dynamic> allBubble = await ApiService().getBubbleUserId(user_id);
    if (allBubble.length == 0) {
      await ApiService().postBubble(
        Bubble(user_id: user_id, bubbles: Bubbles(query: query, count: 1)),
      );
    } else {
      List<dynamic> bubble = await ApiService().getBubble(user_id, query);
      if (bubble.length == 0) {
        await ApiService().updateNewBubble(
          user_id,
          Bubble(user_id: user_id, bubbles: Bubbles(query: query, count: 0)),
        );
      } else {
        await ApiService().updateBubbleCount(
          user_id,
          query,
          Bubble(user_id: user_id, bubbles: Bubbles(query: query, count: 0)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      appBar: appBar(size, '${widget.query} 뉴스', context, true, false),
      body: SafeArea(
        child: FutureBuilder(
          future: getNews(widget.topic),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (data.length != 0) {
              return SizedBox(
                height: size.height * 0.77,
                child: ListView(
                  shrinkWrap: true,
                  children: getNewsList(size),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
