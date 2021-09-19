import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:kbbi_daring/provider/db_vocab.dart';
import 'package:kbbi_daring/provider/provider.dart';
import 'package:kbbi_daring/ui/arsip.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  TextEditingController vocabFinder = TextEditingController(text: "");
  bool isFind = false;
  bool isLoading = false;
  List meaning = [];

  @override
  Widget build(BuildContext context) {
    GetDataProvider getDataProvider = Provider.of<GetDataProvider>(context);

    void startFind() async {
      isFind = false;

      setState(() {
        isLoading = true;
      });

      if (await getDataProvider.getDataVocabMean(vocabFinder.text)) {
        meaning = [
          getDataProvider.getVocabulary.lemma,
          getDataProvider.getVocabulary.vocab,
          vocabFinder.text,
        ];
        isFind = true;
      } else {
        isFind = false;
      }

      setState(() {
        isLoading = false;
      });
    }

    Widget header() {
      return Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.3,
        width: double.infinity,
        color: Colors.amber,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Arsip()));
                    },
                    child: Icon(
                      Icons.book,
                      size: 45,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Tentang'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text("Maulana Yusuf. 2021"),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('Keluar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.info,
                      size: 45,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "KBBI Daring",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",
                  ),
                ),
                Text(
                  "Kamus Besar Bahasa Indonesia",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    Widget searchBar() {
      return Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: vocabFinder,
                style: TextStyle(
                  fontFamily: "Poppins",
                ),
                decoration: InputDecoration(
                  hintText: "Cari kosakata",
                  hintStyle: TextStyle(
                    fontFamily: "Poppins",
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(
              width: 25,
            ),
            ElevatedButton(
              onPressed: () async {
                startFind();
              },
              child: Text(
                "Cari",
                style: TextStyle(fontFamily: "Poppins"),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            searchBar(),
            isLoading
                ? Center(
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        CircularProgressIndicator(),
                      ],
                    ),
                  )
                : ((isFind) ? footerFinded(meaning) : footerEmpty()),
          ],
        ),
      ),
    );
  }
}

Widget footerEmpty() {
  return Container(
    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: Center(
      child: Column(
        children: [
          SizedBox(height: 35),
          Icon(Icons.error_outline, size: 75),
          Text(
            "Kata tidak ditemukan",
            style: TextStyle(fontSize: 20, fontFamily: "Poppins"),
          ),
        ],
      ),
    ),
  );
}

Widget footerFinded(List meaning) {
  return Container(
    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(
                meaning[0].toString(),
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Material(
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  var box = await Hive.openBox('db_vocab');
                  String vocab = meaning[2].toString().toLowerCase();
                  var data = DataVocab(
                    vocab,
                    meaning[0],
                    meaning[1],
                  );
                  await box.add(data);
                  Fluttertoast.showToast(
                      msg: "Kata \"$vocab\" berhasil ditambahkan ke arsip",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.book,
                      size: 40,
                    ),
                    SizedBox(width: 5),
                    Column(
                      children: [
                        Text(
                          "Tambah ke",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Arsip",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: meaning[1].length,
          itemBuilder: (builder, index) {
            if (index == 0) {
              if (meaning[1].length == 1) {
                return sizedBoxDefinition(
                    meaning[0], meaning[1][index], true, true);
              } else {
                return sizedBoxDefinition(
                    meaning[0], meaning[1][index], true, false);
              }
            } else if (index == meaning[1].length - 1) {
              return sizedBoxDefinition(
                  meaning[0], meaning[1][index], false, true);
            } else {
              return sizedBoxDefinition(meaning[0], meaning[1][index]);
            }
          },
        ),
      ],
    ),
  );
}

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
