import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/assets_path.dart';
import 'widgets/destination_card.dart';
import 'widgets/transport_option.dart';

class KeretaScreen extends StatelessWidget {
  const KeretaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Kereta',
                    style: AppTextStyles.heading1,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Layanan Kereta dari KAI',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Transport options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                TransportOption(
                  label: 'Antar Kota',
                  color: AppColors.antarKota,
                ),
                TransportOption(
                  label: 'Lokal',
                  color: AppColors.lokal,
                ),
                TransportOption(
                  label: 'Commuter\nLine',
                  color: AppColors.commuterLine,
                ),
                TransportOption(
                  label: 'LRT',
                  color: AppColors.lrt,
                ),
                TransportOption(
                  label: 'Bandara',
                  color: AppColors.bandara,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Popular destinations
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tujuan Populer',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: 16),
                DestinationCard(
                  city: 'Jakarta',
                  imagePath: AssetPaths.jakarta,
                ),
                const SizedBox(height: 16),
                DestinationCard(
                  city: 'Bandung',
                  imagePath: AssetPaths.bandung,
                ),
                const SizedBox(height: 16),
                DestinationCard(
                  city: 'Jogjakarta',
                  imagePath: AssetPaths.jogja,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}