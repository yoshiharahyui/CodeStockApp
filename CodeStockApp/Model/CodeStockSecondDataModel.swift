//
//  CodeStockSecondDataModel.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/11.
//

import Foundation
import RealmSwift

class SpringCodeStockSecondDataModel: Object {
    //データを一意に識別するための識別子
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var imageData: Data?
    @objc dynamic var memotext: String = ""
    @objc dynamic var recordDate: Date = Date()
}

class SummerCodeStockSecondDataModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var imageData: Data?
    @objc dynamic var memotext: String = ""
    @objc dynamic var recordDate: Date = Date()
}

class FallCodeStockSecondDataModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var imageData: Data?
    @objc dynamic var memotext: String = ""
    @objc dynamic var recordDate: Date = Date()
}

class WinterCodeStockSecondDataModel: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var imageData: Data?
    @objc dynamic var memotext: String = ""
    @objc dynamic var recordDate: Date = Date()
}
