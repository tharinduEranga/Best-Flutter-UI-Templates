import 'dart:async';
import 'dart:io';
import 'package:best_flutter_ui_templates/app_config.dart';
import 'package:best_flutter_ui_templates/introduction_animation/introduction_animation_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class DoctorService {
  static Future<DoctorSuggestionResult> getDoctorSuggestions(
      int diseaseId) async {
    DoctorSuggestionResult doctorSuggestionResult =
        DoctorSuggestionResult.getEmpty();

    try {
      if (diseaseId < 1) {
        return Future.value();
      }
      var url = Uri.parse(AppConfig.API_URL + '/patient/doctor/suggest');

      var disease = {"disease": diseaseId};

      var doctorSuggestionRequest = convert.jsonEncode(disease);

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: doctorSuggestionRequest);

      print('Resp:  $response');

      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body)["data"];
        doctorSuggestionResult =
            DoctorSuggestionResult.getFromJson(jsonResponse);

        print('Disease prediction: doctorSuggestionResult.');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }

      return Future.value(doctorSuggestionResult);
    } catch (e) {
      print('Error: $e');
      return Future.value(doctorSuggestionResult);
    }
  }
}
