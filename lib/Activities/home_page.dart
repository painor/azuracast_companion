import 'dart:convert';

import 'package:audioplayer/audioplayer.dart';
import 'package:azuracast_companion/Widgets/audio_slider.dart';
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

AudioPlayer audioPlugin = AudioPlayer();

class _MyHomePageState extends State<MyHomePage> {
  void getListenUrl() async {
    final res = await client.get(MAIN_WEBSITE + "/nowplaying/" + STATION_ID);
    Map<String, dynamic> nowplaying = jsonDecode(res.body);
    listenUrl = nowplaying["station"]["listen_url"];
  }

  void getCurrentSong() async {
    final res = await client.get(MAIN_WEBSITE + "/nowplaying/" + STATION_ID);
    Map<String, dynamic> nowplaying = jsonDecode(res.body);
    print(nowplaying["now_playing"]["song"]["text"]);
    listenUrl = nowplaying["station"]["listen_url"];

    setState(() {
      songTitle = nowplaying["now_playing"]["song"]["title"];
      artistName = nowplaying["now_playing"]["song"]["artist"];
      albumUrl = nowplaying["now_playing"]["song"]["art"];
    });
    final after = nowplaying["now_playing"]["played_at"] +
        nowplaying["now_playing"]["duration"];
    var date = new DateTime.fromMillisecondsSinceEpoch(after * 1000);
    Duration dur = date.difference(DateTime.now());
    Future.delayed(Duration(seconds: dur.inSeconds + 3), () {
      getCurrentSong();
    });
  }

  String songTitle = "loading...";
  String artistName = "loading...";

  String albumUrl;
  String song = "loading...";
  Icon currentIcon;
  bool playing = false;
  String listenUrl;
  returnListTitle() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(left: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                left: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(Icons.autorenew, color: Colors.white),
      ),
      title: Text(
        songTitle,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Icon(Icons.mic, color: Colors.yellowAccent),
          Text(artistName, style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }

  createMakeCard() {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: returnListTitle(),
      ),
    );
  }

  Icon playIcon = Icon(
    Icons.play_circle_filled,
  );
  Icon pauseIcon = Icon(Icons.pause_circle_filled);

  @override
  void initState() {
    super.initState();
    getListenUrl();
    getCurrentSong();

    currentIcon = playIcon;
  }

  @override
  Widget build(BuildContext context) {
    if (albumUrl == null) {
      return Text("loading");
    }
    return Scaffold(
      backgroundColor: Color.fromRGBO(64, 75, 96, .9),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.75,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image(
                  image: NetworkImage(albumUrl),
                ),
              ),
            ),
          ),
          createMakeCard(),
          Expanded(
              child: SliderAudio(
            maxValue: 110,
          )),
          Expanded(
            child: FittedBox(
              child: IconButton(
                iconSize: MediaQuery.of(context).size.width * 0.10,
                padding: EdgeInsets.all(2),
                onPressed: () {
                  playing = !playing;
                  setState(() {
                    currentIcon = playing ? pauseIcon : playIcon;
                  });
                  if (playing) {
                    audioPlugin.play(listenUrl);
                  } else {
                    audioPlugin.stop();
                  }
                },
                icon: currentIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
