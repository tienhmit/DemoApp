//
//  LocalizationStringHelper.swift
//  DemoApp
//
//  Created by Hoang Manh Tien on 2/27/22.
//  Copyright © 2022 Hoang Manh Tien. All rights reserved.
//

import Foundation
import Localize

struct LanguageTypeProperty {
    var locale: String
    var title: String
    var desc: String
    var icon: String
}

enum LanguageType: String {
    case english = "en"
    
    var locale: String {
        return LanguageType.mapProperties[self]?.locale ?? ""
    }
    
    var title: String {
        return LanguageType.mapProperties[self]?.title ?? ""
    }
    
    var desc: String {
        return LanguageType.mapProperties[self]?.desc ?? ""
    }
    
    var icon: String {
        return LanguageType.mapProperties[self]?.icon ?? ""
    }
    
    static func typeWithStr(_ str: String) -> LanguageType {
        return map[str] ?? LanguageType.english
    }
    
    static let map: [String: LanguageType] = [LanguageType.english.rawValue: LanguageType.english]
    
    static var allLanguages: [LanguageType] {
        let list: [LanguageType] = [.english]
        return list
    }
    
    static let mapProperties: [LanguageType: LanguageTypeProperty] = [
        LanguageType.english: LanguageTypeProperty(locale: "en", title: "English", desc: "English", icon: "AC.png")
    ]
}

class LocalizationStringHelper: NSObject {
    
    static func setUpDefaultLanguage () {
        let localize = Localize.shared
        localize.update(provider: .json)
        localize.update(fileName: "lang")
        localize.update(defaultLanguage: LanguageType.english.rawValue)
        localize.update(language: LanguageType.english.rawValue)
    }
    
    class var remove: String                    { return "Remove".localize() }
    class var cancel: String                    { return "Cancel".localize() }
    class var doYouWantRemoveFavorite: String   { return "Do you want remove from favorite list?".localize() }
}
