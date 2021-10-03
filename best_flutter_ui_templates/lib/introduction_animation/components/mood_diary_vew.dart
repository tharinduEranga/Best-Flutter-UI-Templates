import 'package:flutter/material.dart';

class MoodDiaryVew extends StatefulWidget {
  final AnimationController animationController;

  const MoodDiaryVew({Key? key, required this.animationController})
      : super(key: key);

  @override
  _MoodDiaryVewState createState() => _MoodDiaryVewState();
}

class _MoodDiaryVewState extends State<MoodDiaryVew> {
  @override
  Widget build(BuildContext context) {
    final _firstHalfAnimation =
        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.4,
        0.6,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final _secondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final _moodFirstHalfAnimation =
        Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.2,
        0.4,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final _moodSecondHalfAnimation =
        Tween<Offset>(begin: Offset(0, -2), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          0.0,
          0.2,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final _imageFirstHalfAnimation =
        Tween<Offset>(begin: Offset(4, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.4,
        0.6,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final _imageSecondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-4, 0))
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
              /*top padding*/
              Padding(
                padding: EdgeInsets.all(50.0),
              ),
              SlideTransition(
                position: _moodFirstHalfAnimation,
                child: SlideTransition(
                  position: _moodSecondHalfAnimation,
                  child: Text(
                    "Matched disease",
                    style:
                        TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Column(
                children: [
                  SlideTransition(
                    position: _moodSecondHalfAnimation,
                    child: Text(
                      "Selected symptoms",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 35.0,
                    maxHeight: 165.0,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      // if you need this
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: [],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
