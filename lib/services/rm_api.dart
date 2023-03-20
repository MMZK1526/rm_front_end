import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rm_front_end/constants/my_text.dart';
import 'package:rm_front_end/models/decode_data.dart';
import 'package:rm_front_end/models/encode_data.dart';

class RMAPI {
  static const baseUrl = 'ktor-rm.herokuapp.com';
  static const headers = {'Content-Type': 'application/json'};

  static Future<bool> initialise() async {
    try {
      final url = Uri.https(baseUrl);
      await http.get(url);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<DecodeData> decode(String num) async {
    try {
      final url = Uri.https(baseUrl, 'decode');
      final response = await http.post(url, headers: headers, body: num);
      return DecodeData.fromJSON(jsonDecode(response.body));
    } catch (e) {
      return DecodeData(errors: [MyText.connectionErr.text]);
    }
  }

  static Future<EncodeData> encodeRM(String rm) async {
    try {
      final url = Uri.https(baseUrl, 'encode');
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'code': rm}),
      );
      return EncodeData.fromJSON(jsonDecode(response.body));
    } catch (e) {
      return EncodeData(errors: [MyText.connectionErr.text]);
    }
  }
}
