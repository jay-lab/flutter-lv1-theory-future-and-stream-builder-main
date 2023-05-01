import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 16.0,
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<int>( //-- 제네릭을 넣어주지 않아도 동작은 하지만 일반적으로 명시. 타입은 snapshot이 return하는 타입으로 설정
          //-- 이 제네렉을 설정하게 되면 밑에있는 snapshot 부분에도 타입을 명시해주는데 snapshot의 타입은 "AyncSnapshot"이다. (고정. 그냥 외우기)
          //-- FutureBuilder에 비해 StreamBuilder의 또 다른 장점은 닫는 로직이 필요없다. 자동처리 가능.(dispose(?)) TreamBuilder  뽀개버렷!(4:10)
          stream: streamNumbers(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return Column(

              // 실무에서 snapshot을 통한 렌더링 분기처리 관련 활용법
              // if(snapshot.hasData){
              //   //데이터가 있을때 위젯 렌더링
              // }
              // if(snapshot.hasError){
              //   //에러가 났을때 위젯 렌더링
              // }

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'StreamBuilder',
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  'ConState : ${snapshot.connectionState}',
                  style: textStyle,
                ),
                Text(
                  'Data : ${snapshot.data}', //-- 실습간에는 이 부분에 숫자가 출력되고있는데, setState를통해 새로 build를 하더라도 그 찰나마저 null로 돌아가지 않는다.
                  //-- 그 이유는 FutureBuilder난 StreamBuilder는 이전에 가지고있던 값을 캐싱하고 있기 때문(그래서 restart했을때만 처음에 null로 보여지는것을 볼 수 있다)
                  style: textStyle,
                ),
                Text(
                  'Error : ${snapshot.error}',
                  style: textStyle,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text('setState'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<int> getNumber() async {
    await Future.delayed(Duration(seconds: 3));

    final random = Random();

    // throw Exception('에러가 발생했습니다.');

    return random.nextInt(100);
  }

  Stream<int> streamNumbers() async* {
    for(int i = 0 ; i < 10; i ++){
      if(i == 5){
        throw Exception('i = 5');
      }

      await Future.delayed(Duration(seconds: 1));

      yield i;
    }
    //-- 위 로직에 의해 ${snapshot.data} 부분이 0부터 9까지 출력되는 동안
    //-- ${snapshot.connections.State}가 "active"
    //-- 이후 위의 for문이 다 끝나면
    //-- ${snapshot.connections.State}가 "donw"
  }
}
