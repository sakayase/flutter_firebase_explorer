import 'dart:async';
import 'dart:typed_data';

import 'package:firebase_explorer/ui/widget/folder_button.dart';
import 'package:firebase_explorer/ui/widget/image_item.dart';
import 'package:firebase_explorer/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaState with ChangeNotifier {
  FirebaseStorage storage = FirebaseStorage.instance;
  String? initialPath;
  String? modifiablePath;
  Reference? clickedItem;
  String? clickedItemUrl;
  Type? typeClicked;
  bool showInfo = false;
  List<Reference> items = [];
  List<Reference> folders = [];
  List<Widget> itemWidget = [];
  List<Widget> folderWidget = [];
  List<Widget> pathButtonList = [];

  AnimationController? controller;
  Animation<Offset>? offsetAnimation;

  setInitialPath(String path) {
    initialPath = path;
    notifyListeners();
  }

  setModifiablePath(String path) {
    modifiablePath = path;
    notifyListeners();
  }

  setClickedItem(Reference? item) {
    clickedItem = item;
    notifyListeners();
  }

  setClickedItemUrl(String? url) {
    clickedItemUrl = url;
    notifyListeners();
  }

  setTypeClicked(Type? type) {
    typeClicked = type;
    notifyListeners();
  }

  setShowInfo(bool bool) {
    showInfo = bool;
    notifyListeners();
  }

  setController(AnimationController controller) {
    this.controller = controller;
    notifyListeners();
  }

  setOffsetAnimation(Animation<Offset> offsetAnimation) {
    this.offsetAnimation = offsetAnimation;
    notifyListeners();
  }

  setItems(List<Reference> items) {
    this.items = items;
    notifyListeners();
  }

  setFolders(List<Reference> folders) {
    this.folders = folders;
    notifyListeners();
  }

  setItemWidget(List<Widget> listWidget) {
    itemWidget = listWidget;
    notifyListeners();
  }

  setFolderWidget(List<Widget> listWidget) {
    folderWidget = listWidget;
    notifyListeners();
  }

  getDocs() async {
    Reference reference = storage.ref(initialPath! + modifiablePath!);
    ListResult listResult = await reference.listAll();
    setItems(listResult.items);
    setFolders(listResult.prefixes);
    setItemWidget(items.map((e) {
      if (e.name == 'ghost.ghost') {
        return const SizedBox.shrink();
      }
      return ImageItem(
        item: e,
      );
    }).toList());
    setFolderWidget(folders.map(
      (e) {
        return FolderButton(
          item: e,
        );
      },
    ).toList());
    generatePathButtons();
  }

  Future createFolder(String name) async {
    await storage
        .ref(initialPath! + modifiablePath!)
        .child('$name/ghost.ghost')
        .putString('ghost')
        .then((p0) {
      setModifiablePath(modifiablePath! + '/' + name);
      getDocs();
    });
  }

  Future pickImages() async {
    ImagePicker picker = ImagePicker();
    Reference ref = storage.ref(initialPath! + modifiablePath!);
    await picker.pickMultiImage().then((List<XFile>? photos) async {
      if (photos != null) await uploadImages(photos, ref);
    });
  }

  Future uploadImages(List<XFile> photos, Reference ref) async {
    await Future.forEach(photos, (XFile photo) async {
      Uint8List bytes = await photo.readAsBytes();
      UploadTask uploadTask = ref
          .child(photo.name)
          .putData(bytes, SettableMetadata(contentType: photo.mimeType));
      await uploadTask.timeout(
        const Duration(seconds: 15),
        onTimeout: () async {
          await uploadTask.cancel();
          throw TimeoutException('Delai depassé');
        },
      );
    });
  }

  Future openDrawer() async {
    await controller!.forward();
  }

  Future closeDrawer() async {
    await controller!.reverse();
  }

  generatePathButtons() {
    List listFolderNames = modifiablePath!.split('/');
    listFolderNames.removeWhere((element) => element == '');
    String path = '';
    pathButtonList = [];
    pathButtonList.add(
      TextButton(
        key: const Key('media'),
        onPressed: () {
          setModifiablePath('');
          getDocs();
        },
        child: const Text('media/'),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(0),
        ),
      ),
    );
    pathButtonList.addAll(listFolderNames.map((folder) {
      path = path + folder + '/';
      return createPathButtons(path, folder);
    }).toList());

    notifyListeners();
  }

  Widget createPathButtons(String path, String folder) {
    return TextButton(
      key: Key(folder),
      onPressed: () {
        setModifiablePath(path);
        getDocs();
      },
      child: Text(
        folder + '/',
      ),
      style: TextButton.styleFrom(
          padding: const EdgeInsets.all(0), minimumSize: Size.zero),
    );
  }
}
