//
//  DatabaseHandler.swift
//  RoamNotes
//
//  Created by Zafran Mac on 05/10/2023.
//

import Foundation
import SQLite3
class dbmanager{
    func initDatabase() -> OpaquePointer? {
        let filepath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("RoamNotes.db").path
        
        var dbpointer: OpaquePointer?
        if sqlite3_open(filepath, &dbpointer) == SQLITE_OK {
            print("Successfully opened connection to database at \(filepath)")
        } else {
            print("Unable to open database. Verify that you created the directory described in the Getting Started section.")
            return nil
        }
        
        return dbpointer
    }
    
    func CreateInsertUpdateDelete(query: String) -> Bool {
        let dbpointer = self.initDatabase()
        if dbpointer != nil{
            var prepare_stmt : OpaquePointer?
            if sqlite3_prepare_v2(dbpointer, query, -1, &prepare_stmt, nil) == SQLITE_OK{
                if sqlite3_step(prepare_stmt) == SQLITE_DONE{
                    return true;
                }
                
            }
            let msg = String(cString: sqlite3_errmsg(dbpointer))
            print(msg)
            sqlite3_finalize(prepare_stmt)
            
        }
        
        return false
    }
    func InsertImage(tripid: Int, imageData: Data) -> Bool {
        let query = "INSERT INTO AddTripImages (Tripid, image) VALUES (?, ?)"
        
        let dbpointer = self.initDatabase()
        if dbpointer != nil {
            var prepare_stmt: OpaquePointer?
            if sqlite3_prepare_v2(dbpointer, query, -1, &prepare_stmt, nil) == SQLITE_OK {
                print("Trip ID: \(tripid)")
                sqlite3_bind_int(prepare_stmt, 1, Int32(tripid))
                sqlite3_bind_blob(prepare_stmt, 2, (imageData as NSData).bytes, Int32(imageData.count), nil)
                
                if sqlite3_step(prepare_stmt) == SQLITE_DONE {
                    sqlite3_finalize(prepare_stmt)
                    return true
                }
            }
            
            let msg = String(cString: sqlite3_errmsg(dbpointer))
            print(msg)
            sqlite3_finalize(prepare_stmt)
        }
        
        return false
    }
    
    
//    func getImagesFromDatabase() -> [tripImages] {
//        var images: [tripImages] = []
//        let query = "SELECT id, tripid, image FROM AddTripImages"
//
//        if let result = dbmanager.executeQuery(query: query) {
//            for row in result {
//                if let id = row["id"] as? Int,
//                   let tripid = row["tripid"] as? Int,
//                   let imageData = row["image"] as? Data {
//                    let imageRecord = tripImages(id: id, tripid: tripid, image: imageData)
//                    images.append(imageRecord)
//                }
//            }
//        }
//        return images
//    }
    func getImagesFromDatabase(id:Int) -> [tripImages] {
        var tripDataList = [tripImages]()
        let dbpointer = self.initDatabase()
        
        if dbpointer != nil {
            let query = "SELECT id, tripid, image FROM AddTripImages where tripid=\(id)"
            var stmpointer: OpaquePointer?
            
            if sqlite3_prepare_v2(dbpointer, query, -1, &stmpointer, nil) == SQLITE_OK {
                while sqlite3_step(stmpointer) == SQLITE_ROW {
                    let id = Int(sqlite3_column_int(stmpointer, 0))
                    let tripid = Int(sqlite3_column_int(stmpointer, 1))
                    
                    let imageDataPointer = sqlite3_column_blob(stmpointer, 2)
                    let imageDataSize = Int(sqlite3_column_bytes(stmpointer, 2))
                    let imageData = Data(bytes: imageDataPointer! , count: imageDataSize)
                    let tripImage = tripImages(id: id, tripid: tripid, image: imageData)
                    tripDataList.append(tripImage)
                }
                sqlite3_finalize(stmpointer)
            }
        }
        
        return tripDataList
    }

        
    func getAllInfo() -> [Trip] {
        var tripDataList = [Trip]()
        let dbpointer = self.initDatabase()
        if(dbpointer != nil){
            let query = "select * from AddTrip"
            var stmpointer : OpaquePointer?
            if sqlite3_prepare_v2(dbpointer, query, -1, &stmpointer, nil) == SQLITE_OK{
                while sqlite3_step(stmpointer) == SQLITE_ROW {
                    let id = Int(sqlite3_column_int(stmpointer, 0))
                    
                    let destination = String(cString: sqlite3_column_text(stmpointer, 1))
                    
                    let date = String(cString: sqlite3_column_text(stmpointer, 2))
                    
                    let tripdata = Trip(id: id, destination: destination, date: date)
                    tripDataList.append(tripdata)
                }
                sqlite3_finalize(stmpointer)
            }
        }
        return tripDataList
    }
    
    func checkTables() {
        guard let db = initDatabase() else {
            print("Unable to open database.")
            return
        }
        
        var statement: OpaquePointer?
        let query = "SELECT name FROM sqlite_master WHERE type='table';"
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                if let tableName = sqlite3_column_text(statement, 0) {
                    print("Table name: \(String(cString: tableName))")
                }
            }
        } else {
            print("Unable to execute query.")
        }
        
        sqlite3_finalize(statement)
        sqlite3_close(db)
    }
}
