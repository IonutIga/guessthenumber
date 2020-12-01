import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static Random rand = Random();
  final TextEditingController _controller = TextEditingController();
  int numberToBeGuessed = rand.nextInt(100) + 1;
  String error;
  bool isVisibleGuess = true;
  bool isVisibleTryText = false;
  String tryText = '';
  int number;
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    print(numberToBeGuessed);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess the number'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'I am thinking of a number between 1 and 100. Try to guess it!',
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                child: Text(
                  tryText,
                  style: const TextStyle(fontSize: 20, color: Colors.pink),
                ),
                visible: isVisibleTryText,
              ),
            ),
            Card(
              elevation: 10,
              child: Column(
                children: <Widget>[
                  const Text(
                    // ignore: unnecessary_parenthesis
                    ('Try a number!'),
                    style: TextStyle(fontSize: 28),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _controller,
                      enabled: isEnabled,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'Insert a number', errorText: error),
                      onChanged: (String value) {
                        setState(() {
                          if (value.isEmpty)
                            number = null;
                          if (int.tryParse(value) != null) {
                            number = int.tryParse(value);
                            error = null;
                          } else if (value.isNotEmpty) {
                            error = 'Only integer values allowed!';
                            number = null;
                          }
                        });
                      },
                    ),
                  ),
                  Visibility(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: RaisedButton(
                          child: const Text(
                            'Guess',
                            style: TextStyle(fontSize: 16),
                          ),
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () {
                            setState(
                              () {
                                if (number != null &&
                                    number > 0 &&
                                    number < 101) {
                                  isVisibleTryText = true;
                                  if (number > numberToBeGuessed)
                                    tryText = 'You guessed ' +
                                        number.toString() +
                                        '. Try lower!';
                                  else if (number < numberToBeGuessed)
                                    tryText = 'You guessed ' +
                                        number.toString() +
                                        '. Try higher!';
                                  else {
                                    tryText = 'You guessed right! It was ' +
                                        numberToBeGuessed.toString();
                                    showDialog<AlertDialog>(
                                      context: context,
                                      child: AlertDialog(
                                        title: const Text('You guessed right!'),
                                        content: Text('It was ' +
                                            numberToBeGuessed.toString() +
                                            '!'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text(
                                              'Try again!',
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                numberToBeGuessed =
                                                    rand.nextInt(100) + 1;
                                                tryText = '';
                                                _controller.clear();
                                                Navigator.of(context).pop();
                                              });
                                            },
                                          ),
                                          TextButton(
                                            child: const Text(
                                              'OK',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                isVisibleGuess = false;
                                                tryText = '';
                                                isEnabled = false;
                                                _controller.clear();
                                                Navigator.of(context).pop();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      barrierDismissible: true,
                                    );
                                  }
                                } else {
                                  tryText = '';
                                  error = 'Only numbers between 1 and 100!';
                                }
                              },
                            );
                          }),
                    ),
                    visible: isVisibleGuess,
                  ),
                  Visibility(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: RaisedButton(
                        child: const Text(
                          'Reset',
                          style: TextStyle(fontSize: 16),
                        ),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            isVisibleGuess = true;
                            isEnabled = true;
                            numberToBeGuessed = rand.nextInt(100) + 1;
                          });
                        },
                      ),
                    ),
                    visible: !isVisibleGuess,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
