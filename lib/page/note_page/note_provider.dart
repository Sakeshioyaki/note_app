import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:note_app/common/app_const.dart';
import 'package:note_app/model/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

DbNote snapshotToNote(Map<String, Object?> snapshot) {
  return DbNote()..fromMap(snapshot);
}

class DbNotes extends ListBase<DbNote> {
  final List<Map<String, Object?>> list;
  late List<DbNote?> _cacheNotes;

  DbNotes(this.list) {
    _cacheNotes = List.generate(list.length, (index) => null);
  }

  @override
  DbNote operator [](int index) {
    return _cacheNotes[index] ??= snapshotToNote(list[index]);
  }

  @override
  int get length => list.length;

  @override
  void operator []=(int index, DbNote? value) => throw 'read-only';

  @override
  set length(int newLength) => throw 'read-only';
}

class DbNoteProvider with ChangeNotifier {
  final lock = Lock(reentrant: true);
  final DatabaseFactory dbFactory;
  final _updateTriggerController = StreamController<bool>.broadcast();
  Database? db;

  DbNoteProvider(this.dbFactory);

  Future openPath(String path) async {
    db = await dbFactory.openDatabase(path,
        options: OpenDatabaseOptions(
            version: AppConst.kVersion1,
            onCreate: (db, version) async {
              await _createDb(db);
            },
            onUpgrade: (db, oldVersion, newVersion) async {
              if (oldVersion < AppConst.kVersion1) {
                await _createDb(db);
              }
            }));
  }

  void _triggerUpdate() {
    _updateTriggerController.sink.add(true);
  }

  Future<Database?> get ready async => db ??= await lock.synchronized(() async {
        if (db == null) {
          await open();
        }
        return db;
      });

  Future<DbNote?> getNote(int? id) async {
    var list = (await db!.query(AppConst.tableNotes,
        columns: [
          AppConst.columnId,
          AppConst.columnTitle,
          AppConst.columnContent,
          AppConst.columnUpdated
        ],
        where: '${AppConst.columnId} = ?',
        whereArgs: <Object?>[id]));
    if (list.isNotEmpty) {
      return DbNote()..fromMap(list.first);
    }
    return null;
  }

  Future _createDb(Database db) async {
    await db.execute('DROP TABLE If EXISTS ${AppConst.tableNotes}');
    await db.execute(
        'CREATE TABLE ${AppConst.tableNotes}(${AppConst.columnId} INTEGER PRIMARY KEY, ${AppConst.columnTitle} TEXT, ${AppConst.columnContent} TEXT, ${AppConst.columnUpdated} INTEGER)');
    await db.execute(
        'CREATE INDEX NotesUpdated ON ${AppConst.tableNotes} (${AppConst.columnUpdated})');
    await _saveNote(
        db,
        DbNote()
          ..title.v = 'Simple title'
          ..content.v = 'Simple content'
          ..date.v = 1);
    await _saveNote(
        db,
        DbNote()
          ..title.v = 'Welcome to NotePad'
          ..content.v =
              'Enter your notes\n\nThis is a content. Just tap anywhere to edit the note.\n'
                  '${kIsWeb ? '\nYou can open multiple tabs or windows and see that the content is the same in all tabs' : ''}'
          ..date.v = 2);
    _triggerUpdate();
  }

  Future open() async {
    await openPath(await fixPath(AppConst.dbName));
  }

  Future<String> fixPath(String path) async => path;

  /// Add or update a note
  Future _saveNote(DatabaseExecutor? db, DbNote updatedNote) async {
    if (updatedNote.id.v != null) {
      await db!.update(AppConst.tableNotes, updatedNote.toMap(),
          where: '${AppConst.columnId} = ?',
          whereArgs: <Object?>[updatedNote.id.v]);
    } else {
      updatedNote.id.v =
          await db!.insert(AppConst.tableNotes, updatedNote.toMap());
    }
  }

  Future saveNote(DbNote updatedNote) async {
    await _saveNote(db, updatedNote);
    _triggerUpdate();
  }

  Future<void> deleteNote(int? id) async {
    await db!.delete(AppConst.tableNotes,
        where: '${AppConst.columnId} = ?', whereArgs: [id]);
    _triggerUpdate();
  }

  var notesTransformer =
      StreamTransformer<List<Map<String, Object?>>, List<DbNote>>.fromHandlers(
          handleData: (snapshotList, sink) {
    sink.add(DbNotes(snapshotList));
  });

  var noteTransformer =
      StreamTransformer<Map<String, Object?>, DbNote?>.fromHandlers(
          handleData: (snapshot, sink) {
    sink.add(snapshotToNote(snapshot));
  });

  /// Listen for changes on any note
  Stream<List<DbNote?>> onNotes() {
    late StreamController<DbNotes> ctlr;
    StreamSubscription? triggerSubscription;

    Future<void> sendUpdate() async {
      var notes = await getListNotes();
      if (!ctlr.isClosed) {
        ctlr.add(notes);
      }
    }

    ctlr = StreamController<DbNotes>(onListen: () {
      sendUpdate();

      /// Listen for trigger
      triggerSubscription = _updateTriggerController.stream.listen((_) {
        sendUpdate();
      });
    }, onCancel: () {
      triggerSubscription?.cancel();
    });
    return ctlr.stream;
  }

  /// Listed for changes on a given note
  Stream<DbNote?> onNote(int? id) {
    late StreamController<DbNote?> ctlr;
    StreamSubscription? triggerSubscription;

    Future<void> sendUpdate() async {
      var note = await getNote(id);
      if (!ctlr.isClosed) {
        ctlr.add(note);
      }
    }

    ctlr = StreamController<DbNote?>(onListen: () {
      sendUpdate();

      /// Listen for trigger
      triggerSubscription = _updateTriggerController.stream.listen((_) {
        sendUpdate();
      });
    }, onCancel: () {
      triggerSubscription?.cancel();
    });
    return ctlr.stream;
  }

  /// Don't read all fields
  Future<DbNotes> getListNotes(
      {int? offset, int? limit, bool? descending}) async {
    var list = (await db!.query(AppConst.tableNotes,
        columns: [
          AppConst.columnId,
          AppConst.columnTitle,
          AppConst.columnContent
        ],
        orderBy:
            '${AppConst.columnUpdated} ${(descending ?? false) ? 'ASC' : 'DESC'}',
        limit: limit,
        offset: offset));
    return DbNotes(list);
  }

  Future clearAllNotes() async {
    await db!.delete(AppConst.tableNotes);
    _triggerUpdate();
  }

  Future close() async {
    await db!.close();
  }

  Future deleteDb() async {
    await dbFactory.deleteDatabase(await fixPath(AppConst.dbName));
  }
}
