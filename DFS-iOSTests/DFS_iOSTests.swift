import XCTest
@testable import DFS_iOS


/// Test class for some methods of this application
/// - author: Julian Einspenner
class DFS_iOSTests: XCTestCase {
    
    //UtilsTests
    func testCheckLoginDetailsTrue(){
        let bool = Utils.checkLoginDetails(name: "SteveJobs", pw: "MacOS", ip: "192.168.0.42")
        XCTAssertEqual(bool, true)
    }
    
    func testCheckLoginDetailsFalse(){
        let bool = Utils.checkLoginDetails(name: "", pw: "MacOS", ip: "192.168.0.42")
        XCTAssertEqual(bool, false)
    }
    
    func testStringToBase64(){
        var text = "i will be converted to base64"
        text = Utils.encodeStringToBase64(str: text)
        XCTAssertEqual(text, "aSB3aWxsIGJlIGNvbnZlcnRlZCB0byBiYXNlNjQ=")
    }
    
    func testGenerateImageName(){
        let imageName = Utils.generateImageName()
        
        print(imageName)
        
        XCTAssertNotNil(imageName)
    }
    
    func testGenerateImageNamePrefixAndSuffix(){
        let prefix = "IMG_"
        let suffix = ".jpg"
        
        let imageName = Utils.generateImageName()
        
        var containsPrefixAndSuffix = false
        if imageName.contains(prefix) && imageName.contains(suffix){
            containsPrefixAndSuffix = imageName.contains("IMG_") && imageName.contains(".jpg")
        }
        
        XCTAssertEqual(true, containsPrefixAndSuffix)
    }
    
    //JSON-Parser
    func testExtractJsonFromImageContainer(){
        let data = "[{\"test\":\"1234\"}]".data(using: .ascii)
        let json = JsonParser.extractJsonDataFromImageContainer(data!)
        
        let expectedValue = json[0]["test"] as! String
        
        XCTAssertEqual(expectedValue, "1234")
    }
}
