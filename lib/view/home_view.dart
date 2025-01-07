import 'package:auto_play_video_sample/manager/feed_kit_manager.dart';
import 'package:auto_play_video_sample/model/post.dart';
import 'package:auto_play_video_sample/widget/content_card/content_video_card.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  PageController controller = PageController();
  List<Assets> allPosts = [];

  @override
  void initState() {
    super.initState();

    addArray();
    //listener current view position and playing
    _itemPositionsListener.itemPositions.addListener(() {
      final positions = _itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final closestToMiddle = positions.reduce((closest, current) {
          final close = closest.itemLeadingEdge + closest.itemTrailingEdge;
          final curr = current.itemLeadingEdge + current.itemTrailingEdge;
          return (curr - 1).abs() < (close - 1).abs() ? current : closest;
        });
        final playingId = allPosts[closestToMiddle.index]
            .urls[allPosts[closestToMiddle.index].currentIndex]
            .id;
        if (FeedMediaKitManager.feedInstance.currentPlayingId != playingId) {
          FeedMediaKitManager.feedInstance
            ..pause()
            ..setPlayer(id: playingId)
            ..play();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Video List Demo'),
        ),
        body: ScrollablePositionedList.separated(
          itemPositionsListener: _itemPositionsListener,
          separatorBuilder: (_, __) => const Divider(height: 32),
          itemCount: allPosts.length,
          minCacheExtent: 0,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            return SizedBox(
              height: 400,
              child: PageView(
                onPageChanged: (value) {
                  allPosts[index].currentIndex = value;
                  if (FeedMediaKitManager.feedInstance.currentPlayingId !=
                      allPosts[index].urls[value].id) {
                    FeedMediaKitManager.feedInstance
                      ..pause()
                      ..setPlayer(id: allPosts[index].urls[value].id)
                      ..play();
                  }
                },
                controller: controller,
                physics: LimitedScrollPhysics(
                  minPage: 0,
                  maxPage: allPosts[index].urls.length,
                ),
                children: allPosts[index]
                    .urls
                    .map(
                      (e) => ContentVideoCard(
                        asset: allPosts[index],
                        pageIndex: allPosts[index].urls.indexOf(e),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  //static array
  void addArray() {
    allPosts = [
      Assets(
        id: '1',
        urls: [
          const Urls(
            id: 'a',
            url:
            'https://videos.pexels.com/video-files/8471681/8471681-uhd_2732_1440_25fps.mp4',
          ),
          const Urls(
            id: 'g',
            url:
            'https://videos.pexels.com/video-files/4620490/4620490-uhd_2732_1440_25fps.mp4',
          ),
          const Urls(
            id: 'h',
            url:
            'https://videos.pexels.com/video-files/855480/855480-hd_1920_1080_25fps.mp4',
          ),
        ],
        placeholder: '',
        contentType: ContentType.video,
      ),
      Assets(
        id: '4',
        urls: [
          const Urls(
            id: 'b',
            url:
            'https://videos.pexels.com/video-files/6296290/6296290-hd_1080_1920_25fps.mp4',
          ),
        ],
        placeholder: '',
        contentType: ContentType.video,
      ),
      Assets(
        id: '7',
        urls: [
          const Urls(
            id: 'c',
            url:
            'https://videos.pexels.com/video-files/5190550/5190550-uhd_2732_1440_25fps.mp4',
          ),
        ],
        placeholder: '',
        contentType: ContentType.video,
      ),
      Assets(
        id: '10',
        urls: [
          const Urls(
            id: 'd',
            url:
            'https://videos.pexels.com/video-files/4716694/4716694-uhd_2732_1440_25fps.mp4',
          ),
        ],
        placeholder: '',
        contentType: ContentType.video,
      ),
      Assets(
        id: '12',
        urls: [
          const Urls(
            id: 'e',
            url:
            'https://videos.pexels.com/video-files/9850676/9850676-uhd_1440_2732_25fps.mp4',
          ),
        ],
        placeholder: '',
        contentType: ContentType.video,
      ),
      Assets(
        id: '101',
        urls: [
          const Urls(
            id: 'f',
            url:
            'https://videos.pexels.com/video-files/4614907/4614907-uhd_2560_1440_30fps.mp4',
          ),
        ],
        placeholder: '',
        contentType: ContentType.video,
      ),
    ];
  }
}

// scrolling physics
class LimitedScrollPhysics extends ClampingScrollPhysics {
  const LimitedScrollPhysics({
    required this.minPage,
    required this.maxPage,
    super.parent,
  });

  final int minPage;
  final int maxPage;

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels &&
        position.pixels <= minPage * position.viewportDimension) {
      return value - position.pixels;
    } else if (value > position.pixels &&
        position.pixels >= maxPage * position.viewportDimension) {
      return value - position.pixels;
    }
    return super.applyBoundaryConditions(position, value);
  }
}
