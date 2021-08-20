import 'package:flutter/material.dart';


class Continent {

  const Continent({
    required this.name,
    required this.size,
  });

  final String name;
  final int size;

  @override
  String toString() {
    return '$name ($size)';
  }
}

const List<Continent> continentOptions = <Continent>[
  Continent(name: 'Africa', size: 30370000),
  Continent(name: 'Antarctica', size: 14000000),
  Continent(name: 'Asia', size: 44579000),
  Continent(name: 'Australia', size: 8600000),
  Continent(name: 'Europe', size: 10180000),
  Continent(name: 'North America', size: 24709000),
  Continent(name: 'South America', size: 17840000),
];


class RelaxView extends StatefulWidget {
  final AnimationController animationController;

  const RelaxView({Key? key, required this.animationController})
      : super(key: key);

  @override
  _RelaxViewState createState() => _RelaxViewState();
}

class _RelaxViewState extends State<RelaxView> {
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
              Padding(padding: EdgeInsets.all(50.0),),
              SlideTransition(
                position: _relaxAnimation,
                child: Text(
                  "Enter your symptoms",
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                ),
              ),
              SlideTransition(
                position: _imageAnimation,
                child: Autocomplete<Continent>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    return continentOptions
                        .where((Continent continent) => continent.name.toLowerCase()
                        .startsWith(textEditingValue.text.toLowerCase())
                    )
                        .toList();
                  },
                  displayStringForOption: (Continent option) => option.name,
                  fieldViewBuilder: (
                      BuildContext context,
                      TextEditingController fieldTextEditingController,
                      FocusNode fieldFocusNode,
                      VoidCallback onFieldSubmitted
                      ) {
                    return TextField(
                      controller: fieldTextEditingController,
                      focusNode: fieldFocusNode,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  },
                  onSelected: (Continent selection) {
                    print('Selected: ${selection.name}');
                  },
                  optionsViewBuilder: (
                      BuildContext context,
                      AutocompleteOnSelected<Continent> onSelected,
                      Iterable<Continent> options
                      ) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Material(
                        child: Container(
                          width: 300,
                          height: 200,
                          color: Colors.white,
                          child: ListView.builder(
                            padding: EdgeInsets.all(10.0),
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Continent option = options.elementAt(index);

                              return GestureDetector(
                                onTap: () {
                                  onSelected(option);
                                },
                                child: ListTile(
                                  title: Text(option.name,
                                      style: const TextStyle(color: Colors.black54)),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
