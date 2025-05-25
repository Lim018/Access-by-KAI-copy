import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTransactions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading transactions from a service
    await Future.delayed(const Duration(seconds: 1));

    // Mock data for demonstration
    setState(() {
      _transactions = [
        {
          'id': 'TRX-001',
          'type': 'ticket',
          'title': 'Tiket Kereta Jakarta - Bandung',
          'date': DateTime.now().subtract(const Duration(days: 2)),
          'amount': 150000,
          'status': 'completed',
        },
        {
          'id': 'TRX-002',
          'type': 'kaipay',
          'title': 'Top Up KAI Pay',
          'date': DateTime.now().subtract(const Duration(days: 5)),
          'amount': 500000,
          'status': 'completed',
        },
        {
          'id': 'TRX-003',
          'type': 'ticket',
          'title': 'Tiket Kereta Bandung - Yogyakarta',
          'date': DateTime.now().subtract(const Duration(days: 10)),
          'amount': 280000,
          'status': 'completed',
        },
        {
          'id': 'TRX-004',
          'type': 'railfood',
          'title': 'RailFood - Nasi Padang',
          'date': DateTime.now().subtract(const Duration(days: 10)),
          'amount': 45000,
          'status': 'completed',
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: AppColors.primary,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Tiket'),
            Tab(text: 'KAI Pay'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionList(null), // All transactions
                _buildTransactionList('ticket'), // Only ticket transactions
                _buildTransactionList('kaipay'), // Only KAI Pay transactions
              ],
            ),
    );
  }

  Widget _buildTransactionList(String? type) {
    final filteredTransactions = type == null
        ? _transactions
        : _transactions.where((tx) => tx['type'] == type).toList();

    if (filteredTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada transaksi ${type == 'ticket' ? 'tiket' : type == 'kaipay' ? 'KAI Pay' : ''} yang ditemukan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final IconData icon = transaction['type'] == 'ticket'
        ? Icons.train
        : transaction['type'] == 'kaipay'
            ? Icons.account_balance_wallet
            : transaction['type'] == 'railfood'
                ? Icons.fastfood
                : Icons.receipt;

    final Color iconColor = transaction['type'] == 'ticket'
        ? AppColors.primary
        : transaction['type'] == 'kaipay'
            ? Colors.green
            : transaction['type'] == 'railfood'
                ? Colors.orange
                : Colors.purple;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(transaction['date']),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction['id'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatCurrency(transaction['amount']),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: transaction['status'] == 'completed'
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    transaction['status'] == 'completed' ? 'Selesai' : 'Pending',
                    style: TextStyle(
                      color: transaction['status'] == 'completed'
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}
