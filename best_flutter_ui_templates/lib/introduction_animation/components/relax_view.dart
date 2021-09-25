import 'dart:math';

import 'package:best_flutter_ui_templates/service/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class RelaxView extends StatefulWidget {
  final AnimationController animationController;

  const RelaxView({Key? key, required this.animationController})
      : super(key: key);

  @override
  _RelaxViewState createState() => _RelaxViewState();
}

class _RelaxViewState extends State<RelaxView> {
  var symptomsSearchPlaceHolder = 'What`s going on your body?';

  List<Widget> addedSymptomsList = <Widget>[];

  @override
  Widget build(BuildContext context) {
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
                        return await BackendService.getSuggestions(pattern);
                      },
                      itemBuilder: (context, Map<String, String> suggestion) {
                        return ListTile(
                          title: Text(suggestion['name']!),
                          subtitle: Text('${suggestion['score']}'),
                        );
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
                      children: addedSymptomsList,
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
      symptomsSearchPlaceHolder = suggestion.entries.first.value;
      var newSymptomsList = addedSymptomsList.map((e) => e).toList();

      newSymptomsList.add(ListTile(
          title: Text(suggestion.entries.first.value),
          trailing: IconButton(
            key: new Key(suggestion.entries.first.value),
            icon: new Icon(
              Icons.delete,
              color: Color(0xff486579),
              size: 35.0,
            ),
            onPressed: () {
              removeSymptomFromSelections(suggestion.entries.first.value);
            },
          )));
      addedSymptomsList = newSymptomsList;
    });
  }

  void removeSymptomFromSelections(String symptomId) {
    setState(() {
      var newSymptomsList = addedSymptomsList
          .where((element) {
            var listTitle = element as ListTile;
            return listTitle.trailing!.key != new Key(symptomId);
          })
          .map((e) => e)
          .toList();
      addedSymptomsList = newSymptomsList;
    });
  }
}
