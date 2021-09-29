import 'package:best_flutter_ui_templates/fitness_app/fitness_app_home_screen.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/care_view.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/center_next_button.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/mood_diary_vew.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/relax_view.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/splash_view.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/top_back_skip_view.dart';
import 'package:best_flutter_ui_templates/introduction_animation/components/welcome_view.dart';
import 'package:best_flutter_ui_templates/service/data.dart';
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
      _animationController?.animateTo(0.6);
    } else if (_animationController!.value > 0.4 &&
        _animationController!.value <= 0.6) {
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