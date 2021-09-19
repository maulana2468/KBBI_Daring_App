import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kbbi_daring/provider/db_vocab.dart';
import 'package:kbbi_daring/provider/provider.dart';
import 'package:kbbi_daring/ui/main_menu.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(DataVocabAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GetDataProvider()),
      ],
      child: MaterialApp(
        title: "KBBI Daring",
        home: Menu(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
