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

  responseJSON,
  responseMarkdown,
  encodeZip,
  decodeZip,
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
      case MyText.responseJSON:
        return 'response.json';
      case MyText.responseMarkdown:
        return 'response.md';
      case MyText.encodeZip:
        return 'encode.zip';
      case MyText.decodeZip:
        return 'decode.zip';
      default:
        return 'Unknown';
    }
  }
}
