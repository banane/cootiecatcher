import CoreText
import Testing
import UIKit
@testable import Cootie

/// One sample of each kind of bundled content.
struct ContentTests {
    @Test func posePhotosAreBundled() {
        for pose in [Pose.closed, .tall, .wide] {
            #expect(UIImage(named: pose.imageName) != nil, "missing \(pose.imageName)")
        }
    }

    @Test func aboutPhotoIsBundled() {
        #expect(UIImage(named: "me_jenny") != nil)
    }

    @Test func flipSoundIsBundled() {
        #expect(Bundle.main.url(forResource: "cootie", withExtension: "wav") != nil)
    }

    @Test func fontRegisters() {
        Theme.registerFont()
        #expect(UIFont(name: Theme.fontName, size: 18) != nil)
    }
}
