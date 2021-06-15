// const String _baseUrl = 'http://192.168.56.1:9000';
const String _baseUrl = 'https://kang-galon.herokuapp.com';

Uri getUrl(String path) => Uri.parse(_baseUrl + path);
