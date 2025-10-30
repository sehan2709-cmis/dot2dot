# Dot2Dot - 인간관계 성향 분석 웹사이트

Flutter로 제작된 인간관계 성향 분류 웹 애플리케이션입니다.

## 프로젝트 개요

사용자의 인간관계 패턴을 3가지 핵심 특성을 통해 분석합니다:

1. **관계 맺는 범위** (네트워크의 넓이 vs 깊이)
   - A: 활발한 사교형
   - B: 소수 정예형
   - C: 균형형

2. **친밀감/의존 스타일** (친밀 추구 vs 독립 강조)
   - 가: 안정 애착형
   - 나: 불안-집착형
   - 다: 회피 독립형

3. **갈등 대처 방식** (직면 해결 vs 회피/조율)
   - 1: 직면 해결형
   - 2: 회피/유지형
   - 3: 협력/조율형

## 프로젝트 구조

```
dot2dot/
├── lib/
│   ├── main.dart                    # 앱 진입점
│   ├── models/
│   │   └── question.dart            # 질문/답변/결과 모델
│   ├── services/
│   │   └── question_service.dart    # 질문 로딩 및 결과 계산 서비스
│   └── screens/
│       ├── home_screen.dart         # 홈 화면
│       ├── test_screen.dart         # 테스트 화면
│       └── result_screen.dart       # 결과 화면
├── assets/
│   ├── questions/                   # 질문 txt 파일들
│   │   ├── part1_A_vs_B.txt
│   │   ├── part1_B_vs_A.txt
│   │   └── ... (총 18개 파일)
│   └── results/                     # 결과 txt 파일들
│       ├── A가1.txt
│       ├── B나2.txt
│       └── ... (총 27개 가능)
└── web/                            # 웹 설정 파일들
```

## 설치 및 실행

### 사전 요구사항
- Flutter SDK (3.0.0 이상)
- Chrome 또는 다른 웹 브라우저

### 실행 방법

1. 프로젝트 클론 또는 다운로드

2. 의존성 설치
```bash
flutter pub get
```

3. 웹에서 실행
```bash
flutter run -d chrome
```

4. 빌드
```bash
flutter build web
```

빌드된 파일은 `build/web` 폴더에 생성됩니다.

## 질문 파일 형식

질문 파일은 `assets/questions/` 폴더에 위치하며, 다음과 같은 형식을 따릅니다:

### 파일명 규칙
- Part 1: `part1_[Type1]_vs_[Type2].txt` (예: part1_A_vs_B.txt)
- Part 2: `part2_[Type1]_vs_[Type2].txt` (예: part2_가_vs_나.txt)
- Part 3: `part3_[Type1]_vs_[Type2].txt` (예: part3_1_vs_2.txt)

### 파일 내용
각 파일에는 3개의 질문이 한 줄에 하나씩 작성됩니다:

```
질문 1
질문 2
질문 3
```

### 필요한 질문 파일 목록

**Part 1 (관계 범위):**
- part1_A_vs_B.txt
- part1_B_vs_A.txt
- part1_A_vs_C.txt
- part1_C_vs_A.txt
- part1_C_vs_B.txt
- part1_B_vs_C.txt

**Part 2 (친밀감 스타일):**
- part2_가_vs_나.txt
- part2_나_vs_가.txt
- part2_가_vs_다.txt
- part2_다_vs_가.txt
- part2_다_vs_나.txt
- part2_나_vs_다.txt

**Part 3 (갈등 대처):**
- part3_1_vs_2.txt
- part3_2_vs_1.txt
- part3_1_vs_3.txt
- part3_3_vs_1.txt
- part3_3_vs_2.txt
- part3_2_vs_3.txt

총 54개의 질문 (각 파일당 3개 × 18개 파일)

## 결과 파일 형식

결과 파일은 `assets/results/` 폴더에 위치하며, 파일명은 성향 조합입니다 (예: `A가1.txt`).

### 파일 구조

```
[인간관계 패턴 분석]
패턴 분석 내용...

[좋아하는 관계와 싫어하는 관계]
좋아하는 관계:
- ...

싫어하는 관계:
- ...

[장점]
1. ...
2. ...

[단점]
1. ...
2. ...

[스스로에게 물어볼 질문들]
1. ...
2. ...

개선 방향:
- ...
```

### 필요한 결과 파일

총 27개의 조합 가능 (3×3×3):
- A가1, A가2, A가3, A나1, A나2, A나3, A다1, A다2, A다3
- B가1, B가2, B가3, B나1, B나2, B나3, B다1, B다2, B다3
- C가1, C가2, C가3, C나1, C나2, C나3, C다1, C다2, C다3

## 점수 계산 방식

사용자의 답변 (1~5)을 기반으로 각 특성의 점수를 계산합니다:

1. 각 질문의 답변을 -2~2 스케일로 변환 (1=매우 그렇지 않음 → -2, 5=매우 그렇음 → 2)
2. TypeA에 긍정 점수, TypeB에 부정 점수 부여
3. 각 Part에서 가장 높은 점수를 받은 특성 선택
4. 3가지 특성을 조합하여 최종 성향 도출

## 커스터마이징

### 색상 변경
현재는 무채색(회색 계열) 디자인을 사용하고 있습니다. 색상을 변경하려면:

`lib/main.dart`에서 색상 테마를 변경:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.grey,  // 메인 색상
  brightness: Brightness.light,
  primary: Colors.grey[900]!,  // 주요 색상
  secondary: Colors.grey[700]!,  // 보조 색상
),
```

각 화면의 색상도 수정 가능:
- 홈 화면: `lib/screens/home_screen.dart`
- 테스트 화면: `lib/screens/test_screen.dart`
- 결과 화면: `lib/screens/result_screen.dart`

### 페이지당 질문 수 변경
`lib/screens/test_screen.dart`에서:
```dart
static const int questionsPerPage = 5;  // 원하는 숫자로 변경
```

### 질문 추가/수정
`assets/questions/` 폴더의 txt 파일을 직접 수정하면 됩니다.

### 결과 내용 수정
`assets/results/` 폴더의 txt 파일을 직접 수정하면 됩니다.

## 기능

- ✅ 54개 질문을 통한 성향 분석
- ✅ **한 페이지당 5개 질문 표시** (총 11페이지)
- ✅ 1~5 척도의 직관적인 답변 시스템
- ✅ 진행률 표시 및 답변 완료 카운터
- ✅ 이전/다음 네비게이션
- ✅ 반응형 디자인 (모바일/태블릿/데스크톱)
- ✅ **무채색 미니멀 디자인**
- ✅ **부드러운 페이드/슬라이드 애니메이션**
- ✅ 깔끔한 UI (숫자 동그라미 제거)
- ✅ 상세한 결과 페이지
- ✅ 텍스트 파일 기반의 쉬운 콘텐츠 관리

## 라이선스

이 프로젝트는 개인 프로젝트입니다.

## 참고사항

- 현재 프로젝트에는 샘플 질문과 결과 파일이 포함되어 있습니다.
- 실제 사용을 위해서는 모든 질문 파일(18개)과 결과 파일(27개)을 작성해야 합니다.
- 질문과 결과는 txt 파일로 관리되므로, 코드 수정 없이 내용을 쉽게 변경할 수 있습니다.