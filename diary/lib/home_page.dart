import 'dart:collection';

import 'package:diary/diary_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryService>(
      builder: (context, diaryService, child) {
        return MaterialApp(
          title: 'TableCalendar Example',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: TableBasicsExample(),
        );
      },
    );
  }
}

class Event {
  final String text;
  Event({required this.text});
}

class TableBasicsExample extends StatefulWidget {
  const TableBasicsExample({super.key});

  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // TextField의 값을 가져올 때 사용합니다.
  TextEditingController textController = TextEditingController();

  // 경고 메세지
  String? error;

  HashMap<DateTime, List<Event>> events = HashMap();

  List<Event> _getEventsForDay(DateTime day) {
    DateTime eventDay = getEventDay(day);
    return events[eventDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryService>(builder: (context, diaryService, child) {
      List<Diary> diaryList = diaryService.diaryList;
      return Scaffold(
        appBar: AppBar(
          title: Text('TableCalendar - Basics'),
        ),
        body: Column(
          children: <Widget>[
            TableCalendar(
              firstDay: DateTime.utc(2021, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                markerSize: 10.0,
                markerDecoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
              eventLoader: _getEventsForDay,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: diaryList.length, // bucketList 개수 만큼 보여주기
              itemBuilder: (context, index) {
                Diary diary = diaryList[index]; // index에 해당하는 bucket 가져오기
                return ListTile(
                  // 버킷 리스트 할 일
                  title: Text(
                    diary.text,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  // 삭제 아이콘 버튼
                  trailing: IconButton(
                    icon: Icon(CupertinoIcons.delete),
                    onPressed: () {
                      Diary diary = diaryList[index];
                      showDeleteDialog(context, diaryService, diary);
                    },
                  ),
                  onTap: () {
                    Diary diary = diaryList[index];
                    textController = TextEditingController(text: diary.text);
                    showEditDialog(context, diaryService, diary);
                  },
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(CupertinoIcons.add),
          onPressed: () => {
            if (_selectedDay == null)
              {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('경고'),
                      content: Text('날짜를 선택하세요.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('확인'),
                        )
                      ],
                    );
                  },
                ),
              }
            else
              {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return showDiaryTextBox(diaryService, context);
                  },
                ),
              }
          },
        ),
      );
    });
  }

  Future<dynamic> showEditDialog(
      BuildContext context, DiaryService diaryService, Diary diary) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('일기 수정'),
            content:
                // 텍스트 입력창
                Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                  errorText: error,
                ),
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  String text = textController.text;
                  if (text.isEmpty) {
                    setState(() {
                      error = "내용을 입력해주세요."; // 내용이 없는 경우 에러 메세지
                    });
                  } else {
                    setState(() {
                      error = null; // 내용이 있는 경우 에러 메세지 숨기기
                    });
                    diaryService.update(diary.createdAt, text);
                    textController.text = '';
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  '확인',
                  style: TextStyle(
                    fontFamily: 'NanumSquareR',
                    color: Color.fromRGBO(16, 37, 231, 1),
                    fontSize: 16,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  '취소',
                  style: TextStyle(
                    fontFamily: 'NanumSquareR',
                    color: Color.fromRGBO(16, 37, 231, 1),
                    fontSize: 16,
                  ),
                ),
              )
            ],
          );
        });
  }

  Future<dynamic> showDeleteDialog(
      BuildContext context, DiaryService diaryService, Diary diary) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('일기 삭제'),
            content: Text('삭제 하시겠습니까?'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  diaryService.delete(diary.createdAt);
                  Navigator.pop(context);
                },
                child: Text(
                  '확인',
                  style: TextStyle(
                    fontFamily: 'NanumSquareR',
                    color: Color.fromRGBO(16, 37, 231, 1),
                    fontSize: 16,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  '취소',
                  style: TextStyle(
                    fontFamily: 'NanumSquareR',
                    color: Color.fromRGBO(16, 37, 231, 1),
                    fontSize: 16,
                  ),
                ),
              )
            ],
          );
        });
  }

  AlertDialog showDiaryTextBox(
      DiaryService diaryService, BuildContext context) {
    return AlertDialog(
      title: Text('일기 작성'),
      content:
          // 텍스트 입력창
          Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "한 줄 일기를 작성해주세요.",
            errorText: error,
          ),
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            //diaryService.create(text, _selectedDay);
            String text = textController.text;
            if (text.isEmpty) {
              setState(() {
                error = "내용을 입력해주세요."; // 내용이 없는 경우 에러 메세지
              });
            } else {
              setState(() {
                error = null; // 내용이 있는 경우 에러 메세지 숨기기
              });
              diaryService.create(text, _selectedDay!);
              DateTime eventDay = getEventDay(_selectedDay!);
              if (events.containsKey(eventDay)) {
                List<Event>? evts = events[eventDay];
                evts!.add(Event(text: text));
              } else {
                events.addAll({
                  eventDay: [Event(text: text)]
                });
              }

              textController.text = '';
              Navigator.pop(context); // 화면을 종료합니다.
            }
          },
          child: Text(
            '확인',
            style: TextStyle(
              fontFamily: 'NanumSquareR',
              color: Color.fromRGBO(16, 37, 231, 1),
              fontSize: 16,
            ),
          ),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            '취소',
            style: TextStyle(
              fontFamily: 'NanumSquareR',
              color: Color.fromRGBO(16, 37, 231, 1),
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}

DateTime getEventDay(DateTime selectedDay) {
  return DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day);
}
