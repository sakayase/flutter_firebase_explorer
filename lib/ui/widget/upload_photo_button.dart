import 'package:flutter/material.dart';

class UploadPhotoButton extends StatelessWidget {
  const UploadPhotoButton({Key? key, required this.onTap}) : super(key: key);
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: SizedBox(
          height: 55,
          width: 55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 40,
                height: 40,
                child: Container(
                  child: Icon(
                    Icons.upload_file,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
