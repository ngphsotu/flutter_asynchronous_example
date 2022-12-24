// @dart = 2.9
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MaterialApp(
    home: MyPage(),
  ));
}

class MyPage extends StatefulWidget {
  const MyPage({
    Key key,
  }) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool loading = false;
  Uint8List image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          ElevatedButton(
              child: const Text('takeAndResizePhoto'),
              onPressed: () {
                setState(() => loading = true);
                takeAndResizePhoto()
                    .then((value) => setState(() => image = value))
                    .whenComplete(() => setState(() => loading = false));
              }),
          if (loading) const CircularProgressIndicator(),
          if (image != null) Image.memory(image),
        ],
      ),
    ));
  }

  Future<Uint8List> takeAndResizePhoto() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    var image = img.decodeImage(await file.readAsBytes());
    // hàm này siêu nặng
    final thumbnail = img.copyResize(image, width: 12000);

    return Uint8List.fromList(img.encodePng(thumbnail));
  }
}
