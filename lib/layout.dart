import 'package:flutter/material.dart';

AppBar appBar({
  String title = '',
  Function()? clearFieldsFunction,
}) {
  return AppBar(
    leadingWidth: 80,
    actions: [
      if (clearFieldsFunction != null)
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: clearFieldsFunction,
        ),
      const SizedBox(width: 20),
    ],
    title: Text(
      title,
      style: const TextStyle(fontSize: 18),
    ),
    titleSpacing: 00.0,
    centerTitle: true,
    toolbarHeight: 60.0,
    toolbarOpacity: 0.9,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(55),
        bottomLeft: Radius.circular(55),
      ),
    ),
    elevation: 1.00,
    backgroundColor: const Color.fromARGB(200, 23, 135, 172),
  );
}


                //            onTap: _showImagePicker,
