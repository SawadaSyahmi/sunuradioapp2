/// Supabase client configuration for SUN4U.
///
/// Build-time values take priority and can be supplied with:
///   --dart-define-from-file=deployment/env/prod.json
///
/// The fallback below is the project's PUBLIC client configuration recovered
/// from this repository's earlier working version. A Supabase publishable/anon
/// key is designed to be present in client applications (including web apps).
/// Database security MUST therefore be enforced with Row Level Security (RLS).
/// Never place a service_role/secret key in this file or in any Flutter build.
class SupabaseConfig {
  const SupabaseConfig._();

  static const String _fallbackUrl = 'https://bvdrpfdmdsikeyzbqxpl.supabase.co';
  static const String _fallbackAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ2ZHJwZmRtZHNpa2V5emJxeHBsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAzNzczNzAsImV4cCI6MjA5NTk1MzM3MH0.GYC5z93-amKXijXx9ovNJb0GAybrghDjtMLUbi5WXoA';

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: _fallbackUrl,
  );

  /// Preferred modern Supabase client-side key.
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  /// Compatibility with projects that still use the legacy anon JWT key.
  static const String legacyAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: _fallbackAnonKey,
  );

  static String get clientKey => publishableKey.trim().isNotEmpty
      ? publishableKey.trim()
      : legacyAnonKey.trim();

  static String get projectUrl {
    var value = url.trim();
    if (value.isNotEmpty && !value.startsWith('http://') && !value.startsWith('https://')) {
      value = 'https://$value';
    }
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

  static const bool hasUrlOverride = bool.hasEnvironment('SUPABASE_URL');
  static const bool hasPublishableKeyOverride = bool.hasEnvironment('SUPABASE_PUBLISHABLE_KEY');
  static const bool hasAnonKeyOverride = bool.hasEnvironment('SUPABASE_ANON_KEY');

  static bool get usesBuildTimeOverride =>
      hasUrlOverride || hasPublishableKeyOverride || hasAnonKeyOverride;
}
