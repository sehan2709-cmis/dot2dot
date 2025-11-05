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

class _TypeDetailScreenState extends State<TypeDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String fullContent = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    
    _loadFullContent();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadFullContent() async {
    final content = await QuestionService.loadResult(widget.typeCode);
    setState(() {
      fullContent = content;
      isLoading = false;
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final typeName = TypeNameService.getTypeName(widget.typeCode);
    
    // 코드 분해
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
      body: isLoading
          ? Center(
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
                    '내용을 불러오는 중...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 900),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        
                        // 메인 카드
                        Card(
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
                                  typeName,
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
                                _buildTypeChip('관계 범위: ${_getTypeDescription(part1)}'),
                                const SizedBox(height: 10),
                                _buildTypeChip('친밀감 스타일: ${_getTypeDescription(part2)}'),
                                const SizedBox(height: 10),
                                _buildTypeChip('갈등 대처: ${_getTypeDescription(part3)}'),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // 전체 내용 표시
                        Card(
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
                                    Icon(Icons.description_outlined, color: Colors.grey[700], size: 24),
                                    const SizedBox(width: 12),
                                    Text(
                                      '상세 분석',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // SelectableText로 줄바꿈 유지
                                SelectableText(
                                  fullContent,
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
                        
                        const SizedBox(height: 32),
                        
                        // 공유/저장 버튼
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('준비 중인 기능입니다')),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[300],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getTypeDescription(String code) {
    final descriptions = {
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
    return descriptions[code] ?? code;
  }
}