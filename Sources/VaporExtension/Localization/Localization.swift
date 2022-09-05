//
//  File.swift
//  
//
//  Created by 尼诺 on 2022/3/10.
//

import Foundation

/// 语言地区代码
///
/// 使用 language-script 格式, 需符合以下标准：
/// - https://www.rfc-editor.org/info/bcp47
/// - https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry
/// - https://www.w3.org/International/articles/language-tags
/// - https://zh.wikipedia.org/wiki/ISO_639-1
/// - https://zh.wikipedia.org/wiki/ISO_3166-1
public enum LanguageCode: String, Codable {
    case zh_CN = "zh_CN"
    case zh_TW = "zh_TW"
    case en_US = "en_US"
    case ja_JP = "ja_JP"
}

/// 多语言字符串
public struct LocalizableString: Codable{
    /// 国家或地区
    public let code: LanguageCode
    
    /// 内容
    public let localized: String
    
    public init(code: LanguageCode, localized: String) {
        self.code = code
        self.localized = localized
    }
}
