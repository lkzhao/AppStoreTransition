//
//  ViewController.swift
//  AppStoreTransition
//
//  Created by Luke Zhao on 2017-12-04.
//  Copyright © 2017 lkzhao. All rights reserved.
//

import UIKit
import Hero

class View: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    viewDidLoad()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    viewDidLoad()
  }

  func viewDidLoad() {}

  var parentViewController: UIViewController? {
    var responder: UIResponder? = self
    while responder is UIView {
      responder = responder!.next
    }
    return responder as? UIViewController
  }
}

class CardView: View {
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  let imageView = UIImageView(image: #imageLiteral(resourceName: "card1"))
  override func viewDidLoad() {
    super.viewDidLoad()
    titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
    subtitleLabel.font = UIFont.systemFont(ofSize: 17)
    addSubview(imageView)
    addSubview(titleLabel)
    addSubview(subtitleLabel)

    heroModifiers = [.whenMatched(.useNoSnapshot), .spring(stiffness: 300, damping: 25)]
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = bounds
    titleLabel.frame = CGRect(x: 20, y: 30, width: bounds.width - 40, height: 30)
    subtitleLabel.frame = CGRect(x: 20, y: 70, width: bounds.width - 40, height: 30)
  }
}

class RoundedCardWrapperView: View {
  let cardView = CardView()
  override func viewDidLoad() {
    super.viewDidLoad()
    cardView.layer.cornerRadius = 12
    cardView.clipsToBounds = true
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowRadius = 24
    layer.shadowOpacity = 0.25
    layer.shadowOffset = CGSize(width: 0, height: 8)
    addSubview(cardView)
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    if cardView.superview == self {
      // this is necessary because we used useNoSnapshot modifier.
      // we don't want cardView to be resized when Hero is using it for transition
      cardView.frame = bounds
    }
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
  }
}

class FirstView: View {
  let cardWrapperView = RoundedCardWrapperView()
  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundColor = .white
    cardWrapperView.cardView.heroID = "card1"
    cardWrapperView.cardView.titleLabel.text = "Hero"
    cardWrapperView.cardView.subtitleLabel.text = "App Store Card Transition"
    addSubview(cardWrapperView)

    cardWrapperView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
  }
  @objc func tap() {
    parentViewController?.present(ViewController<SecondView>(), animated: true, completion: nil)
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    cardWrapperView.frame = CGRect(x: 20, y: 100, width: bounds.width - 40, height: bounds.width - 40)
  }
}

class SecondView: View {
  let cardView = CardView()
  let contentView = UILabel()
  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundColor = .white
    cardView.heroID = "card1"
    cardView.titleLabel.text = "Hero 2"
    cardView.subtitleLabel.text = "App Store Card Transition"

    contentView.numberOfLines = 0
    contentView.text = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent neque est, hendrerit vitae nibh ultrices, accumsan elementum ante. Phasellus fringilla sapien non lorem consectetur, in ullamcorper tortor condimentum. Nulla tincidunt iaculis maximus. Sed ut urna urna. Nulla at sem vel neque scelerisque imperdiet. Donec ornare luctus dapibus. Donec aliquet ante augue, at pellentesque ipsum mollis eget. Cras vulputate mauris ac eleifend sollicitudin. Vivamus ut posuere odio. Suspendisse vulputate sem vel felis vehicula iaculis. Fusce sagittis, eros quis consequat tincidunt, arcu nunc ornare nulla, non egestas dolor ex at ipsum. Cras et massa sit amet quam imperdiet viverra. Mauris vitae finibus nibh, ac vulputate sapien.
    """
    contentView.heroModifiers = [.useNoSnapshot, .translate(y: -200), .fade]

    addSubview(contentView)
    addSubview(cardView)

    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(gr:))))
  }
  @objc func pan(gr: UIPanGestureRecognizer) {
    let translation = gr.translation(in: self)
    switch gr.state {
    case .began:
      parentViewController?.dismiss(animated: true, completion: nil)
    case .changed:
      Hero.shared.update(translation.y / bounds.height)
    default:
      let velocity = gr.velocity(in: self)
      if ((translation.y + velocity.y) / bounds.height) > 0.5 {
        Hero.shared.finish()
      } else {
        Hero.shared.cancel()
      }
    }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    cardView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width)
    contentView.frame = CGRect(x: 20, y: bounds.width + 20, width: bounds.width - 40, height: bounds.height - bounds.width - 40)
  }
}

class ViewController<RootView: UIView>: UIViewController {
  override func loadView() {
    view = RootView()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    isHeroEnabled = true
  }
}
