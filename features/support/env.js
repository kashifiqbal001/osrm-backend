var path = require('path');
var util = require('util');
var fs = require('fs');
var d3 = require('d3-queue');
var child_process = require('child_process');

// Sets up all constants that are valid for all features
module.exports = function () {
    this.initializeEnv = (callback) => {
        this.TIMEOUT = process.env.CUCUMBER_TIMEOUT && parseInt(process.env.CUCUMBER_TIMEOUT) || 5000;
        // set cucumber default timeout
        this.setDefaultTimeout(this.TIMEOUT);
        this.ROOT_FOLDER = process.cwd();

        this.TEST_FOLDER = path.resolve(this.ROOT_FOLDER, 'test');
        this.DATA_FOLDER = path.resolve(this.TEST_FOLDER, 'cache');
        this.TMP_FOLDER = path.resolve(this.TEST_FOLDER, 'tmp');

        this.PROFILES_PATH = path.resolve(this.ROOT_FOLDER, 'profiles');
        this.FIXTURES_PATH = path.resolve(this.ROOT_FOLDER, 'unit_tests/fixtures');
        this.BIN_PATH = process.env.OSRM_BUILD_DIR && process.env.OSRM_BUILD_DIR || path.resolve(this.ROOT_FOLDER, 'build');

        this.DEFAULT_PROFILE = 'bicycle';
        this.DEFAULT_INPUT_FORMAT = 'osm';
        this.DEFAULT_LOAD_METHOD = 'datastore';
        this.DEFAULT_ORIGIN = [1,1];
        this.OSM_USER = 'osrm';
        this.OSM_GENERATOR = 'osrm-test';
        this.OSM_UID = 1;
        this.OSM_TIMESTAMP = '2000-01-01T00:00:00Z';
        this.WAY_SPACING = 100;
        this.DEFAULT_GRID_SIZE = 100; // meters

        this.OSRM_PORT = process.env.OSRM_PORT && parseInt(process.env.OSRM_PORT) || 5000;
        this.HOST = 'http://127.0.0.1:' + this.OSRM_PORT;

        this.ERROR_LOG_FILE = path.resolve(this.TEST_FOLDER, 'error.log');
        this.OSRM_ROUTED_LOG_FILE = path.resolve(this.TEST_FOLDER, 'osrm-routed.log');
        this.PREPROCESS_LOG_FILE = path.resolve(this.TEST_FOLDER, 'preprocessing.log');
        this.LOG_FILE = path.resolve(this.TEST_FOLDER, 'fail.log');

        // TODO make sure this works on win
        if (process.platform.match(/indows.*/)) {
            this.TERMSIGNAL = 9;
            this.EXE = '.exe';
            this.LIB = '.dll';
            this.QQ = '"';
        } else {
            this.TERMSIGNAL = 'SIGTERM';
            this.EXE = '';
            this.LIB = '.so';
            this.QQ = '';
        }

        this.OSRM_EXTRACT_PATH = path.resolve(util.format('%s/%s%s', this.BIN_PATH, "osrm-extract", this.EXE));
        this.OSRM_CONTRACT_PATH = path.resolve(util.format('%s/%s%s', this.BIN_PATH, "osrm-contract", this.EXE));
        this.OSRM_ROUTED_PATH = path.resolve(util.format('%s/%s%s', this.BIN_PATH, "osrm-routed", this.EXE));
        this.LIB_OSRM_EXTRACT_PATH = util.format('%s/libosrm_extract%s', this.BIN_PATH, this.LIB),
        this.LIB_OSRM_CONTRACT_PATH = util.format('%s/libosrm_contract%s', this.BIN_PATH, this.LIB),
        this.LIB_OSRM_PATH = util.format('%s/libosrm%s', this.BIN_PATH, this.LIB);

        // eslint-disable-next-line no-console
        console.info(util.format('Node Version', process.version));
        if (parseInt(process.version.match(/v(\d)/)[1]) < 4) throw new Error('*** PLease upgrade to Node 4.+ to run OSRM cucumber tests');

        if(!fs.existsSync(this.TEST_FOLDER))
        {
            throw new Error(util.format('*** Test folder %s doesn\'t exist.', this.TEST_FOLDER);
            callback();
            return;
        }

        callback();
    };

    this.getProfilePath = (profile) => {
        return path.resolve(this.PROFILES_PATH, profile + '.lua');
    };

    this.verifyOSRMIsNotRunning = (callback) => {
        if (this.OSRMLoader.up()) {
            callback(new Error('*** osrm-routed is already running.'));
            return;
        }
        callback();
    };

    this.verifyExistenceOfBinaries = (callback) => {
        var verify = (binPath, cb) => {
            fs.exists(binPath, (exists) => {
                if (!exists) throw new Error(util.format('%s is missing. Build failed?', binPath));
                var helpPath = util.format('%s --help > /dev/null 2>&1', binPath);
                child_process.exec(helpPath, (err) => {
                    if (err) {
                        this.log(util.format('*** Exited with code %d', err.code), 'preprocess');
                        throw new Error(util.format('*** %s exited with code %d', helpPath, err.code));
                    }
                    cb();
                });
            });
        };

        var q = d3.queue();
        [this.OSRM_EXTRACT_PATH, this.OSRM_CONTRACT_PATH, this.OSRM_ROUTED_PATH].forEach(bin => { q.defer(verify, bin); });
        q.awaitAll(() => {
            callback();
        });
    };

    process.on('exit', () => {
        if (this.OSRMLoader.loader) this.OSRMLoader.shutdown(() => {});
    });

    process.on('SIGINT', () => {
        process.exit(2);
        // TODO need to handle for windows??
    });
};
