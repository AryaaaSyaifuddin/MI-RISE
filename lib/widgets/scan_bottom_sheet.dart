import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ScanBottomSheet extends StatefulWidget {
  final CameraDescription camera;

  const ScanBottomSheet({super.key, required this.camera});

  @override
  State<ScanBottomSheet> createState() => _ScanBottomSheetState();
}

class _ScanBottomSheetState extends State<ScanBottomSheet> {
  CameraController? _controller;
  bool isReady = false;

  String selectedType = 'Masuk';
  String locationStatus = 'Cek lokasi...';

  @override
  void initState() {
    super.initState();
    _initCamera();
    checkLocation();
  }

  Future<void> checkLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          locationStatus = 'GPS tidak aktif';
        });
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          locationStatus = 'Izin lokasi ditolak';
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationStatus = 'Izin lokasi permanen ditolak';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Ganti dengan koordinat kantor yang valid
      const officeLat = -7.052190779774966;
      const officeLng = 112.57879026209491;

      final distance = Geolocator.distanceBetween(
        officeLat,
        officeLng,
        position.latitude,
        position.longitude,
      );

      setState(() {
        if (distance <= 100) {
          locationStatus = 'Dalam radius (OK)';
        } else {
          locationStatus = 'Di luar area';
        }
      });
    } catch (_) {
      setState(() {
        locationStatus = 'Gagal cek lokasi';
      });
    }
  }

  Future<void> _initCamera() async {
    final controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller.initialize();

    if (!mounted) {
      await controller.dispose();
      return;
    }

    setState(() {
      _controller = controller;
      isReady = true;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  bool get isInsideRadius => locationStatus.contains('Dalam');

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Scan Absensi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: isReady && _controller != null
                    ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CameraPreview(_controller!),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),

                  // 🔘 TOGGLE MASUK / PULANG (MODERN)
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F3F6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: ["Masuk", "Pulang"].map((e) {
                        final isActive = selectedType == e;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedType = e;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 250),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isActive ? const Color.fromARGB(255, 185, 26, 26) : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  e,
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Colors.black54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 20),

                  // ⏰ JAM (MINIMAL STYLE)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Waktu",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        TimeOfDay.now().format(context),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // 💡 INFO TEXT (SUBTLE, BUKAN CARD BERAT)
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 18, color: Colors.grey),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Pastikan wajah terlihat jelas dan berada di dalam frame",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // 🔥 BUTTON MODERN
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final image = await _controller!.takePicture();

                        print("Type: $selectedType");
                        print("Image: ${image.path}");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 185, 26, 26),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Ambil Foto & Absen",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                ],
              ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }
}
