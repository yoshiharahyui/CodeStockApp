//
//  CodeStockSecondDataModel.swift
//  CodeStockApp
//
//  Created by 吉原飛偉 on 2024/04/11.
//

import Foundation
import RealmSwift

class CodeStockSecondDataModel: Object {
    //データを一意に識別するための識別子
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var imageData: Data?
    @objc dynamic var memotext: String = ""
    @objc dynamic var recordDate: Date = Date()
}
