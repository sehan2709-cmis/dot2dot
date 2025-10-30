class TypeNameService {
  // 27가지 조합의 한글 이름 매핑
  static const Map<String, String> typeNames = {
    'A가1': '관계의 건축가',
    'A가2': '평화로운 커뮤니티 빌더',
    'A가3': '관계의 오케스트라 지휘자',
    'A나1': '열정적인 관계 탐색가',
    'A나2': '친절한 표정의 불안한 관찰자',
    'A나3': '헌신적인 관계 조율자',
    'A다1': '유능한 고독한 해결사',
    'A다2': '상냥한 거리의 소셜라이트',
    'A다3': '이성적인 사교 설계자',
    'B가1': '신뢰의 건축가',
    'B가2': '고요한 관계의 수호자',
    'B가3': '관계의 장인(匠人)',
    'B나1': '헌신적인 관계의 파수꾼',
    'B나2': '조용한 폭풍을 품은 관계의 외교관',
    'B나3': '온실 속 관계를 가꾸는 정원사',
    'B다1': '고독한 전략가',
    'B다2': '고요한 섬의 등대지기',
    'B다3': '이성적인 평화 설계자',
    'C가1': '건강한 관계의 중심축',
    'C가2': '만인의 평화로운 친구',
    'C가3': '관계의 건강한 생태계 관리자',
    'C나1': '유능한 관계의 항해사',
    'C나2': '평온을 연기하는 사교계의 스타',
    'C나3': '관계를 지키는 섬세한 중재자',
    'C다1': '사교적인 전략가',
    'C다2': '매력적인 방랑자',
    'C다3': '지혜로운 재판관',
  };

  // 유형 코드를 받아서 한글 이름 반환
  static String getTypeName(String typeCode) {
    return typeNames[typeCode] ?? typeCode;
  }

  // 유형 코드를 받아서 "한글 이름 (코드)" 형태로 반환
  static String getTypeNameWithCode(String typeCode) {
    final name = typeNames[typeCode];
    if (name != null) {
      return '$name ($typeCode)';
    }
    return typeCode;
  }

  // 유형 코드를 받아서 통합 모델 설명 반환
  static String getFullDescription(String typeCode) {
    final descriptions = {
      'A가1': '활발한 사교형 + 안정 애착형 + 직면 해결형',
      'A가2': '활발한 사교형 + 안정 애착형 + 회피/유지형',
      'A가3': '활발한 사교형 + 안정 애착형 + 협력/조율형',
      'A나1': '활발한 사교형 + 불안-집착형 + 직면 해결형',
      'A나2': '활발한 사교형 + 불안-집착형 + 회피/유지형',
      'A나3': '활발한 사교형 + 불안-집착형 + 협력/조율형',
      'A다1': '활발한 사교형 + 회피 독립형 + 직면 해결형',
      'A다2': '활발한 사교형 + 회피 독립형 + 회피/유지형',
      'A다3': '활발한 사교형 + 회피 독립형 + 협력/조율형',
      'B가1': '소수 정예형 + 안정 애착형 + 직면 해결형',
      'B가2': '소수 정예형 + 안정 애착형 + 회피/유지형',
      'B가3': '소수 정예형 + 안정 애착형 + 협력/조율형',
      'B나1': '소수 정예형 + 불안-집착형 + 직면 해결형',
      'B나2': '소수 정예형 + 불안-집착형 + 회피/유지형',
      'B나3': '소수 정예형 + 불안-집착형 + 협력/조율형',
      'B다1': '소수 정예형 + 회피 독립형 + 직면 해결형',
      'B다2': '소수 정예형 + 회피 독립형 + 회피/유지형',
      'B다3': '소수 정예형 + 회피 독립형 + 협력/조율형',
      'C가1': '균형형 + 안정 애착형 + 직면 해결형',
      'C가2': '균형형 + 안정 애착형 + 회피/유지형',
      'C가3': '균형형 + 안정 애착형 + 협력/조율형',
      'C나1': '균형형 + 불안-집착형 + 직면 해결형',
      'C나2': '균형형 + 불안-집착형 + 회피/유지형',
      'C나3': '균형형 + 불안-집착형 + 협력/조율형',
      'C다1': '균형형 + 회피 독립형 + 직면 해결형',
      'C다2': '균형형 + 회피 독립형 + 회피/유지형',
      'C다3': '균형형 + 회피 독립형 + 협력/조율형',
    };
    
    return descriptions[typeCode] ?? '';
  }

  // 모든 유형 코드 리스트 반환
  static List<String> getAllTypeCodes() {
    return typeNames.keys.toList();
  }

  // 모든 유형 정보 반환 (코드, 이름, 설명)
  static List<TypeInfo> getAllTypes() {
    return typeNames.entries.map((entry) {
      return TypeInfo(
        code: entry.key,
        name: entry.value,
        description: getFullDescription(entry.key),
      );
    }).toList();
  }
}

class TypeInfo {
  final String code;
  final String name;
  final String description;

  TypeInfo({
    required this.code,
    required this.name,
    required this.description,
  });
}