import 'package:awspro/gallery_page.dart';
import 'package:awspro/storage_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_page.dart';

class CameraFlow extends StatefulWidget {
  const CameraFlow({ Key? key, required this.shouldLogOut}) : super(key: key);
  final VoidCallback shouldLogOut;

  @override
  _CameraFlowState createState() => _CameraFlowState();
}

class _CameraFlowState extends State<CameraFlow> {
  late CameraDescription _camera;
  bool _shouldShowCamera = false;
  late StorageService _storageService;

  @override
  initState() {
    super.initState();
    _getCamera();
    _storageService = new StorageService();
    _storageService.getImages();
  }

  _getCamera() async {
    final cameraList = await availableCameras();
    setState(() {
      final firstCamera = cameraList.first;
      this._camera = firstCamera;
    });
  }
  List<MaterialPage> get _pages {
    return [
      MaterialPage(child : 
      GalleryPage(
        shouldLogOut: widget.shouldLogOut,
        shouldShowCamera: () => _toggleCameraOpen(true),
        imageUrlsController: _storageService.imgUrlController,
      )),
      if (_shouldShowCamera)
        MaterialPage(child : CameraPage(
          camera : _camera,
          didProvideImagePath: (imgPath) {
            this._toggleCameraOpen(false);
            this._storageService.uploadImageAtPath(imgPath);
          },
        ))
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages : _pages,
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  _toggleCameraOpen(bool isOpen) {
    setState(() {
      this._shouldShowCamera = isOpen;
    });
  }
}