import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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

/*
 * Kelas WidgetsBindingObserver ini berfungsi sebagai pengamat siklus aplikasi.
 * Ketika siklus berubah, kelas ini akan memberikan pemberitahuan untuk melakukan 
 * proses tertentu. Kita dapat melakukan extend kelas _CameraScreenState 
 * dengan WidgetsBindingObserver. 
 */
class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  // * Variabel untuk mengecek persiapan kamera dan mengontrol penggunaan kamera.
  bool _isCameraInitialized = false;
  CameraController? controller;

  // * Variabel baru untuk mengecek perubahan jenis kamera.
  bool _isBackCameraSelected = true;

  @override
  void initState() {
    // * observasi kelas dengan menambahkan baris kode berikut pada method initState.
    WidgetsBinding.instance.addObserver(this);

    onNewCameraSelected(widget.cameras.first);
    super.initState();
  }

  // * Untuk menangani perubahan siklus aplikasi
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // * Beberapa baris kode berikut untuk menangani perubahan siklus aplikasi.
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    log('Dispose Work');
    // * Membatalkan proses observasi apabila halaman sudah tidak berada pada widget tree.
    WidgetsBinding.instance.removeObserver(this);

    controller?.dispose();
    super.dispose();
  }

  // * Bangun sebuah fungsi baru bernama onNewCameraSelected untuk menangani inisialisasi kamera.
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    // * Beri inisialisasi camera controller dan lakukan proses dispose pada controller sebelumnya.
    final previousCameraController = controller;
    final cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );
    await previousCameraController?.dispose();

    /*
     * Membungkus perintah tersebut menggunakan try-catch untuk mengetahui 
     * kondisi error ketika inisialisasi kamera tidak berhasil.
     */
    try {
      // * lakukan inisialisasi kamera dengan perintah berikut.
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    /*
     * Gunakan method mounted untuk mengecek CameraScreen berada di widget tree
     * atau tidak. Kemudian, lakukan pembaruan variabel controller dan 
     * _isCameraInitialized berdasarkan controller yang baru.
     */
    if (mounted) {
      setState(() {
        controller = cameraController;
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ambil Gambar"),
          actions: [
            IconButton(
              onPressed: () => _onCameraSwitch(),
              icon: const Icon(Icons.cameraswitch),
            ),
          ],
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              /*
               * Ketika kamera sedang melakukan inisialisasi, layar akan 
               * menampilkan indikator loading. Apabila proses berhasil dan 
               * kamera siap dipakai, tampilkan camera feed.
               */
              _isCameraInitialized
                  ? CameraPreview(controller!)
                  : const Center(child: CircularProgressIndicator()),
              Align(
                alignment: const Alignment(0, 0.95),
                child: _actionWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionWidget() {
    return FloatingActionButton(
      heroTag: "take-picture",
      tooltip: "Ambil Gambar",
      onPressed: () => _onCameraButtonClick(),
      child: const Icon(Icons.camera_alt),
    );
  }

  Future<void> _onCameraButtonClick() async {
    final navigator = Navigator.of(context);
    final image = await controller?.takePicture();
    // * Setelah gambar berhasil diambil, kembalikan ke halaman utama untuk ditampilkan pada layar aplikasi.
    navigator.pop(image);
  }

  void _onCameraSwitch() async {
    final cameras = await availableCameras();
    for (var camera in cameras) {
      log("Camera Test: $camera");
    }

    /*
     * Apabila perangkat memiliki lebih dari satu kamera, Anda bisa tukar jenis 
     * kamera menggunakan kamera depan. Namun, untuk perangkat yang memiliki 
     * satu kamera, Anda bisa lakukan pengondisian agar tidak melakukan 
     * peralihan jenis kamera.
     */
    if (widget.cameras.length == 1) return;

    // * Atur _isCameraInitialized menjadi false untuk persiapan pergantian kamera.
    setState(() {
      _isCameraInitialized = false;
    });

    // * Ubahlah jenis kamera menggunakan properti cameras pada CameraScreen.
    onNewCameraSelected(
      widget.cameras[_isBackCameraSelected ? 1 : 0],
    );

    // * Perbarui kondisi jenis kamera setelah melakukan inisialisasi kamera depan.
    setState(() {
      _isBackCameraSelected = !_isBackCameraSelected;
    });
  }
}
