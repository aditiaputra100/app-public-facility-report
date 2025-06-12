import 'dart:io';

import 'package:flutter/material.dart';

class ImagePickerButton extends StatefulWidget {
  final GestureTapCallback? onTap;
  final File? image;

  const ImagePickerButton({super.key, this.onTap, this.image});

  @override
  State<ImagePickerButton> createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          spacing: 12,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  widget.image == null
                      ? Icon(Icons.image)
                      : Image.file(widget.image!, scale: 30),
            ),
            Text(widget.image == null ? "Tambahkan foto" : "Ganti foto"),
          ],
        ),
      ),
    );
  }
}
