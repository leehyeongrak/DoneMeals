# 던밀스(DoneMeals)

인공지능 식습관 관리 앱 (iOS 모바일 애플리케이션)

2019-1 미디어 프로젝트 (이형락, 박창현, 이지나)

---

### 기획의도

음식은 건강과 밀접한 요인 중 하나입니다.
올바른 식습관을 통해 건강한 삶을 살 수 있도록 하고 섭취한 음식을 인공지능을 활용해서 더 쉽고 간결하게 기록하도록 도움을 주는 서비스를 개발하려고 합니다.

---

### 주요기능

* 로그인(이메일로 로그인, 카카오톡 로그인(예정))
* 촬영한 이미지에 대한 머신러닝 분석
* 당일 섭취한 음식 기록(TableView&CollectionView) 및 이전 기록 열람 기능(FSCalendar)
* 유저 섭취 칼로리 및 영양분 수치 제공
* 과부족 영양분 섭취를 위한 음식 추천 피드백(예정)
* 알림 기능
* 위젯 제공

---

### 워크플로우

회원가입 및 로그인 -> 최초 로그인 시 신체정보 입력 -> 카메라 촬영 -> 이미지 분석 및 결과 도출 (미일치 시 수기입력) -> 데이터 저장 -> 수집된 데이터를 토대로 과부족 영양분에 따른 적절한 음식 추천

---

### MVC 구성

* Model

  1. 사용자정보(UserInfo)
     * uid, email, name, gender, age, height, weight, recommendedIntake
     * 권장섭취량(RecommendedIntake)
       calorie, carbo, prot, fat
  2. 식사정보(FoodInfo)
     * fid, name, intake, defaultIntake, createdTime, imageURL, nutrientInfo, bld
     * 식사시간(Bld)
       case Breakfast, case Lunch, case Dinner
  3. 영양소정보(NutrientInfo)
     * calorie, carbo, prot, fat, sugars, sodium, cholesterol, satFat, transFat
  4. 인공지능모델(FoodModel.mlmodel) 

* ViewController

  1. 최초화면(WelcomeViewController)

  2. 로그인(LoginViewController)

  3. 회원가입(SignUpViewController)

  4. 신체정보(BodyInfoViewController)

     4-1. 신체정보선택(PickerViewController)

  5. 홈(ViewController)

     5-1. 음식정보(FoodInfoViewController)

     5-2. 음식검색(SearchInfoViewController)

     5-3. 수기등록(ManualAddInfoViewController)

     5-4. 날짜선택(DateSelectViewController)

  6. 음식추천(RecommendViewController)

  7. 음식분석(PredictViewController)

     7-1. 등록(AddViewController)

     7-2. 음식검색(SearchInfoViewController)

     7-3. 날짜선택(DateSelectViewController)

  8. 기록(HistoryViewController)

  9. 더보기(MoreViewController)

     9-1. 신체정보수정(EditBodyInfoViewController)

     9-2. 알림설정(SetNotificationViewController)

     9-3. 시간선택(TimeSelectViewController)

  10. 탭바(TabBarController)

* TodayExtension

  1. 위젯(TodayViewController)

* APIService

---

### View 상세기능

* 비로그인 및 신체정보 미입력 시 기능 사용 불가
* 이메일 로그인, 카카오톡 로그인(예정) 제공
* 최초 로그인 시 성별, 연령, 신장, 체중 입력
* 탭1: 금일 섭취한 음식 정보 표시, 과부족 영양소 및 칼로리 시각적으로 표시
* 탭2: 균형잡힌 영양소를 섭취하기 위한 추천 음식정보 제공
* 탭3: 카메라 촬영(모달뷰로 띄우기, 앱델리게이트 수정)
* 탭4: 상단 캘린더 뷰(FSCalendar), 하단에 해당 날짜에 섭취한 음식 및 영양소 정보 표시(횡스크롤)
* 탭5: 신체정보 수정, 알림설정, 문의하기, 로그아웃
* 위젯: 과부족 영양소 및 칼로리 시각적으로 표시

---

### 외부 라이브러리 및 프레임워크

* KakaoSDK(카카오톡 로그인)(예정)
* FirebaseAuth(사용자 인증, 연락처 로그인)
* FirebaseDatabase(사용자, 음식 데이터 저장)
* FirebaseStorage(이미지 데이터 저장)
* CoreML(이미지 분석)
* FSCalendar(이전 기록 열람)

---

