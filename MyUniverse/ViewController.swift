//
//  ViewController.swift
//  MyUniverse
//
//  Created by Benjamin THOMAS on 22/03/2021.
//

import UIKit

class ViewController: UIViewController {
    
    struct TabView {
        let index: Int
        let viewController: UIViewController
        
        var leading: NSLayoutConstraint?
        var trailing: NSLayoutConstraint?
    }
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tabContainer: UIView!
    
    
    var tabs: [TabView] = []
    var activeTab: TabView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex

        guard var previousTab = activeTab else { return }
        var nextTab = tabs[index]
        
        let showTabOnTheRight: Bool = previousTab.index < nextTab.index
        
        if showTabOnTheRight {
//            activeTab.trailing?.isActive = false
//
//            nextTab.leading = nextTab.viewController.view.leadingAnchor.constraint(equalTo: activeTab.viewController.view.trailingAnchor)
//            nextTab.leading?.isActive = true
            nextTab.leading?.isActive = false
            nextTab.leading = nextTab.viewController.view.leadingAnchor.constraint(equalTo: previousTab.viewController.view.leadingAnchor, constant: self.view.frame.width)
            nextTab.leading?.isActive = true
        } else {
//            activeTab.leading?.isActive = false
//
//            nextTab.trailing = nextTab.viewController.view.trailingAnchor.constraint(equalTo: activeTab.viewController.view.leadingAnchor)
//            nextTab.trailing?.isActive = true
            nextTab.leading?.isActive = false
            nextTab.leading = nextTab.viewController.view.leadingAnchor.constraint(equalTo: previousTab.viewController.view.leadingAnchor, constant: -view.frame.width)
            nextTab.leading?.isActive = true
        }
        
        self.tabContainer.layoutIfNeeded()
        if showTabOnTheRight {
            previousTab.leading?.constant = -self.view.frame.width
        } else {
            previousTab.leading?.constant = self.view.frame.width
        }
        
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                self?.tabContainer.layoutIfNeeded()
            },
            completion: { [weak self] finished in
                guard finished, let self = self else { return }
                self.tabContainer.bringSubviewToFront(nextTab.viewController.view)
                
                if showTabOnTheRight {
//                    activeTab.trailing?.isActive = true
//                    nextTab.leading?.isActive = false
//                    activeTab.leading?.constant = 0
                    
                    nextTab.leading?.isActive = false
                    nextTab.leading = nextTab.viewController.view.leadingAnchor.constraint(equalTo: self.tabContainer.leadingAnchor)
                    nextTab.leading?.isActive = true
                    
                    previousTab.leading?.constant = 0
                } else {
//                    activeTab.leading?.isActive = true
//                    nextTab.trailing?.isActive = false
//                    activeTab.trailing?.constant = 0
                    
                    nextTab.leading?.isActive = false
                    nextTab.leading = nextTab.viewController.view.leadingAnchor.constraint(equalTo: self.tabContainer.leadingAnchor)
                    nextTab.leading?.isActive = true
                    
                    previousTab.leading?.constant = 0
                }
                
                
                self.tabContainer.layoutIfNeeded()
                self.activeTab = nextTab
            })
    }
    
    func setup() {
        segmentControl.removeAllSegments()
        
        let blueViewController = UIViewController()
        blueViewController.view.translatesAutoresizingMaskIntoConstraints = false
        blueViewController.view.backgroundColor = .blue
        
        let redViewController = UIViewController()
        redViewController.view.translatesAutoresizingMaskIntoConstraints = false
        redViewController.view.backgroundColor = .red
        
        let yellowViewController = UIViewController()
        yellowViewController.view.translatesAutoresizingMaskIntoConstraints = false
        yellowViewController.view.backgroundColor = .yellow
        
        [blueViewController,
         redViewController]
            .enumerated().forEach { index, viewController in
                self.segmentControl.insertSegment(withTitle: "\(index)", at: index, animated: false)
                tabContainer.addSubview(viewController.view)
                
                viewController.view.topAnchor.constraint(equalTo: tabContainer.topAnchor).isActive = true
                viewController.view.widthAnchor.constraint(equalTo: tabContainer.widthAnchor).isActive = true
                viewController.view.heightAnchor.constraint(equalTo: tabContainer.heightAnchor).isActive = true
                viewController.view.bottomAnchor.constraint(equalTo: tabContainer.bottomAnchor).isActive = true
                
                let leading = viewController.view.leadingAnchor.constraint(equalTo: tabContainer.leadingAnchor)
                leading.isActive = true
                
                let tabView = TabView(
                    index: index,
                    viewController: viewController,
                    leading: leading,
                    trailing: nil
                )
                
                tabs.append(tabView)
            }
        
        guard let firstView = tabs.first else { return }
        tabContainer.bringSubviewToFront(firstView.viewController.view)
        segmentControl.selectedSegmentIndex = firstView.index
        activeTab = firstView
    }
    
}
