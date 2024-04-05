import Flutter
import UIKit
import Vision
import Foundation
import CoreImage

public class SwiftImagekitplusPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "imagekitplus", binaryMessenger: registrar.messenger())
        let instance = SwiftImagekitplusPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    public func getPlatformVersion(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        print("getPlatformVersion swift");
        result(UIDevice.current.systemVersion)
        
    }
    func imageFromData(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    enum ImageExtractError: Error {
        case noResultFromForegroundMaskRequest
    }
   private func imageSubjectLift(from image: CIImage) throws -> CIImage {
        
        let request = VNGenerateForegroundInstanceMaskRequest()
        
        let handler = VNImageRequestHandler(ciImage: image)
        try handler.perform([request])
        
        guard let result = request.results?.first else {
            throw ImageExtractError.noResultFromForegroundMaskRequest
        }
        
        let maskedImage = try result.generateMaskedImage(
            ofInstances: result.allInstances,
            from: handler,
            croppedToInstancesExtent: false
        );
        
        let output = CIImage(cvPixelBuffer: maskedImage);
        return output;
        
   }
//       public func imageFromData(_ data: Data) -> UIImage? {
//           return UIImage(data: data)
//       }
//
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        // if (call.method == "recognizeText") {
        //     recognizeText(call, result)
        // }
        if (call.method == "removeBackground") {
            removeBackground(call, result)
        }
        if (call.method == "getPlatformVersion") {
            getPlatformVersion(call, result)
        }
        if (call.method == "classifyImage") {
            classifyImage(call, result)
        }
    }
    
    // func recognizeTextFromImage(image: UIImage) -> String {
    //        guard let cgImage = image.cgImage else { return }
           
    //        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
           
    //        let request = VNRecognizeTextRequest { (request, error) in
    //            if let error = error {
    //                print("Error: \(error)")
    //                return
    //            }
               
    //            guard let observations = request.results as? [VNRecognizedTextObservation] else {
    //                print("No text recognized.")
    //                return
    //            }
               
    //            let recognizedStrings = observations.compactMap { observation in
    //                return observation.topCandidates(1).first?.string
    //            }
    //            return recognizedStrings.joined(separator: " ");
    //            print("Recognized text: \(recognizedStrings.joined(separator: " "))")
    //        }
           
    //        do {
    //            try requestHandler.perform([request])
    //        } catch {
    //            print("Error performing request: \(error)")
    //        }
    //     return "failed";
    //    }
    // private func recognizeText(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    //     let uintInt8List =  call.arguments as! FlutterStandardTypedData
    //     let byte = [UInt8](uintInt8List.data)
        
    //     if #available(iOS 13.0, *) {
    //     let fromImage =  imageFromData(Data(byte));
    //         result( recognizeTextFromImage(image:fromImage!));
    //     }else{
    //         result([])
    //     }
    // }
    private func removeBackground(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let uintInt8List =  call.arguments as! FlutterStandardTypedData
        let byte = [UInt8](uintInt8List.data)
        let fromImage =  imageFromData(Data(byte));
        
        if #available(iOS 17.0, *) {
            if let ciImage = fromImage!.ciImage ?? CIImage(image: fromImage!) {
                let uiImage =  imageSubjectLift(from: ciImage);
            
                            if let jpegData = uiImage.jpegData(compressionQuality: 0.8) {
                                let typedData = FlutterStandardTypedData(bytes: jpegData)
                                result(typedData)
                            } else {
                                result("Failed to convert image data")
                            }
                            return;
                  } else {
                      print("Failed to convert UIImage to CIImage")
                  }
          
          
         
        } else {
            result("Background removal is only available on iOS 13 and later.")
        }
    }
    private func classifyImage(_ call: FlutterMethodCall, _ result: @escaping FlutterResult){
        if #available(iOS 15.0, *) {
            let uintInt8List =  call.arguments as! FlutterStandardTypedData
            let byte = [UInt8](uintInt8List.data);
            
            let image =  imageFromData(Data(byte));
            
            let request = VNClassifyImageRequest();
            do {
                
                let supportedIdentifiers = try? request.supportedIdentifiers();
                
           
                
                let requestHandler = VNImageRequestHandler(data: Data(byte));
                
                do {
                    try requestHandler.perform([request])
                } catch {
                    print("Can't make the request due to \(error)")
                }
                guard let results = request.results as? [VNClassificationObservation] else { return }
                
                result(results.map { ["text": $0.identifier, "confidence": $0.confidence] });
            }
            }else{
                result([["error": "image classification  is only available on iOS 13 and later."]]);
            }
            
        }
    }

