import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'fast_attendance_viewmodel.dart';

class FastAttendanceView extends StackedView<FastAttendanceViewModel> {
  const FastAttendanceView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FastAttendanceViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: viewModel.scanQRCode,
                child: Text('Scan QR Code'),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Scan result: ${viewModel.scanResult}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  FastAttendanceViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      FastAttendanceViewModel();
}
