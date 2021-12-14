//
//  ViewController.swift
//  TestReachability_cocoa
//
//  Created by active on 2021/11/04.
//

import UIKit
import Reachability
import SocketIO

class ViewController: UIViewController {

    @IBOutlet weak var ShowLabel: UILabel!
    
    
    
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Test start")
        testNetWorkNow()
        testSocketIO()
    }
    func testNetWorkNow(){
        reachability.whenReachable = {reachability in
            if reachability.connection == .wifi {
                print("wifi")
                self.ShowLabel.text = "wifi"
            }else{
                print("data?")
                self.ShowLabel.text = "data"
            }
        }
        reachability.whenUnreachable = { _ in
            print("????")
            self.ShowLabel.text = "?"
            self.ShowAlert()
        }
        do{
            try reachability.startNotifier()
        }catch{
            print("?불가능? ")
        }
        
    }// 일단은 해보는중
    @IBAction func ClickButton(_ sender: Any) {
        reachability.stopNotifier()
        print("통하긴 한건가?")// 이거 통하긴 하는데 좀 애매하다
        
    }
    func ShowAlert(){
        let alert = UIAlertController(title: "no Internet", message: "인터넷 끊어짐", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok?", style: .default, handler: {_ in NSLog("hey what happen")}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func testSocketIO(){
        let manager = SocketManager(socketURL: URL(string: "000.000.00.0:32563")!, config: [.log(true), .compress])
        let socket = manager.defaultSocket

        
//        SocketIOClient(manager: <#T##SocketManagerSpec#>, nsp: <#T##String#>)
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }

        socket.on("currentAmount") {data, ack in
            guard let cur = data[0] as? Double else { return }
            
            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                if data != nil {// 일단 여기는 도착하지도 않는다
                    print("?")
                }

                socket.emit("update", ["amount": cur + 2.50])
            }

            ack.with("Got your currentAmount", "dude")
        }

        socket.connect()
    }
    
   
    
//    @objc func actionObserver( note : NSNotification){
//        let reachability = note.object as! Reachability
//        switch reachability.connection{
//        case .wifi:
//            print("와이파이")
//            ShowLabel.text = "와이파이"
//            break
//        case .cellular:
//            print("어.. 암튼 영어")
//            ShowLabel.text = "????"
//            break
//        case .unavailable:
//            print("인터넷 노?")
//            ShowLabel.text = "인터넷 안돰"
//            break
//        case .none:
//            print("오류?그런거인듯?")
//            ShowLabel.text = "버그 "
//            break
//        }
//    }
    
    //What is Network ?
   // let reachability = try! Reachability()
//        NotificationCenter.default.addObserver(self, selector: #selector(actionObserver(note: )), name: .reachabilityChanged, object: reachability)
/*
    NotificationCenter.default.addObserver(self, selector: #selector(actionObserver(note:)), name: .reachabilityChanged, object: reachability)//d
    
    do{
        try reachability.startNotifier()
        
    }catch{
        print("이거 아니래")
    }
 */

}

