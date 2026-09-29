import 'dart:convert';

import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class UpdateService {
  // ============================================================
  // IMPORTANT: Update this every time you bump the version
  // in pubspec.yaml so the update check works correctly.
  // ============================================================
  static const String currentVersion = '1.0.0';

  // The URL where your version check JSON file is hosted.
  // This file lives at: web/updates/app.json in your project,
  // and becomes available at the URL below after GitHub Pages deploys.
  static const String updateUrl =
      'https://rro-007.github.io/omniformula_solver/updates/app.json';

  static Future<void> checkForUpdate(BuildContext context) async {
    // Show a loading spinner while we fetch the update file
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await http
          .get(Uri.parse(updateUrl))
          .timeout(const Duration(seconds: 10));

      // Guard 1: check mounted before using context after the await
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Close loading spinner

      if (response.statusCode != 200) {
        _showError(
          context,
          'Could not reach update server.\n'
          'Status code: ${response.statusCode}',
        );
        return;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final platformKey = _getPlatformKey();
      final platformData = data[platformKey];

      if (platformData == null) {
        _showError(context, 'No update info found for this platform.');
        return;
      }

      final latestVersion = platformData['version'] as String? ?? '0.0.0';
      final downloadUrl = platformData['download_url'] as String? ?? updateUrl;
      final releaseNotes =
          platformData['release_notes'] as String? ?? 'No release notes.';

      if (_isNewer(latestVersion, currentVersion)) {
        _showUpdateDialog(
          context,
          latestVersion: latestVersion,
          downloadUrl: downloadUrl,
          releaseNotes: releaseNotes,
        );
      } else {
        _showUpToDate(context);
      }
    } catch (e) {
      // Guard 2: check mounted before using context in the catch block
      if (!context.mounted) return;
      // Close the loading spinner if it's still open
      Navigator.of(context).pop();
      _showError(context, 'Error checking for updates:\n$e');
    }
  }

  static String _getPlatformKey() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'macos'; // iOS uses macos key for now
      default:
        return 'web';
    }
  }

  static bool _isNewer(String latest, String current) {
    final latestParts = latest.split('.');
    final currentParts = current.split('.');

    for (int i = 0; i < 3; i++) {
      final l = i < latestParts.length
          ? (int.tryParse(latestParts[i]) ?? 0)
          : 0;
      final c = i < currentParts.length
          ? (int.tryParse(currentParts[i]) ?? 0)
          : 0;
      if (l > c) return true;
      if (l < c) return false;
    }
    return false;
  }

  static void _showUpdateDialog(
    BuildContext context, {
    required String latestVersion,
    required String downloadUrl,
    required String releaseNotes,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Update Available!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current version: $currentVersion'),
              Text('Latest version: $latestVersion'),
              const SizedBox(height: 12),
              const Text(
                "What's new:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(releaseNotes),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _copyDownloadLink(context, downloadUrl);
            },
            child: const Text('Get Update'),
          ),
        ],
      ),
    );
  }

  static void _copyDownloadLink(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Download link copied to clipboard:\n$url'),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  static void _showUpToDate(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("✅ You're Up to Date"),
        content: Text(
          'Current version: $currentVersion\nNo updates available.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Check Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
