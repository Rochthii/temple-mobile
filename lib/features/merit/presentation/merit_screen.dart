import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';


class MeritScreen extends StatefulWidget {
  const MeritScreen({super.key});

  @override
  State<MeritScreen> createState() => _MeritScreenState();
}

class _MeritScreenState extends State<MeritScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Trạng thái giả lập VietQR
  String? _qrCodeData;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_formatAmount);
  }

  @override
  void dispose() {
    _amountController.removeListener(_formatAmount);
    _amountController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _formatAmount() {
    // Demo implementation for formatting if needed.
    // print(_currencyFormat.format(int.tryParse(_amountController.text) ?? 0));
  }

  void _generateQR() {
    FocusScope.of(context).unfocus();
    if (_amountController.text.isNotEmpty) {
      setState(() {
        // Mock payload for VietQR
        _qrCodeData = 'vietqr://temple/${_amountController.text}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.primaryDark),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to ledger
              context.push('/merit-ledger');
            },
            child: const Text(
              'Sổ Vàng',
              style: TextStyle(
                fontFamily: 'NotoSerif',
                fontWeight: FontWeight.w600,
                color: AppColors.primary, // Saffron Gold
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Atmospheric Header
              const Text(
                'Gieo Duyên\nCông Đức',
                style: TextStyle(
                  fontFamily: 'NotoSerif',
                  fontSize: 40,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 64),

              // Massive Amount Input
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'NotoSerif',
                  fontSize: 56,
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: '500,000',
                  hintStyle: TextStyle(
                    fontFamily: 'NotoSerif',
                    fontSize: 56,
                    color: AppColors.primaryDark.withValues(alpha: 0.2),
                  ),
                  suffixText: '₫',
                  suffixStyle: const TextStyle(
                    fontFamily: 'NotoSerif',
                    fontSize: 32,
                    color: AppColors.primaryDark,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              
              const SizedBox(height: 48),

              // Dedication Field
              TextField(
                controller: _messageController,
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Lời nguyện cầu...',
                  hintStyle: AppTypography.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 64),

              // Glassmorphism QR Container
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: _qrCodeData != null ? 300 : 0,
                child: _qrCodeData != null ? _buildQRContainer() : const SizedBox.shrink(),
              ),

              SizedBox(height: _qrCodeData != null ? 48 : 0),

              // CTA Button
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withValues(alpha: 0.1),
                      offset: const Offset(0, 16),
                      blurRadius: 32,
                    )
                  ],
                ),
                child: FilledButton(
                  onPressed: _generateQR,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: AppColors.primary, // Saffron Gold text (Primary here represents gold/saffron based on Bespoke Archive schema)
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'PHÁT TÂM',
                    style: TextStyle(
                      fontFamily: 'NotoSerif',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRContainer() {
    return Stack(
      children: [
        // Glass Backdrop
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceBright.withValues(alpha: 0.4),
            border: Border.all(
              color: AppColors.primaryDark.withValues(alpha: 0.05),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const Center(
                // Trình giả lập hiển thị mã QR (thực tế dùng qr_flutter package)
                child: Icon(
                  Icons.qr_code_2_rounded,
                  size: 160,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
        ),
        
        // Top Left Saffron Accent
        Positioned(
          top: 0,
          left: 0,
          child: _buildCornerAccent(isTop: true, isLeft: true),
        ),
        // Top Right Saffron Accent
        Positioned(
          top: 0,
          right: 0,
          child: _buildCornerAccent(isTop: true, isLeft: false),
        ),
        // Bottom Left Saffron Accent
        Positioned(
          bottom: 0,
          left: 0,
          child: _buildCornerAccent(isTop: false, isLeft: true),
        ),
        // Bottom Right Saffron Accent
        Positioned(
          bottom: 0,
          right: 0,
          child: _buildCornerAccent(isTop: false, isLeft: false),
        ),
      ],
    );
  }

  Widget _buildCornerAccent({required bool isTop, required bool isLeft}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
          left: isLeft ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: AppColors.primary, width: 2) : BorderSide.none,
        ),
      ),
    );
  }
}
