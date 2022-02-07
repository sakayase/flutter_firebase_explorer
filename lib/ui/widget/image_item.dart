import 'package:firebase_explorer/provider/providers.dart';
import 'package:firebase_explorer/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageItem extends ConsumerWidget {
  const ImageItem({Key? key, required this.item}) : super(key: key);
  final Reference item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaState = ref.watch(mediaProvider);

    return FutureBuilder<String>(
      future: item.getDownloadURL(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () async {
                String url = await item.getDownloadURL();
                mediaState.controller!.forward();
                mediaState.setClickedItem(item);
                mediaState.setClickedItemUrl(url);
                mediaState.setTypeClicked(Type.item);
                mediaState.setShowInfo(true);
              },
              child: Container(
                height: 55,
                width: 55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Image.network(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 8,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                height: 55,
                width: 55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Icon(
                        Icons.image,
                        color: Theme.of(context).colorScheme.primary,
                        size: 40,
                      ),
                    ),
                    Text(
                      item.name,
                      style: TextStyle(
                          fontSize: 8, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Container(
          child: Icon(
            Icons.image_not_supported,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
