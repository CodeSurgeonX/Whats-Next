import UIKit

var str = "Hello, playground"

class sharedBrowser {
    var url : String?
    var time_out : Int?
    
    static var instance : sharedBrowser = sharedBrowser()
}

var one = sharedBrowser()
var two = sharedBrowser()
one.url = "google"
two.url = "youtube"

var three = sharedBrowser.instance
three.url = "facebook"
var four = sharedBrowser.instance
print(four.url!)



let defaults = UserDefaults.standard

defaults.set("Some Info About The User Stored In The App", forKey: "whatsnext_Userinfo")
print(defaults.string(forKey: "whatsnext_Userinfo")!)



class Apples : Encodable, Decodable {
    var color : String?
    var price : Int?
    var isAvailable : Bool?
}

let myFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Apples.plist")
var applesBucket = [Apples]()

let redApples = Apples()
redApples.color = "Red"
redApples.price = 2
redApples.isAvailable = false
applesBucket.append(redApples)
let greenApples = Apples()
greenApples.color = "Green"
greenApples.price = 1
greenApples.isAvailable = true
applesBucket.append(greenApples)


let encoder = PropertyListEncoder()
let data = try encoder.encode(applesBucket)
do {
    try data.write(to: myFilePath!)
}catch{
    print(error)
}


print("Data has been encoded and saved")

let decoder = PropertyListDecoder()
let encodedData  = try Data(contentsOf: myFilePath!)
let recoveredData : [Apples] = try decoder.decode([Apples].self, from: encodedData)

print(recoveredData[0].color!)
