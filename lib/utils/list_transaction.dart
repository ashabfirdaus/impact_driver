import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTransaction extends StatefulWidget {
  final Map content;
  final Function action;

  const ListTransaction({
    Key? key,
    required this.content,
    required this.action,
  }) : super(key: key);

  @override
  State<ListTransaction> createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListTransaction> {
  Map statusDelivery = {
    '0': {'status': 'Belum Dikirim', 'color': Colors.red},
    '1': {'status': 'Terkirim', 'color': Colors.cyan}
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.action(),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.content['surat_jalan'] != null
                                ? widget.content['surat_jalan']['kode']
                                : '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(widget.content['surat_jalan'] != null
                              ? DateFormat(' d MMMM y', "id_ID").format(
                                  DateTime.parse(
                                      widget.content['surat_jalan']['tanggal']))
                              : ''),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.content['customer'] != null
                              ? widget.content['customer']['nama']
                              : ''),
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: widget.content['surat_jalan'] != null
                                    ? statusDelivery[
                                        widget.content['surat_jalan']
                                            ['status_kirim']]['color']
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              widget.content['surat_jalan'] != null
                                  ? statusDelivery[widget.content['surat_jalan']
                                      ['status_kirim']]['status']
                                  : '',
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Text(widget.content['customer'] != null
                          ? widget.content['customer']['alamat']
                          : ''),
                      Text(widget.content['customer'] != null
                          ? widget.content['customer']['no_hp']
                          : ''),
                      Text(widget.content['surat_jalan'] != null
                          ? widget.content['surat_jalan']['keterangan']
                          : ''),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
