//
//  Mockable.swift
//  TopGames
//
//  Created by Matheus Weber on 13/02/18.
//  Copyright © 2018 Matheus Weber. All rights reserved.
//

import UIKit

class Mockable {
    func mock<T>(jsonFile: String) -> [T] {
        if let path = Bundle.main.path(forResource: jsonFile, ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let results = try decoder.decode([TopModel].self, from: data)
                if let results = results as? [T] {
                    return results
                }
            } catch {
                print(error)
            }
        }
        
        return []
    }
}
