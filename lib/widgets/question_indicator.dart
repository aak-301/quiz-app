import 'package:flutter/material.dart';
import 'package:game/constants/theme.dart';

class QuestionIndicator extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  const QuestionIndicator(
      {super.key, this.currentQuestion = 0, this.totalQuestions = 1});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: totalQuestions,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Container(
              height: 5,
              width: 90,
              decoration: BoxDecoration(
                  color: index <= currentQuestion
                      ? AppTheme.progressColor
                      : AppTheme.disabledColor,
                  borderRadius: BorderRadius.circular(10)),
            ),
            Container(
              height: 5,
              width: 6,
              color: Colors.white,
            )
          ],
        );
      },
    );
  }
}
