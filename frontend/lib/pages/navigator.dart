// ignore_for_file: prefer_const_constructors, unused_element, unused_local_variable, prefer_const_constructors_in_immutables, prefer_final_fields, prefer_const_literals_to_create_immutables, must_be_immutable
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/pages/bookmark/bookmark_page.dart';
import 'package:frontend/pages/home/home_page.dart';
import 'package:frontend/pages/home/news_page.dart';
import 'package:frontend/pages/more/my_keyword_page.dart';
import 'package:frontend/pages/more/notice_detail_page.dart';
import 'package:frontend/pages/more/notice_page.dart';
import 'package:frontend/pages/more/qna_page.dart';
import 'package:frontend/pages/search/detail_news_page.dart';
import 'package:frontend/pages/search/search_page.dart';
import 'package:frontend/pages/search/timeline_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class NavigatorPage extends StatefulWidget {
  NavigatorPage({
    Key? key,
    required this.index,
    this.nickname,
    this.user_id,
    this.news_id,
    this.query,
    this.topic,
    this.topicNum,
    this.title,
    this.content,
    this.isSearch,
    this.news,
    this.topicStepNum,
    this.method,
    this.topicName,
  }) : super(key: key);
  int index = 0;
  String? nickname;
  String? user_id;
  String? news_id;
  String? query;
  String? topic;
  int? topicNum;
  String? title;
  String? content;
  bool? isSearch;
  List<dynamic>? news;
  int? topicStepNum;
  String? method;
  String? topicName;

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  Random random = Random();

  List<Widget> _widgetOptions() => <Widget>[
        HomePage(
            random: random,
            nickname: widget.nickname,
            user_id: widget.user_id,
            method: widget.method),
        SearchPage(
          user_id: widget.user_id,
          nickname: widget.nickname,
        ),
        BookmarkPage(
          user_id: widget.user_id,
          nickname: widget.nickname,
        ),
        NewsPage(
          user_id: widget.user_id,
          nickname: widget.nickname,
          news: widget.news ?? [],
          query: widget.query,
          topic: widget.topic,
          topicNum: widget.topicNum,
          topicStepNum: widget.topicStepNum,
          topicName: widget.topicName,
        ),
        TimelinePage(
            user_id: widget.user_id,
            nickname: widget.nickname,
            query: widget.query,
            topicNum: widget.topicNum),
        DetailNewsPage(
          user_id: widget.user_id,
          nickname: widget.nickname,
          news_id: widget.news_id,
          query: widget.query,
          topicNum: widget.topicNum,
          topicStepNum: widget.topicStepNum,
          topicName: widget.topicName,
        ),
        NoticePage(
          user_id: widget.user_id,
          nickname: widget.nickname,
        ),
        NoticeDetailPage(
          title: widget.title,
          content: widget.content,
          user_id: widget.user_id,
          nickname: widget.nickname,
        ),
        QnAPage(
          user_id: widget.user_id,
          nickname: widget.nickname,
        ),
        MyKeywordPage(
          user_id: widget.user_id,
          nickname: widget.nickname,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final List<Widget> widgetOptions = _widgetOptions();
    return Scaffold(
      // backgroundColor:
      // widget.index == 7 ? Color(0xFFe7f3ff) : Color(0xfff7f7f7),
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: widgetOptions.elementAt(widget.index),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: size.width * 0.05,
          right: size.width * 0.05,
          bottom: size.height * 0.01,
        ),
        child: SafeArea(
          child: GNav(
            gap: 10,
            iconSize: 24,
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.01,
            ),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Color(0xffC6E4FF),
            activeColor: Color(0xff0086FF),
            color: Colors.black,
            tabs: [
              GButton(
                icon: LineIcons.home,
                text: '홈',
              ),
              GButton(
                icon: LineIcons.search,
                text: '검색',
              ),
              GButton(
                icon: LineIcons.bookmark,
                text: '북마크',
              ),
            ],
            selectedIndex: widget.index,
            onTabChange: (idx) {
              setState(() {
                widget.index = idx;
              });
            },
          ),
        ),
      ),
    );
  }
}
