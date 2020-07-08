import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicplayer/theme/theme_notifier.dart';
import 'package:musicplayer/utilities/constants.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class LocalArt extends StatelessWidget {
  const LocalArt({Key key, @required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return Column(
      children: [
        Container(
          decoration: kRaisedButtonShadow,
          child: RaisedButton(
            onPressed: () async {
              //Getting file from User
              final _picker = ImagePicker();
              final File _pickedFile = await _picker
                  .getImage(source: ImageSource.gallery)
                  .then((value) => File(value.path));

              //Editing Image
              final File _editedFile = await ImageCropper.cropImage(
                  cropStyle: CropStyle.circle,
                  androidUiSettings: AndroidUiSettings(
                    toolbarTitle: 'Edit Album Art',
                    toolbarColor: Colors.white,
                    activeControlsWidgetColor: Color(0xff505050),
                  ),
                  aspectRatioPresets: [
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.square
                  ],
                  sourcePath: _pickedFile.path);

              //Saving Image if edit was complete
              if (_editedFile != null) {
                final Directory _localDir =
                    await getApplicationDocumentsDirectory();
                final File _finalImage = await _editedFile
                    .copy(_localDir.path + '/' + p.basename(_editedFile.path));
                themeNotifier.setArt(_finalImage.path, index);
              }
            },
            child: Icon(
              Icons.image,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Gallery',
          style: Theme.of(context).textTheme.headline2,
        )
      ],
    );
  }
}
