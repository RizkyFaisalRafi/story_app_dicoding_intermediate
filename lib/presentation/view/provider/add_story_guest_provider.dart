import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app_dicoding_intermediate/domain/entities/add_new_story_entity.dart';
import 'package:story_app_dicoding_intermediate/domain/use_case/post_add_guest_story.dart';
import '../../../common/error/failure.dart';
import '../../../common/state_enum.dart';
import '../ui/custom_camera/camera_screen.dart';

// *Provider untuk mengelola logika fitur penambahan cerita dengan akun guest.
class AddStoryGuestProvider extends ChangeNotifier {
  AddStoryGuestProvider({
    required this.postAddGuestStory,
  });

  // *Path file gambar yang dipilih.
  String? imagePath;

  // *Objek file gambar (berbasis [XFile]) yang dipilih.
  XFile? imageFile;

  /// State permintaan, menggunakan [RequestState].
  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  // *Pesan error jika terjadi kegagalan.
  String _errorMessage = '';
  String? get errorMessage => _errorMessage;

  // *Hasil respons dari server setelah unggah cerita.
  AddNewStoryEntity? _addNewStoryEntity;
  AddNewStoryEntity? get addNewStoryEntity => _addNewStoryEntity;

  // *Controller untuk input deskripsi cerita.
  final TextEditingController _descController = TextEditingController();
  TextEditingController get descController => _descController;

  // *Key untuk validasi form.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  // *Use case untuk mengunggah cerita sebagai guest.
  PostAddGuestStory postAddGuestStory;

  // *Mengatur path file gambar.
  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  // *fungsi untuk meng-update perubahan berkas gambar.
  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  // Validator Description
  String? validateDesc(desc) {
    if (desc.isEmpty) {
      return "Deskripsi tidak boleh kosong!";
    } else if (desc.split('').length < 8) {
      return 'Deskripsi harus terdiri dari minimal 8 karakter!';
    } else {
      return null;
    }
  }

  // * Memilih Gambar dari Galeri
  onGalleryView() async {
    // * Buat inisialisasi kelas ImagePickerdi dalam fungsi tersebut.
    final ImagePicker picker = ImagePicker();

    /*
     * Karena library Image Picker tidak dapat berjalan pada platform MacOS dan
     * Linux, kita bisa memberikan pengecualian. Dengan begitu, saat aplikasi 
     * berjalan pada platform tersebut tidak dapat menjalankan fitur pilih gambar.
     */
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    // * Jalankan fungsi untuk memilih gambar dengan sumber penyimpanan berasal dari galeri.
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    /*
     * Sebelum mengolah berkas gambar, kita harus memastikan bahwa berkas yang 
     * diterima oleh Image Picker tidak null. Untuk itu, 
     * tambahkanlah pengondisian untuk memastikan berkas tersebut benar-benar berisi sebuah gambar.
     */
    if (pickedFile != null) {
      setImageFile(pickedFile);
      setImagePath(pickedFile.path);
    }
  }

  // * Memilih Gambar dari Custom Camera
  onCustomCameraView(BuildContext context) async {
    // *  Navigasi dari HomeScreen ke CameraScreen dengan menambahkan kode pada fungsi _onCustomCameraView.
    final navigator = Navigator.of(context);

    // * Buat inisialisasi kelas availableCameras di dalam fungsi tersebut.
    final cameras = await availableCameras();

    // * Variabel untuk menyimpan data gambar setelah proses navigasi selesai.
    final XFile? resultImageFile = await navigator.push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          cameras: cameras,
        ),
      ),
    );

    // *Jika gambar berhasil diambil, atur file dan path gambar.
    if (resultImageFile != null) {
      setImageFile(resultImageFile);
      setImagePath(resultImageFile.path);
    }
  }

  // *Fungsi untuk mengunggah cerita sebagai guest.
  Future<void> submitStoryGuest(BuildContext context) async {
    _state = RequestState.loading;
    notifyListeners();

    try {
      // *Validasi file gambar
      if (imagePath == null || imageFile == null) {
        _state = RequestState.error;
        _errorMessage = "File gambar belum dipilih!";
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("File gambar belum dipilih!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // *Ambil data dari input.
      final description = _descController.text;
      final String? fileName = imageFile?.name;
      // Baca file hanya sekali
      final imageBytes = await imageFile?.readAsBytes();

      // *Eksekusi use case dengan data yang disiapkan.
      final result = await postAddGuestStory.execute(
        description,
        imageBytes!,
        1.2,
        1.2,
        fileName!,
      );

      // *Menangani hasil eksekusi.
      result.fold(
        (failure) {
          _state = RequestState.error;
          _errorMessage = failure.message;
          log('Add Story Guest Provider: $_errorMessage');

          if (failure is ServerFailure) {
            _errorMessage = "Kesalahan server: ${failure.message}";
          } else if (failure is ConnectionFailure) {
            _errorMessage =
                "Tidak dapat terhubung ke server. Periksa koneksi internet Anda!";
          } else {
            _errorMessage = "Terjadi kesalahan yang tidak diketahui.";
          }

          // *Tampilkan pesan error ke pengguna
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_errorMessage),
            backgroundColor: Colors.red,
          ));
        },
        (data) {
          _state = RequestState.loaded;
          _addNewStoryEntity = data;
          // *Hapus data gambar setelah unggah berhasil.
          if (_addNewStoryEntity != null) {
            setImageFile(null);
            setImagePath(null);
          }
          log('Success: ${data.message}');
          notifyListeners();

          // *Tampilkan pesan sukses ke pengguna.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berhasil mengunggah cerita!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      );
    } catch (e) {
      _state = RequestState.error;
      _errorMessage = "Kesalahan tidak terduga: $e";
      log('Unexpected error: $e');
      notifyListeners();
    }
  }
}
