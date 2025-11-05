import 'package:flutter/material.dart';
import '../services/type_name_service.dart';
import 'type_detail_screen.dart';

class TypesScreen extends StatefulWidget {
  const TypesScreen({super.key});

  @override
  State<TypesScreen> createState() => _TypesScreenState();
}

class _TypesScreenState extends State<TypesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  String selectedPart1 = 'ALL'; // ALL, A, B, C
  String selectedPart2 = 'ALL'; // ALL, 가, 나, 다
  String selectedPart3 = 'ALL'; // ALL, 1, 2, 3

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
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<TypeInfo> get filteredTypes {
    final allTypes = TypeNameService.getAllTypes();
    
    return allTypes.where((type) {
      bool matchPart1 = selectedPart1 == 'ALL' || type.code[0] == selectedPart1;
      bool matchPart2 = selectedPart2 == 'ALL' || type.code[1] == selectedPart2;
      bool matchPart3 = selectedPart3 == 'ALL' || type.code[2] == selectedPart3;
      
      return matchPart1 && matchPart2 && matchPart3;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final types = filteredTypes;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('모든 유형'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // 필터 섹션
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.filter_list, color: Colors.grey[700], size: 24),
                              const SizedBox(width: 12),
                              Text(
                                '필터',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          // 관계 범위 필터
                          _buildFilterSection(
                            '관계 범위',
                            ['ALL', 'A', 'B', 'C'],
                            selectedPart1,
                            (value) => setState(() => selectedPart1 = value),
                            {
                              'ALL': '전체',
                              'A': '활발한 사교형',
                              'B': '소수 정예형',
                              'C': '균형형',
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // 친밀감 스타일 필터
                          _buildFilterSection(
                            '친밀감 스타일',
                            ['ALL', '가', '나', '다'],
                            selectedPart2,
                            (value) => setState(() => selectedPart2 = value),
                            {
                              'ALL': '전체',
                              '가': '안정 애착형',
                              '나': '불안-집착형',
                              '다': '회피 독립형',
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // 갈등 대처 필터
                          _buildFilterSection(
                            '갈등 대처',
                            ['ALL', '1', '2', '3'],
                            selectedPart3,
                            (value) => setState(() => selectedPart3 = value),
                            {
                              'ALL': '전체',
                              '1': '직면 해결형',
                              '2': '회피/유지형',
                              '3': '협력/조율형',
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 결과 카운트
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '총 ${types.length}개의 유형',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 유형 그리드
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount;
                      if (constraints.maxWidth > 900) {
                        crossAxisCount = 3;
                      } else if (constraints.maxWidth > 600) {
                        crossAxisCount = 2;
                      } else {
                        crossAxisCount = 1;
                      }
                      
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: types.length,
                        itemBuilder: (context, index) {
                          return _buildTypeCard(types[index]);
                        },
                      );
                    },
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

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selected,
    Function(String) onSelect,
    Map<String, String> labels,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected == option;
            return InkWell(
              onTap: () => onSelect(option),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.grey[800]! : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  labels[option] ?? option,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTypeCard(TypeInfo type) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TypeDetailScreen(typeCode: type.code),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type.code,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      type.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '자세히 보기',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey[600],
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