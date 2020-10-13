import 'dart:async';

import 'package:flutter/material.dart';

class SliderAudio extends StatefulWidget {
  double maxValue;

  SliderAudio({@required final this.maxValue});

  @override
  _SliderAudioState createState() => _SliderAudioState();
}

class _SliderAudioState extends State<SliderAudio> {
  String getReadableDate(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  int currentDate = 0;

  @override
  void initState() {
    new Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (currentDate > widget.maxValue) {
          return;
        }
        currentDate++;
      });
      print("ok");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Center(
              child: Container(
                  padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                  child: Text(
                    getReadableDate(Duration(seconds: currentDate)),
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ))),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackShape: CustomTrackShape(),
              ),
              child: Slider(
                value: currentDate.toDouble(),
                max: widget.maxValue,
                min: 0,
                onChanged: (double value) {},
              ),
            ),
          ),
          Center(
              child: Container(
                  padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                  child: Text(
                    getReadableDate(Duration(seconds: widget.maxValue.floor())),
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ))),
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
