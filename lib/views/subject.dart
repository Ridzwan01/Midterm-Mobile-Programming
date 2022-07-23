import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_tutor/constants.dart';
import '../models/subjects.dart';

class subjectScreen extends StatefulWidget {
  const subjectScreen({Key? key}) : super(key: key);

  @override
  State<subjectScreen> createState() => _subjectScreenState();
}

class _subjectScreenState extends State<subjectScreen> {

  List<Subject> subjectlist = <Subject>[];
  String titlecenter = " ";
  var numofpage, curpage = 1; 

  @override
  void initState(){
    super.initState();
    _loadsubjects(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: subjectlist.isEmpty 
      ? Center(
          child: Text(titlecenter, 
            style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold))) 
        : Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("Subjects",
              style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
                children: List.generate(subjectlist.length, (index) {
                  return Card(
                    child: Column(
                      children: [
                        Flexible(flex: 6,
                        child: CachedNetworkImage(imageUrl: CONSTANTS.server + "/my_tutor/mobile/assets/courses/" + 
                        subjectlist[index]
                        .subjectId
                        .toString() + '.jpg'),
                        ),
                        Flexible(flex:4, child: Column(
                          children: [
                            Text(subjectlist[index]
                            .subjectName
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

  void _loadsubjects(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/mobile/php/load_subjects.php"),
      body: {'pageno' : pageno.toString()}).then((response) {
        var jsondata = jsonDecode(response.body);

        print(jsondata);
        if(response.statusCode == 200 && jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if(extractdata['subjects'] != null){
            subjectlist = <Subject>[];
            extractdata['subjects'].forEach((v) {
              subjectlist.add(Subject.fromJson(v));
            });
          }
          setState(() {});
        }
      });
  }
}