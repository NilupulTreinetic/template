abstract class CacheService {
  init(name);

  delete();

  saveToLocal(key, value);

  getLocalData(key);

  setVersion();

  getVersion();
}
