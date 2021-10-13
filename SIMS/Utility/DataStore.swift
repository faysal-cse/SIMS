//
//  DataStore.swift
//  SIMS
//
//  Created by Faysal on 11/10/21.
//

import UIKit


class DataStore: NSObject {
    
    //    Store
    //
    //    UserDefaults.standard.set(true, forKey: "Key") //Bool
    //    UserDefaults.standard.set(1, forKey: "Key")  //Integer
    //    UserDefaults.standard.set("TEST", forKey: "Key") //setObject
    //
    //    Retrieve
    //
    //    UserDefaults.standard.bool(forKey: "Key")
    //    UserDefaults.standard.integer(forKey: "Key")
    //    UserDefaults.standard.string(forKey: "Key")
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    // MARK: - Write value -
    static func writeString(value:String, key:String){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func writeBool(value:Bool, key:String){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func writeInteger(value:Int, key:String){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func writeDouble(value:Double, key:String){
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // MARK: - Read value -
    static func readString(key:String) -> String {
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
    
    static func readBool(key:String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func readInteger(key:String) -> Int? {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    static func readDouble(key:String) -> Double? {
        return UserDefaults.standard.double(forKey: key)
    }
    

    /*
    static func setMessage(message:MessageModel) {
        var messageList = DataStore.getMessages()
        
        let index = messageList.firstIndex(where: {$0.timestamp == message.timestamp})
         if index == nil {
            messageList.append(message)
            let placesData = try! JSONEncoder().encode(messageList)
            UserDefaults.standard.set(placesData, forKey: "messages")
        }
    }
    
    static func getMessages() -> [MessageModel] {
        let menuData = UserDefaults.standard.data(forKey: "messages")
        if menuData != nil {
            let menuArray = try! JSONDecoder().decode([MessageModel].self, from: menuData!)
            return menuArray
        }else{
            return []
        }
    }
    
    static func removeMessages(message: MessageModel) -> Bool {
           var messageList = DataStore.getMessages()
         if let index = messageList.firstIndex(where: {$0.timestamp == message.timestamp}) {
               messageList.remove(at: index)
               let placesData = try! JSONEncoder().encode(messageList)
               UserDefaults.standard.set(placesData, forKey: "messages")
            return true
           }
        return false
       }
    */
}
