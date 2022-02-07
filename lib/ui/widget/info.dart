import 'package:firebase_explorer/provider/providers.dart';
import 'package:firebase_explorer/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Info extends ConsumerWidget {
  const Info({
    Key? key,
    required this.update,
    this.item,
    this.url,
    this.type,
  }) : super(key: key);
  final Function update;
  final Reference? item;
  final String? url;
  final Type? type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaState = ref.watch(mediaProvider);
    if ((item == null)) return const SizedBox.shrink();
    if ((type == Type.item))
      return FutureBuilder<FullMetadata>(
        future: item!.getMetadata(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      mediaState
                          .closeDrawer()
                          .then((value) => mediaState.setShowInfo(false));
                    },
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Flex(
                  direction: Axis.vertical,
                  children: [
                    url != null
                        ? Image.network(
                            url!,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              size: 150,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : SizedBox.shrink(),
                    Divider(),
                    ListTile(
                      title: Text('Nom'),
                      subtitle: Text(item!.name),
                      trailing: IconButton(
                        onPressed: () async {
                          mediaState.setClickedItem(null);
                          mediaState.setClickedItemUrl(null);
                          mediaState.setTypeClicked(null);
                          mediaState.setShowInfo(false);
                          await item!.delete();
                          update();
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red[900],
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text('Date de création'),
                      subtitle: Text(
                          snapshot.data!.timeCreated!.toLocal().toString()),
                    ),
                    ListTile(
                      title: Text('Type'),
                      subtitle: Text(snapshot.data!.contentType!),
                    ),
                    ListTile(
                      title: Text('Taille'),
                      subtitle: Text(
                          (snapshot.data!.size! / 1000).toString() + ' kB'),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context, url);
                        },
                        child: Text('Selectionner'))
                  ],
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
      );
    else
      return Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                mediaState
                    .closeDrawer()
                    .then((value) => mediaState.setShowInfo(false));
              },
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Flex(
            direction: Axis.vertical,
            children: [
              Icon(Icons.folder,
                  size: 150, color: Theme.of(context).colorScheme.primary),
              Divider(),
              ListTile(
                title: Text(item!.name),
                subtitle: Text('Dossier'),
                trailing: IconButton(
                  onPressed: () async {
                    mediaState.setClickedItem(null);
                    mediaState.setClickedItemUrl(null);
                    mediaState.setTypeClicked(null);
                    mediaState.setShowInfo(false);
                    await deleteFolderContent(item!);
                    update();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[900],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
  }

  deleteFolderContent(Reference prefixe) async {
    ListResult listResult = await prefixe.listAll();
    await Future.forEach(listResult.items, (Reference item) async {
      await item.delete();
    });
    await Future.forEach(listResult.prefixes, (Reference prefixe) async {
      await deleteFolderContent(prefixe);
    });
  }
}
