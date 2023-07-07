import 'package:flutter/material.dart';

import 'main.dart';

/// Bucket 담당
class BucketService extends ChangeNotifier {
  List<Bucket> bucketList = [
    Bucket('잠자기', false), // 더미(dummy) 데이터
  ];

  /// bucket 추가
  void createBucket(String job) {
    bucketList.add(Bucket(job, false));
    notifyListeners(); // 새로고침, Consumer builder() 내부만 새로고침한다.
  }

  void updateBucket(Bucket bucket, int index) {
    bucketList[index] = bucket;
    notifyListeners();
  }

  void deleteBucket(int index) {
    bucketList.removeAt(index);
    notifyListeners();
  }
}
