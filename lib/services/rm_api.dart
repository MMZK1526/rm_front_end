import 'package:http/http.dart' as http;

class RMAPI {
  static const baseUrl = 'ktor-rm.herokuapp.com';

  static decode(String num) async {
    final url = Uri.https(baseUrl, 'decode');
    final response = await http.post(url, body: num);
    return response.body;
  }
}
