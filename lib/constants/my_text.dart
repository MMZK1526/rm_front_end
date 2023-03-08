enum MyText {
  convert;
}

extension MyTextExtension on MyText {
  String get text {
    switch (this) {
      case MyText.convert:
        return 'Convert';
      default:
        return 'Unknown';
    }
  }
}
