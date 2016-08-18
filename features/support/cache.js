var d3 = require('d3-queue');

modules.exports = function() {
  this.initializeCache = (callback) => {
    this.getOSRMHash((osrmHash) => {
      this.osrmHash = osrmHash;
    }.bind(this));
  };

  this.getFeatureCacheDirectory = (feature, callback) => {
    let uri = feature.getUri();

    // setup cache for feature data
    this.hashOfFiles([uri], (hash) => {
      // shorten uri to be realtive to 'features/'
      let featurePath = path.relative(path.resolve('./features'), uri).replace('.feature', '');
      // test/cache/bicycle/bollards/{HASH}/
      let featureOSMPath = path.join([this.DATA_PATH, featurePath, hash]);

      callback(featureOSMPath);
    });
  };

  // returns a hash of all OSRM code side dependencies
  this.getOSRMHash = (callback) => {
    let dependencies = [
      this.OSRM_EXTRACT_PATH,
      this.OSRM_CONTRACT_PATH,
      this.OSRM_ROUTED_PATH,
      this.LIB_OSRM_EXTRACT_PATH,
      this.LIB_OSRM_CONTRACT_PATH,
      this.LIB_OSRM_PATH
    ];

    var addLuaFiles = (directory, callback) => {
      fs.readdir(path.normalize(directory), (err, files) => {
        if (err) callback(err);

        var luaFiles = files.filter(f => !!f.match(/\.lua$/)).map(f => path.normalize(directory + '/' + f));
        Array.prototype.push.apply(dependencies, luaFiles);

        callback();
      });
    };

    d3.queue()
      .defer(addLuaFiles, this.PROFILES_PATH)
      .defer(addLuaFiles, this.PROFILES_PATH + '/lib)
      .awaitAll(this.hashOfFiles.bind(this, dependencies, callback));
  };

  // converts the scenario titles in file prefixes
  this.getScenarioPrefix = (scenario) => {
    return scenario.getName().toLowerCase().replace('/', '').replace('-', '').replace(' ', '_');
  };

  // test/cache/{feature_path}/{feature_hash}/{scenario}.osm
  this.getScenarioCacheFile = (featureCacheDirectory, scenarioPrefix) => {
    return path.join([featureCacheDirectory, scenarioPrefix]) + '.osm';
  };

  // test/cache/{feature_path}/{feature_hash}/{osrm_hash}/{scenario}.osrm
  this.getOSRMCacheFile = (featureCacheDirectory, osrmHash, scenarioPrefix) => {
    return path.join([scenarioCacheDirectory, osrmHash, scenarioPrefix]) + '.osrm';
  };

  return this;
};
