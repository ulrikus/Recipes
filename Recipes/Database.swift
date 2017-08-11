import Foundation

class Database {

    let database: YapDatabase
    let connection: YapDatabaseConnection

    static let shared: Database = {
        return Database(database: YapDatabase(path: String.databasePath()))
    }()

    private init(database: YapDatabase) {
        self.database = database
        self.connection = database.newConnection()
    }
}

extension String {
    static func databasePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let baseDir = paths.count > 0 ? paths[0] : NSTemporaryDirectory()

        let databaseName = "database.sqlite"

        return baseDir + databaseName
    }
}
