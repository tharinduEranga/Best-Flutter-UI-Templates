import 'dart:async';
import 'dart:io';
import 'package:best_flutter_ui_templates/app_config.dart';
import 'package:best_flutter_ui_templates/introduction_animation/introduction_animation_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SymptomsService {
  static Future<List<Map<String, String>>> searchSymptoms(String query) async {
    try {
      if (query.isEmpty || query.length < 3) {
        return Future.value([]);
      }
      var url =
          Uri.parse(AppConfig.API_URL + '/patient/symptoms/search?name=$query');

      var response = await http.get(url);
      print('Resp:  ${response.statusCode}');
      List<SymptomsSearchResult> suggestions = [];
      if (response.statusCode == 200) {
        Iterable json = convert.jsonDecode(response.body)["data"];
        suggestions = List<SymptomsSearchResult>.from(
            json.map((model) => SymptomsSearchResult.fromJson(model)));

        print('Number of suggestion: ${suggestions.length}.');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }

      return Future.value(suggestions
          .map((e) => {
                'id': e.id.toString(),
                'name': e.name,
                'position': e.position.toString()
              })
          .toList());
    } catch (e) {
      print('Error: $e');
      return Future.value([]);
    }
  }

  static Future<List<SymptomDTO>> getSimilarSymptoms(
      List<SymptomDTO> symptomDTOs) async {
    try {
      if (symptomDTOs.isEmpty) {
        return Future.value([]);
      }
      var url = Uri.parse(AppConfig.API_URL + '/patient/symptoms/correlated');

      var symptomIds = {"symptomIds": symptomDTOs.map((e) => e.id).toList()};

      var symptomIdsReqBody = convert.jsonEncode(symptomIds);

      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: symptomIdsReqBody);

      print('Resp:  $response');
      List<SymptomDTO> suggestions = [];

      if (response.statusCode == 200) {
        Iterable json = convert.jsonDecode(response.body)["data"];
        suggestions = List<SymptomDTO>.from(json.map((model) =>
            new SymptomDTO(model['id'], model['name'], model['position'])));

        print('Number of suggestion: ${suggestions.length}.');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }

      return Future.value(suggestions);
    } catch (e) {
      print('Error: $e');
      return Future.value([]);
    }
  }
}

class SymptomsSearchResult {
  final int id;
  final String name;
  final int position;

  SymptomsSearchResult(
      {required this.id, required this.name, required this.position});

  static fromJson(Map<String, dynamic> json) {
    return new SymptomsSearchResult(
        id: json['id'], name: json['name'], position: json['position']);
  }
}
