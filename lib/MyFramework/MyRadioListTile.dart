// import 'package:flutter/material.dart';

// class _MyRadioListTile extends StatefulWidget {
//   const _MyRadioListTile({super.key,required this.val_redio});

//   @override
//   State<_MyRadioListTile> createState() => __MyRadioListTileState();
// }

// class __MyRadioListTileState extends StatelessWidget {
//   final String val_redio;
//   String _selectedOption = 'Option 1';
  
//   @override
//   Widget build(BuildContext context) {
//     return RadioListTile<String>(
//               title: Text('Option 1'),
//               value: 'Option 1',
//               groupValue: _selectedOption,
//               onChanged: (String? value) {
//                 setState(() {
//                   _selectedOption = value!;
//                 });
//               },
//             );
//   }
// }