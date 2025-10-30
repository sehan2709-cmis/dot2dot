import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/question_service.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final TestResult result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String resultContent = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final content = await QuestionService.loadResult(widget.result.combinedType);
    setState(() {
      resultContent = content;
      isLoading = false;
    });
  }

  Map<String, String> _parseResultContent(String content) {
    Map<String, String> sections = {
      'pattern': '',
      'relationships': '',
      'strengths': '',
      'weaknesses': '',
      'questions': '',
    };

    final lines = content.split('\n');
    String currentSection = '';

    for (var line in lines) {
      final trimmed = line.trim();
      
      if (trimmed.startsWith('[인간관계 패턴')) {
        currentSection = 'pattern';
        continue;
      } else if (trimmed.startsWith('[좋아하는 관계')) {
        currentSection = 'relationships';
        continue;
      } else if (trimmed.startsWith('[장점')) {
        currentSection = 'strengths';
        continue;
      } else if (trimmed.startsWith('[단점')) {
        currentSection = 'weaknesses';
        continue;
      } else if (trimmed.startsWith('[스스로에게')) {
        currentSection = 'questions';
        continue;
      }

      if (currentSection.isNotEmpty && trimmed.isNotEmpty && !trimmed.startsWith('[')) {
        sections[currentSection] = sections[currentSection]! + trimmed + '\n';
      }
    }

    return sections;
  }

  String _getTypeDescription(String type) {
    const descriptions = {
      'A': '활발한 사교형',
      'B': '소수 정예형',
      'C': '균형형',
      '가': '안정 애착형',
      '나': '불안-집착형',
      '다': '회피 독립형',
      '1': '직면 해결형',
      '2': '회피/유지형',
      '3': '협력/조율형',
    };
    return descriptions[type] ?? type;
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

    final sections = _parseResultContent(resultContent);

    return Scaffold(
      appBar: AppBar(
        title: const Text('테스트 결과'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[50],
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 결과 타입 카드
                  Card(
                    elevation: 4,
                    color: const Color(0xFF6B4CE6),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          const Text(
                            '당신의 인간관계 성향은',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.result.combinedType,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildTypeChip(
                            '관계 범위: ${_getTypeDescription(widget.result.part1Type)}',
                          ),
                          const SizedBox(height: 8),
                          _buildTypeChip(
                            '친밀감 스타일: ${_getTypeDescription(widget.result.part2Type)}',
                          ),
                          const SizedBox(height: 8),
                          _buildTypeChip(
                            '갈등 대처: ${_getTypeDescription(widget.result.part3Type)}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // 인간관계 패턴 분석
                  _buildResultSection(
                    '인간관계 패턴 분석',
                    sections['pattern']!,
                    Icons.psychology,
                  ),

                  const SizedBox(height: 16),

                  // 좋아하는/싫어하는 관계
                  _buildResultSection(
                    '좋아하는 관계와 싫어하는 관계',
                    sections['relationships']!,
                    Icons.favorite,
                  ),

                  const SizedBox(height: 16),

                  // 장점
                  _buildResultSection(
                    '장점',
                    sections['strengths']!,
                    Icons.star,
                  ),

                  const SizedBox(height: 16),

                  // 단점
                  _buildResultSection(
                    '단점',
                    sections['weaknesses']!,
                    Icons.warning_amber,
                  ),

                  const SizedBox(height: 16),

                  // 개선 질문
                  _buildResultSection(
                    '스스로에게 물어볼 질문들',
                    sections['questions']!,
                    Icons.question_answer,
                  ),

                  const SizedBox(height: 32),

                  // 다시하기 버튼
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: const Color(0xFF6B4CE6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '처음으로 돌아가기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildResultSection(String title, String content, IconData icon) {
    if (content.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF6B4CE6),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content.trim(),
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}