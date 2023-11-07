import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:trivia/data/box.dart';
import 'package:trivia/data/controllers.dart';
import 'package:trivia/models/dialogs/fail.dart';
import 'package:trivia/providers/money.dart';
import 'package:trivia/providers/profile.dart';
import 'package:trivia/providers/stage.dart';

class QuestionProvider extends ChangeNotifier {
  Map data = {};
  List questions = [];
  int questionIndex = 0;
  int currentLevel = 1;
  int correctAnswers = box.get("correctAnswers", defaultValue: 0);
  int totalQuestionsAnswered =
      box.get("totalQuestionsAnswered", defaultValue: 0);
  double leaderboardScore = box.get("leaderboardScore", defaultValue: 0.0);
  double averageTime = box.get("averageTime", defaultValue: 0.0);

  String question = "", title = "";

  List options = [];
  bool questionIsShuffled = false;
  bool autoAnswer = box.get("autoAnswer", defaultValue: false);

  void initQuestionProvider(context) {
    questions = data["data"];
    questionIndex = data["currentIndex"];
    // currentLevel = data["currentLevel"];
    // currentLevel = box.get(data["title"])["currentLevel"];

    /* if (!questionIsShuffled) {
      questions.shuffle();
      questionIsShuffled = true;
    } */

    if (questionIndex >= questions.length) {
      questionIndex = 0;
      data["currentIndex"] = questionIndex;
      for (var i = 0; i < 10; i++) {
        questions.shuffle();
      }

      data["data"] = questions;
      box.put(data["title"], data);
    }

    question = questions[questionIndex]["question"];
    options = questions[questionIndex]["options"];
    options.shuffle();

    notifyListeners();
  }

  void onExhaustedQuestions(context) {
    questionIndex = 0;
    data["currentIndex"] = questionIndex;
    for (var i = 0; i < 10; i++) {
      questions.shuffle();
    }

    data["data"] = questions;
    box.put(data["title"], data);

    notifyListeners();
  }

  void resetOptions() {
    for (var option in options) {
      option["color"] = "yellow";
    }
  }

  incrementLevel() {
    currentLevel = currentLevel + 1;
    data["currentLevel"] = currentLevel;
    box.put(data["title"], data);
    // debugPrint(data["title"]);

    notifyListeners();
  }

  toggleAutoAnswer(bool value) {
    autoAnswer = value;
    box.put("autoAnswer", value);
    notifyListeners();
  }

  updateLeaderBoardScore(BuildContext context) {
    final moneyProvider = Provider.of<MoneyProvider>(context, listen: false);

    leaderboardScore = (correctAnswers / totalQuestionsAnswered) *
        moneyProvider.coins /
        averageTime;
    if (totalQuestionsAnswered == 0) leaderboardScore = 0;

    box.put("leaderboardScore", leaderboardScore);

    debugPrint("Leaderboard score: $leaderboardScore");

    notifyListeners();
  }

  void checkCorrectAnswer(BuildContext context, int index,
      {bool? answered, String? timeElapsed}) {
    answered ?? false;

    if (index == -1) {
      showFailedDialog(context, questionIndex, true);
      notifyListeners();
      return;
    }

    if (!answered!) {
      if (options[index]["value"] == true) {
        options[index]["color"] = "right";
        correctAnswers = correctAnswers + 1;
        box.put("correctAnswers", correctAnswers);
        debugPrint("Correct Answers: $correctAnswers");

        averageTime = ((averageTime * (correctAnswers - 1)) +
                (30 - double.parse(timeElapsed ?? "1"))) /
            correctAnswers;
        box.put("averageTime", averageTime);
        debugPrint("Average Answering Time: $averageTime");
      } else {
        options[index]["color"] = "wrong";

        for (var option in options) {
          if (option["value"] == true) {
            option["color"] = "right";
          }
        }
      }

      totalQuestionsAnswered = totalQuestionsAnswered + 1;
      box.put("totalQuestionsAnswered", totalQuestionsAnswered);
      debugPrint("Total Questions Answered: $totalQuestionsAnswered");

      updateLeaderBoardScore(context);

      final stageProvider = Provider.of<StageProvider>(context, listen: false);

      Future.delayed(
          (options[index]["value"] == true) ? 3.seconds : 1.5.seconds, () {
        if (options[index]["value"] == true) {
          Provider.of<MoneyProvider>(context, listen: false)
              .updateReward(int.parse(countDownController.getTime()!));
          stageProvider.incrementCompletedStage();

          if (stageProvider.completedStage == 3) {
            Navigator.pushNamedAndRemoveUntil(
                context, "/reward", (route) => false);
            Future.delayed(2.seconds, () {
              stageProvider.resetCompletedStage();
            });
          } else {
            if (autoAnswer) {
              Navigator.pushReplacementNamed(context, "/game");
            } else {
              Navigator.pushReplacementNamed(context, "/stage");
            }
          }
        } else {
          showFailedDialog(context, questionIndex, false);
        }

        questionIndex = questionIndex + 1;
        data["currentIndex"] = questionIndex;

        resetOptions();
      });

      Future.delayed(.2.seconds, () {
        final profileProvider =
            Provider.of<ProfileProvider>(context, listen: false);
        if (profileProvider.hasProfile) {
          profileProvider.updatePlayer(context);
        }
        notifyListeners();
      });
    }
  }
}
