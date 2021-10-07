import 'package:flutter/material.dart';

import '../introduction_animation_screen.dart';

class WelcomeView extends StatefulWidget {
  final AnimationController animationController;
  final DoctorSuggestionResult doctorSuggestion;

  const WelcomeView(
      {Key? key,
      required this.animationController,
      required this.doctorSuggestion})
      : super(key: key);

  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    final _firstHalfAnimation =
        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final _secondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0)).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          0.8,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final _welcomeFirstHalfAnimation =
        Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final _welcomeImageAnimation =
        Tween<Offset>(begin: Offset(4, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: _firstHalfAnimation,
      child: SlideTransition(
        position: _secondHalfAnimation,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(50.0),
              ),
              SlideTransition(
                position: _firstHalfAnimation,
                child: SlideTransition(
                  position: _secondHalfAnimation,
                  child: Text(
                    "Matched doctors",
                    style:
                        TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 50),
              ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 35.0,
                    maxHeight: 265.0,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      // if you need this
                      side: BorderSide(
                        color: Colors.white,
                        width: 0.5,
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: widget.doctorSuggestion.doctors
                          .map((doctor) => getDocListTitle(doctor))
                          .toList(),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  ListTile getDocListTitle(DoctorDTO doctor) {
    return new ListTile(
        title: Text(doctor.name),
        subtitle: Text(doctor.speciality),
        trailing: IconButton(
          key: new Key(doctor.id.toString()),
          icon: new Icon(
            Icons.arrow_forward_ios_rounded,
            color: Color(0xff486579),
            size: 25.0,
          ),
          onPressed: () {
            print('pressed doc');
          },
        ));
  }
}
