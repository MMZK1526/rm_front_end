enum MyText {
  title,
  introTab,
  convTab,
  simTab,

  convert,
  upload,
  download,
  reset,

  connectionErr,
  connectionErrContent,

  responseFileName,
  decodeFileName,
  decodeZipFileName,
}

extension MyTextExtension on MyText {
  String get text {
    switch (this) {
      case MyText.title:
        return 'Register Machine Simulator';
      case MyText.introTab:
        return 'Introduction';
      case MyText.convTab:
        return 'Gödel Number Conversion';
      case MyText.simTab:
        return 'Simulation';
      case MyText.convert:
        return 'Convert';
      case MyText.upload:
        return 'Upload';
      case MyText.download:
        return 'Download';
      case MyText.reset:
        return 'Reset';
      case MyText.connectionErr:
        return 'Connection Error';
      case MyText.connectionErrContent:
        return 'Failed to connect to the back-end. The functionalities may not work';
      case MyText.responseFileName:
        return 'response.json';
      case MyText.decodeFileName:
        return 'decode.rm';
      case MyText.decodeZipFileName:
        return 'decode.zip';
      default:
        return 'Unknown';
    }
  }
}
