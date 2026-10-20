import Foundation
import PDFKit

let paths = Array(CommandLine.arguments.dropFirst())
let pdfs = paths.isEmpty
  ? ["cv.pdf", "cv-de.pdf", "cv-no-picture.pdf", "cv-de-no-picture.pdf"]
  : paths
let a4 = CGSize(width: 595.276, height: 841.89)
var failed = false

for path in pdfs {
  guard let pdf = PDFDocument(url: URL(fileURLWithPath: path)),
        pdf.pageCount == 1,
        let page = pdf.page(at: 0) else {
    fputs("\(path): expected a readable, one-page PDF\n", stderr)
    failed = true
    continue
  }

  let size = page.bounds(for: .mediaBox).size
  guard abs(size.width - a4.width) < 0.5,
        abs(size.height - a4.height) < 0.5 else {
    fputs("\(path): expected A4; got \(size.width) × \(size.height) pt\n", stderr)
    failed = true
    continue
  }

  print("\(path): 1 A4 page")
}

if failed { exit(1) }
