import 'package:firebase_explorer/provider/providers.dart';
import 'package:firebase_explorer/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FolderButton extends ConsumerWidget {
  const FolderButton({
    Key? key,
    required this.item,
  }) : super(key: key);
  final Reference item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaState = ref.watch(mediaProvider);
    String path = item.fullPath
        .replaceAll(mediaState.initialPath!.replaceFirst('/', ''), '');
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          mediaState.controller!.forward();
          mediaState.setClickedItem(item);
          mediaState.setTypeClicked(Type.folders);
          mediaState.setShowInfo(true);
        },
        onDoubleTap: () {
          mediaState.setModifiablePath(path);
          mediaState.getDocs();
        },
        child: SizedBox(
          width: 55,
          height: 55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.folder,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
              Text(
                item.name,
                style: const TextStyle(
                    fontSize: 9, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
