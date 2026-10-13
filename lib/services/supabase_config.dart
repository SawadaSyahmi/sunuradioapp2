/// Build-time configuration for Supabase.
///
/// Pass values with Flutter's --dart-define or --dart-define-from-file.
/// The publishable key is intentionally a client key; it is NOT a server secret.
/// Database security must be enforced with Row Level Security (RLS).
class SupabaseConfig {
  const SupabaseConfig._();

  static const String url = String.fromEnvironment('SUPABASE_URL');

  /// Use the Supabase publishable/client key only.
  /// Never place a service_role/secret key in a mobile app.
  static const String publishableKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  /// Compatibility with older Supabase projects/tooling that still labels the
  /// client key as an anon key. This is still a public client credential.
  static const String legacyAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static String get clientKey => publishableKey.trim().isNotEmpty ? publishableKey.trim() : legacyAnonKey.trim();

  static String get projectUrl {
    var value = url.trim();
    while (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }
    value = value.replaceAll('/rest/v1', '');
    return value;
  }

  static bool get isConfigured {
    final uri = Uri.tryParse(projectUrl);
    return uri != null &&
        uri.scheme == 'https' &&
        uri.host.endsWith('.supabase.co') &&
        clientKey.isNotEmpty;
  }
}
