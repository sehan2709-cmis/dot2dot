class Question {
  final String text;
  final String typeA; // 첫 번째 특징 (예: A, 가, 1)
  final String typeB; // 두 번째 특징 (예: B, 나, 2)
  final int part; // 1, 2, 3

  Question({
    required this.text,
    required this.typeA,
    required this.typeB,
    required this.part,
  });
}

class Answer {
  final int questionIndex;
  final int score; // 1~5
  final String selectedType; // 선택된 타입

  Answer({
    required this.questionIndex,
    required this.score,
    required this.selectedType,
  });
}

class TestResult {
  final String part1Type; // A, B, C
  final String part2Type; // 가, 나, 다
  final String part3Type; // 1, 2, 3

  TestResult({
    required this.part1Type,
    required this.part2Type,
    required this.part3Type,
  });

  String get combinedType => '$part1Type$part2Type$part3Type';
}