// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/logo.dart';
import 'package:frontend/components/search_bar.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  final rankingData = '[{"rank":"1st", "keyword":"코로나"},{"rank":"2nd", "keyword":"우크라이나"},{"rank":"3rd", "keyword":"산불"},{"rank":"4th", "keyword":"기름값"},{"rank":"5th", "keyword":"주식"}]';

  List data = [];

  Future<String> getData() async { 
    // http.Response response = await http.get( 
    //   Uri.encodeFull('http://jsonplaceholder.typicode.com/posts'), 
    //   headers: {"Accept": "application/json"}
    // ); 
      
    setState(() { 
      data = jsonDecode(rankingData); 
    }); 
    
    return "success";
  }

  @override
  void initState() { 
    super.initState(); 
    getData(); 
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xffF7F7F7),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            logo(size),
            searchBar(size),
            Container(
              margin: EdgeInsets.all(20), 
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30), 
              ),
              width: size.width * 0.9,
              height: size.height * 0.6,
              padding: EdgeInsets.only(top: size.height * 0.03),
              child:Column(
                children: [
                  Text("검색 순위", style:TextStyle(fontSize: 25,)),
                  ListView.builder( 
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: data == [] ? 0 : data.length, 
                    itemBuilder: (BuildContext context, int index) { 
                      return Container(
                        margin: EdgeInsets.only(left: size.width*0.05, right: size.width*0.05, top: size.height*0.02),
                        padding: EdgeInsets.only(left: size.width*0.05, right: size.width*0.05),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(231, 243, 255, 1),
                          borderRadius: BorderRadius.circular(30), 
                        ),
                        width: size.width * 0.5,
                        height: size.height * 0.08,
                        child: Row(
                          children: [
                            SizedBox(child: Text(data[index]["rank"], style: TextStyle(color: Color.fromRGBO(93, 109, 190, 1), fontSize: 20,)),width: size.width * 0.13,),
                            Text(data[index]["keyword"], style: TextStyle(fontSize: 20,)),
                          ],
                        )
                      );
                    }, 
                  ),
                ],
              ) 
            )

          ],
          
        ),
      ),
    );
  }
}

