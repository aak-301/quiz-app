import 'package:flutter/material.dart';
import 'package:game/provider/game_provider.dart';
import 'package:game/screens/answer_screen.dart';
import 'package:provider/provider.dart';

import '../constants/theme.dart';
import '../widgets/question_indicator.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool isLoading = true;
  int chosenOption = -1;

  void loadData(GameProvider gameProvider) async {
    await gameProvider.parseJsonFile();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData(Provider.of<GameProvider>(context, listen: false));
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    GameProvider provider = Provider.of<GameProvider>(context);
    if (isLoading) {
      return const Scaffold(
        body: Center(child: Text("Loading...")),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.bgColor,
        title: Text(
          provider.title,
          style: const TextStyle(
            color: AppTheme.appbarColor,
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 20,
              child: QuestionIndicator(
                currentQuestion: provider.currentQuestion,
                totalQuestions: provider.totalQuestions,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              provider.question[provider.currentQuestion]['schema']['label'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: provider
                    .question[provider.currentQuestion]['schema']["options"]
                    .length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        chosenOption = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 9.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: chosenOption == index
                                    ? AppTheme.activeColor
                                    : AppTheme.disabledColor,
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 15,
                          ),
                          child: Row(
                            children: [
                              if (chosenOption != index)
                                Container(
                                  height: 12,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: AppTheme.disabledColor),
                                  ),
                                ),
                              if (chosenOption == index)
                                Container(
                                  height: 14,
                                  width: 14,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: AppTheme.activeColor),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: chosenOption == index
                                            ? AppTheme.activeColor
                                            : AppTheme.disabledColor,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 12),
                              Text(
                                provider.question[provider.currentQuestion]
                                    ['schema']["options"][index]["value"],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: chosenOption == index
                                      ? AppTheme.activeColor
                                      : const Color.fromARGB(255, 62, 61, 61),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    provider.saveResponse(isForward: false);
                    provider.changeQuestion(isForward: false);
                    if (provider.currentQuestion >= 0) {
                      setState(() {
                        chosenOption = provider.previousIndex;
                      });
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_left_outlined,
                        color: Colors.black,
                        size: 28,
                      ),
                      Text(
                        "Back",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    provider.saveResponse(
                      selectedOption:
                          provider.question[provider.currentQuestion]['schema']
                              ["options"][chosenOption]["value"],
                      index: chosenOption,
                    );
                    setState(() {
                      chosenOption = -1;
                    });
                    if (provider.currentQuestion ==
                        provider.totalQuestions - 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const AnswerScreen();
                          },
                        ),
                      );
                      return;
                    }
                    provider.changeQuestion();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppTheme.activeColor,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
