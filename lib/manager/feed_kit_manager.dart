import 'package:auto_play_video_sample/manager/custom_player.dart';
import 'package:auto_play_video_sample/model/playable.dart' as pl;
import 'package:auto_play_video_sample/model/post.dart';
import 'package:kartal/kartal.dart';
import 'package:media_kit/media_kit.dart';

// manager class for getting current player
class FeedMediaKitManager {
  FeedMediaKitManager._init();

  static final FeedMediaKitManager feedMediaKitInstance =
      FeedMediaKitManager._init();

  static FeedMediaKitManager get feedInstance => feedMediaKitInstance;
  CustomPlayer? _player;
  final List<pl.PlayItem> _players = [];
  bool _isCurrentlyPlaying = false;
  bool volume = false;

  String get currentPlayingId {
    final index = _players.ext.indexOrNull((e) => e.player == _player);
    if (index == null) return '';
    return _players[index].id;
  }

  Future<void> play() async {
    if (_isCurrentlyPlaying) return;
    if (!_isMounted) return;
    await _player?.videoController.waitUntilFirstFrameRendered;
    _player
      // ignore: unawaited_futures
      ?..setVolume(volume ? 100 : 0)
      // ignore: unawaited_futures
      ..setPlaylistMode(PlaylistMode.loop)
      // ignore: unawaited_futures
      ..play();
    _isCurrentlyPlaying = true;
  }

  void pause() {
    if (!_isCurrentlyPlaying) return;
    if (!_isMounted) return;
    _player?.pause();
    _isCurrentlyPlaying = false;
  }

  void seekTo(Duration duration) {
    if (!_isMounted) return;
    _player?.seek(duration);
  }

  void setPlayer({required String id}) {
    final model = _players.firstWhereOrNull((element) => element.id == id);
    _player = model?.player;
  }

  void toggleVolume() {
    volume = !volume;
    for (var i = 0; i < _players.length; i++) {
      _players[i].player.setVolume(volume ? 100 : 0);
    }
  }

  pl.PlayItem _createVideoPlayer(Assets post, int index) {
    final p = CustomPlayer(post.urls[index].url);
    final model = pl.PlayItem(
      id: post.urls[index].id,
      player: p,
      placeholder: post.placeholder,
      source: '',
    );
    _players.add(model);
    p.init();
    return model;
  }

  pl.PlayItem getPlayerModelFromPostModel(Assets assets, int pageIndex) {
    final index =
        _players.ext.indexOrNull((p0) => p0.id == assets.urls[pageIndex].id);
    if (index != null) return _players[index];
    return _createVideoPlayer(assets, pageIndex);
  }

  Future<void> dispose(pl.Playable playable) async {
    if (playable.player.mounted == false) return;
    await playable.player.dispose();
    _players.remove(playable);
  }

  bool get _isMounted => _player?.mounted ?? false;
}
