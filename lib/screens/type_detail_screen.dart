import 'dart:ui';
import 'package:dot2dot/screens/test_screen.dart';
import 'package:flutter/material.dart';
import '../services/type_name_service.dart';
import '../services/question_service.dart';
import '../constants/colors.dart';
import '../services/compatibility_service.dart';
import 'home_screen.dart';

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

  Future<void> _loadResult() async {
    final raw = await QuestionService.loadResult(widget.typeCode);

    String content = raw
        .replaceAll(RegExp(r'\\r\\n'), '\n')
        .replaceAll(RegExp(r'\\n'), '\n')
        .replaceAll(RegExp(r'\r\n?'), '\n');

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
        if (!lineTrimmedForHeader.startsWith('[')) {
          sections[currentSection] = sections[currentSection]! + line + '\n';
        }
      }
    }

    sections.updateAll((k, v) => v.endsWith('\n') ? v.substring(0, v.length - 1) : v);

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
    final typeColor = AppColors.getTypeColor(widget.typeCode, medium: true);
    final accentColor = AppColors.getTypeAccentColor(widget.typeCode);

    if (isLoading) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.grey[900],
                    elevation: 0,
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final sections = _parseResultContent(resultContent);
    final part1 = widget.typeCode[0];
    final part2 = widget.typeCode[1];
    final part3 = widget.typeCode[2];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.grey[900],
                elevation: 0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 900),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    accentColor.withOpacity(0.5),
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
                                      TypeNameService.getTypeName(widget.typeCode),
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
                                _buildCompatibilitySection(accentColor),
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
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: accentColor.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('준비 중인 기능입니다'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.share_outlined, color: accentColor),
                                      label: Text(
                                        '공유하기',
                                        style: TextStyle(color: accentColor),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        side: BorderSide.none,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
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
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                                      label: const Text(
                                        '목록으로',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        elevation: 0,
                                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompatibilitySection(Color accentColor) {
    final compatibility = CompatibilityService.getCompatibility(widget.typeCode);
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
                    Icon(Icons.handshake, size: 28, color: Colors.grey[900]),
                    const SizedBox(width: 12),
                    Text(
                      '궁합 분석',
                      style: TextStyle(
                        color: Colors.grey[900],
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
                  accentColor,
                ),
                const SizedBox(height: 16),
                
                // 최악의 궁합
                _buildCompatibilityItem(
                  '최악의 궁합',
                  compatibility.worstMatch,
                  Colors.red[300]!,
                  Icons.warning_amber,
                  accentColor,
                ),
                const SizedBox(height: 24),
                
                const Divider(height: 32),
                
                // 잠긴 연인 궁합 섹션
                _buildLockedLoverSection(accentColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLockedLoverSection(Color accentColor) {
    return Stack(
      children: [
        // Blurred content
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100]!.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite, size: 24, color: Colors.grey[400]),
                      const SizedBox(width: 12),
                      Text(
                        '연인 궁합',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // 가짜 블러된 항목들
                  _buildBlurredItem('연인 (Best) 1', Icons.favorite),
                  const SizedBox(height: 12),
                  _buildBlurredItem('연인 (Best) 2', Icons.favorite),
                  const SizedBox(height: 12),
                  _buildBlurredItem('연인 (Worst) 1', Icons.heart_broken),
                  const SizedBox(height: 12),
                  _buildBlurredItem('연인 (Worst) 2', Icons.heart_broken),
                ],
              ),
            ),
          ),
        ),
        
        // 잠금 오버레이
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _showTestPromptDialog();
                },
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          size: 48,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '연인 궁합 보기',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '유형 검사를 완료하면\n자세한 연인 궁합을 확인할 수 있어요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              accentColor.withOpacity(0.8),
                              accentColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              '테스트하러 가기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBlurredItem(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.grey[400], size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 16,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTestPromptDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.lock_open,
              color: AppColors.getTypeAccentColor(widget.typeCode),
            ),
            const SizedBox(width: 12),
            const Text('연인 궁합 확인하기'),
          ],
        ),
        content: const Text(
          '연인 궁합 정보는 유형 검사를 완료한 사용자에게만 제공됩니다.\n\n'
          '지금 테스트를 시작하시겠어요?',
          style: TextStyle(height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              // 홈 화면으로 이동
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => TestScreen(),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.getTypeAccentColor(widget.typeCode),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
            child: const Text('테스트 시작'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilityItem(
    String label, 
    String typeCode, 
    Color color, 
    IconData icon,
    Color accentColor,
  ) {
    final typeName = TypeNameService.getTypeName(typeCode);
    
    return InkWell(
      onTap: () {
        // 같은 화면을 새로운 유형으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TypeDetailScreen(typeCode: typeCode),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
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
                      color: Colors.grey[700],
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