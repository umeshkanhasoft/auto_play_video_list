enum ContentType { video, image }

final class Assets {
  Assets({
    required this.id,
    required this.urls,
    required this.placeholder,
    required this.contentType,
    this.currentIndex = 0,
  });

  final String id;
  final List<Urls> urls;
  final String placeholder;
  int currentIndex;
  final ContentType contentType;

  int setCurrentIndex(int index) {
    return currentIndex = index;
  }
}

class Urls {
  const Urls({
    required this.id,
    required this.url,
  });

  final String id;
  final String url;
}
