//
//  BRTableViewController.swift
//  xmlTut4
//
//  Created by Anil on 02/01/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit

class BRTableViewController: UITableViewController, NSXMLParserDelegate {

    var parser : NSXMLParser = NSXMLParser()
    var categoryID : String = String()
    var subCategoryID : String = String()
    var subCategoryTitle : String = String()
    var subCat : [subCategory] = []
    var eName : String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url : NSURL = NSURL(string: "http://api.feedzilla.com/v1/categories/\(categoryID)/subcategories.xml")!
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
    }


    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        eName = elementName
        if elementName == "subcategory"{
            subCategoryID = String()
            subCategoryTitle = String()
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if(!data.isEmpty){
            if eName == "a:subcategory_id"{
                subCategoryID += data
            }else if eName == "a:english_subcategory_name" {
                subCategoryTitle += data
            }
            
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        
        if elementName == "subcategory"{
            
            let blogPost : subCategory = subCategory()
            blogPost.subCategoryID = subCategoryID
            blogPost.subCategoryTitle = subCategoryTitle
            subCat.append(blogPost)
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return subCat.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        let subCategorys : subCategory = subCat[indexPath.row]
        cell.textLabel.text = subCategorys.subCategoryTitle
        cell.detailTextLabel?.text = subCategorys.subCategoryID

        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "Third"{
            
            let selectedRow = tableView.indexPathForSelectedRow()?.row
            let Passcategory : subCategory = subCat[selectedRow!]
            let ThirdVC = segue.destinationViewController as articleTableViewController
            ThirdVC.catarticleID = categoryID
            ThirdVC.subCatArticleID = Passcategory.subCategoryID
        }
    }
}
