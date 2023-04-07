//
//  SQLite.swift
//  PersonalOnlineBanking
//
//  Created by Abu Nabe on 6/4/2023.
//

import UIKit
import SQLite3

class SQLiteTransaction {
    static func createTable() {
        var db: OpaquePointer?
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Database.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }

        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS Transactions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT,
                amount TEXT,
                time TEXT,
                type TEXT
            );
        """
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableQuery, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing create table: \(errmsg)")
            sqlite3_finalize(statement)
            return
        }

        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(errmsg)")
            sqlite3_finalize(statement)
            return
        }

        sqlite3_finalize(statement)
    }
    
    
    static func insertTransaction(username: String, amount: String, time: String, type: String) {
        var db: OpaquePointer?
        let fileURL = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Database.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        var statement: OpaquePointer?
        let insertQuery = "INSERT INTO Transactions (username, amount, time, type) VALUES (?, ?, ?, ?);"
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (amount as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (time as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (type as NSString).utf8String, -1, nil)
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully inserted transaction")
            } else {
                print("Error inserting transaction")
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(db)
    }

    static func getTransactions() -> [TransactionModel] {
        var transactions = [TransactionModel]()
        var db: OpaquePointer?
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Database.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return transactions
        }

        let selectQuery = "SELECT * FROM Transactions;"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
//                let id = sqlite3_column_int(statement, 0)
                let username = String(cString: sqlite3_column_text(statement, 1))
                let amount = String(cString: sqlite3_column_text(statement, 2))
                let time = String(cString: sqlite3_column_text(statement, 3))
                let type = String(cString: sqlite3_column_text(statement, 4))
                let transaction = TransactionModel(username: username, amount: amount, time: time, type: type)
                transactions.append(transaction)
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(db)
        return transactions
    }
    
    static func tableExists(tableName: String) -> Bool {
        var database: OpaquePointer?
        let fileURL = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Database.sqlite")
        
        // Open database
        if sqlite3_open(fileURL.path, &database) != SQLITE_OK {
            print("Error opening database")
        }

        let tableName = tableName

        // Check if table exists
        var exists = false
        let query = "SELECT name FROM sqlite_master WHERE type='table' AND name='\(tableName)';"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                exists = true
            }
            sqlite3_finalize(statement)
        }

        // Close database
        sqlite3_close(database)

        return exists
    }
}
