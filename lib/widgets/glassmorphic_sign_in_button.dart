// glassmorphic_signin_button.dart
import 'dart:ui';
import 'package:euphor/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:euphor/providers/auth_provider.dart';

class GlassmorphicSignInButton extends StatelessWidget {
  final AuthProvider authProvider;
  final VoidCallback? onPressed;
  final String text;
  final Widget? leading;
  final bool isLoading;

  const GlassmorphicSignInButton({
    super.key,
    required this.authProvider,
    required this.text,
    this.onPressed,
    this.leading,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTap: isLoading ? null : onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: AppTheme.primaryColor,
                  blurRadius: 200,
                  spreadRadius: 0,
                  offset: Offset(0, 80),
                ),
              ],
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (leading != null) leading!,
                        if (leading != null) const SizedBox(width: 12),
                        Text(
                          text,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
