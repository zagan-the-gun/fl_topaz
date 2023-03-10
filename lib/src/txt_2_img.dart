import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

import 'load_view.dart';

import 'dart:math';

class Txt2ImgScreen extends StatelessWidget {
  const Txt2ImgScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Topaz',
      home: Scaffold(
        appBar: AppBar(
          title: Text('AI Topaz'),
          // 右側のアイコン
          // actions: <Widget>[
          //   IconButton(onPressed: () {}, icon: Icon(Icons.account_circle))
          // ]
        ),
        body: SingleChildScrollView(
          child: ChangeForm(),
        ),
      ),
    );
  }
}

class ChangeForm extends StatefulWidget {
  @override
  _ChangeFormState createState() => _ChangeFormState();
}

class _ChangeFormState extends State<ChangeForm> {
  final _formKey = GlobalKey<FormState>();

  String _prompt =
      "epic portrait An muscular waitress with short sleeved uniform carrying food, highly detailed, digital painting, artstation, concept art, sharp focus, illustration, art by artgerm and greg rutkowski and alphonse mucha";
  // String _seed = '3972771385'; //32bit乱数毎回入れた方が良いかも?
  // String _seed = rng.nextInt(pow(2, 32).toInt() - 1);
  String _seed = Random().nextInt(0x7FFFFFFF + 1).toString();
  String _n_iter = '1';
  String _scale = '7.0';
  String _ddim_steps = '32'; //64が良いかも？
  String _engine = 'sd';
  String _filename = '';

  String _response = '';

  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: <Widget>[
                new TextFormField(
                  initialValue: _prompt,
                  enabled: true,
                  maxLength: 1000,
                  maxLengthEnforcement: MaxLengthEnforcement.none,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                    hintText: '呪文を詠唱して下さい',
                    labelText: 'prompt *',
                  ),
                  validator: (value) {
                    return value!.isEmpty ? '必須入力です' : null;
                  },
                  onSaved: (value) {
                    this._prompt = value!;
                  },
                ),
                new TextFormField(
                  initialValue: _seed,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  enabled: true,
                  maxLength: 20,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: '乱数の種',
                    labelText: 'seed',
                  ),
                  validator: (value) {
                    return value!.isEmpty ? '必須入力です' : null;
                  },
                  onSaved: (value) {
                    this._seed = value!;
                  },
                ),
                new TextFormField(
                  initialValue: _n_iter,
                  enabled: true,
                  maxLength: 10,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.disabled,
                  decoration: const InputDecoration(
                    hintText: '探索数',
                    labelText: 'n_iter',
                  ),
                  validator: (value) {
                    return value!.isEmpty ? '必須入力です' : null;
                  },
                  onSaved: (value) {
                    this._n_iter = value!;
                  },
                ),
                new TextFormField(
                  initialValue: _scale,
                  enabled: true,
                  maxLength: 10,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.disabled,
                  decoration: const InputDecoration(
                    hintText: 'サイズ',
                    labelText: 'scale',
                  ),
                  validator: (value) {
                    return value!.isEmpty ? '必須入力です' : null;
                  },
                  onSaved: (value) {
                    this._scale = value!;
                  },
                ),
                new TextFormField(
                  initialValue: _ddim_steps,
                  enabled: true,
                  maxLength: 10,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.disabled,
                  decoration: const InputDecoration(
                    hintText: '画像精度',
                    labelText: 'ddim_steps',
                  ),
                  validator: (value) {
                    return value!.isEmpty ? '必須入力です' : null;
                  },
                  onSaved: (value) {
                    this._ddim_steps = value!;
                  },
                ),
                ElevatedButton(
                  onPressed: _submission,
                  child: Text('生成'),
                )
              ],
            )));
  }

  void _submission() async {
    if (this._formKey.currentState!.validate()) {
      this._formKey.currentState?.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data')),
      );
      print(this._prompt);
      print(this._seed);
      print(this._scale);

      String body = json.encode({
        "prompt": _prompt,
        "seed": _seed,
        "n_iter": _n_iter,
        "scale": _scale,
        "ddim_steps": _ddim_steps,
      });
      final headers = {
        'Content-Type': 'application/json',
        // 'Access-Control-Allow-Origin': 'true'
      };
      try {
        print('DEAD BEEF 1');
        var response = await Dio().post(
            'https://sd.tokyo-tsushin.com/api/txt2img',
            data: body,
            options: Options(headers: headers));
        Map<String, dynamic> map = jsonDecode(response.toString());

        // var response = await http.post(
        //     Uri.parse('https://sd.tokyo-tsushin.com/api/txt2img'),
        //     headers: headers,
        //     body: body);
        // Map<String, dynamic> map = jsonDecode(response.body.toString());

        _filename = map['filename'];
      } catch (e) {
        print(e);
      }

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoadViewScreen(paramText: _filename)),
      );
    }
  }
}
