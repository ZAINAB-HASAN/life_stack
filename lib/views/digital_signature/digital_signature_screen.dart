import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';

class DigitalSignatureScreen extends StatefulWidget {
  const DigitalSignatureScreen({super.key});

  @override
  State<DigitalSignatureScreen> createState() => _DigitalSignatureScreenState();
}

class _DigitalSignatureScreenState extends State<DigitalSignatureScreen> {
  Uint8List? signature;
  final signatureController = SignatureController(
    penColor: Colors.green,
    penStrokeWidth: 3,
    exportPenColor: Colors.amber,
    exportBackgroundColor: Colors.black,
  );

  @override
  void dispose() {
    super.dispose();
    signatureController.dispose();
  }

  /// ✅ SAVE AS IMAGE
  Future<File?> saveImage() async {
    final Uint8List? data = await signatureController.toPngBytes();

    if (data == null) return null;

    /// 👇 DOWNLOAD FOLDER
    final directory = Directory('/storage/emulated/0/Download');

    final file = File("${directory.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png");

    await file.writeAsBytes(data);

    return file;
  }


  /// ✅ SAVE AS PDF
  Future<File?> savePDF() async {
    final hasPermission = await requestPermission();
    if (!hasPermission) {
      print("Permission denied");
      return null;
    }

    final Uint8List? data = await signatureController.toPngBytes();
    if (data == null) return null;

    final pdf = pw.Document();
    final image = pw.MemoryImage(data);

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(child: pw.Image(image)),
      ),
    );

    final directory = Directory('/storage/emulated/0/Download');

    final file = File(
      "${directory.path}/signature_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );

    await file.writeAsBytes(await pdf.save());

    return file;
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true;
      }

      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Document')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 250, // 🔥 IMPORTANT FIX
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Signature(
                controller: signatureController,
                backgroundColor: Colors.grey[200]!,
              ),
            ),
            const SizedBox(height: 20),

            /// ✅ BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    signatureController.clear();
                  },
                  child: const Text("Clear"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final file = await saveImage();
                    if (file != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Saved: ${file.path}")),
                      );
                      print('ONCLICKImageFile: ${file.path}');
                    }
                  },
                  child: const Text("Save Image"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final file = await savePDF();
                    if (file != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("PDF Saved: ${file.path}")),
                      );
                      print('ONCLICKPDF: ${file.path}');
                    }
                  },
                  child: const Text("Save PDF"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
