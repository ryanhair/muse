library muse.repo.mongo;


import 'dart:mirrors';
import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:muse_model/model.dart';

class MongoRepositoryBase {
  static Db _db;
  static bool _ready = false;
  static bool get ready {
    return _ready;
  }
  
  static Future onReady;
  
  static Future setDb(String dbPath) {
    _db = new Db(dbPath);
    onReady = _db.open().then((_) {
      _ready = true;
      return _;
    });
    return onReady;
  }
}

class MongoRepository<T> extends MongoRepositoryBase {
  DbCollection collection;
  Uuid uuidGen;
  MongoRepository(String modelName) {
    uuidGen = new Uuid();
    MongoRepositoryBase.onReady.then((_) {
      collection = MongoRepositoryBase._db.collection(modelName);      
    });
  }
  
  _populate(instance, Map data) {
    var mirror = reflect(instance);
    
    data.forEach((k, v) {
      try {
        mirror.setField(new Symbol(k), v);
      }
      catch(e) {}
    });
  }
  
  _toJson(instance) {
    var mirror = reflect(instance);
    return mirror.type.declarations.keys
        .where((d) => mirror.type.declarations[d] is VariableMirror)
        .map((s, v) {
          return mirror.getField(MirrorSystem.getName(s));
        });
  }
  
  _checkErrors() {
    if(MongoRepositoryBase._db == null) {
      throw new Exception('Mongo database connection must first be set up with MongoRepository.setDb()');
    }
    if(!MongoRepositoryBase.ready) {
      throw new Exception('Must first finish connecting to database');
    }
  }
  
  Symbol get idProp {
    var reflectedClass = reflectClass(T);
    return reflectedClass.declarations.keys.firstWhere((Symbol name) {
      return reflectedClass.declarations[name] is VariableMirror && reflectedClass.declarations[name].metadata.any((InstanceMirror m) => m.reflectee == Id);
    }, orElse: () => throw new IdRequiredException());
  }
  
  /**
   * Example query:
   * 'last_name': {
   *   '$in': ['Smith', 'Harris']
   * }
   */
  Stream<T> query(Map query, {Map sort:null, int offset:0, int count:1000}) {
    _checkErrors();
    
    if(query == null) {
      query = {};
    }
    
    var cursor = collection.find(query);
    cursor.skip = offset;
    cursor.limit = count;
    
    if(sort != null) {
      cursor.sort = sort;
    }
//    var items = [];
//    return cursor.forEach((item) => items.add(item)).then(() {
//      return items;
//    });
    
    var reflectedClass = reflectClass(T);
    
    return cursor.stream.map((item) {
      var newInstanceMirror = reflectedClass.newInstance(const Symbol(''), []);
      newInstanceMirror.setField(idProp, item['_id']);
      var newInstance = newInstanceMirror.reflectee;
      _populate(newInstance, item);
      return newInstance;
    });
  }
  
  Future<String> _create(T item) {
    _checkErrors();
    var data = Model.convert(item);
    data.remove(MirrorSystem.getName(idProp));
    data['_id'] = uuidGen.v4();
    return collection.insert(data).then((_) {
      return data['_id'];
    });
  }
  
  void delete(dynamic id) {
    _checkErrors();
    collection.remove({ '_id': id });
  }
  
  Future<T> get(String id) {
    _checkErrors();
    
    return query({
      '_id': id
    }).toList().then((items) {
      return items.isNotEmpty ? items[0] : null;
    });
  }
  
  Future<T> save(T item) {
    _checkErrors();
    var id = reflect(item).getField(idProp).reflectee;
    if(id == null) {
      //It's new, delegate to Create
      return _create(item).then((id) {
        reflect(item).setField(idProp, id);
        return item;
      });
    }
    else {
      var data = Model.convert(item);
      data['_id'] = id;
      data.remove(MirrorSystem.getName(idProp));
      return collection.save(data).then((_) {
        return item;
      });
    }
  }
}

class IdRequiredException implements Exception {
  IdRequiredException() {}
  toString() => 'Model must have field marked as Id';
}