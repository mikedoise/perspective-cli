//
//  main.swift
//  VissionCMD
//
//  Created by Michael Doise on 1/13/21.
//

import Foundation
import Vision

let visioncmd = VisionCMD()
if CommandLine.argc < 2 {
    visioncmd.interactiveMode()
} else {
  visioncmd.staticMode()
}
