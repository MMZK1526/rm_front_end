enum MyText {
  convert,
  download,
  reset,
}

extension MyTextExtension on MyText {
  String get text {
    switch (this) {
      case MyText.convert:
        return 'Convert';
      case MyText.download:
        return 'Download';
      case MyText.reset:
        return 'Reset';
      default:
        return 'Unknown';
    }
  }
}
