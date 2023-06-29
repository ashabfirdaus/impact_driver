import 'package:flutter/material.dart';

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
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.content['surat_jalan'] != null
                                  ? widget.content['surat_jalan']['kode']
                                  : '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                            Text(widget.content['customer'] != null
                                ? widget.content['customer']['nama']
                                : ''),
                            Text(widget.content['customer'] != null
                                ? widget.content['customer']['alamat']
                                : ''),
                            Text(widget.content['customer'] != null
                                ? widget.content['customer']['no_hp']
                                : ''),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(widget.content['surat_jalan'] != null
                                ? widget.content['surat_jalan']['tanggal']
                                : ''),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: widget.content['surat_jalan'] != null
                                      ? statusDelivery[
                                          widget.content['surat_jalan']
                                              ['status_kirim']]['color']
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                widget.content['surat_jalan'] != null
                                    ? statusDelivery[
                                        widget.content['surat_jalan']
                                            ['status_kirim']]['status']
                                    : '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
