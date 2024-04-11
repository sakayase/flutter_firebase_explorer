import 'package:firebase_explorer/ui/page/media_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseExplorer extends StatelessWidget {
  const FirebaseExplorer({Key? key, required this.storage}) : super(key: key);
  final FirebaseStorage storage;

  @override
  Widget build(BuildContext context) {
    return MediaPage(storage: storage);
  }
}
