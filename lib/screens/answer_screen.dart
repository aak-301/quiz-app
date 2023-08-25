import 'package:flutter/material.dart';
import 'package:game/constants/theme.dart';
import 'package:game/provider/game_provider.dart';
import 'package:provider/provider.dart';

class AnswerScreen extends StatelessWidget {
  const AnswerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GameProvider provider = Provider.of(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        provider.reset();
        Navigator.of(context).popUntil((route) => route.isFirst);
        return await true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.bgColor,
          title: const Text(
            "Answers",
            style: TextStyle(
              color: AppTheme.appbarColor,
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: provider.question.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Q${index + 1}. ${provider.question[provider.currentQuestion]['schema']['label']}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Answer: ${provider.answer[index].keys}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 2,
                            width: double.infinity,
                            color: AppTheme.answerSpacerColor,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  provider.reset();
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.btnColor, width: 3),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Play Again",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.btnTextColor),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
