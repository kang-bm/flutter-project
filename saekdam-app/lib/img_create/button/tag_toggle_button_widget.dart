import 'package:flutter/material.dart';
import 'package:fly_ai_1/constant/color.dart';
// 태그 선택 버튼
class TagToggleButton extends StatelessWidget {
  final String buttonText;
  final bool isSelected;
  final VoidCallback onTap;

  const TagToggleButton({
    required this.buttonText,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? pinkmain : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}