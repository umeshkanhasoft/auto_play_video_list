import 'package:async/async.dart' as asynca;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

// created player class
class CustomPlayer extends Player with EquatableMixin {
  CustomPlayer(this.resource) : super() {
    videoController = VideoController(this);
    operation = asynca.CancelableOperation.fromFuture(
      Future.delayed(const Duration(seconds: 1)),
    );
    mounted = true;
  }
  late bool? mounted;
  final String resource;
  late final VideoController videoController;
  late final asynca.CancelableOperation<void> operation;
  final ValueNotifier<bool> isInitialized = ValueNotifier(false);

  Future<void> init() async {
    await operation.value.then((_) async {
      await open(Media(resource), play: false);
      await videoController.notifier.value?.waitUntilFirstFrameRendered;
      isInitialized.value = true;
    });
  }

  @override
  Future<void> dispose() {
    operation.cancel();
    mounted = false;
    return super.dispose();
  }

  @override
  List<Object?> get props => [resource];
}
