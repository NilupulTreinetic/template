abstract class CacheService {
  // service
  init(name);

  delete();

  saveToLocal(key, value);

  getLocalData(key);

  setVersion();

  getVersion();
}
