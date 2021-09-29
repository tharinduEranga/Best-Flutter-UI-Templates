import 'dart:math';

import 'package:best_flutter_ui_templates/service/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../introduction_animation_screen.dart';

class RelaxView extends StatefulWidget {
  final List<ListTile> addedSymptomsViewList;

  final AnimationController animationController;
  final Function(SymptomDTO, ListTile, int) callback;

  const RelaxView({
    Key? key,
    required this.animationController,
    required this.addedSymptomsViewList,
    required this.callback,
  }) : super(key: key);

  @override
  _RelaxViewState createState() => _RelaxViewState();
}

class _RelaxViewState extends State<RelaxView> {
  var symptomsSearchPlaceHolder = 'What`s going on your body?';

  List<ListTile> addedSymptomsViewList = [];

  @override
  Widget build(BuildContext context) {
    addedSymptomsViewList = widget.addedSymptomsViewList.toList();

    final _firstHalfAnimation =
        Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          0.0,
          0.2,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final _secondHalfAnimation =
    Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0)).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          0.2,
          0.4,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final _textAnimation =
    Tween<Offset>(begin: Offset(0, 0), end: Offset(-2, 0)).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          0.2,
          0.4,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final _imageAnimation =
    Tween<Offset>(begin: Offset(0, 0), end: Offset(-4, 0)).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          0.2,
          0.4,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final _relaxAnimation =
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
                position: _relaxAnimation,
                child: Text(
                  "Enter your symptoms",
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
              ),
              SlideTransition(
                position: _imageAnimation,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        autofocus: true,
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontStyle: FontStyle.italic),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: symptomsSearchPlaceHolder),
                      ),
                      suggestionsCallback: (pattern) async {
                        return await SymptomsService.searchSymptoms(pattern);
                      },
                      itemBuilder: (context, Map<String, String> suggestion) {
                        return ListTile(
                            title: Text(suggestion['name']!));
                      },
                      onSuggestionSelected: (Map<String, String> suggestion) {
                        // your implementation here
                        addSymptomToSelections(suggestion);
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 150), // give it height
              Column(
                children: [
                  SlideTransition(
                    position: _relaxAnimation,
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
                      children: addedSymptomsViewList,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void addSymptomToSelections(Map<String, String> suggestion) {
    setState(() {
      var symptomDTO = new SymptomDTO(
          int.parse(suggestion.entries.elementAt(0).value),
          suggestion.entries.elementAt(1).value,
          int.parse(suggestion.entries.elementAt(2).value));

      symptomsSearchPlaceHolder = symptomDTO.name;
      var newSymptomsList = addedSymptomsViewList.map((e) => e).toList();
      var newSymptomWidget = ListTile(
          title: Text(symptomDTO.name),
          trailing: IconButton(
            key: new Key(symptomDTO.id.toString()),
            icon: new Icon(
              Icons.delete,
              color: Color(0xff486579),
              size: 35.0,
            ),
            onPressed: () {
              removeSymptomFromSelections(symptomDTO);
            },
          ));
      newSymptomsList.add(newSymptomWidget);
      addedSymptomsViewList = newSymptomsList;
      widget.callback(symptomDTO, newSymptomWidget, -1);
    });
  }

  void removeSymptomFromSelections(SymptomDTO symptomDTO) {
    setState(() {
      ListTile removingWidget = new ListTile();
      var newSymptomsList = addedSymptomsViewList
          .where((element) {
            removingWidget = element;
            return element.trailing!.key != new Key(symptomDTO.id.toString());
          })
          .map((e) => e)
          .toList();
      addedSymptomsViewList = newSymptomsList;
      widget.callback(symptomDTO, removingWidget, symptomDTO.id);
    });
  }
}
