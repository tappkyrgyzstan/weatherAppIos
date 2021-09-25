//
//  ForecastTableViewCell.swift
//  Weather
//
//  Created by Tilek Sulaymanbekov on 25/9/21.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    static let reuseID = String(describing: ForecastTableViewCell.self)
    static let nib = UINib(nibName: String(describing: ForecastTableViewCell.self), bundle: nil)
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    
    private let userDefaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getDailyForecast(list: Daily) {
        dayTempLabel.text = "\(list.temp?.day ?? 0)"
        nightTempLabel.text = "\(list.temp?.night ?? 0)"
        if let day = list.dt {
            let date = Date(timeIntervalSince1970: TimeInterval(day))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d"
            dateFormatter.timeZone = .current
            let dateStr = dateFormatter.string(from: date)
            dayLabel.text = dateStr
        }
        
        if let icon = list.weather {
            for i in icon {
                let img = i.icon ?? ""
                let urlStr = NSURL(string: "http://openweathermap.org/img/wn/\(img).png")
                if let url = urlStr {
                    let urlData = NSData(contentsOf: url as URL)
                    if urlData != nil {
                        self.icon.image = UIImage(data: urlData! as Data)
                    }
                }
            }
        }
    }
}
