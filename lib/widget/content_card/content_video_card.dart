import 'package:auto_play_video_sample/manager/feed_kit_manager.dart';
import 'package:auto_play_video_sample/model/playable.dart';
import 'package:auto_play_video_sample/model/post.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

class ContentVideoCard extends StatefulWidget {
  const ContentVideoCard({
    required this.asset,
    required this.pageIndex,
    super.key,
  });

  final Assets asset;
  final int pageIndex;

  @override
  State<ContentVideoCard> createState() => _ContentVideoCardState();
}

class _ContentVideoCardState extends State<ContentVideoCard> {
  //getting single model player
  Playable get _model => FeedMediaKitManager.feedInstance
      .getPlayerModelFromPostModel(widget.asset, widget.pageIndex);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    FeedMediaKitManager.feedInstance.dispose(_model);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: FutureBuilder<void>(
        future: _model.player.videoController.waitUntilFirstFrameRendered,
        builder: (context, AsyncSnapshot<void> snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              // [Thumbnail]
              ? const ColoredBox(
                  color: Colors.tealAccent,
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ) // thumb
              : ColoredBox(
                  color: Colors.transparent,
                  child: Video(
                    resumeUponEnteringForegroundMode: true,
                    controller: _model.player.videoController,
                    controls: (state) {
                      return Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed:
                              FeedMediaKitManager.feedInstance.toggleVolume,
                          icon: StreamBuilder(
                            stream:
                                state.widget.controller.player.stream.volume,
                            builder: (context, playing) {
                              return Icon(
                                playing.data == 100.0
                                    ? Icons.volume_up_outlined
                                    : Icons.volume_off,
                              );
                            },
                          ),
                          // It's not necessary to use [StreamBuilder] or to use [Player] & [VideoController] from [state].
                          // [StreamSubscription]s can be made inside [initState] of this widget.
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
