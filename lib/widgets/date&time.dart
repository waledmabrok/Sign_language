import 'package:flutter/material.dart';
import 'package:flutter_application/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class DateAndTime extends StatefulWidget {
  const DateAndTime({super.key});

  @override
  State<DateAndTime> createState() => _DateAndTimeState();
}

class _DateAndTimeState extends State<DateAndTime> {
  TextEditingController controllerDate = TextEditingController();
  TextEditingController controllerTime = TextEditingController();
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff0051FF), // اللون الأزرق
            hintColor: const Color(0xff0051FF), // تأكيد اللون الأزرق
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme
                  .primary, // التأكيد على استخدام اللون الأزرق للنص
            ),
            scaffoldBackgroundColor: Colors.white, // خلفية بيضاء
            dialogBackgroundColor: Colors.white, // خلفية الديالوج بيضاء
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    const Color(0xff0051FF), // تغيير لون النص إلى الأزرق
              ),
            ),
            colorScheme: ColorScheme.light(
              primary: const Color(0xff0051FF), // اللون الأزرق
              onPrimary: Colors.white, // لون النص داخل الأزرار أزرق
              onSurface: Colors.black, // لون النص العادي أسود
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controllerDate.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: const Color(0xff0051FF), // اللون الأزرق
            hintColor: const Color(0xff0051FF), // اللون الأزرق
            buttonTheme: ButtonThemeData(
              textTheme:
                  ButtonTextTheme.primary, // النص داخل الأزرار باللون الأزرق
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Color(0xffE9E9E9),
              dialBackgroundColor: Colors.white, // الخلفية الخاصة بالساعة
              dialTextColor: Colors.black, // لون النص داخل الساعة
              hourMinuteTextColor: Colors.black,
              dialHandColor: const Color(0xff0051FF),

              confirmButtonStyle: ButtonStyle(
                  textStyle:
                      WidgetStatePropertyAll(TextStyle(color: Colors.red)),
                  backgroundColor: WidgetStatePropertyAll(Colors.white)),
              cancelButtonStyle: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                    TextStyle(color: Colors.white), // تغيير لون نص الزر OK
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                      Colors.white)), // لون النص للساعة والدقائق
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controllerTime.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Date',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              onTap: _selectDate,
              isReadOnly: true,
              hintText: 'Select date',
              borderRadius: 20,
              controller: controllerDate,
              icon: const Icon(
                Icons.calendar_today,
                color: Color(0xff939393),
              ),
            ),
          ]),
        ),
        const SizedBox(width: 23),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Time',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              onTap: _selectTime,
              isReadOnly: true,
              hintText: 'Select time',
              borderRadius: 20,
              controller: controllerTime,
              icon: const Icon(
                Icons.access_time,
                color: Color(0xff939393),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
