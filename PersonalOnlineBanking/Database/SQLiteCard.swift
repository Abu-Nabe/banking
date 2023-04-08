//
//  SQLiteCard.swift
//  PersonalOnlineBanking
//
//  Created by Abu Nabe on 8/4/2023.
//

import UIKit
import SQLite3

class SQLiteCard{
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
            CREATE TABLE IF NOT EXISTS Cards (
                username TEXT,
                type TEXT,
                last4 TEXT,
                expdate TEXT
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
    
    static func insertCard(username: String, type: String, last4: String, expdate: String) {
        var db: OpaquePointer?
        let fileURL = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Database.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        var statement: OpaquePointer?
        let insertQuery = "INSERT INTO Cards (username, type, last4, expdate) VALUES (?, ?, ?, ?);"
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (type as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (last4 as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (expdate as NSString).utf8String, -1, nil)
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully inserted transaction")
            } else {
                print("Error inserting transaction")
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(db)
    }
    
    static func getCards() -> [CardModel] {
        var cards = [CardModel]()
        var db: OpaquePointer?
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Database.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return cards
        }

        let selectQuery = "SELECT * FROM Cards;"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
//                let id = sqlite3_column_int(statement, 0)
                let username = String(cString: sqlite3_column_text(statement, 0))
                let type = String(cString: sqlite3_column_text(statement, 1))
                let last4 = String(cString: sqlite3_column_text(statement, 2))
                let expdate = String(cString: sqlite3_column_text(statement, 3))
                let cardModel = CardModel(username: username, type: type, last4: last4, expiry: expdate)
                cards.append(cardModel)
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(db)
        return cards
    }
    
    
}
