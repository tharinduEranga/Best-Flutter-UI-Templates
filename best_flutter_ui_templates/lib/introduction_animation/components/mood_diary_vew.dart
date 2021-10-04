import 'package:flutter/material.dart';

class MoodDiaryVew extends StatefulWidget {
  final AnimationController animationController;
  final String predictedDisease;

  const MoodDiaryVew(
      {Key? key,
      required this.animationController,
      required this.predictedDisease})
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
              SlideTransition(
                  position: _imageFirstHalfAnimation,
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 150,
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.purple.shade50, width: 2)),
                      child: DefaultTextStyle(
                        style: TextStyle(fontSize: 36, color: Colors.blue),
                        child: DefaultTextStyle(
                          style: TextStyle(color: Colors.green),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  widget.predictedDisease != ''
                                      ? widget.predictedDisease
                                      : 'No disease',
                                  style: TextStyle(
                                      color: Colors.red.shade300,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])),
              SizedBox(height: 75),
              SlideTransition(
                  position: _imageSecondHalfAnimation,
                  child: Text('Can`t trust our prediction?',
                      style: TextStyle(fontSize: 14))),
              SizedBox(height: 5),
              SlideTransition(
                position: _imageSecondHalfAnimation,
                child: ElevatedButton(
                  child: Text('Channel a general doctor',
                      style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(230, 198, 230, 5),
                      onPrimary: Colors.grey.shade800,
                      onSurface: Colors.grey,
                      fixedSize: Size(400, 50)),
                  onPressed: () {
                    print('Pressed');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
