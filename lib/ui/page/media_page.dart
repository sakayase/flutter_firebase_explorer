import 'package:firebase_explorer/provider/providers.dart';
import 'package:firebase_explorer/ui/widget/create_folder_button.dart';
import 'package:firebase_explorer/ui/widget/info.dart';
import 'package:firebase_explorer/ui/widget/upload_photo_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MediaPage extends ConsumerStatefulWidget {
  MediaPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MediaPageState();
}

enum Type {
  folders,
  item,
}

class _MediaPageState extends ConsumerState<MediaPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    final mediaState = ref.read(mediaProvider);
    mediaState.setInitialPath('');
    mediaState.setModifiablePath('');
    mediaState.getDocs();
    mediaState.setController(
      AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    mediaState.setOffsetAnimation(
      Tween<Offset>(
        begin: Offset(1, 0),
        end: Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: mediaState.controller!,
          curve: Curves.decelerate,
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaState = ref.watch(mediaProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                'Medias',
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Color(0xFF00296B)),
              ),
            ),
            Flexible(
              flex: 4,
              child: Card(
                clipBehavior: Clip.hardEdge,
                elevation: 4,
                child: LimitedBox(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 5,
                        child: Column(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Container(
                                color: Colors.blue.withOpacity(0.1),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Row(
                                        children: [
                                          ...mediaState.pathButtonList,
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        CreateFolderButton(
                                          onTap: () async {
                                            createFolderDialog().then((name) {
                                              mediaState.createFolder(
                                                name,
                                              );
                                            });
                                          },
                                        ),
                                        UploadPhotoButton(
                                          onTap: () async {
                                            mediaState
                                                .pickImages()
                                                .then((value) {
                                              mediaState.getDocs();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 11,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Wrap(
                                  children: <Widget>[
                                    ...mediaState.folderWidget,
                                    ...mediaState.itemWidget,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      mediaState.showInfo
                          ? SlideTransition(
                              position: mediaState.offsetAnimation!,
                              child: Container(
                                width: 200,
                                color: Colors.black.withOpacity(0.05),
                                child: Info(
                                  item: mediaState.clickedItem,
                                  url: mediaState.clickedItemUrl,
                                  type: mediaState.typeClicked,
                                  update: () {
                                    mediaState.getDocs();
                                  },
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> createFolderDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return SimpleDialog(
          title: Text('Nom du dossier'),
          children: [
            TextField(
              controller: controller,
              onSubmitted: (value) =>
                  Navigator.of(context).pop(controller.text),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
