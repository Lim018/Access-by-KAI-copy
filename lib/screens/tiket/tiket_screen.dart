import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/assets_path.dart';
import 'widgets/service_icon.dart';
import 'widgets/filter_chip.dart';

class TiketScreen extends StatelessWidget {
  const TiketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.secondary,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Tiket Saya',
                    style: AppTextStyles.headingLight,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Semua tiket kereta yang sudah aktif dan menunggu pembayaran',
                    style: AppTextStyles.bodyLargeLight,
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Layanan Tambahan untuk perjalanan kamu',
                  style: AppTextStyles.heading4,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    ServiceIcon(
                      label: 'RailFood',
                      color: AppColors.railFood,
                      icon: Icons.fastfood,
                    ),
                    ServiceIcon(
                      label: 'Taksi',
                      color: AppColors.taksi,
                      icon: Icons.local_taxi,
                    ),
                    ServiceIcon(
                      label: 'Bus',
                      color: AppColors.bus,
                      icon: Icons.directions_bus,
                    ),
                    ServiceIcon(
                      label: 'Hotel',
                      color: AppColors.hotel,
                      icon: Icons.hotel,
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                const Text(
                  'Tiket & Layanan Saya',
                  style: AppTextStyles.heading4,
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: const [
                      CustomFilterChip(
                        label: 'Semua',
                        isSelected: true,
                      ),
                      CustomFilterChip(
                        label: 'Antar Kota',
                        isSelected: false,
                      ),
                      CustomFilterChip(
                        label: 'Bandara',
                        isSelected: false,
                      ),
                      CustomFilterChip(
                        label: 'Lokal',
                        isSelected: false,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'CEK & TAMBAH TIKET',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                Center(
                  child: Image.asset(
                    AssetPaths.tickets,
                    height: 200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}