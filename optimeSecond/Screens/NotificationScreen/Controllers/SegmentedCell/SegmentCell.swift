//
//  SegmentCell.swift
//  optimeSecond
//
//  Created by Nyazik Byashimova on 18.09.2022.
//

import UIKit

class SegmentCell: UITableViewCell {

    @IBOutlet weak var notificationSegment: UISegmentedControl!
    var selectedSegment: ((Int) -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        notificationSegment.setTitle("All", forSegmentAt: 0)
        notificationSegment.setTitle("MessageRequest", forSegmentAt: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    @IBAction func chooseAction(_ sender: Any) {
        selectedSegment?((sender as AnyObject).selectedSegmentIndex)
    }
    
}
