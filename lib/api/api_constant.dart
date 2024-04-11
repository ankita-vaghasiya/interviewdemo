class ApiEndPoints {
  static const String baseUrl = 'http://base_url/api/';
  static AuthEndPoints authEndpoints = AuthEndPoints();
}

class AuthEndPoints {
  final String registerEmail = 'authaccount/registration';
  final String loginEmail = 'authaccount/login';
}

Future<String?> postNewProperty(
    Map<String, String> data,
    XFile? xfile,
    ) async {
  final storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'token');

  Map<String, String> headerOptions = {
    'accept': 'application/json',
    'Authorization': token!,
    "Content-Type": "multipart/form-data",
  };

  var request = http.MultipartRequest('POST', Uri.parse('${Utils.baseUrl}/property'));
  request.fields.addAll(data);
  request.headers.addAll(headerOptions);
  if (xfile != null) {
    File file = File(xfile.path);
    String type = file.path.split('.').last;
    String fileName = file.path.split('/').last;
    http.MultipartFile mFile = http.MultipartFile(
      'photo',
      file.readAsBytes().asStream(),
      await file.length(),
      filename: fileName,
    );
    request.files.add(mFile);
  }

  print(request.files);
  print(request.fields);
  print(request.headers);
  // Map<String, String> ans = {};
  String? ans;
  await request.send().then((response) async {
    if (response.statusCode == 200) {
      print("Successfully added advertisement");
      // await response.stream.transform(utf8.decoder).join().then((String string) {
      //   print("RESPOSE STREAM");
      //   print(string);
      //   ans["id"] = jsonDecode(string)['data']['id'];
      // });
      // ans["res"] = "success";
    } else {
      print('FAILED add advertisement ');
      print(response.statusCode);

      await response.stream.transform(utf8.decoder).join().then((String string) {
        print("RESPOSE STREAM");
        print(string);

        // ans['error'] = string;
        ans = string;
      });
      // ans["res"] = "fail";
    }
  });

  return ans;
}