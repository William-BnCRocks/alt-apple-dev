import PNG
import Testing
@testable import DarwinAssets

/// The loose home-screen PNGs of the single-size icon form come from
/// SingleSizeIcon.downsampleRGBA; it must keep colours, not saturate them.
@Suite struct DownsampleRGBATests {
    private func uniform(_ pixel: PNG.RGBA<UInt8>, side: Int) -> [PNG.RGBA<UInt8>] {
        Array(repeating: pixel, count: side * side)
    }

    @Test func opaqueColourIsPreserved() {
        let colour = PNG.RGBA<UInt8>(200, 100, 50, 255)
        for (n, m) in [(1024, 120), (1024, 152), (5, 3)] {
            let out = SingleSizeIcon.downsampleRGBA(uniform(colour, side: n), from: n, to: m)
            #expect(out.count == m * m)
            #expect(out.allSatisfy { $0 == colour }, "\(n) -> \(m)")
        }
    }

    @Test func halfTransparentColourIsPreserved() {
        let colour = PNG.RGBA<UInt8>(200, 100, 50, 128)
        let out = SingleSizeIcon.downsampleRGBA(uniform(colour, side: 8), from: 8, to: 3)
        #expect(out.allSatisfy { $0 == colour })
    }

    @Test func mixedAlphaIsTheAlphaWeightedMean() {
        // Opaque red, opaque blue and two transparent pixels: the colour is
        // the alpha-weighted mean (128, 0, 128), the alpha the plain mean.
        let src: [PNG.RGBA<UInt8>] = [
            .init(255, 0, 0, 255), .init(0, 0, 255, 255),
            .init(0, 0, 0, 0), .init(0, 0, 0, 0),
        ]
        let out = SingleSizeIcon.downsampleRGBA(src, from: 2, to: 1)
        #expect(out == [PNG.RGBA<UInt8>(128, 0, 128, 127)])
    }

    @Test func fullyTransparentStaysTransparent() {
        let out = SingleSizeIcon.downsampleRGBA(
            uniform(.init(10, 20, 30, 0), side: 4), from: 4, to: 2)
        #expect(out.allSatisfy { $0 == PNG.RGBA<UInt8>(0, 0, 0, 0) })
    }
}
