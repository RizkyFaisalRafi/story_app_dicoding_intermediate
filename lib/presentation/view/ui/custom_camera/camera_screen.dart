import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_dicoding_intermediate/presentation/view/provider/camera_provider.dart';

// * Halaman Custom Camera
class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({
    super.key,
    required this.cameras,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraProvider? _cameraProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cameraProvider == null) {
      _cameraProvider = Provider.of<CameraProvider>(context, listen: false);
      _cameraProvider!.initializeCamera(widget.cameras.first);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _cameraProvider?.disposeCamera();
    } else if (state == AppLifecycleState.resumed) {
      // Inisialisasi ulang kamera dengan kamera terakhir yang digunakan
      if (_cameraProvider?.controller == null ||
          !_cameraProvider!.isCameraInitialized) {
        final lastCamera = _cameraProvider?.isBackCameraSelected ?? true
            ? widget.cameras.first
            : widget.cameras.last;
        _cameraProvider?.initializeCamera(lastCamera);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraProvider?.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _cameraProvider = Provider.of<CameraProvider>(context);

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ambil Gambar"),
          actions: [
            IconButton(
              onPressed: () => _cameraProvider?.switchCamera(widget.cameras),
              icon: const Icon(Icons.cameraswitch),
            ),
          ],
        ),
        body: _cameraProvider!.isCameraInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(_cameraProvider!.controller!),
                  Align(
                    alignment: const Alignment(0, 0.95),
                    child: _actionWidget(),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _actionWidget() {
    return FloatingActionButton(
      heroTag: "take-picture",
      tooltip: "Ambil Gambar",
      onPressed: () async {
        final navigator = Navigator.of(context);
        final image = await _cameraProvider?.controller?.takePicture();
        navigator.pop(image);
      },
      child: const Icon(Icons.camera_alt),
    );
  }
}
