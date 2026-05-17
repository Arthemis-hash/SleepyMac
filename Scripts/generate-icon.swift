#!/usr/bin/env swift

import Foundation
import AppKit

let size = CGSize(width: 1024, height: 1024)
let colorSpace = NSColorSpace.deviceRGB
let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

guard let context = CGContext(
    data: nil,
    width: Int(size.width),
    height: Int(size.height),
    bitsPerComponent: 8,
    bytesPerRow: 0,
    space: colorSpace.cgColorSpace!,
    bitmapInfo: bitmapInfo.rawValue
) else {
    print("Failed to create context")
    exit(1)
}

// Background: dark blue gradient
let gradient = CGGradient(
    colorsSpace: colorSpace.cgColorSpace,
    colors: [NSColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1).cgColor,
             NSColor(red: 0.2, green: 0.2, blue: 0.5, alpha: 1).cgColor] as CFArray,
    locations: [0, 1]
)!

context.drawLinearGradient(
    gradient,
    start: CGPoint(x: 0, y: 0),
    end: CGPoint(x: size.width, y: size.height),
    options: []
)

// Moon crescent
context.setFillColor(NSColor.white.cgColor)
let moonRect = CGRect(x: 212, y: 212, width: 600, height: 600)
context.addEllipse(in: moonRect)
context.fillPath()

// Cutout for crescent effect
context.setFillColor(NSColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1).cgColor)
let cutoutRect = CGRect(x: 360, y: 260, width: 460, height: 460)
context.addEllipse(in: cutoutRect)
context.fillPath()

// Small stars
func drawStar(at point: CGPoint, radius: CGFloat) {
    context.setFillColor(NSColor.white.withAlphaComponent(0.7).cgColor)
    context.addEllipse(in: CGRect(x: point.x - radius, y: point.y - radius,
                                  width: radius * 2, height: radius * 2))
    context.fillPath()
}

drawStar(at: CGPoint(x: 180, y: 750), radius: 6)
drawStar(at: CGPoint(x: 750, y: 800), radius: 4)
drawStar(at: CGPoint(x: 800, y: 200), radius: 5)
drawStar(at: CGPoint(x: 150, y: 300), radius: 3)

// ZZZ text
let text = "Z"
let font = NSFont.systemFont(ofSize: 120, weight: .light)
let textAttrs: [NSAttributedString.Key: Any] = [
    .font: font,
    .foregroundColor: NSColor.white.withAlphaComponent(0.3)
]
let attributed = NSAttributedString(string: text, attributes: textAttrs)
let textSize = attributed.size()
let textRect = CGRect(
    x: 460 - textSize.width / 2,
    y: 460 - textSize.height / 2,
    width: textSize.width,
    height: textSize.height
)
attributed.draw(at: textRect.origin)

guard let cgImage = context.makeImage() else {
    print("Failed to create image")
    exit(1)
}

let image = NSImage(cgImage: cgImage, size: size)
let outputPath = CommandLine.arguments[1]

guard let tiffData = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiffData),
      let pngData = bitmap.representation(using: .png, properties: [:]) else {
    print("Failed to create PNG data")
    exit(1)
}

try pngData.write(to: URL(fileURLWithPath: outputPath))
print("Icon created: \(outputPath)")
