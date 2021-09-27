import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../introduction_animation_screen.dart';

class CareView extends StatefulWidget {
  final List<SymptomDTO> selectedSymptoms;
  final List<SymptomDTO> similarSymptoms;

  final AnimationController animationController;

  const CareView(
      {Key? key,
      required this.animationController,
      required this.selectedSymptoms,
      required this.similarSymptoms})
      : super(key: key);

  @override
  _CareViewState createState() => _CareViewState();
}

class _CareViewState extends State<CareView> {

  @override
  Widget build(BuildContext context) {
    final _firstHalfAnimation =
        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.2,
        0.4,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final _secondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.4,
        0.6,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final _relaxFirstHalfAnimation =
    Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.2,
        0.4,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final _relaxSecondHalfAnimation =
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
        0.2,
        0.4,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final _imageAnimation =
    Tween<Offset>(begin: Offset(0, 0), end: Offset(-4, 0))
        .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.4,
        0.6,
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
                position: _relaxFirstHalfAnimation,
                child: SlideTransition(
                  position: _relaxSecondHalfAnimation,
                  child: Text(
                    "Similar symptoms",
                    style:
                    TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SlideTransition(
                  position: _imageAnimation,
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.purple.shade50, width: 2)),
                      child: MultiSelectChipDisplay(
                        chipColor: Color.fromRGBO(130, 73, 186, 75),
                        textStyle: TextStyle(color: Colors.white),
                        items: widget.similarSymptoms
                            .map((e) => MultiSelectItem(e.id, e.name))
                            .toList(),
                        onTap: (values) {
                          print(values);
                        },
                        height: 150,
                        scroll: true,
                        scrollBar: HorizontalScrollBar(isAlwaysShown: true),
                      ),
                    ),
                  ])),
              SizedBox(height: 50),
              Column(
                children: [
                  SlideTransition(
                    position: _relaxSecondHalfAnimation,
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
