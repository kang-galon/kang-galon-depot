const String _baseUrl = 'http://192.168.56.1:9000';

Uri getUrl(String path) => Uri.parse(_baseUrl + path);
