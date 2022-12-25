import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pedometer/core/functions.dart';

class CountApi {
  String baseUrl = "https://pedometer.herokuapp.com";

  Future<int> getCount({required List<List<double>> data}) async {
    try {
      // showAppSnackbar(title: "", message:"in api data length: ${data.length.toString()}");
      final map = <String, dynamic>{};
      map['data'] = data;
      var url = Uri.parse("$baseUrl/step");
      // print(jsonEncode(map));

      var res = await http.post(url,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: jsonEncode(map));
      // showAppSnackbar(title: "", message: res.body);

      if (res.statusCode == 200) {
        Map<String, dynamic> out = jsonDecode(res.body);
        // showAppSnackbar(title: "", message: out['count']?.toString() ?? "0");
        return out['count'] ?? 0;
      }
    } catch (e) {
      showAppSnackbar(title: "", message: e.toString());
      return 0;
    }
    showAppSnackbar(title: "", message: "Error");
    return 0;
  }
}
