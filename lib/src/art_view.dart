import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:async'; // ← StreamController を使うために import する必要あり

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:my_app/main.dart';

class ArtViewScreen extends StatelessWidget {
  // final Map<String, String> paramText;
  final String paramText;
  ArtViewScreen({Key? key, required this.paramText}) : super(key: key);
  //print(paramText['filename']);

  //ArtViewScreen(this.paramText);
  //  String paramText;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "生成画像",
      home: LoadImageWidget(
        paramText: paramText,
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('AIお絵描き'),
  //     ),
  //     body: Center(
  //       // child: Image.network(
  //       //     'https://dev-common-s3.s3.ap-northeast-1.amazonaws.com/arts/157a48b3-440e-4f42-a748-51c1b13c2e0f-1.png')

  //       child: CachedNetworkImage(
  //         imageUrl:
  //             'https://images.unsplash.com/photo-1532264523420-881a47db012d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9',
  //       ),

  //       // child: CachedNetworkImage(
  //       //   imageUrl:
  //       //       'https://dev-common-s3.s3.ap-northeast-1.amazonaws.com/arts/' +
  //       //           paramText +
  //       //           '-1.png',
  //       // ),

  //     ),
  //   );
  // }
}

class LoadImageWidget extends StatefulWidget {
  final String paramText;
  const LoadImageWidget({super.key, required this.paramText});

  @override
  State<LoadImageWidget> createState() => _LoadImageWidgetState();
}

class _LoadImageWidgetState extends State<LoadImageWidget> {
  String fileName = '157a48b3-440e-4f42-a748-51c1b13c2e0f';

  // StreamBuilder に渡す stream を作成
  final Stream<String> _image_url = ((fileName) {
    late final StreamController<String> controller;
    controller = StreamController<String>(
      onListen: () async {
        print('Start');

        int _counter = 0;
        int? _http_status_code = 0;
        print(fileName);

        while (_http_status_code != 200) {
          //   await Future.delayed(Duration(seconds: 1));
          print('DEAD BEEF fileName: ');
          print(fileName);
          var response = await Dio().get(
            'https://dev-common-s3.s3.ap-northeast-1.amazonaws.com/arts/' +
                '157a48b3-440e-4f42-a748-51c1b13c2e0f' +
                '-1.png',
          );
          _http_status_code = response.statusCode;
          await Future<void>.delayed(const Duration(seconds: 1));
          // _counter++;
          // print(_counter);
          //   print(_http_status_code);
          // if (_counter == 10) break;
          //   if (_http_status_code == 200) break;
          //   await Future<void>.delayed(const Duration(seconds: 1));
        }
        // controller.add('');
        // await Future<void>.delayed(const Duration(seconds: 1));
        controller.sink.add(fileName);

        await controller.close();
      },
    );

    return controller.stream;
  })('');

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: Container(
        alignment: FractionalOffset.center,
        color: Colors.white,
        child: StreamBuilder<String>(
          initialData: widget.paramText,
          stream: _image_url,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            List<Widget> children;

            // Error が発生したとき
            if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Stack trace: ${snapshot.stackTrace}'),
                ),
              ];
            } else {
              switch (snapshot.connectionState) {

                // 初期時（今回はすぐ waiting に移るので表示されているようには見えない）
                case ConnectionState.none:
                  children = const <Widget>[
                    Icon(
                      Icons.info,
                      color: Colors.blue,
                      size: 60,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Select a lot'),
                    ),
                  ];
                  break;

                // 接続中の時（waiting が終わったら非同期処理が開始される）
                case ConnectionState.waiting:
                  children = const <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting image...'),
                    ),
                  ];
                  break;

                // 非同期処理実行中の時
                //snapshot から取得したデータをもとに画面を作成
                case ConnectionState.active:
                  children = <Widget>[
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('\$${snapshot.data}'),
                    ),
                  ];
                  break;

                // 非同期処理が終わった時
                // 最後に取得したデータをもとに画面を作成
                case ConnectionState.done:
                  children = <Widget>[
                    const Icon(
                      Icons.info,
                      color: Colors.blue,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                          '\$${snapshot.data} ${widget.paramText}  (closed)'),
                    ),
                  ];

                  break;
              }
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            );
          },
        ),
      ),
    );
  }
}
