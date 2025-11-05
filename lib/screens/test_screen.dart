import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/question_service.dart';
import 'result_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> with TickerProviderStateMixin {
  List<Question> questions = [];
  List<Answer> answers = [];
  int currentPageIndex = 0;
  bool isLoading = true;
  
  static const int questionsPerPage = 12;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _loadQuestions();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
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
      
      _fadeController.forward();
    } catch (e) {
      print('TestScreen: Error loading questions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  int get totalPages => (questions.length / questionsPerPage).ceil();
  
  List<Question> get currentPageQuestions {
    final startIndex = currentPageIndex * questionsPerPage;
    final endIndex = (startIndex + questionsPerPage).clamp(0, questions.length);
    return questions.sublist(startIndex, endIndex);
  }
  
  List<int> get currentPageQuestionIndices {
    final startIndex = currentPageIndex * questionsPerPage;
    final endIndex = (startIndex + questionsPerPage).clamp(0, questions.length);
    return List.generate(endIndex - startIndex, (i) => startIndex + i);
  }

  bool get isCurrentPageComplete {
    return currentPageQuestionIndices.every((index) => answers[index].score > 0);
  }

  void _answerQuestion(int questionIndex, int score) {
    setState(() {
      final question = questions[questionIndex];
      answers[questionIndex] = Answer(
        questionIndex: questionIndex,
        score: score,
        selectedType: score >= 3 ? question.typeA : question.typeB,
      );
    });
  }

  void _nextPage() {
    if (!isCurrentPageComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('모든 질문에 답변해주세요.'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (currentPageIndex < totalPages - 1) {
      _fadeController.reset();
      setState(() {
        currentPageIndex++;
      });
      _fadeController.forward();
      
      // 스크롤을 최상단으로 이동
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      _showResults();
    }
  }

  void _previousPage() {
    if (currentPageIndex > 0) {
      _fadeController.reset();
      setState(() {
        currentPageIndex--;
      });
      _fadeController.forward();
      
      // 스크롤을 최상단으로 이동
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
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
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[800]!),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '질문을 불러오는 중...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[600]),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                  ),
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
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[800],
                  ),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final answeredCount = answers.where((a) => a.score > 0).length;
    final progress = answeredCount / questions.length; // 전체 답변 완료 비율

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // 진행바
                _buildProgressBar(progress, answeredCount),
                
                const SizedBox(height: 32),
                
                // 질문 카드들
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          ...currentPageQuestionIndices.asMap().entries.map((entry) {
                            final localIndex = entry.key;
                            final globalIndex = entry.value;
                            return _buildQuestionCard(
                              questions[globalIndex],
                              globalIndex,
                              localIndex,
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 네비게이션 버튼
                _buildNavigationButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, int answeredCount) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            // 실제 진행바의 최대 너비 계산
            final maxBarWidth = constraints.maxWidth;
            
            return Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 6,
                  width: maxBarWidth * progress,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '페이지 ${currentPageIndex + 1} / $totalPages',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '답변 완료: $answeredCount / ${questions.length}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Question question, int globalIndex, int localIndex) {
    final answer = answers[globalIndex];
    final isAnswered = answer.score > 0;

    return AnimatedScale(
      scale: isAnswered ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        margin: EdgeInsets.only(
          bottom: localIndex < currentPageQuestions.length - 1 ? 20 : 0,
        ),
        child: Card(
          elevation: isAnswered ? 1 : 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isAnswered ? Colors.grey[300]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isAnswered ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${globalIndex + 1}',
                          style: TextStyle(
                            color: isAnswered ? Colors.white : Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        question.text,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildScaleSelector(globalIndex, answer.score),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScaleSelector(int questionIndex, int currentScore) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '전혀 아니다',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '매우 그렇다',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(5, (index) {
            final score = index + 1;
            final isSelected = currentScore == score;
            
            return Expanded(
              child: GestureDetector(
                onTap: () => _answerQuestion(questionIndex, score),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 48,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 4,
                    right: index == 4 ? 0 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.grey[800]! : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
                      child: Text('$score'),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (currentPageIndex > 0)
          OutlinedButton.icon(
            onPressed: _previousPage,
            icon: const Icon(Icons.arrow_back),
            label: const Text('이전'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[800],
              side: BorderSide(color: Colors.grey[300]!),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
            ),
          )
        else
          const SizedBox(),
        
        ElevatedButton.icon(
          onPressed: _nextPage,
          icon: Icon(
            currentPageIndex < totalPages - 1 
                ? Icons.arrow_forward 
                : Icons.check,
          ),
          label: Text(
            currentPageIndex < totalPages - 1 
                ? '다음' 
                : '결과 보기',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }
}