import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/screens/CSelectScreen/select_screen.dart';
import 'package:musicplayer/utilities/constants.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    Key key,
    @required this.title,
    @required this.isHome,
  });

  final String title;
  final bool isHome;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: kRaisedButtonShadow,
            child: RaisedButton(
              onPressed: () => isHome
                  ? Navigator.pushNamed(context, SelectScreen.id)
                  : Navigator.pop(context),
              child: Icon(
                  isHome
                      ? FontAwesomeIcons.angleDown
                      : FontAwesomeIcons.angleLeft,
                  color: Colors.white),
            ),
          ),
          isHome
              ? Text(
                  title,
                  style: Theme.of(context).textTheme.headline5,
                )
              : Column(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(
                      'Tap & hold to get details',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
          Container(
            decoration: kRaisedButtonShadow,
            child: RaisedButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              child: Icon(FontAwesomeIcons.bars, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
