import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rm_front_end/constants/my_text.dart';
import 'package:rm_front_end/models/decode_data.dart';
import 'package:rm_front_end/models/encode_data.dart';
import 'package:rm_front_end/models/simulate_data.dart';

class RMAPI {
  static const devBaseUrl = 'http://0.0.0.0:8080';
  static const releaseBaseUrl = 'https://ktor-rm.herokuapp.com';
  static const headers = {'Content-Type': 'application/json'};
  static const useLocal = false;

  /// Get the base URL of the API depending on the build mode.
  static getBaseUrl() {
    if (kDebugMode && useLocal) {
      return devBaseUrl;
    }

    return releaseBaseUrl;
  }

  /// Check if the API is available.
  static Future<bool> initialise() async {
    try {
      final url = Uri.parse(getBaseUrl());
      await http.get(url);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Decode API.
  static Future<DecodeData> decode(String num) async {
    try {
      final url = Uri.parse(getBaseUrl() + '/decode');
      final response = await http.post(url, body: num);
      return DecodeData.fromJSON(jsonDecode(response.body));
    } catch (e) {
      return DecodeData(errors: [MyText.connectionErr.text, '$e']);
    }
  }

  /// Encode API for Register Machines.
  static Future<EncodeData> encodeRM(String rm) async {
    try {
      final url = Uri.parse(getBaseUrl() + '/encode');
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'code': rm}),
      );
      return EncodeData.fromJSON(jsonDecode(response.body));
    } catch (e) {
      return EncodeData(errors: [MyText.connectionErr.text, '$e']);
    }
  }

  /// Encode API for Lists or Pairs.
  static Future<EncodeData> encodeListOrPair(String args) async {
    try {
      List<String> argList =
          args.replaceAll(RegExp('[;, ]+'), ' ').trim().split(' ');
      final url = Uri.parse(getBaseUrl() + '/encode');
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({'args': argList}),
      );
      return EncodeData.fromJSON(jsonDecode(response.body));
    } catch (e) {
      return EncodeData(errors: [MyText.connectionErr.text, '$e']);
    }
  }

  /// Simulate API.
  static Future<SimulateData> simulate(String code, List<String> args) async {
    try {
      final url = Uri.parse(getBaseUrl() + '/simulate');
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'code': code,
          'args': args,
          'startFromR0': true,
        }),
      );
      return SimulateData.fromJSON(jsonDecode(response.body));
    } catch (e) {
      return SimulateData(errors: [MyText.connectionErr.text, '$e']);
    }
  }
}
