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

  @override
  Widget build(BuildContext context) {
    final typeName = TypeNameService.getTypeName(widget.typeCode);
    final typeDescription = TypeNameService.getFullDescription(widget.typeCode);
    
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
      body: FadeTransition(
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
                  
                  // 상세 설명 섹션들
                  _buildDetailSection(
                    '핵심 특징',
                    _getCoreCharacteristics(widget.typeCode),
                    Icons.stars_outlined,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  _buildDetailSection(
                    '강점',
                    _getStrengths(widget.typeCode),
                    Icons.emoji_events_outlined,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  _buildDetailSection(
                    '성장 포인트',
                    _getGrowthPoints(widget.typeCode),
                    Icons.trending_up_outlined,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  _buildDetailSection(
                    '관계 팁',
                    _getRelationshipTips(widget.typeCode),
                    Icons.lightbulb_outline,
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

  Widget _buildDetailSection(String title, List<String> items, IconData icon) {
    return Card(
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
                Icon(icon, color: Colors.grey[700], size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...items.asMap().entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: entry.key < items.length - 1 ? 12 : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
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

  List<String> _getCoreCharacteristics(String code) {
    final characteristics = {
      'A가1': [
        '많은 친구들과 활발하게 교류하며 넓은 인맥을 형성합니다',
        '관계에서 안정감을 느끼며 상대방을 신뢰하는 편입니다',
        '갈등이 생기면 회피하지 않고 직접적으로 해결하려 합니다',
        '사교적이면서도 감정적으로 성숙한 모습을 보입니다',
      ],
      'A가2': [
        '여러 사람과 쉽게 친해지고 다양한 모임에 참여합니다',
        '안정적인 애착 스타일로 관계에서 불안감이 적습니다',
        '갈등 상황에서는 평화를 중시하며 직접적인 대립을 피합니다',
        '조화로운 분위기를 만드는 것을 중요하게 생각합니다',
      ],
      'A가3': [
        '폭넓은 사교 활동을 즐기며 다양한 사람들과 관계를 맺습니다',
        '감정적으로 안정되어 있어 관계에서 여유로운 편입니다',
        '문제가 생기면 양쪽의 입장을 고려해 협력적으로 해결합니다',
        '조율과 중재 능력이 뛰어나 팀에서 중요한 역할을 합니다',
      ],
      // 나머지 유형들...
      'A나1': [
        '새로운 사람들과 만나는 것을 즐기며 관계에 열정적입니다',
        '가까운 사람들에게 확인과 애정을 자주 요구하는 편입니다',
        '문제가 생기면 솔직하게 자신의 감정을 표현합니다',
        '관계에서의 불안감을 직면하고 해결하려는 의지가 있습니다',
      ],
      'A나2': [
        '겉으로는 활발하지만 내면의 불안을 숨기는 경향이 있습니다',
        '타인의 반응에 민감하며 버림받을까 걱정합니다',
        '갈등을 피하려 하지만 내면에서는 계속 신경 쓰입니다',
        '친절한 모습 뒤에 관계에 대한 불안이 존재합니다',
      ],
      'A나3': [
        '사교적이면서도 친밀한 관계에 헌신적입니다',
        '관심과 애정을 필요로 하지만 조화를 위해 노력합니다',
        '갈등 시 양쪽을 모두 만족시키려 애쓰는 경향이 있습니다',
        '관계 유지를 위해 자신을 희생하는 면이 있습니다',
      ],
      'A다1': [
        '사교적이지만 독립성을 중요하게 생각합니다',
        '감정보다는 문제 해결에 집중하는 편입니다',
        '갈등이 생기면 직접적이고 논리적으로 해결합니다',
        '혼자만의 시간을 필요로 하면서도 사회적 활동을 즐깁니다',
      ],
      'A다2': [
        '많은 사람들과 어울리지만 적당한 거리를 유지합니다',
        '깊은 감정 교류보다는 가벼운 관계를 선호합니다',
        '갈등을 피하며 필요시 거리를 두는 방식으로 대응합니다',
        '매력적이지만 진정한 속마음은 잘 드러내지 않습니다',
      ],
      'A다3': [
        '사교적이면서도 이성적으로 관계를 관리합니다',
        '감정적 의존보다는 독립적인 관계를 선호합니다',
        '문제 해결 시 양쪽의 논리를 고려해 조율합니다',
        '전략적으로 생각하며 균형잡힌 관계를 추구합니다',
      ],
      'B가1': [
        '소수의 친구와 깊고 의미있는 관계를 맺습니다',
        '신뢰를 바탕으로 한 안정적인 관계를 선호합니다',
        '갈등이 생기면 직접적으로 대화하며 해결합니다',
        '진정성 있는 관계를 장기간 유지하는 능력이 있습니다',
      ],
      'B가2': [
        '가까운 소수와 조용하고 평화로운 관계를 유지합니다',
        '안정적인 애착으로 관계에서 불안감이 적습니다',
        '갈등보다는 평화를 중시하며 조용히 문제를 넘깁니다',
        '조용한 수호자처럼 관계를 지키는 역할을 합니다',
      ],
      'B가3': [
        '소수의 사람들과 깊이 있는 관계를 가꿉니다',
        '감정적으로 안정되어 있으며 신뢰감을 줍니다',
        '문제 해결 시 상호 협력을 중시하며 함께 답을 찾습니다',
        '장인처럼 관계를 정성스럽게 다듬어갑니다',
      ],
      'B나1': [
        '가까운 사람들에게 매우 헌신적이고 보호적입니다',
        '관계에서 불안감을 느끼지만 직접 표현합니다',
        '갈등 시 강하게 자신의 입장을 주장합니다',
        '소중한 사람을 지키려는 의지가 강합니다',
      ],
      'B나2': [
        '소수의 친구에게 깊은 애착을 보이지만 불안합니다',
        '조용해 보이지만 내면에 감정의 폭풍이 있습니다',
        '갈등을 피하지만 계속해서 마음속으로 걱정합니다',
        '외교관처럼 표면적 평화를 유지하려 노력합니다',
      ],
      'B나3': [
        '가까운 관계를 온실 식물처럼 세심하게 돌봅니다',
        '불안하지만 관계를 위해 조율하고 타협합니다',
        '갈등 시 양쪽을 만족시키려 많은 노력을 기울입니다',
        '관계 유지를 위해 자신의 욕구를 억누르는 경향이 있습니다',
      ],
      'B다1': [
        '혼자 있는 것을 편안해하며 독립적입니다',
        '소수와만 관계를 맺으며 감정 표현이 서툽니다',
        '문제는 혼자서 해결하려 하며 직접적으로 대응합니다',
        '냉철하고 전략적으로 생각하는 경향이 있습니다',
      ],
      'B다2': [
        '고독을 즐기며 깊은 관계보다는 거리를 유지합니다',
        '독립적이지만 따뜻한 마음을 가지고 있습니다',
        '갈등을 피하며 필요시 홀로 있는 시간을 가집니다',
        '등대처럼 멀리서 조용히 빛을 비추는 존재입니다',
      ],
      'B다3': [
        '독립적이지만 필요시 협력할 줄 아는 유형입니다',
        '감정보다는 이성적으로 관계를 관리합니다',
        '갈등 시 논리적으로 타협점을 찾으려 합니다',
        '평화를 설계하듯 신중하게 관계를 다룹니다',
      ],
      'C가1': [
        '넓은 관계와 깊은 관계의 균형을 잘 맞춥니다',
        '안정적인 애착으로 관계의 중심 역할을 합니다',
        '문제가 생기면 직접적으로 해결하며 중재합니다',
        '건강한 관계의 모델이 되는 유형입니다',
      ],
      'C가2': [
        '다양한 사람들과 평화롭게 지내는 능력이 있습니다',
        '안정감 있게 관계를 유지하며 신뢰를 줍니다',
        '갈등을 피하고 조화로운 분위기를 만듭니다',
        '모두에게 편안한 친구가 되어줍니다',
      ],
      'C가3': [
        '관계의 생태계를 건강하게 관리하는 능력이 있습니다',
        '감정적으로 안정되어 있으며 균형감이 뛰어납니다',
        '갈등 시 양쪽을 고려해 최선의 해결책을 찾습니다',
        '조직이나 그룹에서 중요한 연결고리 역할을 합니다',
      ],
      'C나1': [
        '관계의 복잡함을 능숙하게 항해하는 능력이 있습니다',
        '불안감이 있지만 이를 극복하려는 의지가 있습니다',
        '문제 해결에 적극적이며 솔직하게 표현합니다',
        '관계의 선장처럼 방향을 잡아가는 유형입니다',
      ],
      'C나2': [
        '겉으로는 평온해 보이지만 내면의 불안을 숨깁니다',
        '균형잡힌 모습을 연기하며 사교계의 스타처럼 행동합니다',
        '갈등을 피하지만 내면에서는 계속 신경 씁니다',
        '완벽한 이미지 뒤에 진짜 자신을 숨기는 경향이 있습니다',
      ],
      'C나3': [
        '관계를 섬세하게 지키는 중재자의 역할을 합니다',
        '불안하지만 조화를 위해 노력하는 유형입니다',
        '갈등 시 모두를 만족시키려 애쓰며 타협합니다',
        '관계의 균형을 맞추는 데 많은 에너지를 쏟습니다',
      ],
      'C다1': [
        '사교적이면서도 독립성을 유지하는 전략가입니다',
        '감정보다는 논리적으로 관계를 관리합니다',
        '문제 해결에 직접적이고 효율적으로 접근합니다',
        '균형과 독립성을 모두 추구하는 유형입니다',
      ],
      'C다2': [
        '자유롭게 관계를 즐기며 얽매이지 않습니다',
        '독립적이지만 매력적으로 사람들과 어울립니다',
        '갈등을 피하며 필요시 거리를 두는 방랑자 스타일입니다',
        '자유로운 영혼으로 관계에 구속받지 않습니다',
      ],
      'C다3': [
        '지혜롭게 판단하고 조율하는 재판관 같은 유형입니다',
        '독립적이지만 필요시 협력할 줄 압니다',
        '갈등 시 공정하게 양쪽을 고려해 해결책을 제시합니다',
        '이성적이고 균형잡힌 시각으로 관계를 바라봅니다',
      ],
    };
    
    return characteristics[code] ?? ['이 유형에 대한 정보를 준비 중입니다.'];
  }

  List<String> _getStrengths(String code) {
    // 각 유형별 강점
    final strengths = {
      'A가1': [
        '뛰어난 사교 능력과 리더십',
        '건강한 관계 형성 및 유지 능력',
        '갈등을 두려워하지 않는 용기',
        '넓은 인맥을 통한 기회 창출',
      ],
      'A가2': [
        '조화로운 분위기 조성 능력',
        '다양한 사람들과의 원만한 관계',
        '평화로운 해결 방식',
        '사회적 적응력이 뛰어남',
      ],
      'A가3': [
        '뛰어난 조율 및 중재 능력',
        '다양한 관계의 균형 유지',
        '팀워크 증진 능력',
        '포용력과 이해심',
      ],
      // 다른 유형들도 추가...
    };
    
    return strengths[code] ?? [
      '자신만의 독특한 관계 방식',
      '진정성 있는 태도',
      '성장 가능성',
    ];
  }

  List<String> _getGrowthPoints(String code) {
    // 각 유형별 성장 포인트
    final growthPoints = {
      'A가1': [
        '때로는 깊이 있는 관계에도 집중해보세요',
        '모든 갈등을 즉시 해결하려 하기보다 상대방의 속도를 존중하세요',
        '혼자만의 시간도 가져보세요',
      ],
      'A가2': [
        '때로는 갈등을 직면하는 것이 관계에 도움이 될 수 있습니다',
        '자신의 의견을 더 솔직하게 표현해보세요',
        '표면적 평화보다 진정한 해결이 중요할 수 있습니다',
      ],
      'A가3': [
        '항상 중재자 역할만 하지 말고 자신의 입장도 분명히 하세요',
        '모두를 만족시키려 하지 말고 때로는 선택이 필요합니다',
        '자신의 욕구도 중요하게 여기세요',
      ],
      // 다른 유형들도 추가...
    };
    
    return growthPoints[code] ?? [
      '자신의 감정에 더 주의를 기울여보세요',
      '다양한 관계 방식을 시도해보세요',
      '자기 자신을 더 이해하려 노력하세요',
    ];
  }

  List<String> _getRelationshipTips(String code) {
    // 각 유형별 관계 팁
    final tips = {
      'A가1': [
        '넓은 인맥을 활용해 다양한 경험을 쌓으세요',
        '갈등 해결 능력을 더욱 발전시켜 리더십을 키우세요',
        '가끔은 소수의 친구와 깊은 시간을 가져보세요',
      ],
      'A가2': [
        '평화를 중시하되, 필요한 대화는 피하지 마세요',
        '갈등이 관계를 더 깊게 만들 수도 있다는 것을 기억하세요',
        '자신의 진솔한 감정을 표현하는 연습을 하세요',
      ],
      'A가3': [
        '조율 능력을 살려 팀이나 그룹에서 중요한 역할을 맡아보세요',
        '항상 중간에서만 있지 말고 때로는 자신의 색을 드러내세요',
        '자신의 한계를 인정하고 도움을 요청하는 것도 괜찮습니다',
      ],
      // 다른 유형들도 추가...
    };
    
    return tips[code] ?? [
      '자신의 성향을 이해하고 받아들이세요',
      '다른 유형의 사람들과도 좋은 관계를 맺을 수 있습니다',
      '지속적인 자기 성찰을 통해 성장하세요',
    ];
  }
}