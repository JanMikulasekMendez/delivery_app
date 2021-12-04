
import 'package:deliveryapp/screens/home/my_cell.dart';

class Package  {

  final String id;
   String name;
  String estimatedAt;
  String arrivedAt;
   String deliveredBy;
   String address;
   String paymentMethod;
   String user;
   bool delivered;
   String ownerID;

  Package({
    this.id = "",
    required this.name,
    this.estimatedAt = "",
    this.arrivedAt = "",
    this.deliveredBy = "",
    this.address = "",
    this.paymentMethod = "",
    this.user = "",
    this.delivered = false,
    this.ownerID = "",
  });

}