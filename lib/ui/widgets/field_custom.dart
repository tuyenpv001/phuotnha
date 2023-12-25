part of 'widgets.dart';

class TextFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final Icon? icon;
  final FormFieldValidator<String>? validator;

  const TextFieldCustom(
      {Key? key,
      required this.controller,
      this.hintText,
      this.isPassword = false,
      this.icon,
      this.keyboardType = TextInputType.text,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      // style: GoogleFonts.getFont('Roboto', fontSize: 18),
      style: kLoginInputTextStyle.copyWith(
        color: Colors.black,
      ),
      cursorColor: kPrimaryLabelColor,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: kLoginInputTextStyle,
        icon: icon,
      ),
      validator: validator,
    );
  }
}
