//
//  DropView.swift
//  Pushor
//
//  Created by olivia rodrigue on 03/04/2019.
//  Copyright © 2018 olivia rodrigue. All rights reserved.
//

import Cocoa

// Interface
protocol DragViewDelegate {
    func dragView(didDragFileWith URL: NSURL)
}

class DragView: NSView {
    
    var delegate: DragViewDelegate?
    
    private var fileTypeIsOk = false
    private var acceptedFileExtensions = ["jpg"]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        fileTypeIsOk = checkExtension(drag: sender)
        return []
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return fileTypeIsOk ? .link : []
    }
   
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let draggedFileURL = sender.draggedFileURL else {
            return false
        }
        
        if fileTypeIsOk {
            delegate?.dragView(didDragFileWith: draggedFileURL)
        }
        
        return true
    }
   
    private func checkExtension(drag: NSDraggingInfo) -> Bool {
        guard let fileExtension = drag.draggedFileURL?.pathExtension?.lowercased() else {
            return false
        }
        
        return acceptedFileExtensions.contains(fileExtension)
    }
    
}

extension NSDraggingInfo {
    var draggedFileURL: NSURL? {
        let filenames = draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType.fileURL) as? [String]
        let path = filenames?.first
        
        return path.map(NSURL.init)
    }
}
