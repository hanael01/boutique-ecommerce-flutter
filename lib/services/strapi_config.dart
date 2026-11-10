class StrapiConfig {
  static const String url = String.fromEnvironment(
    'STRAPI_URL',
    defaultValue: 'https://strapi-backend-13ae.onrender.com',
  );

  static Uri get origin => Uri.parse(url);
  static Uri get api => origin.resolve('/api/');
}
