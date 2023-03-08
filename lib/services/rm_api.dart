import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rm_front_end/models/decode_data.dart';

class RMAPI {
  static const baseUrl = 'ktor-rm.herokuapp.com';

  static Future<DecodeData> decode(String num) async {
    final url = Uri.https(baseUrl, 'decode');
    final response = await http.post(url, body: num);
    return DecodeData.fromJSON(jsonDecode(response.body));
  }
}
