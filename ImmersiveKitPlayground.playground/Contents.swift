import UIKit

let t = StringTransform("我愛你好嗎 Hello")


print("津路".applyingTransform(StringTransform.mandarinToLatin, reverse: false)?.applyingTransform(.stripCombiningMarks, reverse: false))
print("進路".applyingTransform(StringTransform.mandarinToLatin, reverse: false)?.applyingTransform(.stripCombiningMarks, reverse: false))

var str = "Hello, pla，y一口路gr𣈱dd中。ab楽f...  "
str = str.trimmingCharacters(in: CharacterSet.whitespaces)

//print("\(str.components(separatedBy: CharacterSet.punctuationCharacters))")
//print("\(str.rangeOfCharacter(from: CharacterSet.punctuationCharacters))")

var arr = str.components(separatedBy: " ")
if var last = arr.last {
    let pattern =  "\\p{script=Han}+"
    if let range = last.range(of: pattern, options: .regularExpression, range: nil, locale: nil) {
        print("\(range)")
        
        
        print(last[range.upperBound..<last.endIndex])
        //last.removeSubrange(range)
        //print(last)
    } else {
        print("no range")
    }
    
    
    
    
    /*
    if let regex = try? NSRegularExpression(pattern: pattern, options: .allowCommentsAndWhitespace) {
        let range = NSMakeRange(0, last.count)
        //print("\()")
        let results = regex.matches(in: last, options: [], range: range)
        if let lastResult = results.last {
            let range = lastResult.range
            let index = last.index(last.startIndex, offsetBy: range.location + range.length)
            let sub = last[index..<last.endIndex]
            print("\(sub) loc:\(range.location) \(range.length)")
            if sub.count > 0 {
                //can go to engine
            } else {
                //last char is chinese
            }
        }
    }
     */
    
}
print("\(arr)")



func extract(input : String) -> String {
    let pattern =  "\\p{script=Han}|\\p{InCJK_Symbols_and_Punctuation}+"
    var str = input //"Hello, playgr𣈱ddd...  "
    str = str.trimmingCharacters(in: CharacterSet.whitespaces)
    
    var theStr = str
    var arr = str.components(separatedBy: " ")
    if let last = arr.last {
        theStr = last
    }
    
    if var range = theStr.range(of: pattern, options: .regularExpression, range: nil, locale: nil) {
        while let newRange = theStr.range(of: pattern, options: .regularExpression, range: range.upperBound..<theStr.endIndex, locale: nil) {
            range = newRange
        }
        return String(theStr[range.upperBound..<theStr.endIndex])
    } else {
        theStr = str
    }
    return theStr
}

print("\(extract(input: str))")


