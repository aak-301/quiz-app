import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameProvider with ChangeNotifier {
  // variable declaration

  List question = [];
  List<Map<String, int>> answer = [];
  String title = "";
  int currentQuestion = 0;
  int totalQuestions = 0;
  int previousIndex = -1;

  Future<void> parseJsonFile() async {
    /*
      1. When the app starts this function is called and it stores the question.
      2. Since the JSON had some nested questions that is why there are two nested for loops.
      3. Once we get the decoded json file, we get the questions, title, and totalQuestions.
    */
    final String response =
        await rootBundle.loadString('assets/Questions.json');
    final data = await json.decode(response);

    for (int i = 0; i < data["schema"]["fields"].length; i++) {
      if (data["schema"]["fields"][i]["schema"]['fields'] != null) {
        for (int j = 0;
            j < data["schema"]["fields"][i]["schema"]['fields'].length;
            j++) {
          question.add(data["schema"]["fields"][i]["schema"]['fields'][j]);
        }
      } else {
        question.add(data["schema"]["fields"][i]);
      }
    }
    title = data["title"];
    totalQuestions = question.length;
    notifyListeners();
  }

  void changeQuestion({bool isForward = true}) {
    /*
      when moving to next question the isForward is true => currentQuestion+1
      when moving to prev question the isForward is false => currentQuestion-1
    */
    if (isForward) {
      if (currentQuestion < totalQuestions) {
        currentQuestion++;
      }
    } else {
      if (currentQuestion > 0) {
        currentQuestion--;
      }
    }
    notifyListeners();
  }

  void saveResponse({
    String selectedOption = "",
    int index = -1,
    bool isForward = true,
  }) {
    /*
      1. Answer array stores the {chosenOption,chosenOption_index},
      2. It is because when we move to previous question then,
        we want to see what was the chosen option of previous question,
        which is stored in previousIndex varable.
    */
    if (isForward) {
      if (currentQuestion < totalQuestions) {
        Map<String, int> option = {selectedOption: index};
        answer.add(option);
      }
    } else {
      if (currentQuestion > 0) {
        Map<String, int> last = answer.last;
        last.forEach((key, value) => previousIndex = value);
        answer.removeLast();
      }
    }
  }

  void reset() {
    /*
      When we press back button after viewing our answer or,
      when we click on play again then we will have to reset the system(all variables),
      except questions array
    */
    answer.clear();
    currentQuestion = 0;
    previousIndex = -1;
    notifyListeners();
  }
}
