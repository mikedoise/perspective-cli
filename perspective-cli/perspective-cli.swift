//
//  VisionCMD.swift
//  VissionCMD
//
//  Created by Michael Doise on 1/13/21.
//

import Foundation
import AppKit
import Vision

enum OptionTypes: String {
    case file = "f"
    case text = "t"
    case help = "h"
    case quit = "q"
    case unknown
    
    init(value: String) {
        switch value {
        case "f": self = .file
        case "t": self = .text
        case "h": self = .help
        case "q": self = .quit
        default: self = .unknown
        }
    }
}

class perspectivecli {
    let consoleIO = ConsoleIO()
    
    func staticMode() {
        let argCount = CommandLine.argc
        let argument = CommandLine.arguments[1]
        let (option, value) = getOption(argument.substring(from: argument.index(argument.startIndex, offsetBy: 1)))
        switch option {
        case .file:
            if argCount != 4 {
                if argCount > 4 {
                    consoleIO.writeMessage("Too many arguments for option \(option.rawValue)", to: .error)
                } else {
                    consoleIO.writeMessage("Too few arguments for option \(option.rawValue)", to: .error)
                }
                consoleIO.printUsage()
            } else {
                let imageFile = CommandLine.arguments[2]
                let textFile = CommandLine.arguments[3]
                let fileManager = FileManager.default
                
                let filecontents = fileManager.contents(atPath: imageFile)
                
                // TODO - Convert image to text file
            }
        case .text:
            if argCount != 3 {
                if argCount > 3 {
                    consoleIO.writeMessage("Too many arguments for option \(option.rawValue)", to: .error)
                } else {
                    consoleIO.writeMessage("Too few arguments for option \(option.rawValue)", to: .error)
                }
                consoleIO.printUsage()
            } else {
                let imageFile = CommandLine.arguments[2]
                let fileManager = FileManager.default
                let filecontents = fileManager.contents(atPath: imageFile)
                recognizeWithVision(withData: filecontents!, withType: "t")
                // TODO - Convert image to text
            }
        case .help:
            consoleIO.printUsage()
        case .unknown, .quit:
            consoleIO.writeMessage("Unknown option \(value)")
            consoleIO.printUsage()
        }
        
    }
    func getOption(_ option: String) -> (option:OptionTypes, value: String) {
        return (OptionTypes(value: option), option)
    }
    func interactiveMode() {
        consoleIO.writeMessage("Welcome to Perspective-CLI. This program converts an image file to text.")
        var shouldQuit = false
        while !shouldQuit {
            consoleIO.writeMessage("Type 'f' to convert to file, or t to return text. Type 'q' to quit.")
            let (option, value) = getOption(consoleIO.getInput())
            switch option {
            case .file:
                consoleIO.writeMessage("Type the name of an image file name: ")
                let imageFile = consoleIO.getInput()
                consoleIO.writeMessage("Type the name of the file you wish to save text to : ")
                let textFile = consoleIO.getInput()
            case .text:
                consoleIO.writeMessage("Type the name of an image file name: ")
                let imageFile = consoleIO.getInput()
                let fileManager = FileManager.default
                let filecontents = fileManager.contents(atPath: imageFile)
                recognizeWithVision(withData: filecontents!, withType: "t")
            case .quit:
                shouldQuit = true
            default:
                consoleIO.writeMessage("Unknown option \(value)", to: .error)
            }
        }
    }
    func recognizeWithVision(withData: Data, withType: String) {
        var recognizedText = ""
        let fileManager = FileManager.default
        if #available(iOS 13, *) {
            let requestHandler = VNImageRequestHandler(data: withData, options: [:])
            let request = VNRecognizeTextRequest { ( request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {return}
                for currentObservation in observations {
                    let topCandidate = currentObservation.topCandidates(1)
                    if let RecognizedText = topCandidate.first {
                        if RecognizedText.confidence >= 0.85 {
                            
                            recognizedText += "\(RecognizedText.string) "
                            //print("\(RecognizedText.string) ")
                            if withType == "t" {
                                self.consoleIO.writeMessage("\(RecognizedText.string) ")
                            } else {
                                try? recognizedText.write(to: URL(string:  CommandLine.arguments[3])!, atomically: true, encoding: String.Encoding.utf8)
                            }
                        }

                    }
                }
            }
            request.recognitionLevel = .accurate
            try? requestHandler.perform([request])
        }
    }
}
