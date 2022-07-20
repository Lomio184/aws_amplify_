import 'package:awspro/analytics_events.dart';
import 'package:awspro/analytics_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({ Key? key, 
  required this.camera, 
  required this.didProvideImagePath }) : super(key: key);
  final CameraDescription camera;
  final ValueChanged didProvideImagePath;

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : FutureBuilder<void>(
        future : _initializeControllerFuture,
        builder : (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            return CameraPreview(this._controller);
          } else {
            return Center(child : CircularProgressIndicator());
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        child : Icon(Icons.camera,),
        onPressed: _takePicture,
      ),
    );
  }

  _takePicture() async {
    try {
      await _initializeControllerFuture;
      final tmpDiretory = await getTemporaryDirectory();
      final filePath = '${DateTime.now().millisecondsSinceEpoch}.png';
      final path = join(tmpDiretory.path, filePath);

      await _controller.takePicture();
      widget.didProvideImagePath(path);
      AnalyticsService.log(
        TakePictureEvent(cameraDirection: 
        widget.camera.lensDirection.toString())
      );
    } catch (e) {
      print(e);
    }
  }
}