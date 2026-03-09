import 'package:flutter/material.dart';
import 'package:notix_pro/notix_pro.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const NotiXProApp());

class NotiXProApp extends StatefulWidget {
  const NotiXProApp({super.key});

  @override
  State<NotiXProApp> createState() => _NotiXProAppState();
}

class _NotiXProAppState extends State<NotiXProApp> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotiX Pro Demo',
      debugShowCheckedModeBanner: false,
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      home: DemoScreen(
        darkMode: _darkMode,
        onToggle: () => setState(() => _darkMode = !_darkMode),
      ),
    );
  }
}

class DemoScreen extends StatefulWidget {
  final bool darkMode;
  final VoidCallback onToggle;
  const DemoScreen({super.key, required this.darkMode, required this.onToggle});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  NotixAnimationStyle _anim = NotixAnimationStyle.bounce;

  NotixTheme get _theme => NotixTheme(
        animationStyle: _anim,
        forceDarkMode: widget.darkMode,
        fontFamily: GoogleFonts.poppins().fontFamily,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotiX Pro'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.darkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggle,
            tooltip: 'Toggle Dark Mode',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // Animation picker
          const _Section('ANIMATION STYLE'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: NotixAnimationStyle.values.map((s) {
                final selected = s == _anim;
                return GestureDetector(
                  onTap: () => setState(() => _anim = s),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8, bottom: 14),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? Colors.indigo : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? Colors.indigo : Colors.grey.shade400,
                      ),
                    ),
                    child: Text(s.name,
                      style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : Colors.grey,
                      )),
                  ),
                );
              }).toList(),
            ),
          ),

          // ── Dialogs ──────────────────────────────────────────
          const _Section('DIALOGS'),
          _Btn(label: '✅  Success Dialog', color: const Color(0xFF1DB954),
            onTap: () => NotixDialog.show(context,
              type: NotixType.success, title: 'Payment Successful',
              message: 'Your order #1234 has been confirmed and is now being processed.',
              confirmText: 'Great!', theme: _theme)),
          _Btn(label: '❌  Error Dialog', color: const Color(0xFFE53935),
            onTap: () => NotixDialog.show(context,
              type: NotixType.error, title: 'Delete Account',
              message: 'This action is permanent and cannot be undone. Are you sure?',
              confirmText: 'Delete', cancelText: 'Cancel', theme: _theme)),
          _Btn(label: '⚠️  Warning Dialog', color: const Color(0xFFF59E0B),
            onTap: () => NotixDialog.show(context,
              type: NotixType.warning, title: 'Unsaved Changes',
              message: 'You have unsaved changes. Do you want to discard them?',
              confirmText: 'Discard', cancelText: 'Keep Editing', theme: _theme)),
          _Btn(label: 'ℹ️  Info Dialog', color: const Color(0xFF1E88E5),
            onTap: () => NotixDialog.show(context,
              type: NotixType.info, title: 'Update Available',
              message: 'Version 2.0 brings powerful new Pro features. Update now.',
              confirmText: 'Update', cancelText: 'Later', theme: _theme)),

          // ── Bottom Sheets (PRO) ───────────────────────────────
          const _Section('BOTTOM SHEETS  ⭐ PRO'),
          _Btn(label: '✅  Success Sheet', color: const Color(0xFF1DB954),
            onTap: () => NotixSheet.show(context,
              type: NotixType.success, title: 'Purchase Complete',
              message: 'Your subscription is now active. Enjoy all Pro features!',
              theme: _theme,
              actions: [
                NotixSheetAction(label: 'Start Using Pro', onTap: () {}),
                NotixSheetAction(label: 'Maybe Later', onTap: () {}, isSecondary: true),
              ])),
          _Btn(label: '❌  Destructive Sheet', color: const Color(0xFFE53935),
            onTap: () => NotixSheet.show(context,
              type: NotixType.error, title: 'Delete All Data',
              message: 'This will permanently erase all your files, settings, and account history.',
              theme: _theme,
              actions: [
                NotixSheetAction(label: 'Delete Everything', onTap: () {}, isDestructive: true),
                NotixSheetAction(label: 'Cancel', onTap: () {}, isSecondary: true),
              ])),
          _Btn(label: '⚠️  Warning Sheet', color: const Color(0xFFF59E0B),
            onTap: () => NotixSheet.show(context,
              type: NotixType.warning, title: 'Session Expiring',
              message: 'Your session expires in 2 minutes. Save your work now.',
              theme: _theme,
              actions: [
                NotixSheetAction(label: 'Extend Session', onTap: () {}),
                NotixSheetAction(label: 'Log Out Now', onTap: () {}, isSecondary: true),
              ])),

          // ── Toasts ────────────────────────────────────────────
          const _Section('TOASTS'),
          _Btn(label: '✅  Success Toast (bottom)', color: const Color(0xFF1DB954),
            onTap: () => NotixToast.show(context,
              type: NotixType.success, message: 'Profile saved successfully!', theme: _theme)),
          _Btn(label: '❌  Error Toast (top)', color: const Color(0xFFE53935),
            onTap: () => NotixToast.show(context,
              type: NotixType.error, title: 'Upload Failed',
              message: 'File exceeds the 10MB limit.',
              position: NotixToastPosition.top, theme: _theme)),
          _Btn(label: '⚠️  Warning Toast (bottom)', color: const Color(0xFFF59E0B),
            onTap: () => NotixToast.show(context,
              type: NotixType.warning, message: 'Low battery. Please connect charger.', theme: _theme)),
          _Btn(label: 'ℹ️  Info Toast (top)', color: const Color(0xFF1E88E5),
            onTap: () => NotixToast.show(context,
              type: NotixType.info, title: 'Sync Complete',
              message: '42 files uploaded to cloud.',
              position: NotixToastPosition.top, theme: _theme)),

          // ── Banners ───────────────────────────────────────────
          const _Section('BANNERS'),
          _Btn(label: '✅  Success Banner (top)', color: const Color(0xFF1DB954),
            onTap: () => NotixBanner.show(context,
              type: NotixType.success, title: 'Email Verified',
              message: 'Your account is fully activated.',
              actionLabel: 'Continue', theme: _theme)),
          _Btn(label: '❌  Error Banner (bottom)', color: const Color(0xFFE53935),
            onTap: () => NotixBanner.show(context,
              type: NotixType.error, message: 'No internet connection. Check your network.',
              position: NotixBannerPosition.bottom,
              autoDismiss: false, actionLabel: 'Retry', theme: _theme)),
          _Btn(label: '⚠️  Warning Banner (top)', color: const Color(0xFFF59E0B),
            onTap: () => NotixBanner.show(context,
              type: NotixType.warning, title: 'Session Expiring',
              message: 'Your session will expire in 5 minutes.',
              actionLabel: 'Extend', theme: _theme)),
          _Btn(label: 'ℹ️  Info Banner (bottom)', color: const Color(0xFF1E88E5),
            onTap: () => NotixBanner.show(context,
              type: NotixType.info, message: 'A new version of the app is available.',
              position: NotixBannerPosition.bottom,
              actionLabel: 'Update', theme: _theme)),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  const _Section(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 8),
        child: Text(title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
            color: Color(0xFF9CA3AF), letterSpacing: 1.4)),
      );
}

class _Btn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _Btn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 9),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Colors.grey.shade400),
            ],
          ),
        ),
      );
}