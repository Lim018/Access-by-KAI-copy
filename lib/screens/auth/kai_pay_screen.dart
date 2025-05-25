import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/assets_path.dart';
import '../../providers/auth_provider.dart';
import 'payment_screen.dart';

class KaiPayScreen extends StatefulWidget {
  const KaiPayScreen({Key? key}) : super(key: key);

  @override
  _KaiPayScreenState createState() => _KaiPayScreenState();
}

class _KaiPayScreenState extends State<KaiPayScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isActivated = false;
  int _balance = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkKaiPayStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkKaiPayStatus() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      setState(() {
        // In a real app, this would come from the user's profile
        _isActivated = user.kaiPayBalance > 0;
        _balance = user.kaiPayBalance;
      });
    }
  }

  void _activateKaiPay() {
    setState(() {
      _isLoading = true;
    });

    // Simulate activation process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isActivated = true;
        _isLoading = false;
      });
    });
  }

  void _navigateToTopUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          amount: 100000,
          description: 'Top Up KAI Pay',
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KAI Pay'),
        backgroundColor: AppColors.primary,
      ),
      body: _isActivated ? _buildActivatedView() : _buildActivationView(),
    );
  }

  Widget _buildActivationView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AssetPaths.kaiPayLogo,
            width: 120,
            height: 120,
          ),
          const SizedBox(height: 24),
          const Text(
            'Aktivasi KAI Pay',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'KAI Pay adalah dompet digital resmi dari KAI untuk mempermudah pembayaran tiket dan layanan lainnya.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          const Text(
            'Keuntungan menggunakan KAI Pay:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildBenefitItem(
            icon: Icons.flash_on,
            title: 'Pembayaran Lebih Cepat',
            description: 'Bayar tiket dan layanan KAI dengan sekali klik',
          ),
          const SizedBox(height: 12),
          _buildBenefitItem(
            icon: Icons.security,
            title: 'Aman dan Terpercaya',
            description: 'Transaksi dijamin aman dengan teknologi terkini',
          ),
          const SizedBox(height: 12),
          _buildBenefitItem(
            icon: Icons.card_giftcard,
            title: 'Bonus RailPoints',
            description: 'Dapatkan RailPoints untuk setiap transaksi',
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _activateKaiPay,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'AKTIVASI SEKARANG',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivatedView() {
    return Column(
      children: [
        // KAI Pay balance card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.indigo.shade800,
                Colors.purple.shade700,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    AssetPaths.kaiPayLogo,
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'KAI PAY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Saldo KAI Pay',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatCurrency(_balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _navigateToTopUp,
                    icon: const Icon(Icons.add),
                    label: const Text('Top Up'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.history),
                    label: const Text('Riwayat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Tab bar
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Fitur'),
            Tab(text: 'Promo'),
            Tab(text: 'Bantuan'),
          ],
        ),
        
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildFeaturesTab(),
              _buildPromosTab(),
              _buildHelpTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesTab() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildFeatureItem(
          icon: Icons.qr_code_scanner,
          label: 'Scan QR',
          onTap: () {},
        ),
        _buildFeatureItem(
          icon: Icons.train,
          label: 'Tiket Kereta',
          onTap: () {},
        ),
        _buildFeatureItem(
          icon: Icons.fastfood,
          label: 'RailFood',
          onTap: () {},
        ),
        _buildFeatureItem(
          icon: Icons.local_taxi,
          label: 'Taksi',
          onTap: () {},
        ),
        _buildFeatureItem(
          icon: Icons.hotel,
          label: 'Hotel',
          onTap: () {},
        ),
        _buildFeatureItem(
          icon: Icons.shopping_bag,
          label: 'Belanja',
          onTap: () {},
        ),
        _buildFeatureItem(
          icon: Icons.phone_android,
          label: 'Pulsa',
          onTap: () {},
        ),
        _buildFeatureItem(
          icon: Icons.electric_bolt,
          label: 'Listrik',
          onTap: () {},
        ),
        _buildFeatureItem(
          icon: Icons.more_horiz,
          label: 'Lainnya',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPromosTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.card_giftcard,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada promo tersedia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Promo KAI Pay akan segera hadir',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Pertanyaan Umum',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildFaqItem(
          question: 'Apa itu KAI Pay?',
          answer: 'KAI Pay adalah dompet digital resmi dari KAI untuk mempermudah pembayaran tiket dan layanan lainnya.',
        ),
        _buildFaqItem(
          question: 'Bagaimana cara top up KAI Pay?',
          answer: 'Anda dapat melakukan top up KAI Pay melalui transfer bank, kartu kredit, atau gerai retail yang bekerja sama dengan KAI.',
        ),
        _buildFaqItem(
          question: 'Apakah KAI Pay aman?',
          answer: 'Ya, KAI Pay menggunakan teknologi keamanan terkini untuk melindungi data dan transaksi Anda.',
        ),
        _buildFaqItem(
          question: 'Berapa saldo maksimum KAI Pay?',
          answer: 'Saldo maksimum KAI Pay adalah Rp 10.000.000 untuk akun yang sudah terverifikasi.',
        ),
        const SizedBox(height: 24),
        const Text(
          'Butuh bantuan lainnya?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.headset_mic),
          label: const Text('Hubungi Customer Service'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
