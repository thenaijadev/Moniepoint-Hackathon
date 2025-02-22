import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monieshop/providers/file_reader.dart';
import 'package:monieshop/screens/metric_card_widget.dart';
import 'package:monieshop/screens/top_staff_card_widget.dart';
import 'package:monieshop/widgets/info_snackbar.dart';
import 'package:monieshop/widgets/text_widget.dart';

class Sal4sAnalisisScreen extends StatefulWidget {
  const Sal4sAnalisisScreen({super.key});

  @override
  State<Sal4sAnalisisScreen> createState() => _Sal4sAnalisisScreenState();
}

class _Sal4sAnalisisScreenState extends State<Sal4sAnalisisScreen> {
  Map<String, dynamic>? analysisResults;
  bool isLoading = false;

  Future<void> pickAndAnalizeFiles() async {
    setState(() {
      isLoading = true;
    });

    try {
      final fileContents = await FileReader.pickFiles();
      if (fileContents.isNotEmpty) {
        setState(() {
          analysisResults = FileReader.analyzeTransactions(fileContents);
        });
      }
    } catch (e) {
      InfoSnackBar.showErrorSnackBar(
          context, 'Error processing files: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Analysis Dashboard'),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: isLoading ? null : pickAndAnalizeFiles,
              icon: const Icon(Icons.upload_file),
              label: TextWidget(
                  text: isLoading ? 'Processing...' : 'Upload Sales Data'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (analysisResults != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MetricCardWidget(
                        title: 'Highest Volume Day',
                        icon: Icon(Icons.bar_chart,
                            size: 32, color: Colors.blue[700]),
                        details: [
                          'Date: ${analysisResults!['highestVolumeDay']['date']}',
                          'Volume: ${analysisResults!['highestVolumeDay']['volume']} units',
                        ],
                      ),
                      const SizedBox(height: 16),
                      MetricCardWidget(
                        title: 'Highest Value Day',
                        icon: Icon(Icons.attach_money,
                            size: 32, color: Colors.green[700]),
                        details: [
                          'Date: ${analysisResults!['highestValueDay']['date']}',
                          'Value: \$${NumberFormat('#,##0.00').format(analysisResults!['highestValueDay']['value'])}',
                        ],
                      ),
                      const SizedBox(height: 16),
                      MetricCardWidget(
                        title: 'Most Sold Product',
                        icon: Icon(Icons.shopping_cart,
                            size: 32, color: Colors.orange[700]),
                        details: [
                          'Product ID: ${analysisResults!['mostSoldProduct']['productId']}',
                          'Volume: ${analysisResults!['mostSoldProduct']['volume']} units',
                        ],
                      ),
                      const SizedBox(height: 16),
                      MetricCardWidget(
                        title: 'Busiest Hour',
                        icon: Icon(Icons.access_time,
                            size: 32, color: Colors.purple[700]),
                        details: [
                          'Hour: ${analysisResults!['busiestHour']['hour']}:00',
                          'Average Transactions: ${analysisResults!['busiestHour']['averageTransactions'].toStringAsFixed(2)}',
                        ],
                      ),
                      const SizedBox(height: 16),
                      TopStaffCardWidget(
                          topStaffPerMonth:
                              analysisResults!['topStaffPerMonth']),
                    ],
                  ),
                ),
              )
            else
              const Center(
                child: Text(
                  'Upload sales data files to view analysis',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
