import 'package:flutter/material.dart';
import 'package:musicplayer/utilities/audioFunctions.dart';

class SliderBar extends StatelessWidget {
  const SliderBar({Key key, @required this.audioFnObj, @required this.index})
      : super(key: key);

  final AudioFunctions audioFnObj;
  final int index;

  @override
  Widget build(BuildContext context) {
    double v, max;
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Current time
              StreamBuilder<Duration>(
                  stream: audioFnObj.getPosition(),
                  builder: (context, snapshot) {
                    int seconds = snapshot.hasData
                        ? snapshot.data.inSeconds - snapshot.data.inMinutes * 60
                        : 0;
                    String sec;
                    if (seconds < 10) {
                      sec = '0' + seconds.toString();
                    } else {
                      sec = seconds.toString();
                    }
                    return Text(
                      snapshot.hasData
                          ? snapshot.data.inMinutes.toString() + ':' + sec
                          : '0:00',
                      style: Theme.of(context).textTheme.caption,
                    );
                  }),

              //Full time
              StreamBuilder<Duration>(
                  stream: audioFnObj.getLength(),
                  builder: (context, snapshot) {
                    max = snapshot.data != null
                        ? snapshot.data.inSeconds.toDouble()
                        : 0;
                    int seconds = snapshot.hasData
                        ? snapshot.data.inSeconds - snapshot.data.inMinutes * 60
                        : 0;
                    String sec;
                    if (seconds < 10) {
                      sec = '0' + seconds.toString();
                    } else {
                      sec = seconds.toString();
                    }
                    return Text(
                      snapshot.hasData
                          ? snapshot.data.inMinutes.toString() + ':' + sec
                          : '0:00',
                      style: Theme.of(context).textTheme.caption,
                    );
                  }),
            ],
          ),

          //Slider
          StreamBuilder<Duration>(
              stream: audioFnObj.getPosition(),
              builder: (context, snapshot) {
                v = snapshot.hasData ? snapshot.data.inSeconds.toDouble() : 0;
                return Slider(
                  min: 0,
                  max: max,
                  value: v,
                  onChanged: (val) async {
                    int result = await audioFnObj
                        .changeSlider(Duration(seconds: val.toInt()));
                    v = result.toDouble();
                  },
                );
              }),
        ],
      ),
    );
  }
}
