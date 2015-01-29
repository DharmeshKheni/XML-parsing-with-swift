//
//  articleTableViewController.swift
//  xmlTut4
//
//  Created by Anil on 06/01/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit

class articleTableViewController: UITableViewController, NSXMLParserDelegate {

    var parser : NSXMLParser = NSXMLParser()
    var catarticleID : String = String()
    var subCatArticleID : String = String()
    var articleTitle : String = String()
    var articleSummry : String = String()
    var art : [article] = []
    var eName : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var url : NSURL = NSURL(string: "http://api.feedzilla.com/v1/categories/\(catarticleID)/subcategories/\(subCatArticleID)/articles.atom?count=10")!
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
    }

    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        eName = elementName
        if elementName == "title"{
            articleTitle = String()
            articleSummry = String()
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if(!data.isEmpty){
            if eName == "title"{
                articleTitle += data
            }else if eName == "summary" {
                articleSummry += data
            }
            
        }
    }

    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        
        if elementName == "title"  || elementName == "summary"{
            
            let articlenew : article = article()
            articlenew.title = articleTitle
            articlenew.summry = articleSummry
            art.append(articlenew)
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return art.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as CustomTableViewCell

        // Configure the cell...

        let artNew : article = art[indexPath.row]
        cell.nameLabel.text = artNew.title
//        cell.addressLabel?.text = artNew.summry
        return cell
    }

}
