import 'package:flutter/material.dart';
import 'package:mushaf_app/src/helpers/navigator.dart';
import 'package:mushaf_app/src/quran_viewer/view.dart';
import 'package:mushaf_app/src/wird/controller.dart';
import 'package:mushaf_app/widgets/buttons.dart';
import 'package:provider/provider.dart';

class WirdTab extends StatelessWidget {
  const WirdTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WirdController>();
    final dailyDoze = controller.dailyDoze;

    return Scaffold(
      appBar: AppBar(title: const Text('الورد')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (dailyDoze == null) ...[
              Text(
                'لم تبدء ورد حتى الآن',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              AppButton(
                labelText: 'ابدء الورد',
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const SelectWirdDurationDialog(),
                ),
                margin: const EdgeInsets.only(top: 20),
              ),
            ] else ...[
              Text(
                controller.completedPercentage >= 1
                    ? 'أكتملت الختمة!'
                    : 'الورد اليومي',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'الورد الحالي: ${controller.currentWirdStr} '
                    'يوميا',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => const SelectWirdDurationDialog(),
                    ),
                    icon: const Icon(Icons.edit),
                    iconSize: 20,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                '${(controller.completedPercentage * 100).round()}%',
                textAlign: TextAlign.end,
              ),
              LinearProgressIndicator(
                value: controller.completedPercentage,
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(.25),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (controller.completedPercentage < 1) ...[
                    Expanded(
                      child: AppButton(
                        labelText: 'قراءة وردك اليومي',
                        onPressed: () => AppNavigator.push(
                          QuranViewer.buildRouteName(
                            controller.wirdPage,
                            forWird: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: AppButton(
                      labelText: controller.completedPercentage >= 1
                          ? 'إنشاء ختمة جديدة'
                          : 'أكملت القراءة',
                      style: controller.completedPercentage >= 1
                          ? AppButtonStyle.primary
                          : AppButtonStyle.outline,
                      onPressed: () => controller.completedPercentage >= 1
                          ? showDialog(
                              context: context,
                              builder: (_) => const SelectWirdDurationDialog(),
                            )
                          : controller.completeCurrentWird(updateCP: true),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SelectWirdDurationDialog extends StatefulWidget {
  const SelectWirdDurationDialog({super.key});

  @override
  State<SelectWirdDurationDialog> createState() =>
      _SelectWirdDurationDialogState();
}

class _SelectWirdDurationDialogState extends State<SelectWirdDurationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool isJuz = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WirdController>();

    return Dialog(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'الرجاء تحديد المدة التي تريد ختم القرآن فيها',
                style: Theme.of(context).textTheme.headline6,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      validator: (value) {
                        final number = int.tryParse(value ?? '');
                        if (number == null) return 'ليس رقم';

                        if (isJuz && number >= 30) return 'أكبر من 30';

                        if (!isJuz && number >= 604) return 'أكبر من 604';

                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'العدد',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<bool>(
                      value: isJuz,
                      onChanged: (value) => setState(
                        () => isJuz = value ?? false,
                      ),
                      items: const [
                        DropdownMenuItem(value: false, child: Text('صفحات')),
                        DropdownMenuItem(value: true, child: Text('أجزاء')),
                      ],
                      hint: const Text('عدد الصفحات'),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              AppButton(
                labelText: 'إبدء الورد',
                margin: const EdgeInsets.only(top: 20),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  controller.setDailyDoze(
                    int.parse(_amountController.text) *
                        (isJuz ? controller.pagesPerJuz : 1),
                    isJuz,
                  );
                  AppNavigator.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
