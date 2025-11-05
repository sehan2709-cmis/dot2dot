import 'package:flutter/material.dart';

class AppColors {
  // RGB 기본 색상 (매우 투명하고 은은하게 - 유리 질감용)
  static const Color socialRed = Color(0x08FF5252);      // 활발한 사교형 - 빨강 (투명도 약 3%)
  static const Color selectiveBlue = Color(0x085271FF);   // 소수 정예형 - 파랑 (투명도 약 3%)
  static const Color balancedGreen = Color(0x0852C752);   // 균형형 - 초록 (투명도 약 3%)
  
  // 약간 더 진한 버전 (강조용)
  static const Color socialRedMedium = Color(0x18FF5252);      // 투명도 약 9%
  static const Color selectiveBlueMedium = Color(0x185271FF);  // 투명도 약 9%
  static const Color balancedGreenMedium = Color(0x1852C752);  // 투명도 약 9%
  
  // 아이콘/텍스트용 (더 선명)
  static const Color socialRedAccent = Color(0xFFFF5252);
  static const Color selectiveBlueAccent = Color(0xFF5271FF);
  static const Color balancedGreenAccent = Color(0xFF52C752);
  
  // 유형 코드로 색상 가져오기
  static Color getTypeColor(String typeCode, {bool medium = false}) {
    final firstChar = typeCode.isNotEmpty ? typeCode[0] : '';
    
    switch (firstChar) {
      case 'A':
        return medium ? socialRedMedium : socialRed;
      case 'B':
        return medium ? selectiveBlueMedium : selectiveBlue;
      case 'C':
        return medium ? balancedGreenMedium : balancedGreen;
      default:
        return Colors.grey[100]!;
    }
  }
  
  static Color getTypeAccentColor(String typeCode) {
    final firstChar = typeCode.isNotEmpty ? typeCode[0] : '';
    
    switch (firstChar) {
      case 'A':
        return socialRedAccent;
      case 'B':
        return selectiveBlueAccent;
      case 'C':
        return balancedGreenAccent;
      default:
        return Colors.grey[600]!;
    }
  }
}