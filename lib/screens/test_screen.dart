import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/question_service.dart';
import 'result_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<Question> questions = [];
  List<Answer> answers = [];
  int currentQuestionIndex = 0;
  bool isLoading = true;
  int? selectedScore;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      print('TestScreen: Starting to load questions...');
      final loadedQuestions = await QuestionService.loadQuestions();
      print('TestScreen: Loaded ${loadedQuestions.length} questions');
      
      setState(() {
        questions = loadedQuestions;
        isLoading = false;
        if (questions.isNotEmpty) {
          answers = List.filled(questions.length, Answer(questionIndex: -1, score: 0, selectedType: ''));
        }
      });
    } catch (e) {
      print('TestScreen: Error loading questions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _answerQuestion(int score) {
    setState(() {
      selectedScore = score;
    });
  }

  void _nextQuestion() {
    if (selectedScore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('답변을 선택해주세요.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    final currentQuestion = questions[currentQuestionIndex];
    
    // 답변 저장
    answers[currentQuestionIndex] = Answer(
      questionIndex: currentQuestionIndex,
      score: selectedScore!,
      selectedType: selectedScore! >= 3 ? currentQuestion.typeA : currentQuestion.typeB,
    );

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedScore = answers[currentQuestionIndex].score > 0 
            ? answers[currentQuestionIndex].score 
            : null;
      });
    } else {
      _showResults();
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        selectedScore = answers[currentQuestionIndex].score > 0 
            ? answers[currentQuestionIndex].score 
            : null;
      });
    }
  }

  void _showResults() {
    final result = QuestionService.calculateResult(answers, questions);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dot2Dot 테스트'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  '질문을 불러오는데 실패했습니다.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'assets/questions/ 폴더에 질문 파일들이 있는지 확인해주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Flutter를 재시작하고 다시 시도해보세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('돌아가기'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    _loadQuestions();
                  },
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dot2Dot 테스트'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey[50],
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // 진행바
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6B4CE6)),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${currentQuestionIndex + 1} / ${questions.length}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // 질문 카드
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentQuestion.text,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),
                          
                          // 점수 선택 버튼
                          Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('매우 그렇지 않다', style: TextStyle(fontSize: 12)),
                                  Text('매우 그렇다', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(5, (index) {
                                  final score = index + 1;
                                  final isSelected = selectedScore == score;
                                  return GestureDetector(
                                    onTap: () => _answerQuestion(score),
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: isSelected 
                                            ? const Color(0xFF6B4CE6) 
                                            : Colors.white,
                                        border: Border.all(
                                          color: isSelected 
                                              ? const Color(0xFF6B4CE6) 
                                              : Colors.grey[300]!,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$score',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected 
                                                ? Colors.white 
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 네비게이션 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentQuestionIndex > 0)
                      OutlinedButton(
                        onPressed: _previousQuestion,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_back),
                            SizedBox(width: 8),
                            Text('이전'),
                          ],
                        ),
                      )
                    else
                      const SizedBox(),
                    
                    ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B4CE6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            currentQuestionIndex < questions.length - 1 
                                ? '다음' 
                                : '결과 보기'
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            currentQuestionIndex < questions.length - 1 
                                ? Icons.arrow_forward 
                                : Icons.check
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}