import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;

  //final Function(String) onChanged;
 // final String initialValue;
  final String hintText;
  final String suffix;
  final String prefix;
  final String obscuringCharacter;
  final bool hideText;

  final Function? onTap;

  final List<TextInputFormatter>? inputFormatters;
  //final bool onlyOnTapEditing;
  final bool enabled;
  final FocusNode focusNode;
  final VoidCallback? onPressedSuffix;

  AppTextField({
    required this.controller,
   // this.initialValue,
    //this.type = TextInputType.text,
    this.keyboardType = TextInputType.text,
    this.suffix = '',
    this.prefix = '',
    this.obscuringCharacter = '•',
    this.hintText = '',
    this.inputFormatters,
    //String initial,
    //this.error,
    //this.onChanged,
    this.onTap,
    //this.onlyOnTapEditing = false,
    this.enabled = true,
    required this.focusNode,
    this.onPressedSuffix,
    this.hideText = false,
  })  //: inputFormatters = inputFormatters ?? []
      //  controller = controller ?? TextEditingController(text: initial)*/
  ;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        focusNode: focusNode,
        enabled: enabled,
        controller: controller,
        obscureText: hideText,
        obscuringCharacter: obscuringCharacter,
        keyboardType:keyboardType,
       inputFormatters: inputFormatters,
       // initialValue: initialValue,
        style: GoogleFonts.openSans(
          color: enabled? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.secondaryVariant,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        //keyboardType: type,
        // onChanged: (newValue) {
        //   onChanged?.call(newValue);
        // },
        //inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(
            vertical: 16,
            //horizontal: 16,
          ),
          prefixIcon: Container(
            //padding: EdgeInsets.only(left: 16),
            child: Text(prefix,
                style: Theme.of(context).textTheme.headline4),
          ),
          isDense: true,
          prefixIconConstraints: BoxConstraints(minWidth: 140, minHeight: 0),
          suffixIcon: TextButton(
            onPressed: onPressedSuffix,
            child: Text(suffix,
                style: GoogleFonts.openSans(
                  color: Theme.of(context).toggleableActiveColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )),
          ),
          suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        ),
      ),
    );
  }
}
