import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_project/display_image_screen.dart';

class CameraPage extends StatefulWidget {
  final String userId;
  const CameraPage({super.key, required this.userId});
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras = [];
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final ImagePicker _picker = ImagePicker();
  int selectedCameraIndex = 0;
  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void _switchCamera() {
    selectedCameraIndex = selectedCameraIndex == 0 ? 1 : 0;
    _controller = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    await Permission.camera.request();
  }

  void _closeCamera() {
    _controller?.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayImageScreen(
              imagePath: pickedFile.path,
              userId: widget.userId,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nu s-a putut face poza!')),
      );
    }
  }

  Future<void> _toggleFlash() async {
    setState(() {
      isFlashOn = !isFlashOn;
    });
    await _controller
        ?.setFlashMode(isFlashOn ? FlashMode.torch : FlashMode.off);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller!);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/scanCamera.svg', // Replace with your asset path
                width: MediaQuery.of(context).size.width *
                    0.9, // Adjust the size as needed
                color: Colors.black
                    .withOpacity(0.8), // Adjust the color and opacity as needed
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0),
              child: FloatingActionButton(
                onPressed: _toggleFlash,
                backgroundColor: Theme.of(context).colorScheme.primary,
                mini: true,
                heroTag: 'flashControlButton',
                child: Icon(
                  isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              onPressed: _pickImageFromGallery,
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: AutoSizeText(
                'Galerie',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface),
                minFontSize: 15,
                maxFontSize: 30,
              ),
              icon: Icon(Icons.photo_library,
                  color: Theme.of(context).colorScheme.onSurface),
              heroTag: 'galleryButton',
            ),
            FloatingActionButton(
              onPressed: () async {
                await _requestPermission();
                if (await Permission.camera.isGranted) {
                  try {
                    await _initializeControllerFuture;
                    final image = await _controller!.takePicture();
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisplayImageScreen(
                          imagePath: image.path,
                          userId: widget.userId,
                        ),
                      ),
                    );
                  } catch (e) {
                    print(e);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Accesul la camera nu este permis!')),
                  );
                }
              },
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.surface,
              heroTag: 'cameraButton',
              child: Icon(
                Icons.camera_alt,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            FloatingActionButton.extended(
              onPressed: _switchCamera,
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: AutoSizeText(
                'Roteste',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                minFontSize: 15,
                maxFontSize: 30,
              ),
              icon: Icon(
                Icons.cameraswitch,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              heroTag: 'rotateCameraButton',
            ),
          ],
        ),
      ),
    );
  }
}
