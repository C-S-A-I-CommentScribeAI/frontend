import 'package:flutter/material.dart';
import 'package:frontend/user/screens/write_screen.dart';
import 'package:intl/intl.dart';

// 결제 완료 후 이 페이지로 넘어가는 동시에 스낵바로 '주문 완료되었습니다'라고 뜨게 구현(API 할 때 구현할 예정)
class CompletePage extends StatelessWidget {
  final bool? isWritten;
  final Map<String, dynamic>? menu;

  const CompletePage(
      {this.isWritten = false, this.menu, super.key}); // null일 경우를 대비하여 기본값을 설정

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat('###,###,###,###'); // 숫자 세자리마다 콤마 넣는 코드

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          '주문 내역',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF374AA3),
        actions: const [
          // 홈 화면으로 이동
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.home,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 24.0),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              shadowColor: const Color(0xFF374AA3),
              elevation: 3.0, // 그림자 설정
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 가게 명
                            Text(
                              '피자에 미치다 교대역점',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),

                            // 배달 상태
                            Text(
                              '배달 완료',
                              style: TextStyle(
                                color: Color(0xFF808080),
                              ),
                            ),
                          ],
                        ),

                        // 가게 로고
                        Image.asset(
                            'assets/images/olive.png'), // pull 받으면 바꿀 예정
                      ],
                    ),
                    const SizedBox(height: 5),

                    // 주문 내용
                    const Text(
                      '1. 페퍼로니 알리오올리오\n2. 시칠리안 갈릭쉬림프',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 34),

                    // 주문 가격
                    Text(
                      '합계 : ${f.format(20000)}원', // 숫자 세자리마다 콤마 넣는 법
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 리뷰 쓰기 버튼
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          isWritten!
                              ? ''
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const writeReviewPage(
                                        '피자에 미치다 교대역점',
                                        null), // 나중에 변수로 집어넣을 계획
                                  ),
                                );
                        }, // 리뷰 페이지로 이동
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(302, 39),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          side: const BorderSide(
                            color: Color(0xFF7E7EB2),
                            width: 2.0,
                          ),
                        ),
                        child: Text(
                          isWritten! ? '작성된 리뷰' : '리뷰 쓰기',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}