class Constants {
  // Yahoo Finance Base URLs (No API key needed for basic usage)
  static const String yahooFinanceQuoteUrl = 'https://query2.finance.yahoo.com/v8/finance/chart';
  static const String yahooFinanceSearchUrl = 'https://query2.finance.yahoo.com/v1/finance/search';

  // ESG Enterprise API (via RapidAPI or direct)
  // Get your key at: https://rapidapi.com/esgenterprise/api/esg-environmental-social-governance-data
  static const String esgApiKey = 'YOUR_RAPID_API_KEY_HERE'; 
  static const String esgApiHost = 'esg-environmental-social-governance-data.p.rapidapi.com';
  static const String esgApiBaseUrl = 'https://esg-environmental-social-governance-data.p.rapidapi.com/search';
}
