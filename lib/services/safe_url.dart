class SafeUrl {
  const SafeUrl._();

  /// Network content used by the app must be HTTPS in production.
  static Uri? https(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null || !uri.hasScheme || uri.scheme.toLowerCase() != 'https' || uri.host.isEmpty) {
      return null;
    }
    return uri;
  }

  static Uri? external(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null || !uri.hasScheme) return null;
    final scheme = uri.scheme.toLowerCase();
    if (scheme == 'https' && uri.host.isNotEmpty) return uri;
    if (scheme == 'mailto' && uri.path.isNotEmpty) return uri;
    return null;
  }

  static bool isYoutube(String raw) {
    final uri = https(raw);
    if (uri == null) return false;
    final host = uri.host.toLowerCase();
    return host == 'youtu.be' || host == 'youtube.com' || host.endsWith('.youtube.com');
  }
}
