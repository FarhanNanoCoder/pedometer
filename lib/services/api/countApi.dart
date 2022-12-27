import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pedometer/controllers/userController.dart';
import 'package:pedometer/core/functions.dart';

class CountApi {
  String baseUrl = "https://pedometer.herokuapp.com";

  Future<Map<String,dynamic>?> getCount(
      {required List<List<double>> data,
      required int age,
      required double weight,
      required double height,required int gender}) async {
    try {
      // showAppSnackbar(title: "", message:"in api data length: ${data.length.toString()}");
      final map = <String, dynamic>{};
      map['data'] = data;
      map['height'] = height;
      map['weight'] = weight;
      map['age'] = age;
      map['gender'] = gender;
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
        return out;
      }
    } catch (e) {
      showAppSnackbar(title: "", message: e.toString());
      return null;
    }
    showAppSnackbar(title: "", message: "Error");
    return null;
  }
}
