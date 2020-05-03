//
//  Toaster.swift
//  HSTracker
//
//  Created by Martin BONNIN on 03/05/2020.
//  Copyright © 2020 Benjamin Michotte. All rights reserved.
//

import Foundation

class Toaster {
    private let windowManager: WindowManager
    private var hideWorkItem: DispatchWorkItem?
    
    init(windowManager: WindowManager) {
        self.windowManager = windowManager
    }
    
    func displayToast(viewController: NSViewController, timeoutMillis: Int) {
        if let hideWorkItem = self.hideWorkItem {
            hideWorkItem.cancel()
        }
        
        DispatchQueue.main.async {
            let rect = SizeHelper.collectionFeedbackFrame()

            self.windowManager.show(controller: self.windowManager.toastWindowController, show: true, frame: rect, title: nil, overlay: true)

            self.windowManager.toastWindowController.contentViewController = viewController
        }
        
        if timeoutMillis > 0 {
            hideWorkItem = DispatchWorkItem(block: {
                self.windowManager.show(controller: self.windowManager.toastWindowController, show: false)
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(timeoutMillis), execute: self.hideWorkItem!)
        }
    }
    
    func hide() {
        if let hideWorkItem = self.hideWorkItem {
            hideWorkItem.cancel()
        }
        self.windowManager.show(controller: self.windowManager.toastWindowController, show: false)
    }
}