//
//  UIGraphicsPDFRendererContext.swift
//  ATPD
//
//  Created by Francisco F on 4/1/23.
//

// credit to: https://betterprogramming.pub/swift-generating-pdfs-dynamically-using-pdfkit-12c37168e106
import PDFKit

extension UIGraphicsPDFRendererContext {
    func addCenterText(fontSize: CGFloat = 21.0,
                       weight: UIFont.Weight = .bold,
                       text: String,
                       cursor: CGFloat,
                       pdfSize: CGSize) -> CGFloat {
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let pdfText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: textFont])
        
        let rect = CGRect(x: (pdfSize.width / 2) - (pdfText.size().width / 2),
                          y: cursor,
                          width: pdfText.size().width,
                          height: pdfText.size().height)
        pdfText.draw(in: rect)
        
        return self.checkContext(cursor: rect.origin.y + rect.size.height, pdfSize: pdfSize)
    }
    
    func addSingleLineText(fontSize: CGFloat = 21.0,
                           weight: UIFont.Weight = .regular,
                           text: String,
                           indent: CGFloat,
                           cursor: CGFloat,
                           pdfSize: CGSize,
                           annotation: PDFAnnotationSubtype? = nil,
                           annotationColor: UIColor? = nil) -> CGFloat {
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let pdfText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: textFont])
        
        let rect = CGRect(x: indent,
                          y: cursor,
                          width: (pdfSize.width - 2) * indent,
                          height: pdfText.size().height)
        pdfText.draw(in: rect)
        
        if let annotation = annotation {
            let annotation = PDFAnnotation(
                bounds: CGRect.init(x: indent,
                                    y: rect.origin.y + rect.size.height,
                                    width: pdfText.size().width,
                                    height: 10),
                forType: annotation,
                withProperties: nil)
            annotation.color = annotationColor ?? .black
            annotation.draw(with: PDFDisplayBox.artBox, in: self.cgContext)
        }
        
        return self.checkContext(cursor: rect.origin.y + rect.size.height, pdfSize: pdfSize)
    }
    
    func addMultiLineText(fontSize: CGFloat = 21.0,
                          weight: UIFont.Weight = .regular,
                          text: String,
                          indent: CGFloat,
                          cursor: CGFloat,
                          pdfSize: CGSize) -> CGFloat {
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping

        let pdfText = NSAttributedString(string: text,
                                         attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                                                      NSAttributedString.Key.font: textFont])
        let pdfTextHeight = pdfText.height(withConstrainedWidth: pdfSize.width - (2 * indent))
        
        let rect = CGRect(x: indent,
                          y: cursor,
                          width: pdfSize.width - (2 * indent),
                          height: pdfTextHeight)
        pdfText.draw(in: rect)

        return self.checkContext(cursor: rect.origin.y + rect.size.height, pdfSize: pdfSize)
    }
    
    func add(image: UIImage?,
             desiredRectSize: CGSize = CGSize(width: 128, height: 128),
             indent: CGFloat,
             cursor: CGFloat,
             pdfSize: CGSize) -> CGFloat {
        let rect = CGRect(x: indent, y: cursor, width: desiredRectSize.width, height: desiredRectSize.height)
        image?.draw(in: rect)
        
        return self.checkContext(cursor: rect.origin.y + rect.size.height, pdfSize: pdfSize)
    }
    
    func checkContext(cursor: CGFloat, pdfSize: CGSize) -> CGFloat {
        guard cursor > (pdfSize.height - 100) else { return cursor }
        
        self.beginPage()
        return 40
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
    
        return ceil(boundingBox.height)
    }
}
