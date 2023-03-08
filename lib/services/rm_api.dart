import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rm_front_end/constants/my_text.dart';
import 'package:rm_front_end/models/decode_data.dart';

class RMAPI {
  static const baseUrl = 'ktor-rm.herokuapp.com';

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
      final response = await http.post(url, body: num);
      return DecodeData.fromJSON(jsonDecode(response.body));
    } catch (e) {
      return DecodeData(errors: [MyText.connectionErr.text]);
    }
  }
}
