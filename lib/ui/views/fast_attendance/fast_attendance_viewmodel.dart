import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:stacked/stacked.dart';

class FastAttendanceViewModel extends BaseViewModel {
  String _scanResult = 'Scan a QR code to get attendance status';

  String get scanResult => _scanResult;

  Future<void> scanQRCode() async {
    setBusy(true);
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
      if (barcodeScanRes != '-1') {
        _scanResult = barcodeScanRes;
        notifyListeners(); // Notify the UI of the new scan result
      }
    } finally {
      setBusy(false);
    }
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.QR)!
        .listen((barcode) => print(barcode));
  }
}
