import 'dart:convert';

import 'package:http/http.dart' as http;

class GetVocabulary {
  String lemma;
  List vocab;

  GetVocabulary({required this.lemma, required this.vocab});

  factory GetVocabulary.fromJson(Map<String, dynamic> obj) {
    return GetVocabulary(
      lemma: obj['lema'],
      vocab: obj['arti'] as List<dynamic>,
    );
  }

  static Future<GetVocabulary> getData(String vocabFind) async {
    var getURL = "https://kbbi-api-zhirrr.vercel.app/api/kbbi?text=$vocabFind";

    var response = await http.get(Uri.parse(getURL));

    if (response.statusCode == 200) {
      var jsonObj = json.decode(response.body);
      var data = jsonObj as Map<String, dynamic>;

      return GetVocabulary.fromJson(data);
    } else {
      throw Exception("Gagal mendapatkan data");
    }
  }
}
