//
//  TableViewController.swift
//  xmlTut4
//
//  Created by Anil on 02/01/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, NSXMLParserDelegate {

    var parser : NSXMLParser = NSXMLParser()
    var category : [BlogPost] = []
    var categoryID : String = String()
    var catTitle : String = String()
    var eName : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url : NSURL = NSURL(string: "http://api.feedzilla.com/v1/categories.xml")!
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
    }


    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
    
        eName = elementName
        if elementName == "category"{
            categoryID = String()
            catTitle = String()
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if(!data.isEmpty){
            if eName == "a:category_id"{
                categoryID += data
            }else if eName == "a:english_category_name" {
                catTitle += data
            }
            
        }
        self.tableView.reloadData()
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
    
    
        if elementName == "category"{
            
            let blogPost : BlogPost = BlogPost()
            blogPost.categoryID = categoryID
            blogPost.categoryTitle = catTitle
            category.append(blogPost)
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return category.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        let categorys : BlogPost = category[indexPath.row]
        cell.textLabel.text = categorys.categoryTitle
        cell.detailTextLabel?.text = categorys.categoryID
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    
        if segue.identifier == "Second"{
            
            let selectedRow = tableView.indexPathForSelectedRow()?.row
            let Passcategory : BlogPost = category[selectedRow!]
            let seconVC = segue.destinationViewController as BRTableViewController
            seconVC.categoryID = Passcategory.categoryID
        }
    }

}
