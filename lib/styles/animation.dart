import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zap_chat/styles/widget.dart';

import '../chat.dart';

class AnimatedDialog extends StatefulWidget {
  final double height;
  final double width;

  const AnimatedDialog({Key? key, required this.height, required this.width})
      : super(key: key);

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog> {
  final firestore = FirebaseFirestore.instance;
  final controller = TextEditingController();
  String search = '';
  bool show = false;

  Future<void> _refreshData() async {
    await firestore.collection('Users').get();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.height != 0) {
      Timer(const Duration(milliseconds: 200), () {
        setState(() {
          show = true;
        });
      });
    } else {
      setState(() {
        show = false;
      });
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: widget.height,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: widget.width == 0
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.white,
                borderRadius: BorderRadius.only(),
              ),
              child: widget.width == 0
                  ? null
                  : !show
                      ? null
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ChatWidgets.searchField(onChange: (a) {
                              setState(() {
                                search = a;
                              });
                            }),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: StreamBuilder(
                                  stream:
                                      firestore.collection('Users').snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      final data = snapshot.data!.docs
                                          .where((element) =>
                                              element['email']
                                                  .toString()
                                                  .contains(search) ||
                                              element['email']
                                                  .toString()
                                                  .contains(search))
                                          .toList();

                                      return ListView.builder(
                                        itemCount: data.length,
                                        itemBuilder: (context, i) {
                                          Timestamp time = data[i]['date_time'];
                                          return ChatWidgets.card(
                                            title: data[i]['name'],
                                            time: DateFormat('EEE hh:mm')
                                                .format(time.toDate()),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return ChatPage(
                                                      id: data[i].id.toString(),
                                                      name: data[i]['name'],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
