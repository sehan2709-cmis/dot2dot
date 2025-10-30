import 'package:flutter/services.dart' show rootBundle;
import '../models/question.dart';

class QuestionService {
  static Future<List<Question>> loadQuestions() async {
    List<Question> questions = [];

    print('Starting to load questions...');

    // Part 1: A, B, C 비교
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part1_A_vs_B.txt', 'A', 'B', 1));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part1_B_vs_A.txt', 'B', 'A', 1));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part1_A_vs_C.txt', 'A', 'C', 1));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part1_C_vs_A.txt', 'C', 'A', 1));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part1_C_vs_B.txt', 'C', 'B', 1));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part1_B_vs_C.txt', 'B', 'C', 1));

    // Part 2: 가, 나, 다 비교
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part2_가_vs_나.txt', '가', '나', 2));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part2_나_vs_가.txt', '나', '가', 2));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part2_가_vs_다.txt', '가', '다', 2));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part2_다_vs_가.txt', '다', '가', 2));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part2_다_vs_나.txt', '다', '나', 2));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part2_나_vs_다.txt', '나', '다', 2));

    // Part 3: 1, 2, 3 비교
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part3_1_vs_2.txt', '1', '2', 3));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part3_2_vs_1.txt', '2', '1', 3));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part3_1_vs_3.txt', '1', '3', 3));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part3_3_vs_1.txt', '3', '1', 3));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part3_3_vs_2.txt', '3', '2', 3));
    questions.addAll(await _loadQuestionsFromFile('assets/questions/part3_2_vs_3.txt', '2', '3', 3));

    print('Total questions loaded: ${questions.length}');
    return questions;
  }

  static Future<List<Question>> _loadQuestionsFromFile(
    String path,
    String typeA,
    String typeB,
    int part,
  ) async {
    try {
      print('Loading questions from: $path');
      final content = await rootBundle.loadString(path);
      print('Successfully loaded $path');
      print('Content length: ${content.length}');
      
      final lines = content.split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
      
      print('Found ${lines.length} questions in $path');
      
      return lines.map((line) => Question(
        text: line.trim(),
        typeA: typeA,
        typeB: typeB,
        part: part,
      )).toList();
    } catch (e) {
      print('Error loading $path: $e');
      return [];
    }
  }

  static TestResult calculateResult(List<Answer> answers, List<Question> questions) {
    Map<String, double> scores = {
      'A': 0, 'B': 0, 'C': 0,
      '가': 0, '나': 0, '다': 0,
      '1': 0, '2': 0, '3': 0,
    };

    for (var answer in answers) {
      final question = questions[answer.questionIndex];
      
      // 점수 계산: 1~5 스케일을 -2~2로 변환
      // 1(매우 그렇지 않음) = -2, 3(보통) = 0, 5(매우 그렇음) = 2
      final normalizedScore = (answer.score - 3).toDouble();
      
      // typeA에 대한 점수
      scores[question.typeA] = (scores[question.typeA] ?? 0) + normalizedScore;
      // typeB에 대한 반대 점수
      scores[question.typeB] = (scores[question.typeB] ?? 0) - normalizedScore;
    }

    // Part 1 결과 (A, B, C)
    String part1 = _getMaxType(['A', 'B', 'C'], scores);
    
    // Part 2 결과 (가, 나, 다)
    String part2 = _getMaxType(['가', '나', '다'], scores);
    
    // Part 3 결과 (1, 2, 3)
    String part3 = _getMaxType(['1', '2', '3'], scores);

    return TestResult(
      part1Type: part1,
      part2Type: part2,
      part3Type: part3,
    );
  }

  static String _getMaxType(List<String> types, Map<String, double> scores) {
    String maxType = types[0];
    double maxScore = scores[maxType] ?? 0;

    for (var type in types) {
      if ((scores[type] ?? 0) > maxScore) {
        maxScore = scores[type] ?? 0;
        maxType = type;
      }
    }

    return maxType;
  }

  static Future<String> loadResult(String resultType) async {
    try {
      return await rootBundle.loadString('assets/results/$resultType.txt');
    } catch (e) {
      print('Error loading result $resultType: $e');
      return '결과를 불러오는데 실패했습니다.';
    }
  }
}