import 'package:hive/hive.dart';
part 'db_vocab.g.dart';

@HiveType(typeId: 0)
class DataVocab {
  @HiveField(0)
  String vocab;
  @HiveField(1)
  String lema;
  @HiveField(2)
  List mean;

  DataVocab(this.vocab, this.lema, this.mean);
}
