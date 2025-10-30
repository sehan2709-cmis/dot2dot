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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('모든 성향 유형'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1400),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  Text(
                    '27가지 인간관계 성향',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    '3가지 핵심 축의 조합으로 만들어진 27가지 성향을 확인해보세요.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 3가지 축 요약 (3열 카드)
                  _buildAxisSummary(),
                  
                  const SizedBox(height: 48),
                  
                  // 27가지 유형 그리드
                  Text(
                    '모든 성향 유형',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  _buildTypeGrid(),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAxisSummary() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 반응형: 작은 화면에서는 1열, 중간은 2열, 큰 화면은 3열
        int crossAxisCount = 3;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 900) {
          crossAxisCount = 2;
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: [
            _buildAxisCard(
              '관계 맺는 범위',
              'A: 활발한 사교형 · B: 소수 정예형 · C: 균형형',
              Icons.people_outline,
              Colors.blue,
            ),
            _buildAxisCard(
              '친밀감 스타일',
              '가: 안정 애착형 · 나: 불안-집착형 · 다: 회피 독립형',
              Icons.favorite_outline,
              Colors.green,
            ),
            _buildAxisCard(
              '갈등 대처 방식',
              '1: 직면 해결형 · 2: 회피/유지형 · 3: 협력/조율형',
              Icons.balance_outlined,
              Colors.orange,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAxisCard(String title, String types, IconData icon, Color color) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              types,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeGrid() {
    final allTypes = TypeNameService.getAllTypes();
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // 반응형 그리드 열 수
        int crossAxisCount = 4;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 900) {
          crossAxisCount = 2;
        } else if (constraints.maxWidth < 1200) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: allTypes.length,
          itemBuilder: (context, index) {
            return _buildTypeCard(allTypes[index]);
          },
        );
      },
    );
  }

  Widget _buildTypeCard(TypeInfo typeInfo) {
    // 짧은 설명 생성
    final shortDesc = _getShortDescription(typeInfo.code);
    
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TypeDetailScreen(typeCode: typeInfo.code),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 아이콘 (성향별)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getTypeColor(typeInfo.code).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(typeInfo.code),
                  color: _getTypeColor(typeInfo.code),
                  size: 28,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 이름만 표시 (코드 제거)
              Text(
                typeInfo.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              // 짧은 설명
              Expanded(
                child: Text(
                  shortDesc,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Colors.grey[600],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // 더보기 버튼
              Row(
                children: [
                  Text(
                    '자세히 보기',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getShortDescription(String code) {
    final descriptions = {
      'A가1': '많은 친구와 건강한 관계를 맺으며 문제를 직접 해결',
      'A가2': '활발하게 사교하지만 갈등은 피하는 평화주의자',
      'A가3': '사교적이면서 모두와 협력하는 조율의 달인',
      'A나1': '열정적으로 관계를 탐색하고 솔직하게 표현',
      'A나2': '친절하지만 내면의 불안을 숨기는 관찰자',
      'A나3': '헌신적으로 관계를 조율하며 화합 추구',
      'A다1': '독립적이지만 문제는 직접 해결하는 능력자',
      'A다2': '사교적이지만 적당한 거리를 유지하는 스타일',
      'A다3': '이성적으로 관계를 설계하고 조율하는 전략가',
      'B가1': '소수의 친구와 깊은 신뢰를 쌓는 건축가',
      'B가2': '조용히 관계를 지키며 평화를 유지',
      'B가3': '소수와 깊은 관계를 장인처럼 가꾸는 유형',
      'B나1': '가까운 사람을 헌신적으로 지키는 파수꾼',
      'B나2': '조용하지만 내면에 폭풍을 품은 외교관',
      'B나3': '온실처럼 소중한 관계를 세심하게 가꿈',
      'B다1': '홀로서기를 선호하는 냉철한 전략가',
      'B다2': '고요한 섬처럼 독립적이지만 따뜻한 존재',
      'B다3': '이성적으로 평화를 설계하는 설계자',
      'C가1': '균형잡힌 관계의 중심에서 문제를 해결',
      'C가2': '모두에게 평화로운 친구이자 중재자',
      'C가3': '건강한 생태계처럼 관계를 관리하는 유형',
      'C나1': '관계의 바다를 유능하게 항해하는 선장',
      'C나2': '평온한 겉모습 뒤 불안을 연기하는 스타',
      'C나3': '섬세하게 관계를 지키는 중재의 달인',
      'C다1': '사교적이면서도 전략적으로 움직이는 유형',
      'C다2': '자유롭게 관계를 즐기는 매력적인 방랑자',
      'C다3': '지혜롭게 판단하고 조율하는 재판관',
    };
    
    return descriptions[code] ?? '';
  }

  Color _getTypeColor(String code) {
    // 첫 글자로 색상 결정
    if (code.startsWith('A')) return Colors.blue;
    if (code.startsWith('B')) return Colors.green;
    if (code.startsWith('C')) return Colors.orange;
    return Colors.grey;
  }

  IconData _getTypeIcon(String code) {
    // 첫 글자로 아이콘 결정
    if (code.startsWith('A')) return Icons.groups_outlined;
    if (code.startsWith('B')) return Icons.favorite_outline;
    if (code.startsWith('C')) return Icons.balance_outlined;
    return Icons.person_outline;
  }
}