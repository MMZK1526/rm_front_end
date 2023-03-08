enum MyText {
  convert,
  download,
  reset,

  connectionErr,
  connectionErrContent,
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
      case MyText.connectionErr:
        return 'Connection Error';
      case MyText.connectionErrContent:
        return 'Failed to connect to the back-end. The functionalities may not work';
      default:
        return 'Unknown';
    }
  }
}
