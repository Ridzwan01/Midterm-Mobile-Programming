import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_tutor/constants.dart';
import '../models/tutors.dart';

class tutorScreen extends StatefulWidget {
  const tutorScreen({Key? key}) : super(key: key);

  @override
  State<tutorScreen> createState() => _tutorsScreenState();
}

class _tutorsScreenState extends State<tutorScreen> {

  List<Tutor> tutorlist = <Tutor>[];
  String titlecenter = " ";
  var numofpage, curpage = 1;

  @override
  void initState(){
    super.initState();
    _loadtutors(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tutorlist.isEmpty 
      ? Center(
          child: Text(titlecenter, 
            style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold))) 
        : Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("Tutor Available",
              style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
                children: List.generate(tutorlist.length, (index) {
                  return Card(
                    child: Column(
                      children: [
                        Flexible(flex: 6,
                        child: CachedNetworkImage(imageUrl: CONSTANTS.server + "/my_tutor/mobile/assets/tutors/" + 
                        tutorlist[index]
                        .tutorId
                        .toString() + '.jpg'),
                        ),
                        Flexible(flex:4, child: Column(
                          children: [
                            Text(tutorlist[index]
                            .tutorName
                            .toString())
                          ],
                        ))
                      ],
                    )
                  );
                }
              )
            )
          )
        ],
      ),
    );
  }

  void _loadtutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/mobile/php/load_tutor.php"),
      body: {}
      ).then((response) {
        var jsondata = jsonDecode(response.body);
        print(jsondata);
        if(response.statusCode == 200 && jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if(extractdata['tutors'] != null){
            tutorlist = <Tutor>[];
            extractdata['tutors'].forEach((v) {
              tutorlist.add(Tutor.fromJson(v));
            });
          }
          setState(() {});
        }
      });
  }
}