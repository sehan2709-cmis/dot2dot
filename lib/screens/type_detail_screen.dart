import 'package:flutter/material.dart';
import '../services/type_name_service.dart';
import '../services/question_service.dart';

class TypeDetailScreen extends StatefulWidget {
  final String typeCode;

  const TypeDetailScreen({
    super.key,
    required this.typeCode,
  });

  @override
  State<TypeDetailScreen> createState() => _TypeDetailScreenState();
}

class _TypeDetailScreenState extends State<TypeDetailScreen> with TickerProviderStateMixin {
  String resultContent = '';
  bool isLoading = true;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _loadResult();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // Future<void> _loadResult() async {
  //   final content = await QuestionService.loadResult(widget.typeCode);
  //   setState(() {
  //     resultContent = content;
  //     isLoading = false;
  //   });
    
  //   _fadeController.forward();
  //   Future.delayed(const Duration(milliseconds: 200), () {
  //     _slideController.forward();
  //   });
  // }

  Future<void> _loadResult() async {
    final raw = await QuestionService.loadResult(widget.typeCode);

    // 1) 윈도우/맥/리눅스 줄바꿈 통일
    // 2) 파일에 리터럴 "\n" (백슬래시 + n) 이 들어있을 경우 실제 줄바꿈으로 변환
    // 3) 혹시 "\r" 만 있는 경우도 처리
    String content = raw
        .replaceAll(RegExp(r'\\r\\n'), '\n') // 리터럴 "\r\n" -> 실제 줄바꿈
        .replaceAll(RegExp(r'\\n'), '\n')    // 리터럴 "\n" -> 실제 줄바꿈
        .replaceAll(RegExp(r'\r\n?'), '\n'); // CRLF or CR -> LF

    // (디버그) 콘솔에 실제 들어온 텍스트 확인하고 싶으면 주석 해제
    // print('--- RAW START ---\n$raw\n--- RAW END ---');
    // print('--- NORMALIZED START ---\n$content\n--- NORMALIZED END ---');

    setState(() {
      resultContent = content;
      isLoading = false;
    });

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
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

    // OS별 모든 줄바꿈을 통일한 뒤 라인으로 분할
    final lines = content.split('\n');
    String currentSection = '';

    for (var line in lines) {
      final lineTrimmedForHeader = line.trim();

      if (lineTrimmedForHeader.startsWith('[인간관계 패턴')) {
        currentSection = 'pattern';
        continue;
      } else if (lineTrimmedForHeader.startsWith('[좋아하는 관계')) {
        currentSection = 'relationships';
        continue;
      } else if (lineTrimmedForHeader.startsWith('[장점')) {
        currentSection = 'strengths';
        continue;
      } else if (lineTrimmedForHeader.startsWith('[단점')) {
        currentSection = 'weaknesses';
        continue;
      } else if (lineTrimmedForHeader.startsWith('[스스로에게')) {
        currentSection = 'questions';
        continue;
      }

      if (currentSection.isNotEmpty) {
        // 헤더 라인이 아니라면 라인을 그대로 추가 (빈 줄은 그대로 유지)
        // 단, 파일 내부의 '[...' 같은 다른 섹션 헤더가 섞여있으면 무시
        if (!lineTrimmedForHeader.startsWith('[')) {
          sections[currentSection] = sections[currentSection]! + line + '\n';
        }
      }
    }

    // 각 섹션 끝의 불필요한 마지막 개행 하나 제거 (선택)
    sections.updateAll((k, v) => v.endsWith('\n') ? v.substring(0, v.length - 1) : v);

    return sections;
  }


  // Map<String, String> _parseResultContent(String content) {
  //   Map<String, String> sections = {
  //     'pattern': '',
  //     'relationships': '',
  //     'strengths': '',
  //     'weaknesses': '',
  //     'questions': '',
  //   };

  //   final lines = content.split('\n');
  //   String currentSection = '';

  //   for (var line in lines) {
  //     final trimmed = line; //.trim();
      
  //     if (trimmed.startsWith('[인간관계 패턴')) {
  //       currentSection = 'pattern';
  //       continue;
  //     } else if (trimmed.startsWith('[좋아하는 관계')) {
  //       currentSection = 'relationships';
  //       continue;
  //     } else if (trimmed.startsWith('[장점')) {
  //       currentSection = 'strengths';
  //       continue;
  //     } else if (trimmed.startsWith('[단점')) {
  //       currentSection = 'weaknesses';
  //       continue;
  //     } else if (trimmed.startsWith('[스스로에게')) {
  //       currentSection = 'questions';
  //       continue;
  //     }

  //     if (currentSection.isNotEmpty && trimmed.isNotEmpty && !trimmed.startsWith('[')) {
  //       sections[currentSection] = sections[currentSection]! + trimmed + '\n';
  //     }
  //   }

  //   return sections;
  // }

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
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey[900],
          elevation: 0,
        ),
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
                '유형 정보를 불러오는 중...',
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

    final sections = _parseResultContent(resultContent);
    final part1 = widget.typeCode[0]; // A, B, C
    final part2 = widget.typeCode[1]; // 가, 나, 다
    final part3 = widget.typeCode[2]; // 1, 2, 3

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // 결과 타입 카드
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Card(
                    elevation: 0,
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          Text(
                            TypeNameService.getTypeName(widget.typeCode),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // const SizedBox(height: 16),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white.withOpacity(0.15),
                          //     borderRadius: BorderRadius.circular(20),
                          //   ),
                          //   child: Text(
                          //     widget.typeCode,
                          //     style: TextStyle(
                          //       color: Colors.grey[300],
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.bold,
                          //       letterSpacing: 4,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 28),
                          _buildTypeChip(
                            '관계 범위: ${_getTypeDescription(part1)}',
                          ),
                          const SizedBox(height: 10),
                          _buildTypeChip(
                            '친밀감 스타일: ${_getTypeDescription(part2)}',
                          ),
                          const SizedBox(height: 10),
                          _buildTypeChip(
                            '갈등 대처: ${_getTypeDescription(part3)}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),

                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      _buildResultSection(
                        '인간관계 패턴 분석',
                        sections['pattern']!,
                        Icons.psychology_outlined,
                        0,
                      ),

                      const SizedBox(height: 16),

                      _buildResultSection(
                        '좋아하는 관계와 싫어하는 관계',
                        sections['relationships']!,
                        Icons.favorite_outline,
                        1,
                      ),

                      const SizedBox(height: 16),

                      _buildResultSection(
                        '장점',
                        sections['strengths']!,
                        Icons.star_outline,
                        2,
                      ),

                      const SizedBox(height: 16),

                      _buildResultSection(
                        '단점',
                        sections['weaknesses']!,
                        Icons.warning_amber_outlined,
                        3,
                      ),

                      const SizedBox(height: 16),

                      _buildResultSection(
                        '스스로에게 물어볼 질문들',
                        sections['questions']!,
                        Icons.question_answer_outlined,
                        4,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('준비 중인 기능입니다'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('공유하기'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: Colors.grey[800],
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('목록으로'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.grey[900],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildResultSection(String title, String content, IconData icon, int index) {
    if (content.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.grey[700],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                content.trim(),
                style: TextStyle(
                  fontSize: 16,
                  height: 1.7,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}