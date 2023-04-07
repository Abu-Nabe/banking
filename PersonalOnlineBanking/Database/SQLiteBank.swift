//
//  SQLiteBank.swift
//  PersonalOnlineBanking
//
//  Created by Abu Nabe on 6/4/2023.
//

import UIKit
import SQLite3

class SQLiteBank {
    static func createTable(){
        var db: OpaquePointer?
           let fileURL = try! FileManager.default
               .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
               .appendingPathComponent("Database.sqlite")
           
           if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
               print("Error opening database")
               return
           }

           let createTableQuery = """
               CREATE TABLE IF NOT EXISTS Banks (
                   id INTEGER PRIMARY KEY AUTOINCREMENT,
                   username TEXT,
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
    
    static func insertBank(username: String, type: String){
        var db: OpaquePointer?
        let fileURL = try!
        FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Database.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        var statement: OpaquePointer?
        let insertQuery = "INSERT INTO Banks (username, type) VALUES (?, ?);"
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (type as NSString).utf8String, -1, nil)
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully inserted to bank")
            } else {
                print("Error inserting to bank")
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(db)
    }
    
    static func retrieveBankData() -> [BankModel] {
        var db: OpaquePointer?
        var bankData: [BankModel] = []
        let fileURL = try! FileManager.default
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent("Database.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
               print("Error opening database")
               return []
           }

           let selectQuery = "SELECT * FROM Banks;"
           var statement: OpaquePointer?
           if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
               while sqlite3_step(statement) == SQLITE_ROW {
                   let id = sqlite3_column_int(statement, 0)
                   let username = String(cString: sqlite3_column_text(statement, 1))
                   let type = String(cString: sqlite3_column_text(statement, 2))
                   
                   let bank = BankModel(username: username, type: type)
                   bankData.append(bank)
               }
               sqlite3_finalize(statement)
           }

           sqlite3_close(db)
           return bankData
    }
}
