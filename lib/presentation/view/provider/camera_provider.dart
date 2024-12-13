import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider with ChangeNotifier {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isBackCameraSelected = true;

  CameraController? get controller => _controller;
  bool get isCameraInitialized => _isCameraInitialized;

  Future<void> initializeCamera(CameraDescription cameraDescription) async {
    final previousCameraController = _controller;
    _controller = CameraController(cameraDescription, ResolutionPreset.medium);
    await previousCameraController?.dispose();

    try {
      await _controller!.initialize();
      _isCameraInitialized = _controller!.value.isInitialized;
    } on CameraException catch (e) {
      log('Error initializing camera: $e');
    }

    // Pastikan notifyListeners dipanggil setelah widget tree selesai dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void switchCamera(List<CameraDescription> cameras) {
    if (cameras.length == 1) return;

    _isBackCameraSelected = !_isBackCameraSelected;
    initializeCamera(cameras[_isBackCameraSelected ? 1 : 0]);
  }

  void disposeCamera() {
    _controller?.dispose();
    _controller = null;
    _isCameraInitialized = false;

    // Pastikan notifyListeners dipanggil setelah widget tree selesai dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
