import 'dart:async';
import 'dart:io';
import 'package:best_flutter_ui_templates/app_config.dart';
import 'package:best_flutter_ui_templates/introduction_animation/introduction_animation_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class DiseaseService {
  static Future<String> getDiseasePredictions(
      List<SymptomDTO> symptomDTOs) async {
    try {
      if (symptomDTOs.isEmpty) {
        return Future.value('');
      }
      var url = Uri.parse(AppConfig.API_URL + '/patient/disease/predict');

      var symptomIds = {"symptomIds": symptomDTOs.map((e) => e.id).toList()};

      var symptomIdsReqBody = convert.jsonEncode(symptomIds);

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: symptomIdsReqBody);

      print('Resp:  $response');
      String predictedDisease = '';

      if (response.statusCode == 200) {
        predictedDisease = convert.jsonDecode(response.body)["data"]["disease"];

        print('Disease prediction: predictedDisease.');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }

      return Future.value(predictedDisease);
    } catch (e) {
      print('Error: $e');
      return Future.value('');
    }
  }
}
