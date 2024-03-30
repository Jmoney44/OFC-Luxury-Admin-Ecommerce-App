import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ofcluxury_seller/const/const.dart';
import 'package:ofcluxury_seller/services/store_services.dart';
import 'package:ofcluxury_seller/views/products_screen/product_details.dart';
import 'package:ofcluxury_seller/views/widgets/appbar_widget.dart';
import 'package:ofcluxury_seller/views/widgets/dashboard_button.dart';
import 'package:ofcluxury_seller/views/widgets/loading_indicator.dart';
import 'package:ofcluxury_seller/views/widgets/text_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(dashboard),
      body: StreamBuilder(
          stream: StoreServices.getProducts(currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return loadingIndicator();
            } else {
              var data = snapshot.data!.docs;

              data = data.sortedBy((a, b) =>
                  b['p_wishlist'].length.compareTo(a['p_wishlist'].length));

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                        future: StoreServices.getCounts(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: loadingIndicator());
                          } else {
                            var countData = snapshot.data;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                dashbboardButton(context,
                                    title: products,
                                    count: countData[0].toString(),
                                    icon: icProducts),
                                dashbboardButton(context,
                                    title: orders,
                                    count: countData[1].toString(),
                                    icon: icOrders),
                              ],
                            );
                          }
                        }),
                    10.heightBox,
                    FutureBuilder(
                        future: StoreServices.getCounts(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: loadingIndicator());
                          } else {
                            var countData = snapshot.data;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                dashbboardButton(context,
                                    title: rating,
                                    count: countData[2].toString(),
                                    icon: icStar),
                                dashbboardButton(context,
                                    title: totalSales,
                                    count: countData[3].toString(),
                                    icon: icOrders),
                              ],
                            );
                          }
                        }),
                    10.heightBox,
                    const Divider(),
                    10.heightBox,
                    boldText(text: popular, color: fontGrey, size: 16.0),
                    20.heightBox,
                    ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: List.generate(
                          data.length,
                          (index) => data[index]['p_wishlist'].length == 0
                              ? const SizedBox()
                              : ListTile(
                                  onTap: () {
                                    Get.to(() =>
                                        ProductDetails(data: data[index]));
                                  },
                                  leading: Image.network(
                                      data[index]['p_imgs'][0],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover),
                                  title: boldText(
                                      text: "${data[index]['p_name']}",
                                      color: fontGrey),
                                  subtitle: normalText(
                                      text: "\$${data[index]['p_price']}",
                                      color: darkGrey),
                                )),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
