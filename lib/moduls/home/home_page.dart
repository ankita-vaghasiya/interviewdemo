import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(appBar: AppBar(title: Text('Home Page')),body:
    Obx(() => homeController.isLoading.value
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
          itemCount: homeController.openseaModel?.assets?.length ?? 0,
          itemBuilder: (context, index)
    {
      return ListTile(
          title: Text(
      homeController.openseaModel?.assets![index].name ??
                  'no name'),
          subtitle: Text(homeController
              .openseaModel?.assets![index].description ??
              'no description')
          leading: homeController
          .openseaModel?.assets![index].imageUrl ==
      null
      ? Icon(Icons.image): Image.network(homeController
        .openseaModel!.assets![index].imageUrl!),
  }))
  }
}
