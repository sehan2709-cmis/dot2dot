class CompatibilityService {
  // 각 유형별 궁합 데이터
  static const Map<String, CompatibilityData> compatibilityMap = {
    'A가1': CompatibilityData(
      bestMatch: 'C가3',
      worstMatch: 'B나2',
      loverBest1: 'A가3',
      loverBest2: 'B가3',
      loverWorst1: 'B나2',
      loverWorst2: 'A나2',
    ),
    'A가2': CompatibilityData(
      bestMatch: 'A가3',
      worstMatch: 'B나1',
      loverBest1: 'B가2',
      loverBest2: 'B가3',
      loverWorst1: 'B나1',
      loverWorst2: 'A나1',
    ),
    'A가3': CompatibilityData(
      bestMatch: 'C가3',
      worstMatch: 'B다1',
      loverBest1: 'A가1',
      loverBest2: 'B가3',
      loverWorst1: 'B다2',
      loverWorst2: 'B나2',
    ),
    'A나1': CompatibilityData(
      bestMatch: 'A나3',
      worstMatch: 'A다2',
      loverBest1: 'A가3',
      loverBest2: 'A나3',
      loverWorst1: 'A다2',
      loverWorst2: 'A나2',
    ),
    'A나2': CompatibilityData(
      bestMatch: 'A나3',
      worstMatch: 'A나1',
      loverBest1: 'A가3',
      loverBest2: 'A나3',
      loverWorst1: 'A나1',
      loverWorst2: 'A다1',
    ),
    'A나3': CompatibilityData(
      bestMatch: 'A가3',
      worstMatch: 'A다2',
      loverBest1: 'A가3',
      loverBest2: 'A나1',
      loverWorst1: 'A다2',
      loverWorst2: 'B다2',
    ),
    'A다1': CompatibilityData(
      bestMatch: 'C다3',
      worstMatch: 'A나2',
      loverBest1: 'A다3',
      loverBest2: 'C다1',
      loverWorst1: 'A나2',
      loverWorst2: 'A나1',
    ),
    'A다2': CompatibilityData(
      bestMatch: 'B다2',
      worstMatch: 'A나1',
      loverBest1: 'A다2',
      loverBest2: 'C다2',
      loverWorst1: 'A나1',
      loverWorst2: 'B나1',
    ),
    'A다3': CompatibilityData(
      bestMatch: 'C다3',
      worstMatch: 'A나1',
      loverBest1: 'C다3',
      loverBest2: 'A가3',
      loverWorst1: 'A나1',
      loverWorst2: 'A나2',
    ),
    'B가1': CompatibilityData(
      bestMatch: 'B가3',
      worstMatch: 'B나2',
      loverBest1: 'B가3',
      loverBest2: 'A가1',
      loverWorst1: 'B나2',
      loverWorst2: 'B나1',
    ),
    'B가2': CompatibilityData(
      bestMatch: 'B가3',
      worstMatch: 'B나1',
      loverBest1: 'B가2',
      loverBest2: 'A가2',
      loverWorst1: 'B나1',
      loverWorst2: 'A나1',
    ),
    'B가3': CompatibilityData(
      bestMatch: 'B가3',
      worstMatch: 'B다2',
      loverBest1: 'B가1',
      loverBest2: 'A가3',
      loverWorst1: 'B다2',
      loverWorst2: 'B나2',
    ),
    'B나1': CompatibilityData(
      bestMatch: 'B나3',
      worstMatch: 'B나2',
      loverBest1: 'B나3',
      loverBest2: 'B가3',
      loverWorst1: 'B나2',
      loverWorst2: 'B다2',
    ),
    'B나2': CompatibilityData(
      bestMatch: 'B나3',
      worstMatch: 'B나1',
      loverBest1: 'B나3',
      loverBest2: 'B가3',
      loverWorst1: 'B나1',
      loverWorst2: 'B다1',
    ),
    'B나3': CompatibilityData(
      bestMatch: 'B가3',
      worstMatch: 'B다2',
      loverBest1: 'B가3',
      loverBest2: 'B나1',
      loverWorst1: 'B다2',
      loverWorst2: 'B다1',
    ),
    'B다1': CompatibilityData(
      bestMatch: 'B다3',
      worstMatch: 'B나2',
      loverBest1: 'B다3',
      loverBest2: 'A다1',
      loverWorst1: 'B나2',
      loverWorst2: 'B나1',
    ),
    'B다2': CompatibilityData(
      bestMatch: 'B다2',
      worstMatch: 'B나1',
      loverBest1: 'A다2',
      loverBest2: 'C다2',
      loverWorst1: 'B나1',
      loverWorst2: 'A나1',
    ),
    'B다3': CompatibilityData(
      bestMatch: 'A다3',
      worstMatch: 'B나1',
      loverBest1: 'A다3',
      loverBest2: 'B가3',
      loverWorst1: 'B나1',
      loverWorst2: 'B나2',
    ),
    'C가1': CompatibilityData(
      bestMatch: 'C가3',
      worstMatch: 'C나2',
      loverBest1: 'C가3',
      loverBest2: 'A가1',
      loverWorst1: 'C나2',
      loverWorst2: 'B나2',
    ),
    'C가2': CompatibilityData(
      bestMatch: 'C가3',
      worstMatch: 'C나1',
      loverBest1: 'B가2',
      loverBest2: 'C가3',
      loverWorst1: 'C나1',
      loverWorst2: 'B나1',
    ),
    'C가3': CompatibilityData(
      bestMatch: 'C가3',
      worstMatch: 'C다2',
      loverBest1: 'C가1',
      loverBest2: 'A가3',
      loverWorst1: 'C다2',
      loverWorst2: 'C나2',
    ),
    'C나1': CompatibilityData(
      bestMatch: 'C나3',
      worstMatch: 'C다2',
      loverBest1: 'C가3',
      loverBest2: 'C나3',
      loverWorst1: 'C다2',
      loverWorst2: 'C나2',
    ),
    'C나2': CompatibilityData(
      bestMatch: 'C나3',
      worstMatch: 'C나1',
      loverBest1: 'C가3',
      loverBest2: 'C나3',
      loverWorst1: 'C나1',
      loverWorst2: 'C다1',
    ),
    'C나3': CompatibilityData(
      bestMatch: 'C가3',
      worstMatch: 'C다2',
      loverBest1: 'C가3',
      loverBest2: 'C나1',
      loverWorst1: 'C다2',
      loverWorst2: 'C다1',
    ),
    'C다1': CompatibilityData(
      bestMatch: 'C다3',
      worstMatch: 'C나2',
      loverBest1: 'C다3',
      loverBest2: 'A다1',
      loverWorst1: 'C나2',
      loverWorst2: 'C나1',
    ),
    'C다2': CompatibilityData(
      bestMatch: 'A다2',
      worstMatch: 'C나1',
      loverBest1: 'A다2',
      loverBest2: 'C다2',
      loverWorst1: 'C나1',
      loverWorst2: 'B나1',
    ),
    'C다3': CompatibilityData(
      bestMatch: 'A다3',
      worstMatch: 'C나1',
      loverBest1: 'C가3',
      loverBest2: 'A다3',
      loverWorst1: 'C나1',
      loverWorst2: 'C나2',
    ),
  };

  static CompatibilityData? getCompatibility(String typeCode) {
    return compatibilityMap[typeCode];
  }
}

class CompatibilityData {
  final String bestMatch;
  final String worstMatch;
  final String loverBest1;
  final String loverBest2;
  final String loverWorst1;
  final String loverWorst2;

  const CompatibilityData({
    required this.bestMatch,
    required this.worstMatch,
    required this.loverBest1,
    required this.loverBest2,
    required this.loverWorst1,
    required this.loverWorst2,
  });
}