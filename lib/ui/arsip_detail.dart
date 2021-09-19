// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ArsipDetail extends StatelessWidget {
  //const ArsipDetail({Key? key}) : super(key: key);
  String vocab;
  String lema;
  List mean;

  ArsipDetail(this.vocab, this.lema, this.mean);

  Widget sizedBoxDefinition(String vocabulary, String mean,
      [bool first = false, bool last = false]) {
    return SizedBox(
      width: double.infinity,
      //padding: EdgeInsets.all(10),
      child: TimelineTile(
        endChild: Container(
          padding: EdgeInsets.fromLTRB(20, 6, 0, 6),
          child: Text(
            mean.toString(),
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        isFirst: first,
        isLast: last,
      ),
    );
  }

  Widget body() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lema.toString(),
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            textAlign: TextAlign.left,
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: mean.length,
            itemBuilder: (builder, index) {
              if (index == 0) {
                if (mean.length == 1) {
                  return sizedBoxDefinition(vocab, mean[index], true, true);
                } else {
                  return sizedBoxDefinition(vocab, mean[index], true, false);
                }
              } else if (index == mean.length - 1) {
                return sizedBoxDefinition(vocab, mean[index], false, true);
              } else {
                return sizedBoxDefinition(vocab, mean[index]);
              }
            },
          ),
        ],
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
        centerTitle: true,
        title: Text(vocab),
        titleTextStyle: TextStyle(
          fontFamily: "Poppins",
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: Colors.amber,
      ),
      body: body(),
    );
  }
}
