import Foundation
import UIKit

public struct Formulas {
    
    public var avgRed = 0
    public var avgGreen = 0
    public var avgBlue = 0
    public var totalRed = 0
    public var totalGreen = 0
    public var totalBlue = 0
    public var countPixels = 0
    var myRGBA: RGBAImage
    
    public init(myRGBA: RGBAImage) {
        self.myRGBA = myRGBA
        countPixels = myRGBA.width * myRGBA.height
        
        for y in 0..<myRGBA.height {
            for x in 0..<myRGBA.width {
                let index = y * myRGBA.width + x
                let pixel = myRGBA.pixels[index]

                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
                totalBlue += Int(pixel.blue)
            }
        }
        
        avgRed = totalRed / countPixels
        avgGreen = totalGreen / countPixels
        avgBlue = totalBlue / countPixels
    }

    public mutating func applyRedAttenuation() -> RGBAImage {
        for y in 0..<myRGBA.height {
            for x in 0..<myRGBA.width {
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]

                let redDiff = Int(pixel.red) - avgRed
                if redDiff > 0 {
                    pixel.red = UInt8(max(0, min(255, avgRed + redDiff * 5)))
                    myRGBA.pixels[index] = pixel
                }
            }
        }

        return myRGBA
    }
    
    /* desiredLevelContrast -255 to 255 */
    public mutating func applyContrastToImage(desiredLevelContrast: Float) -> RGBAImage {
        let factor: Float = (259.0 * (desiredLevelContrast + 255.0)) / (255.0 * (259.0 - desiredLevelContrast))
        
        for y in 0..<myRGBA.height {
            for x in 0..<myRGBA.width {
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]
                
                let rRed = factor * (Float(pixel.red) - 128.0) + 128.0
                let rGreen = factor * (Float(pixel.green) - 128.0) + 128.0
                let rBlue = factor * (Float(pixel.blue) - 128.0) + 128.0
                
                pixel.red = UInt8(max(0, min(255, Int(rRed))))
                pixel.green = UInt8(max(0, min(255, Int(rGreen))))
                pixel.blue = UInt8(max(0, min(255, Int(rBlue))))
                
                myRGBA.pixels[index] = pixel
            }
        }

        return myRGBA
    }
    
    public mutating func applyGreyscaleByMeanToImage() -> RGBAImage {
        for y in 0..<myRGBA.height {
            for x in 0..<myRGBA.width {
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]
                
                let mean = (Int(pixel.red) + Int(pixel.green) + Int(pixel.blue))/3
                
                pixel.red = UInt8(mean)
                pixel.green = UInt8(mean)
                pixel.blue = UInt8(mean)
                
                self.myRGBA.pixels[index] = pixel
            }
        }

        return myRGBA
    }
    
    public mutating func applyGreyscaleByWeightToImage() -> RGBAImage {
        for y in 0..<myRGBA.height {
            for x in 0..<myRGBA.width {
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]
                
                let weight = ((0.299 * Float(pixel.red)) + (0.587 * Float(pixel.green)) + (0.114 * Float(pixel.blue)))
                
                pixel.red = UInt8(weight)
                pixel.green = UInt8(weight)
                pixel.blue = UInt8(weight)
                
                myRGBA.pixels[index] = pixel
            }
        }

        return myRGBA
    }
    
    /* desiredLevelBrightness -255 to 255 */
    public mutating func applyBrightnessToImage(desiredLevelBrightness: Int) -> RGBAImage {
        for y in 0..<myRGBA.height {
            for x in 0..<myRGBA.width {
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]

                pixel.red = UInt8(max(0, min(255, Int(pixel.red) + desiredLevelBrightness)))
                pixel.green = UInt8(max(0, min(255, Int(pixel.green) + desiredLevelBrightness)))
                pixel.blue = UInt8(max(0, min(255, Int(pixel.blue) + desiredLevelBrightness)))

                myRGBA.pixels[index] = pixel
            }
        }

        return myRGBA
    }
    
    public mutating func applyColourInversionToImage() -> RGBAImage {
        for y in 0..<myRGBA.height {
            for x in 0..<myRGBA.width {
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]

                pixel.red = UInt8(255 - Int(pixel.red))
                pixel.green = UInt8(255 - Int(pixel.green))
                pixel.blue = UInt8(255 - Int(pixel.blue))

                myRGBA.pixels[index] = pixel
            }
        }

        return myRGBA
    }
    
    /* desiredLevelGamma 0.01 to 7.99 */
    public mutating func applyGammaToImage(desiredLevelGamma: Double) -> RGBAImage {
        let gammaCorrection = 1/desiredLevelGamma
        
        for y in 0..<myRGBA.height {
            for x in 0..<myRGBA.width {
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]
                
                let newRed = 255.0 * (pow((Double(pixel.red) / 255.0), gammaCorrection))
                let newGreen = 255.0 * (pow((Double(pixel.green) / 255.0), gammaCorrection))
                let newBlue = 255.0 * (pow((Double(pixel.blue) / 255.0),gammaCorrection))

                pixel.red = UInt8(newRed)
                pixel.green = UInt8(newGreen)
                pixel.blue = UInt8(newBlue)

                myRGBA.pixels[index] = pixel
            }
        }

        return myRGBA
    }
    
    public mutating func applyFilterByName(filter: String) -> RGBAImage {
        switch filter {
        case "50% Brightness":
            return applyBrightnessToImage(desiredLevelBrightness: -128)
        case "2x Contrast":
            return applyContrastToImage(desiredLevelContrast: 128.0)
        case "Better greyscale":
            return applyGreyscaleByWeightToImage()
        case "4x Gamma":
            return applyGammaToImage(desiredLevelGamma: 4.0)
        case "Colour inversion":
            return applyColourInversionToImage()
        default:
            return myRGBA
        }
    }
}
