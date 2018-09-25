//
//  ViewController.swift
//  Guard
//
//  Created by hc on 2018/9/25.
//  Copyright © 2018年 ios. All rights reserved.
//

import UIKit

import Darwin


class ViewController: UIViewController {

    
    var name: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


//        if name != nil {
//
//        }
//
//        guard name != nil else {
//            return
//        }
        
        
        
//        let imageNameList = ["apple", "pear"]
//        for imageName in imageNameList {
//            guard UIImage(named: imageName) != nil
//                else {
//                    continue
//            }
//
//
//            //do something with image
//            
//        }
        
        
        
        
        
        
        
       
        sayHello(numberOfTimes: 2)

        //
        try! readBedTimeStory2()
        
        //
        print(currenthostName())
        
        procrastinate()
        
        
        flipFlop()
    }

  
    
    func sayHello(numberOfTimes: Int) -> () {
        guard numberOfTimes > 0 else {
            return
        }
        
        for _ in 1...numberOfTimes {
            print("Hello!")
        }
        
    }
    
    
    enum StoryError:Error {
        case missing
        case illegible
        case tooScary
    }
    
    //未使用guard的函数
    func readBedtimeStory() throws {
        if let url = Bundle.main.url(forResource: "books", withExtension: "txt") {
            
            if let data = try? Data(contentsOf: url), let story = String(data: data, encoding: .utf8) {
                if story.contains("👾") {
                    throw StoryError.tooScary
                } else {
                    print("Once upon a time...\(story)")
                }
            } else {
                throw StoryError.illegible
            }
            
        } else {
            throw StoryError.missing
        }
    }
    
    //使用guard
    func readBedTimeStory2() throws {
        
        guard let url = Bundle.main.url(forResource: "books", withExtension: "txt") else {
            throw StoryError.missing
        }
        
        guard let data = try? Data(contentsOf: url), let story = String(data: data, encoding: .utf8) else {
            throw StoryError.illegible
        }
        
        if story.contains("😈") {
            throw StoryError.tooScary
        }
        
        print("Once upon a time...\(story)")
        
    }
    
    
    
    
    
    //defer
    
    func currenthostName() -> String {
        let capacity = Int(NI_MAXHOST)
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: capacity)
        
        guard gethostname(buffer, capacity) == 0 else {
            buffer.deallocate()
            return "localhost"
        }
        
        let hostname = String(cString: buffer)
        buffer.deallocate()
        
        return hostname
        
        
    }
    
    //使用defer
//    考虑在任何需要配对调用的 API 上都使用 defer，比如 allocate(capacity:) / deallocate()、wait() / signal() 和 open() / close()。
    func currentHostName2() -> String {
        let capacity = Int(NI_MAXHOST)
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: capacity)
        defer {
            buffer.deallocate()
        }
        
        guard gethostname(buffer, capacity) == 0 else {
            return "localhost"
        }
        
        return String(cString: buffer)
        
    }
    
    
    
    
    //多个defer
    func procrastinate() {
        defer {
            print("wash the dishes")
        }
        defer {
            print("take out the recycling")
        }
        defer {
            print("clean the refrigerator")
        }
        
        defer {
            defer {
                print("clean the gutter")
            }
        }
        
        
        print("play videogames")
        
    }
    
    
    //如果在 defer 语句中引用了一个变量，执行时会用到变量最终的值。换句话说：defer 代码块不会捕获变量当前的值。
    
    func flipFlop() -> () {
        var position = "It's pronounced /haha/"
        defer {
            print(position)
        }
        
        position = "It's pronounced /hehe/"
        defer {
            print(position)
        }
        
    }
    
    
    // defer 代码块无法跳出它所在的作用域。因此如你尝试调用一个会 throw 的方法，抛出的错误就无法传递到其周围的上下文。
//    作为替代，你可以使用 try? 来无视掉错误，或者直接将语句移出 defer 代码块，将其放到函数的最后，正常的执行。
    func burnAfterReading(file url: URL) throws {
        
        defer {
            try? FileManager.default.removeItem(at: url)
        }
        
        let string = try String(contentsOf: url)
        
    }
    
    
    
    


}

