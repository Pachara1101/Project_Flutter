import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:purchaseassistant/utils/formatDate.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class APIMatiching {
  String baseUrl = "http://3.25.59.0/api";
  Map<String, dynamic> dataresponse = {};
  Future<Map<String, dynamic>> sendData(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      print('Response Status Code: ${response.statusCode}');
      // print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to send data: $e');
    }
  }

  Future<Map<String, dynamic>> getRiderlist(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send data');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> setResponse(Map<String, dynamic> data) async {
    if (data != {}) {
      return data;
    } else {
      return {};
    }
  }

  // sett data in firestore
  Future<void> setMatchingResult(
      String cusid, String riderid, String cusname, String ridername) async {
    try {
      if ((cusname, ridername, cusid, riderid) != "") {
        List<String> ids = [cusid, riderid];
        ids.sort();
        String matchid = ids.join("_");
        Timestamp timestamp = Timestamp.now();
        String datetime = FormatDate(timestamp);
        await _firestore.collection("matchingResult").doc(matchid).set({
          "cusid": cusid,
          "riderid": riderid,
          "cusname": cusname,
          "ridername": ridername,
          "date": datetime
        });
      }
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }
}
