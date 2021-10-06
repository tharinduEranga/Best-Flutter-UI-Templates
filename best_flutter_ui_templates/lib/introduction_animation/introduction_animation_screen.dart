import 'package:best_flutter_ui_templates/fitness_app/fitness_app_home_screen.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/care_view.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/center_next_button.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/mood_diary_vew.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/relax_view.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/splash_view.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/top_back_skip_view.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/welcome_view.dart';
import 'package:best_flutter_ui_templates/service/data.dart';
import 'package:best_flutter_ui_templates/service/disease_service.dart';
import 'package:best_flutter_ui_templates/service/doctor_service.dart';
import 'package:flutter/material.dart';

class IntroductionAnimationScreen extends StatefulWidget {
  const IntroductionAnimationScreen({Key? key}) : super(key: key);

  @override
  _IntroductionAnimationScreenState createState() =>
      _IntroductionAnimationScreenState();
}

class _IntroductionAnimationScreenState
    extends State<IntroductionAnimationScreen> with TickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 8));
    _animationController?.animateTo(0.0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  List<SymptomDTO> addedSymptomsList = [];
  List<SymptomDTO> similarSymptomsList = [];
  List<ListTile> addedSymptomsViewList = <ListTile>[];
  DiseaseDTO predictedDisease = DiseaseDTO.getEmpty();
  DoctorSuggestionResult doctorSuggestion = DoctorSuggestionResult.getEmpty();

  callback(SymptomDTO newSymptom, ListTile listTile, int removeId) {
    setState(() {
      print('Setting state.... $newSymptom,\t $listTile');
      if (removeId > -1) {
        addedSymptomsList.removeWhere((element) => element.id == removeId);
        addedSymptomsViewList.removeWhere(
            (element) => element.trailing!.key == new Key(removeId.toString()));
      } else {
        addedSymptomsList.add(newSymptom);
        addedSymptomsViewList.add(listTile);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_animationController?.value);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFFFFFFF),
      body: ClipRect(
        child: Stack(
          children: [
            SplashView(
              animationController: _animationController!,
            ),
            RelaxView(
                animationController: _animationController!,
                addedSymptomsViewList: addedSymptomsViewList,
                callback: callback),
            CareView(
              animationController: _animationController!,
              selectedSymptoms: addedSymptomsList,
              similarSymptoms: similarSymptomsList,
              addedSymptomsViewList: addedSymptomsViewList,
              callback: callback,
            ),
            MoodDiaryVew(
              animationController: _animationController!,
              predictedDisease: predictedDisease,
            ),
            WelcomeView(
              animationController: _animationController!,
            ),
            TopBackSkipView(
              onBackClick: _onBackClick,
              onSkipClick: _onSkipClick,
              animationController: _animationController!,
            ),
            CenterNextButton(
              animationController: _animationController!,
              onNextClick: _onNextClick,
            ),
          ],
        ),
      ),
    );
  }

  void _onSkipClick() {
    // _animationController?.animateTo(0.8,
    //     duration: Duration(milliseconds: 1200));
    _signUpClick();
  }

  void _onBackClick() {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      _animationController?.animateTo(0.0);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      _animationController?.animateTo(0.2);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.8 &&
        _animationController!.value <= 1.0) {
      _animationController?.animateTo(0.8);
    }
  }

  Future<void> _onNextClick() async {
    if (_animationController!.value >= 0 &&
        _animationController!.value <= 0.2) {
      // going to similar symptoms UI
      var similarSymptoms =
          await SymptomsService.getSimilarSymptoms(addedSymptomsList);
      setState(() {
        similarSymptomsList = similarSymptoms;
        addedSymptomsViewList = addedSymptomsViewList.toList();
      });

      _animationController?.animateTo(0.4);
    } else if (_animationController!.value > 0.2 &&
        _animationController!.value <= 0.4) {
      // going to disease predict UI
      DiseaseDTO disease =
          await DiseaseService.getDiseasePredictions(addedSymptomsList);
      setState(() {
        this.predictedDisease = disease;
      });

      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
      //going to doctor suggestions UI
      DoctorSuggestionResult doctorSuggestion =
          await DoctorService.getDoctorSuggestions(predictedDisease.id);
      setState(() {
        this.doctorSuggestion = doctorSuggestion;
      });

      _animationController?.animateTo(0.8);
    } else if (_animationController!.value > 0.6 &&
        _animationController!.value <= 0.8) {
      _signUpClick();
    }
  }

  void _signUpClick() {
    /*this redirect (pushReplacement) trigger closes the app when back pressed*/
    Navigator.pushReplacement(context, MaterialPageRoute<dynamic>(
      builder: (BuildContext context) =>
          FitnessAppHomeScreen(),
    ));
  }
}

class SymptomDTO {
  final int id;
  final String name;
  final int position;

  SymptomDTO(this.id, this.name, this.position);

  @override
  String toString() {
    return 'SymptomDTO{id: $id, name: $name, position: $position}';
  }
}

class DiseaseDTO {
  final int id;
  final String name;

  DiseaseDTO(this.id, this.name);

  @override
  String toString() {
    return 'DiseaseDTO{id: $id, name: $name}';
  }

  static DiseaseDTO getFromJson(Map<String, dynamic> json) {
    return new DiseaseDTO(json['id'], json['disease']);
  }

  static DiseaseDTO getEmpty() {
    return new DiseaseDTO(0, '');
  }

  static bool isEmpty(DiseaseDTO diseaseDTO) {
    return diseaseDTO.id < 1 || diseaseDTO.name == '';
  }
}

class DoctorDTO {
  final int id;
  final String name;
  final String speciality;

  DoctorDTO(this.id, this.name, this.speciality);

  static DoctorDTO getFromJson(Map<String, dynamic> json) {
    return new DoctorDTO(json['id'], json['name'], json['speciality']);
  }

  @override
  String toString() {
    return 'DoctorDTO{id: $id, name: $name, speciality: $speciality}';
  }
}

class DoctorSuggestionResult {
  final List<String> specialities;
  final List<DoctorDTO> doctors;

  DoctorSuggestionResult(this.specialities, this.doctors);

  @override
  String toString() {
    return 'DoctorSuggestionResult{specialities: $specialities, '
        'doctors: $doctors}';
  }

  static DoctorSuggestionResult getEmpty() {
    return new DoctorSuggestionResult([], []);
  }

  static bool isEmpty(DoctorSuggestionResult doctorSuggestionResult) {
    return doctorSuggestionResult.specialities.isEmpty &&
        doctorSuggestionResult.doctors.isEmpty;
  }

  static DoctorSuggestionResult getFromJson(Map<String, dynamic> json) {
    final List<String> specialities = [];
    final List<DoctorDTO> doctors = [];

    json['specialities'].forEach((v) {
      specialities.add(v);
    });

    json['doctors'].forEach((v) {
      doctors.add(DoctorDTO.getFromJson(v));
    });

    return new DoctorSuggestionResult(specialities, doctors);
  }
}