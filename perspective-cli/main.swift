//
//  main.swift
//  VissionCMD
//
//  Created by Michael Doise on 1/13/21.
//

import Foundation
import Vision

let perspetiveCLI = perspectivecli()
if CommandLine.argc < 2 {
    perspetiveCLI.interactiveMode()
} else {
    perspetiveCLI.staticMode()
}
