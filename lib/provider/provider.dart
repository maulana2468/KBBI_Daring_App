import 'package:flutter/cupertino.dart';
import 'package:kbbi_daring/service/connect_api.dart';

class GetDataProvider with ChangeNotifier {
  late GetVocabulary _vocabMean;

  GetVocabulary get getVocabulary => _vocabMean;

  set getVocabulary(GetVocabulary getVocabulary) {
    _vocabMean = getVocabulary;
    notifyListeners();
  }

  Future<bool> getDataVocabMean(String vocabFind) async {
    try {
      GetVocabulary vocab = await GetVocabulary.getData(vocabFind);

      _vocabMean = vocab;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
