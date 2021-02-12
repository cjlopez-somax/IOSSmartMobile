//
//  TestUtil.swift
//  SSmartMobile
//
//  Created by Christian on 09-02-21.
//  Copyright © 2021 Christian. All rights reserved.
//

import Foundation

struct TextLog: TextOutputStream {

    /// Appends the given string to the stream.
    mutating func write(_ string: String) {
        
        return
        
        let finalData = "\(GeneralFunctions.getCurrentTime()) - \(string) \n"
        let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        let documentDirectoryPath = paths.first!
        let log = documentDirectoryPath.appendingPathComponent("debugIOs.txt")

        do {
            let handle = try FileHandle(forWritingTo: log)
            handle.seekToEndOfFile()
            handle.write(finalData.data(using: .utf8)!)
            handle.closeFile()
        } catch {
            print(error.localizedDescription)
            do {
                try string.data(using: .utf8)?.write(to: log)
            } catch {
                print(error.localizedDescription)
            }
        }

    }

}
