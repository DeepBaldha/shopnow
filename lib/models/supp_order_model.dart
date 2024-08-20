import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SupplierOrderModel extends StatefulWidget {
  final dynamic order;
  const SupplierOrderModel({Key? key, required this.order}) : super(key: key);

  @override
  State<SupplierOrderModel> createState() => _SupplierOrderModelState();
}

class _SupplierOrderModelState extends State<SupplierOrderModel> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.order['orderid'])
          .update({
        'deliverystatus': 'shipping',
        'deliverydate': picked,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow),
            borderRadius: BorderRadius.circular(15)),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(maxHeight: 80),
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(widget.order['orderimage']),
                  ),
                ),
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.order['ordername'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(('\$ ') +
                              (widget.order['orderprice'].toStringAsFixed(2))),
                          Text(('x ') + (widget.order['orderqty'].toString()))
                        ],
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
          subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('See More ..'),
                Text(widget.order['deliverystatus'])
              ]),
          children: [
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ('Name: ') + (widget.order['custname']),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        ('Phone No.: ') + (widget.order['phone']),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        ('Email Address: ') + (widget.order['email']),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        ('Address: ') + (widget.order['address']),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Row(
                        children: [
                          const Text(
                            ('Payment Status: '),
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            (widget.order['paymentstatus']),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.purple),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            ('Delivery status: '),
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            (widget.order['deliverystatus']),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.green),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            ('Order Date: '),
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            (DateFormat('yyyy-MM-dd')
                                .format(widget.order['orderdate'].toDate())
                                .toString()),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.green),
                          ),
                        ],
                      ),
                      widget.order['deliverystatus'] == 'delivered'
                          ? const Text('This order has been alreay delivered')
                          : Row(
                              children: [
                                const Text(
                                  ('Change Delivery Status To: '),
                                  style: TextStyle(fontSize: 15),
                                ),
                                widget.order['deliverystatus'] == 'preparing'
                                    ? TextButton(
                                        onPressed: () {
                                          /*DatePicker.showDatePicker(context,
                                              minTime: DateTime.now(),
                                              maxTime: DateTime.now().add(
                                                  const Duration(days: 365)),
                                              onConfirm: (date) async {
                                            await FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(widget.order['orderid'])
                                                .update({
                                              'deliverystatus': 'shipping',
                                              'deliverydate': date,
                                            });
                                          });*/
                                          _selectDate(context);
                                        },
                                        child: const Text('shipping ?'))
                                    : TextButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(widget.order['orderid'])
                                              .update({
                                            'deliverystatus': 'delivered',
                                          });
                                        },
                                        child: const Text('delivered ?'))
                              ],
                            ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
