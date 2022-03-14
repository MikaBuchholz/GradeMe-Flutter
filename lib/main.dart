import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

const int maxGrades = 20;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Proxima Nova",
        colorScheme: const ColorScheme.light(),
      ),
      home: const MyHomePage(title: 'GradeMe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<GradeEntity> _grades = [];
  final TextEditingController _controller = TextEditingController();
  bool _isChecked = false;
  int lkCounter = 0;
  bool _gradeMode = false;
  int initalIndex = 1;
  bool showSnackBar = false;
  bool snackSwitch = false;

  final Map<int, double> _gradesMap = {
    15: 1.0,
    14: 1.0,
    13: 1.3,
    12: 1.7,
    11: 2.0,
    10: 2.3,
    9: 2.7,
    8: 3.0,
    7: 3.3,
    6: 3.7,
    5: 4.0,
    4: 4.3,
    3: 4.6,
    2: 5.0,
    1: 5.3,
    0: 6.0,
  };

  final Map<String, double> _reverseGradeMap = {
    "1+": 15.0,
    "1": 14.0,
    "1-": 13.0,
    "2+": 12.0,
    "2": 11.0,
    "2-": 10.0,
    "3+": 9.0,
    "3": 8.0,
    "3-": 7.0,
    "4+": 6.0,
    "4": 5.0,
    "4-": 4.0,
    "5+": 3.0,
    "5": 2.0,
    "5-": 1.0,
    "6": 0.0,
  };

  final List<String> validGrades = [
    "1+",
    "1",
    "1-",
    "2+",
    "2",
    "2-",
    "3+",
    "3",
    "3-",
    "4+",
    "4",
    "4-",
    "5+",
    "5",
    "5-",
    "6",
  ];

  void addGrade(int grade, bool isLK, String? stringGrade) {
    if (_grades.length <= maxGrades - 1) {
      if (isLK) {
        lkCounter++;
      }

      if (_gradeMode) {
        if (grade >= 0 && grade <= 15) {
          setState(() {
            _grades.add(GradeEntity(
                grade, _gradesMap[grade]!, isLK, isLK ? 2 : 1, null));
          });

          if (showSnackBar) {
            Flushbar(
              title: "Punkt hinzugefügt",
              message: "Punkt $grade hinzugefügt",
              duration: const Duration(seconds: 2),
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              shouldIconPulse: false,
              margin: const EdgeInsets.all(30),
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.green,
              flushbarPosition: FlushbarPosition.TOP,
            ).show(context);
          }
        } else {
          if (showSnackBar) {
            Flushbar(
              title: "Fehler",
              message: "Punkte müssen zwischen 0 und 15 liegen!",
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.pink,
              margin: const EdgeInsets.all(30),
              borderRadius: BorderRadius.circular(10),
              flushbarPosition: FlushbarPosition.TOP,
            ).show(context);
          }
        }
      }

      if (!_gradeMode) {
        if (validGrades.contains(stringGrade)) {
          setState(() {
            _grades.add(GradeEntity(
                _reverseGradeMap[stringGrade]!,
                _gradesMap[_reverseGradeMap[stringGrade]]!.toDouble(),
                isLK,
                isLK ? 2 : 1,
                stringGrade));
          });

          if (showSnackBar) {
            if (showSnackBar) {
              Flushbar(
                title: "Note hinzugefügt",
                message: "Note $stringGrade hinzugefügt",
                duration: const Duration(seconds: 2),
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                shouldIconPulse: false,
                margin: const EdgeInsets.all(30),
                borderRadius: BorderRadius.circular(10),
                backgroundColor: Colors.green,
                flushbarPosition: FlushbarPosition.TOP,
                isDismissible: true,
              ).show(context);
            }
          }
        } else {
          if (showSnackBar) {
            Flushbar(
              title: "Fehler",
              message: "Noten müssen zwischen 1 und 6 liegen!",
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.pink,
              margin: const EdgeInsets.all(30),
              icon: const Icon(
                Icons.error,
                color: Colors.white,
              ),
              shouldIconPulse: false,
              borderRadius: BorderRadius.circular(10),
              flushbarPosition: FlushbarPosition.TOP,
            ).show(context);
          }
        }
      }
    } else {
      if (showSnackBar) {
        Flushbar(
          title: "Fehler",
          message: "Maximal 20 Noten erlaubt!",
          duration: const Duration(seconds: 2),
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ),
          shouldIconPulse: false,
          borderRadius: BorderRadius.circular(10),
          margin: const EdgeInsets.all(30),
          backgroundColor: Colors.pink,
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
      }
    }
  }

  void removeGrade(int position) {
    if (showSnackBar) {
      Flushbar(
        title: !_gradeMode ? "Note entfernt" : "Punkt entfernt",
        message: !_gradeMode
            ? "Note ${_grades[position].stringGrade} wurde entfernt"
            : "${_grades[position].grade} Punkte wurden entfernt",
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(30),
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        shouldIconPulse: false,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Colors.lightBlue,
      ).show(context);
    }

    if (_grades[position].isLK) {
      lkCounter--;
    }
    setState(() {
      _grades.removeAt(position);
    });
  }

  void setChecked(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void setGradeMode(bool value) {
    if (showSnackBar) {
      Flushbar(
        title: _gradeMode ? "Notenmodus" : "Punktemodus",
        message: _gradeMode
            ? "Notenmodus wurde aktiviert"
            : "Punktmodus wurde aktiviert",
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(30),
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        shouldIconPulse: false,
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Colors.green,
        flushbarPosition: FlushbarPosition.TOP,
      ).show(context);
    }
    setState(() {
      _gradeMode = value;
    });
  }

  /// [Points, Grades]
  List<num> calculateAverage() {
    if (_grades.isEmpty) {
      return [0, 0];
    }

    num totalPoints = 0;
    num totalGrades = 0;

    for (int i = 0; i < _grades.length; i++) {
      totalPoints += _grades[i].grade * _grades[i].pointMulitplier;
      totalGrades += _grades[i].points * _grades[i].pointMulitplier;
    }

    final num pointAverage = totalPoints / (_grades.length + lkCounter);
    final num gradeAverage = totalGrades / (_grades.length + lkCounter);

    return [pointAverage, gradeAverage];
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          initalIndex = 5;
        });
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          bottomNavigationBar: AnimatedBottomNavigationBar(
            icons: const [
              Icons.settings,
              Icons.delete,
            ],
            backgroundColor: Colors.primaries[3],
            activeIndex: initalIndex,
            inactiveColor: const Color.fromARGB(255, 192, 191, 191),
            activeColor: Colors.white,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.smoothEdge,
            leftCornerRadius: 4,
            rightCornerRadius: 4,
            elevation: 20,
            onTap: (int i) {
              setState(() {
                initalIndex = i;
              });

              if (i == 0) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 16,
                        child: StatefulBuilder(builder: (context, setState) {
                          return SizedBox(
                            height: height * 0.35,
                            width: width * 0.2,
                            child: Column(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.only(top: 10, bottom: 5),
                                  child: Text(
                                    "Einstellungen",
                                    style: TextStyle(
                                        fontSize: height * 0.02,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            18, 15, 18, 15),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 115, 43, 182),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "LK",
                                          style: TextStyle(
                                              fontSize: height * 0.03,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            18, 15, 18, 15),
                                        child: Text(
                                          "GK",
                                          style: TextStyle(
                                              fontSize: height * 0.03,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 45),
                                  child: Row(
                                    children: [
                                      const Text("Hinweis nachrichten"),
                                      Container(
                                        margin: const EdgeInsets.only(left: 25),
                                        width: width * 0.11,
                                        child: Text(
                                          ' ${showSnackBar ? "An " : "Aus"}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Switch(
                                          value: snackSwitch,
                                          onChanged: (value) {
                                            setState(() {
                                              snackSwitch = value;
                                              showSnackBar = value;
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      const Text("Modus "),
                                      Container(
                                        width: width * 0.13,
                                        margin: const EdgeInsets.only(left: 97),
                                        child: Text(
                                            _gradeMode ? 'Punkte' : 'Noten ',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Switch(
                                          value: _gradeMode,
                                          onChanged: (value) {
                                            setGradeMode(value);
                                            _grades.clear();
                                            _controller.clear();
                                            setChecked(false);
                                            setState(() {
                                              _gradeMode = value;
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    }).then((value) {
                  setState(() {
                    initalIndex = 5;
                  });
                });
              }
              if (i == 1) {
                setState(() {
                  _grades.clear();
                  lkCounter = 0;
                  _controller.clear();

                  if (showSnackBar) {
                    Flushbar(
                      message: "Eingaben gelöscht",
                      duration: const Duration(seconds: 2),
                      margin: const EdgeInsets.all(30),
                      icon: const Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                      shouldIconPulse: false,
                      flushbarPosition: FlushbarPosition.TOP,
                      borderRadius: BorderRadius.circular(10),
                      backgroundColor: Colors.lightBlue,
                    ).show(context);
                  }
                });
              }
            },
          ),
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
            toolbarHeight: height * 0.09,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Text(widget.title)),
                const Icon(Icons.calculate)
              ],
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                MyInput(
                  addGrades: addGrade,
                  isChecked: _isChecked,
                  setChecked: setChecked,
                  controller: _controller,
                  gradeMode: _gradeMode,
                ),
                DataDisplay(
                    calculateAverage: calculateAverage,
                    gradeLength: _grades.length),
                MyGrid(grades: _grades, removeGrade: removeGrade)
              ],
            ),
          )
          // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }
}

class GradeEntity {
  final num grade;
  final num points;
  final bool isLK;
  final int pointMulitplier;
  final String? stringGrade;

  GradeEntity(this.grade, this.points, this.isLK, this.pointMulitplier,
      this.stringGrade);
}

class MyInput extends StatelessWidget {
  const MyInput({
    Key? key,
    required this.addGrades,
    required this.isChecked,
    required this.setChecked,
    required this.controller,
    required this.gradeMode,
  }) : super(key: key);

  final void Function(int, bool, String?) addGrades;
  final bool isChecked;

  final void Function(bool) setChecked;

  final TextEditingController controller;

  final bool gradeMode;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: width * 0.4,
              child: TextField(
                keyboardType:
                    !gradeMode ? TextInputType.phone : TextInputType.number,
                onEditingComplete: () {},
                decoration: InputDecoration(
                  labelText: gradeMode ? "Punkte" : "Note",
                  hintText: "Eingabe",
                  border: const OutlineInputBorder(),
                ),
                controller: controller,
                onSubmitted: (value) {
                  if (!gradeMode) {
                    addGrades(0, isChecked, value);
                    controller.clear();
                  } else {
                    final parsedValue = int.tryParse(value);

                    if (parsedValue != null) {
                      addGrades(parsedValue, isChecked, null);
                      controller.clear();
                      setChecked(false);
                    }
                  }
                },
              )),
          SizedBox(
            width: width * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    value: isChecked,
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return const Color.fromARGB(255, 115, 43, 182);
                      } else {
                        return Colors.grey;
                      }
                    }),
                    onChanged: (isChek) {
                      setChecked(isChek!);
                    }),
                const Text("LK", style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyGrid extends StatefulWidget {
  const MyGrid({Key? key, required this.grades, required this.removeGrade})
      : super(key: key);

  final List<GradeEntity> grades;
  final void Function(int) removeGrade;

  @override
  State<MyGrid> createState() => _MyGridState();
}

class _MyGridState extends State<MyGrid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 9,
            runSpacing: 9,
            children: widget.grades
                .map((grade) => Tooltip(
                      message: "",
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: grade.isLK
                                ? const Color.fromARGB(255, 115, 43, 182)
                                : Colors.blue,
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          ),
                          onPressed: () {
                            widget.removeGrade(widget.grades.indexOf(grade));
                          },
                          child: Text(grade.stringGrade != null
                              ? grade.stringGrade!
                              : grade.grade.toString())),
                    ))
                .toList()),
      ),
    );
  }
}

class DataDisplay extends StatelessWidget {
  DataDisplay(
      {Key? key, required this.calculateAverage, required this.gradeLength})
      : super(key: key);

  final List<num> Function() calculateAverage;
  final int gradeLength;
  num greatest = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final average = calculateAverage();
    final averagePoints = average[0];
    final averageGrades = average[1];

    return SizedBox(
      height: height * 0.2,
      width: width * 0.8,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        SizedBox(
          child: CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 8.0,
            percent: (6 - averageGrades) / 5 > 1 ? 0 : (6 - averageGrades) / 5,
            header: const Text(
              "Noten",
              style: TextStyle(fontSize: 14),
            ),
            center: AnimatedFlipCounter(
              value: averageGrades,
              fractionDigits: 1, // decimal precision
              duration: const Duration(milliseconds: 500),
              textStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
            progressColor: Colors.lightBlue,
          ),
        ),
        SizedBox(
          child: CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 8.0,
            percent: gradeLength / maxGrades,
            header: const Text(
              "Anzahl",
              style: TextStyle(fontSize: 14),
            ),
            center: AnimatedFlipCounter(
              value: gradeLength,
              fractionDigits: 0, // decimal precision
              duration: const Duration(milliseconds: 500),
              textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            progressColor: Colors.purple,
          ),
        ),
        SizedBox(
          child: CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 8.0,
            percent: averagePoints / 15 > 1 ? 1 : averagePoints / 15,
            header: const Text(
              "Punkte",
              style: TextStyle(fontSize: 14),
            ),
            center: AnimatedFlipCounter(
              value: averagePoints,
              fractionDigits: 1, // decimal precision
              duration: const Duration(milliseconds: 500),
              textStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
            progressColor: Colors.green,
          ),
        ),
      ]),
    );
  }
}
