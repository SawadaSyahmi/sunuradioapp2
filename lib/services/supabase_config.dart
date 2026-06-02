class SupabaseConfig {
  const SupabaseConfig._();

  /// Copy this from Supabase Dashboard > Project Settings > Data API.
  /// Use the Project URL only, for example:
  /// https://your-project-ref.supabase.co
  ///
  /// Do NOT use the REST endpoint /rest/v1/ here.
  static const String url = 'bvdrpfdmdsikeyzbqxpl.supabase.co/rest/v1/';

  /// Keep the service role key OUT of the Flutter app.
  /// Use only the anon/public/publishable key here.
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ2ZHJwZmRtZHNpa2V5emJxeHBsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAzNzczNzAsImV4cCI6MjA5NTk1MzM3MH0.GYC5z93-amKXijXx9ovNJb0GAybrghDjtMLUbi5WXoA';

  /// Accepts the correct Project URL and also fixes the common mistake of
  /// pasting "project.supabase.co/rest/v1/" from the API docs.
  static String get projectUrl {
    var value = url.trim();
    if (value.endsWith('/')) value = value.substring(0, value.length - 1);
    value = value.replaceAll('/rest/v1', '');
    if (value.isNotEmpty && !value.startsWith('http://') && !value.startsWith('https://')) {
      value = 'https://$value';
    }
    return value;
  }

  static bool get isConfigured {
    return projectUrl.startsWith('https://') &&
        projectUrl.contains('.supabase.co') &&
        !projectUrl.contains('YOUR_SUPABASE') &&
        anonKey.trim().isNotEmpty &&
        !anonKey.contains('YOUR_SUPABASE');
  }
}
