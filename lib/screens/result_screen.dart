import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/question_service.dart';
import '../services/type_name_service.dart';
import '../constants/colors.dart';
import 'home_screen.dart';
import '../services/compatibility_service.dart';

class ResultScreen extends StatefulWidget {
  final TestResult result;

  const ResultScreen({
    super.key,
    required this.result,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with TickerProviderStateMixin {
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

  Future<void> _loadResult() async {
    final content = await QuestionService.loadResult(widget.result.combinedType);
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

      if (currentSection.isNotEmpty && !trimmed.startsWith('[')) {
        sections[currentSection] = sections[currentSection]! + line + '\n';
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
                '결과를 분석하는 중...',
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
    final typeColor = AppColors.getTypeColor(widget.result.combinedType, medium: true);
    final accentColor = AppColors.getTypeAccentColor(widget.result.combinedType);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            accentColor.withOpacity(0.5),
                            Colors.white,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Text(
                              '당신의 인간관계 성향은',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              TypeNameService.getTypeName(widget.result.combinedType),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 28),
                            _buildTypeChip(
                              '관계 범위: ${_getTypeDescription(widget.result.part1Type)}',
                            ),
                            const SizedBox(height: 10),
                            _buildTypeChip(
                              '친밀감 스타일: ${_getTypeDescription(widget.result.part2Type)}',
                            ),
                            const SizedBox(height: 10),
                            _buildTypeChip(
                              '갈등 대처: ${_getTypeDescription(widget.result.part3Type)}',
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
                        _buildCompatibilitySection(),
                        const SizedBox(height: 16),
                        _buildResultSection(
                          '인간관계 패턴 분석',
                          sections['pattern']!,
                          Icons.psychology_outlined,
                          0,
                          accentColor,
                        ),

                        const SizedBox(height: 16),

                        _buildResultSection(
                          '장점',
                          sections['strengths']!,
                          Icons.star_outline,
                          2,
                          accentColor,
                        ),

                        const SizedBox(height: 16),

                        _buildResultSection(
                          '단점',
                          sections['weaknesses']!,
                          Icons.warning_amber_outlined,
                          3,
                          accentColor,
                        ),

                        const SizedBox(height: 16),

                        _buildResultSection(
                          '좋아하는 관계와 싫어하는 관계',
                          sections['relationships']!,
                          Icons.favorite_outline,
                          1,
                          accentColor,
                        ),

                        const SizedBox(height: 16),

                        _buildResultSection(
                          '스스로에게 물어볼 질문들',
                          sections['questions']!,
                          Icons.question_answer_outlined,
                          4,
                          accentColor,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentColor.withOpacity(0.8),
                            accentColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  const HomeScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 300),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '처음으로 돌아가기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildResultSection(String title, String content, IconData icon, int index, Color accentColor) {
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accentColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: accentColor,
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
              SelectableText(
                content,
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


  Widget _buildCompatibilitySection() {
    final compatibility = CompatibilityService.getCompatibility(widget.result.combinedType);
    if (compatibility == null) return const SizedBox.shrink();
    
    return Column(
      children: [
        const SizedBox(height: 24),
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.handshake, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      '궁합 분석',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                
                // 최고의 궁합
                _buildCompatibilityItem(
                  '최고의 궁합',
                  compatibility.bestMatch,
                  Colors.green[300]!,
                  Icons.star,
                ),
                const SizedBox(height: 16),
                
                // 최악의 궁합
                _buildCompatibilityItem(
                  '최악의 궁합',
                  compatibility.worstMatch,
                  Colors.red[300]!,
                  Icons.warning_amber,
                ),
                const SizedBox(height: 24),
                
                const Divider(color: Colors.white24, height: 32),
                
                  Row(
                    children: [
                      Icon(Icons.favorite, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        '연인 궁합',
                        style: TextStyle(
                              color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                
                // 연인 Best
                _buildCompatibilityItem(
                  '연인 (Best) 1',
                  compatibility.loverBest1,
                  Colors.pink[200]!,
                  Icons.favorite,
                ),
                const SizedBox(height: 12),
                _buildCompatibilityItem(
                  '연인 (Best) 2',
                  compatibility.loverBest2,
                  Colors.pink[200]!,
                  Icons.favorite,
                ),
                const SizedBox(height: 16),
                
                // 연인 Worst
                _buildCompatibilityItem(
                  '연인 (Worst) 1',
                  compatibility.loverWorst1,
                  Colors.grey[500]!,
                  Icons.heart_broken,
                ),
                const SizedBox(height: 12),
                _buildCompatibilityItem(
                  '연인 (Worst) 2',
                  compatibility.loverWorst2,
                  Colors.grey[500]!,
                  Icons.heart_broken,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompatibilityItem(String label, String typeCode, Color color, IconData icon) {
    final typeName = TypeNameService.getTypeName(typeCode);
    
    return InkWell(
      onTap: () {
        // 해당 유형의 result_screen으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              result: TestResult(
                part1Type: typeCode[0],
                part2Type: typeCode[1],
                part3Type: typeCode[2],
              ),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    typeName,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color.withOpacity(0.7),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}