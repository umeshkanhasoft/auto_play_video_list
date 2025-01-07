
import 'package:auto_play_video_sample/manager/custom_player.dart';

abstract class Playable {
  Playable({
    required this.id,
    required this.player,
    required this.source,
    required this.placeholder,
  });

  final String id;
  final CustomPlayer player;
  final String source;
  final String placeholder;
}

class PlayItem extends Playable {
  PlayItem({
    required super.id,
    required super.player,
    required super.source,
    required super.placeholder,
  });
}
