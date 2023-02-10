import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ヘルプ'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            child: Text('利用方法', style: TextStyle(fontSize: 32.0)),
          ),
          Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('呪文は英語をスペース区切りで入力しましょう。',
                      style: TextStyle(fontSize: 18.0)),
                  Text('画像の生成にはかなりの時間がかかります、そのままお待ちください。',
                      style: TextStyle(fontSize: 18.0))
                ],
              ))
        ],
      ),
    );
  }
}
