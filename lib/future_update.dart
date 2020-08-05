//DownloadAudio object = DownloadAudio();
//final Map data = themeNotifier
//    .apiData[themeNotifier.apiSelectedIndex];
//
////Getting default path if exists
//String path = await themeNotifier.getDefaultPath();
//if (path == '') {
////Getting path
//path = await FilePicker.getDirectoryPath() ?? '';
//print(path);
//
////Asking for setting as default
//showDialog(
//context: context,
//builder: (_) => AlertDialog(
//title: Text(
//'Set Download Path',
//style: Theme.of(context)
//    .textTheme
//    .headline1,
//),
//content: Text(
//'Do you want to set this path as your default download path'),
//actions: [
//FlatButton(
//onPressed: () =>
//Navigator.pop(context),
//child: Text('No'),
//),
//FlatButton(
//onPressed: () {
//themeNotifier.setDefaultPath(path);
//Navigator.pop(context);
//},
//child: Text('Yes'),
//)
//],
//));
//}
//
////Making sure path is valid
//if (path != '') {
//object.download(data, path, widget.audioFnObj.len,
//themeNotifier);
//FlutterToast.showToast(msg: 'Download has started');
//}
//}