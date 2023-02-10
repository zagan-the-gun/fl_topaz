import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:async'; // ← StreamController を使うために import する必要あり

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:my_app/main.dart';

class LoadViewScreen extends StatelessWidget {
  final String paramText;
  LoadViewScreen({Key? key, required this.paramText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AI Hokusai",
      home: LoadImageWidget(
        paramText: paramText,
      ),
    );
  }
}

class LoadImageWidget extends StatefulWidget {
  final String paramText;
  const LoadImageWidget({super.key, required this.paramText});

  @override
  State<LoadImageWidget> createState() => _LoadImageWidgetState();
}

class _LoadImageWidgetState extends State<LoadImageWidget> {
  Future<String> _getFutureValue(String url) async {
    int? _http_status_code = 0;
    while (_http_status_code != 200) {
      // デバッグ用
      // while (_http_status_code != 0) {
      try {
        var response = await Dio().get(
          'https://dev-common-s3.s3.ap-northeast-1.amazonaws.com/arts/' +
              url +
              '-1.png',
        );
        _http_status_code = response.statusCode;
      } catch (e) {
        print('loading...');
        await Future<void>.delayed(const Duration(seconds: 10));
        print(e);
      }
    }
    return Future.value(url);
    // デバッグ用
    // return Future.value('8103652a-9428-4e1f-a740-ae2310473a50');
  }

  // ①Futureを定義
  Future<dynamic>? _data;

  // int _counter = 0;
  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  initState() {
    super.initState();

    // ②Futureをあらかじめ_dataに保持しておく
    _data = Future.delayed(const Duration(seconds: 1), () => '完了');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('生成画像'),
        // title: Text(widget.paramText),
      ),

      body: FutureBuilder(
        // ③FutureBuilderに_dataを渡す
        // future: _data,
        future: _getFutureValue(widget.paramText),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //接続完了
          if (snapshot.connectionState == ConnectionState.done) {
            //接続成功
            if (snapshot.hasData) {
              String url = snapshot.data;
              // return contents(data);
              return Center(
                  child: Column(
                children: [
                  Image.network(
                      'https://dev-common-s3.s3.ap-northeast-1.amazonaws.com/arts/' +
                          url +
                          '-1.png'),
                  // Text(
                  //   'https://dev-common-s3.s3.ap-northeast-1.amazonaws.com/arts/' +
                  //       url +
                  //       '-1.png',
                  //   style: const TextStyle(fontSize: 24),
                  // ),
                ],
              ));

              //接続失敗
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('エラー', style: const TextStyle(fontSize: 24)),
                  ],
                ),
              );
            }

            //接続中グルグル
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  // Text('$_counter', style: const TextStyle(fontSize: 24))
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('エラー', style: const TextStyle(fontSize: 24)),
                ],
              ),
            );
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  // Center contents(String data) {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(data, style: const TextStyle(fontSize: 24)),
  //         Text('$_counter', style: const TextStyle(fontSize: 24))
  //       ],
  //     ),
  //   );
  // }
}
