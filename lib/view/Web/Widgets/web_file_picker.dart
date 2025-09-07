import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';
import 'dart:typed_data';

class WebFilePicker extends StatefulWidget {
  final Function(String fileName, Uint8List? fileBytes) onFileSelected;
  final List<String> allowedExtensions;
  final String buttonText;
  final IconData buttonIcon;

  const WebFilePicker({
    super.key,
    required this.onFileSelected,
    this.allowedExtensions = const ['jpg', 'jpeg', 'png', 'gif', 'webp'],
    this.buttonText = 'Select File',
    this.buttonIcon = Icons.file_upload,
  });

  @override
  State<WebFilePicker> createState() => _WebFilePickerState();
}

class _WebFilePickerState extends State<WebFilePicker> {
  html.FileUploadInputElement? _fileInput;

  @override
  void initState() {
    super.initState();
    _fileInput = html.FileUploadInputElement();
    _fileInput!.accept = widget.allowedExtensions.map((ext) => '.$ext').join(',');
    _fileInput!.multiple = false;
    _fileInput!.onChange.listen(_handleFileSelection);
  }

  void _handleFileSelection(html.Event event) {
    final files = _fileInput!.files;
    if (files != null && files.isNotEmpty) {
      final file = files.first;
      final fileName = file.name;
      final fileExtension = fileName.split('.').last.toLowerCase();
      
      if (widget.allowedExtensions.contains(fileExtension)) {
        final reader = html.FileReader();
        reader.onLoad.listen((event) {
          final result = reader.result;
          if (result is Uint8List) {
            widget.onFileSelected(fileName, result);
          }
        });
        reader.readAsArrayBuffer(file);
      } else {
        // Show error for invalid file type
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid file type. Please select: ${widget.allowedExtensions.join(', ')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openFilePicker() {
    _fileInput!.click();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _openFilePicker,
      icon: Icon(widget.buttonIcon),
      label: Text(widget.buttonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade100,
        foregroundColor: Colors.blue.shade700,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fileInput = null;
    super.dispose();
  }
}


