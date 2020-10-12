import 'dart:convert';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../website.dart';

final client = http.Client();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Icon playIcon = Icon(Icons.play_circle_filled);
Icon pauseIcon = Icon(Icons.pause_circle_filled);
AudioPlayer audioPlugin = AudioPlayer();

class _MyHomePageState extends State<MyHomePage> {
  Future<String> getCurrentSong() async {
    final res = await client.get(MAIN_WEBSITE + "/nowplaying/" + STATION_ID);
    Map<String, dynamic> nowplaying = jsonDecode(res.body);
    print(nowplaying["now_playing"]["song"]["text"]);
    listenUrl = nowplaying["station"]["listen_url"];
    setState(() {
      song = nowplaying["now_playing"]["song"]["text"];
    });

    return "k";
  }

  String song = "loading...";
  Icon currentIcon;
  bool playing = false;
  String listenUrl;
  @override
  void initState() {
    super.initState();
    getCurrentSong();
    currentIcon = playIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              song,
            ),
            IconButton(
              onPressed: () {
                playing = !playing;
                setState(() {
                  currentIcon = playing ? pauseIcon : playIcon;
                });
                if (playing) {
                  audioPlugin.play(listenUrl);
                } else {
                  audioPlugin.pause();
                }
              },
              icon: currentIcon,
            ),
          ],
        ),
      ),
    );
  }
}
