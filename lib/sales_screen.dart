import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monieshop/file_reader.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing files: ${e.toString()}')),
      );
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
              label: Text(isLoading ? 'Processing...' : 'Upload Sales Data'),
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
                      _buildMetricCard(
                        'Highest Volume Day',
                        Icon(Icons.bar_chart,
                            size: 32, color: Colors.blue[700]),
                        [
                          'Date: ${analysisResults!['highestVolumeDay']['date']}',
                          'Volume: ${analysisResults!['highestVolumeDay']['volume']} units',
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildMetricCard(
                        'Highest Value Day',
                        Icon(Icons.attach_money,
                            size: 32, color: Colors.green[700]),
                        [
                          'Date: ${analysisResults!['highestValueDay']['date']}',
                          'Value: \$${NumberFormat('#,##0.00').format(analysisResults!['highestValueDay']['value'])}',
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildMetricCard(
                        'Most Sold Product',
                        Icon(Icons.shopping_cart,
                            size: 32, color: Colors.orange[700]),
                        [
                          'Product ID: ${analysisResults!['mostSoldProduct']['productId']}',
                          'Volume: ${analysisResults!['mostSoldProduct']['volume']} units',
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildMetricCard(
                        'Busiest Hour',
                        Icon(Icons.access_time,
                            size: 32, color: Colors.purple[700]),
                        [
                          'Hour: ${analysisResults!['busiestHour']['hour']}:00',
                          'Average Transactions: ${analysisResults!['busiestHour']['averageTransactions'].toStringAsFixed(2)}',
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildTopStaffCard(analysisResults!['topStaffPerMonth']),
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

  Widget _buildMetricCard(String title, Icon icon, List<String> details) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                icon,
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...details.map((detail) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    detail,
                    style: const TextStyle(fontSize: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStaffCard(Map<String, String> topStaffPerMonth) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, size: 32, color: Colors.red[700]),
                const SizedBox(width: 12),
                const Text(
                  'Top Performing Staff',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...topStaffPerMonth.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '${entry.key}: Staff #${entry.value}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
