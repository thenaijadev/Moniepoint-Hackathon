import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FileReader {
  static Future<List<Map<String, dynamic>>> pickFiles() async {
    List<Map<String, dynamic>> fileContents = [];

    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: true,
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.bytes != null) {
            String content = String.fromCharCodes(file.bytes!);
            List<String> transactionLines = content
                .split('\n')
                .where((line) => line.trim().isNotEmpty)
                .toList();

            List<Map<String, dynamic>> transactions = [];

            for (var line in transactionLines) {
              List<String> parts = line.split(',');

              if (parts.length == 4) {
                String salesStaffId = parts[0];
                String transactionTime = parts[1];
                String products = parts[2];
                String saleAmount = parts[3];

                List<Map<String, int>> productList = [];
                if (products.startsWith('[') && products.endsWith(']')) {
                  String productsData =
                      products.substring(1, products.length - 1);
                  List<String> productPairs = productsData.split('|');
                  for (var pair in productPairs) {
                    List<String> productInfo = pair.split(':');
                    if (productInfo.length == 2) {
                      productList.add({
                        "productId": int.parse(productInfo[0]),
                        "quantity": int.parse(productInfo[1]),
                      });
                    }
                  }
                }

                transactions.add({
                  "salesStaffId": int.parse(salesStaffId),
                  "transactionTime": transactionTime,
                  "products": productList,
                  "saleAmount": double.parse(saleAmount),
                });
              }
            }

            fileContents.add({
              "day": file.name.replaceFirst(".txt", ""),
              "content": transactions
            });
          }
        }
      }
    }

    return fileContents;
  }

  static Map<String, dynamic> analyzeTransactions(
      List<Map<String, dynamic>> fileContents) {
    Map<String, int> dailySalesVolume = {};
    Map<String, double> dailySalesValue = {};
    Map<String, int> productSalesVolume = {};
    Map<String, Map<String, double>> staffSalesPerMonth = {};

    Map<int, Map<String, int>> hourlyTransactions = {};
    Map<int, int> totalHourlyTransactions = {};
    Set<String> uniqueDays = {};

    for (var fileData in fileContents) {
      String day = fileData['day'];
      uniqueDays.add(day);
      List<Map<String, dynamic>> transactions = fileData['content'];

      int dayVolume = 0;
      double dayValue = 0;

      for (var transaction in transactions) {
        String transactionTime = transaction['transactionTime'];
        List<Map<String, int>> products = transaction['products'];
        double saleAmount = transaction['saleAmount'];
        int staffId = transaction['salesStaffId'];

        DateTime dateTime = DateTime.parse(transactionTime);
        String monthKey =
            '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}';
        int hour = dateTime.hour;

        dayVolume +=
            products.fold(0, (sum, product) => sum + product['quantity']!);
        dayValue += saleAmount;

        for (var product in products) {
          int productId = product['productId']!;
          int quantity = product['quantity']!;
          productSalesVolume[productId.toString()] =
              (productSalesVolume[productId.toString()] ?? 0) + quantity;
        }

        staffSalesPerMonth.putIfAbsent(monthKey, () => {});
        staffSalesPerMonth[monthKey]![staffId.toString()] =
            (staffSalesPerMonth[monthKey]![staffId.toString()] ?? 0) +
                saleAmount;

        hourlyTransactions.putIfAbsent(hour, () => {});
        hourlyTransactions[hour]![day] =
            (hourlyTransactions[hour]![day] ?? 0) + 1;
        totalHourlyTransactions[hour] =
            (totalHourlyTransactions[hour] ?? 0) + 1;
      }

      dailySalesVolume[day] = dayVolume;
      dailySalesValue[day] = dayValue;
    }

    var highestVolumeEntry =
        dailySalesVolume.entries.reduce((a, b) => a.value > b.value ? a : b);

    var highestValueEntry =
        dailySalesValue.entries.reduce((a, b) => a.value > b.value ? a : b);

    var mostSoldProductEntry =
        productSalesVolume.entries.reduce((a, b) => a.value > b.value ? a : b);

    Map<String, String> topStaffPerMonth = {};
    for (var monthEntry in staffSalesPerMonth.entries) {
      var topStaffEntry =
          monthEntry.value.entries.reduce((a, b) => a.value > b.value ? a : b);
      topStaffPerMonth[monthEntry.key] = topStaffEntry.key;
    }

    Map<int, double> hourlyAverages = {};
    int numberOfDays = uniqueDays.length;
    for (var hour in totalHourlyTransactions.keys) {
      hourlyAverages[hour] = totalHourlyTransactions[hour]! / numberOfDays;
    }

    var busiestHourEntry =
        hourlyAverages.entries.reduce((a, b) => a.value > b.value ? a : b);

    return {
      'highestVolumeDay': {
        'date': highestVolumeEntry.key,
        'volume': highestVolumeEntry.value,
      },
      'highestValueDay': {
        'date': highestValueEntry.key,
        'value': highestValueEntry.value,
      },
      'mostSoldProduct': {
        'productId': mostSoldProductEntry.key,
        'volume': mostSoldProductEntry.value,
      },
      'topStaffPerMonth': topStaffPerMonth,
      'busiestHour': {
        'hour': busiestHourEntry.key,
        'averageTransactions': busiestHourEntry.value,
      },
    };
  }
}
