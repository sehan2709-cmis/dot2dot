import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('Dot2Dot 소개'),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // 헤더
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.scatter_plot_outlined,
                          size: 64,
                          color: Colors.grey[800],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Dot2Dot',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '청소년·청년을 위한 인간관계 성향 분석',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Dot2Dot이란?
                  _buildSection(
                    '🎯 Dot2Dot이란?',
                    'Dot2Dot은 청소년과 청년들의 인간관계 맺기와 유지 방식을 이해하는 성향 분석 도구입니다. '
                    '점(Dot)과 점을 잇듯이, 사람과 사람 사이의 관계를 어떻게 형성하고 유지하는지 파악할 수 있습니다.',
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 왜 만들었나요?
                  _buildSection(
                    '💡 왜 만들었나요?',
                    '청소년·청년기는 또래 관계와 자아 정체성 형성이 중요한 시기입니다. '
                    '에릭슨(Erikson)에 따르면 청소년기 정체감이 확립된 사람일수록 친밀한 관계 형성에 성공하기 쉽습니다. '
                    'Dot2Dot은 이러한 발달 단계의 특성을 고려하여, 자신의 관계 패턴을 이해하고 건강한 인간관계를 형성하는 데 도움을 주기 위해 만들어졌습니다.',
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 이론적 배경
                  _buildSection(
                    '📚 이론적 배경',
                    'Dot2Dot은 다음과 같은 심리학 이론을 기반으로 합니다:',
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildTheoryCard(
                    '성격 심리학',
                    '빅파이브 성격 이론과 MBTI의 외향성/내향성 개념을 활용하여 관계 맺는 범위와 스타일을 분석합니다.',
                    Icons.psychology_outlined,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildTheoryCard(
                    '애착 이론',
                    '볼비(Bowlby)와 에인스워스(Ainsworth)의 애착 이론을 바탕으로 안정, 불안, 회피 애착 유형을 구분합니다.',
                    Icons.favorite_outline,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildTheoryCard(
                    '갈등 관리 이론',
                    '토마스-킬만(Thomas-Kilmann)의 갈등 대처 모델을 적용하여 갈등 상황에서의 대응 방식을 분석합니다.',
                    Icons.balance_outlined,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 3가지 핵심 축
                  _buildSection(
                    '🔍 3가지 핵심 분석 축',
                    'Dot2Dot은 인간관계를 3가지 핵심 축으로 분석합니다:',
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildAxisCard(
                    '1. 관계 맺는 범위',
                    '넓은 네트워크 vs 깊은 소수 관계',
                    'A (활발한 사교형) / B (소수 정예형) / C (균형형)',
                    Colors.blue[100]!,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildAxisCard(
                    '2. 친밀감 스타일',
                    '친밀 추구 vs 독립 강조',
                    '가 (안정 애착형) / 나 (불안-집착형) / 다 (회피 독립형)',
                    Colors.green[100]!,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _buildAxisCard(
                    '3. 갈등 대처 방식',
                    '직면 해결 vs 회피/조율',
                    '1 (직면 해결형) / 2 (회피/유지형) / 3 (협력/조율형)',
                    Colors.orange[100]!,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 연구 근거
                  _buildSection(
                    '🔬 연구 근거',
                    '실제 연구에서 외향적인 성향을 가진 사람은 내향적인 사람보다 친구 네트워크가 폭넓고 활발한 반면, '
                    '정서 불안(신경증)이 큰 사람들은 관계망이 작고 연결이 적다는 결과가 있습니다. '
                    'Dot2Dot은 이러한 연구 결과와 심리학 이론을 종합하여 청소년·청년에게 맞는 언어로 재구성했습니다.',
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 활용 방법
                  _buildSection(
                    '✨ 활용 방법',
                    '• 자신의 관계 패턴을 객관적으로 이해하기\n'
                    '• 친구나 연인과의 관계에서 갈등의 원인 파악하기\n'
                    '• 자신에게 맞는 관계 형성 방법 찾기\n'
                    '• 건강한 인간관계를 위한 성장 방향 모색하기',
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // 참고 문헌
                  Card(
                    elevation: 0,
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📖 참고 문헌',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '• 에릭슨의 심리사회 발달 이론\n'
                            '• 빅파이브 성격 이론 및 MBTI\n'
                            '• 애착 이론 (Bowlby, Ainsworth)\n'
                            '• 토마스-킬만 갈등 관리 모델\n'
                            '• 성격 및 관계 연구 (PMC9480517)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.6,
                            ),
                          ),
                        ],
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

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            height: 1.7,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildTheoryCard(String title, String description, IconData icon) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAxisCard(String title, String subtitle, String types, Color color) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              types,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}