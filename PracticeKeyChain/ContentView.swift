//
//  ContentView.swift
//  PracticeKeyChain
//
//  Created by 柳元 俊輝 on 2023/12/01.
//

import SwiftUI

struct ContentView: View {
    @State private var inputValue: String = ""
    @State private var outputValue: String = ""

    var body: some View {
        VStack {
            TextField("Enter value to store in Keychain", text: $inputValue)
            Button("Save") {
                KeyChainService.save(key: "myKey", data: inputValue)
            }
            Button("Load") {
                if let loadedData = KeyChainService.load(key: "myKey") {
                    outputValue = loadedData
                }
            }
            Text("Loaded data from Keychain: \(outputValue)")
        }.padding()
    }
}

#Preview {
    ContentView()
}
