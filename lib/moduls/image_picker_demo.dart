import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerExample extends StatefulWidget {
  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles = [];

  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage(limit: 5);

    if (selectedImages != null) {
      int totalSelected = _imageFiles!.length + selectedImages.length;
      int ablelToSelect = (5 - _imageFiles!.length);

      if (totalSelected > 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You can only select up $ablelToSelect.')),
        );
        return;
      }

      setState(() {
        _imageFiles!.addAll(selectedImages);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles!.removeAt(index);
    });
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Picker Example')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImages,
            child: Text('Pick Images'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _imageFiles?.length ?? 0,
              itemBuilder: (context, index) {
                final file = File(_imageFiles![index].path);
                final fileSize = file.lengthSync(); // Get file size in bytes

                return ListTile(
                  leading: Image.file(
                    file,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(_imageFiles![index].name),
                  subtitle: Text('${_formatFileSize(fileSize)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeImage(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
