import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:kbbi_daring/provider/db_vocab.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'arsip_detail.dart';

class Arsip extends StatefulWidget {
  const Arsip({Key? key}) : super(key: key);

  @override
  _ArsipState createState() => _ArsipState();
}

class _ArsipState extends State<Arsip> {
  Widget body() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: FutureBuilder(
        future: Hive.openBox('db_vocab'),
        builder: (builder, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              var dbvocab = Hive.box('db_vocab');
              return ValueListenableBuilder(
                valueListenable: dbvocab.listenable(),
                builder: (BuildContext context, value, Widget? child) {
                  return ListView.builder(
                    itemCount: dbvocab.length,
                    itemBuilder: (context, index) {
                      DataVocab vocabIndex = dbvocab.getAt(index);
                      return vocabContainer(
                        index,
                        dbvocab,
                        vocabIndex.vocab,
                        vocabIndex.lema,
                        vocabIndex.mean,
                      );
                    },
                  );
                },
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget vocabContainer(
      int index, Box dbvocab, String vocab, String lema, List mean) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArsipDetail(
                      vocab,
                      lema,
                      mean,
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(top: (index == 0) ? 10 : 5, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vocab,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                Text(
                  lema,
                  style: TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                dbvocab.deleteAt(index);
                Fluttertoast.showToast(
                    msg: "Kata \"$vocab\" dihapus dari arsip",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black54,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              child: Container(
                //width: 50,
                child: Icon(Icons.delete),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Arsip"),
        titleTextStyle: TextStyle(
          fontFamily: "Poppins",
          fontSize: 20,
          color: Colors.black,
        ),
        backgroundColor: Colors.amber,
      ),
      body: body(),
    );
  }
}
