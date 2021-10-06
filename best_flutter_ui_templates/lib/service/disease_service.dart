import 'dart:async';
import 'dart:io';
import 'package:best_flutter_ui_templates/app_config.dart';
import 'package:best_flutter_ui_templates/introduction_animation/introduction_animation_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class DiseaseService {
  static Future<DiseaseDTO> getDiseasePredictions(
      List<SymptomDTO> symptomDTOs) async {
    DiseaseDTO predictedDisease = DiseaseDTO.getEmpty();

    try {
      if (symptomDTOs.isEmpty) {
        return Future.value(predictedDisease);
      }

      var url = Uri.parse(AppConfig.API_URL + '/patient/disease/predict');

      var symptomIds = {"symptomIds": symptomDTOs.map((e) => e.id).toList()};

      var symptomIdsReqBody = convert.jsonEncode(symptomIds);

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: symptomIdsReqBody);

      print('Resp:  $response');

      if (response.statusCode == 200) {
        var jsonDisease = convert.jsonDecode(response.body)["data"];
        predictedDisease = DiseaseDTO.getFromJson(jsonDisease);

        print('Disease prediction: predictedDisease.');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }

      return Future.value(predictedDisease);
    } catch (e) {
      print('Error: $e');
      return Future.value(predictedDisease);
    }
  }
}
