import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final void Function(File image) onPickImage;
  const ImageInput({super.key, required this.onPickImage});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (pickedFile == null) return;
    final image = File(pickedFile.path);
    setState(() => _selectedImage = image);
    widget.onPickImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: 0.6),
        ),
        clipBehavior: Clip.hardEdge,
        child: _selectedImage == null
            ? const Center(child: Icon(Icons.add_a_photo_rounded, size: 40))
            : Image.file(
                _selectedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
      ),
    );
  }
}
