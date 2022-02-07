import 'package:firebase_explorer/state/media_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mediaProvider = ChangeNotifierProvider.autoDispose<MediaState>((ref) {
  return MediaState();
});
