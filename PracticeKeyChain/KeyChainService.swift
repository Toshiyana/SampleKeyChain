//
//  KeyChainService.swift
//  PracticeKeyChain
//
//  Created by 柳元 俊輝 on 2023/12/01.
//

import Foundation
import Security

struct KeyChainService {

    // 指定されたキーとデータで新しい項目を作成または既存の項目を更新するメソッド
    static func save(key: String, data: String) {
        // 文字列データをDataオブジェクトに変換します。変換できない場合は処理を終了します。
        guard let data = data.data(using: .utf8) else { return }
        
        // キーチェーンに保存するためのクエリを作成します。
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,  // アイテムのクラスを汎用パスワードに指定します。
                                    kSecAttrAccount as String: key,   // アカウント属性にキーを指定します。
                                    kSecValueData as String: data]     // 保存するデータを指定します。

        // 既存のデータを削除します。
        SecItemDelete(query as CFDictionary)
        
        // 新たなデータを追加します。エラーが発生した場合、処理は終了します。
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { return }
    }

    // 指定されたキーの値を読み取るメソッド
    static func load(key: String) -> String? {
        // キーチェーンから読み取るためのクエリを作成します。
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,   // アイテムのクラスを汎用パスワードに指定します。
                                    kSecAttrAccount as String: key,  // アカウント属性にキーを指定します。
                                    kSecMatchLimit as String: kSecMatchLimitOne, // 検索結果の項目数を1に制限します。
                                    kSecReturnData as String: kCFBooleanTrue as Any] // 保存されているデータを返すように要求します。

        // 結果を格納するための場所を用意します。
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef) // クエリに一致する項目のコピーを取得し、dataTypeRefに格納します。

        // 操作が成功した場合、保存されていたデータを取り出し、Dataオブジェクトから文字列に変換します。
        guard status == errSecSuccess,
            let data = dataTypeRef as? Data,
            let result = String(data: data, encoding: .utf8) else { return nil }  // 私たちが保存した文字列データを取得し、それをStringに変換します。
      
        return result
    }
}
