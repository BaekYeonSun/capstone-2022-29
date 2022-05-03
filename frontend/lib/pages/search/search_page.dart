// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/logo.dart';
import 'package:frontend/components/search_bar.dart';
import 'package:frontend/pages/navigator.dart';
import 'package:frontend/pages/search/timeline_page.dart';
import 'package:frontend/api/api_service.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key, this.user_id}) : super(key: key);
  String? user_id;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List data = [];
  List<Map> tmp = [];
  Set ranking = {};

  Future<dynamic> getRanking() async {
    print(widget.user_id);
    data.clear();
    tmp.clear();
    ranking.clear();
    List<dynamic> bubble = await ApiService().getAllBubble();
    // print(bubble);
    for (var i = 0; i < bubble.length; i++) {
      for (var j = 0; j < bubble[i]['bubble'].length; j++) {
        tmp.add({
          'query': bubble[i]['bubble'][j]['query'],
          'count': bubble[i]['bubble'][j]['count']
        });
      }
    }
    tmp.sort(((a, b) => (b['count']).compareTo(a['count'])));

    for (var i = 0; i < tmp.length; i++) {
      ranking.add(tmp[i]['query']);
    }

    data.addAll([
      {"rank": "1st", "keyword": ranking.elementAt(0)},
      {"rank": "2nd", "keyword": ranking.elementAt(1)},
      {"rank": "3rd", "keyword": ranking.elementAt(2)},
      {"rank": "4th", "keyword": ranking.elementAt(3)},
      {"rank": "5th", "keyword": ranking.elementAt(4)},
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double _currentSliderValue = 0;
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xffF7F7F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            logo(size),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Container(child: searchBar(size, true, "")),
                                Slider(
                                  value: _currentSliderValue,
                                  max: 4,
                                  divisions: 3,
                                  onChanged: (double value) {
                                    setState(() {
                                      _currentSliderValue = value;
                                    });
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(198, 228, 255, 1),
                                    onPrimary: Colors.black,
                                    minimumSize: Size(
                                        size.width * 0.2, size.height * 0.05),
                                    maximumSize: Size(
                                        size.width * 0.2, size.height * 0.05),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return NavigatorPage(
                                            index: 4,
                                            query: '코로나',
                                            user_id: widget.user_id,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Text("검색하기"),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    });
              },
              child: AbsorbPointer(
                child: searchBar(size, false, ""),
              ),
            ),
            Container(
              margin: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              width: size.width * 0.9,
              height: size.height * 0.6,
              padding: EdgeInsets.only(top: size.height * 0.03),
              child: FutureBuilder(
                future: getRanking(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (data.isNotEmpty) {
                    return Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: size.width * 0.07),
                            child: Text("검색 순위",
                                style: TextStyle(
                                  fontSize: 25,
                                ))),
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: data == [] ? 0 : data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                margin: EdgeInsets.only(
                                    left: size.width * 0.05,
                                    right: size.width * 0.05,
                                    top: size.height * 0.02),
                                padding: EdgeInsets.only(
                                    left: size.width * 0.05,
                                    right: size.width * 0.05),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(231, 243, 255, 1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                width: size.width * 0.5,
                                height: size.height * 0.08,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      child: Text(data[index]["rank"],
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(93, 109, 190, 1),
                                            fontSize: 20,
                                          )),
                                      width: size.width * 0.13,
                                    ),
                                    Text(data[index]["keyword"],
                                        style: TextStyle(
                                          fontSize: 20,
                                        )),
                                  ],
                                ));
                          },
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
