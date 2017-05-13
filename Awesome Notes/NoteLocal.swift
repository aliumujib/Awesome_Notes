//
//  NoteLocal.swift
//  Awesome Notes
//
//  Created by Abdul-Mujib Aliu on 5/7/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import Foundation

public class NoteLocal : Note {


    public override func awakeFromNib() {
        super.awakeFromNib()

        self.created_date = NSDate()
        
    }
}
