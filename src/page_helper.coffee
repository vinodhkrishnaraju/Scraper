class PageHelper

  ##Helper functions for Casper Page ##
        

    header : '"PropertyName","Address","Category","CivicNumber","StreetName","CityName","Province","PostalCode","RentOrSale","YearBuilt","TotalLandArea","BuildingArea","WareHouseArea","MinSqFeet","MaxSqFeet","SalePrice","BaseRent","AdditionalRent","AgencyName","ClearHeight","ContactName","TruckLevelDoors","DriveInDoors","ContactNo","ImageUrl","Parking","Zoning","OccupancyDate","URL","Description"'

    links : []

    _pisPaginationAvailable : ->
        e = undefined
        try
            return __utils__.exists('#pagination-flickr')
        catch _error
            e = _error
            return console.log(e)
        return

    _pgetLinks : (selector)->
        try
            #elems = document.querySelectorAll('.property_details > h2 > a')
            #elems = document.querySelectorAll('.property_details > h2 > a')
            elems = document.querySelectorAll(selector)
            links = (link.href for link in elems)
        catch e
            console.log e
    		

    _pgetNextLink : (selector) ->
    	try
    		nextElem = jQuery(selector)	
    		nextExists = nextElem.length>0
    		console.log 'NextLink Exists:'+nextExists
    		if nextExists			
    			href = nextElem[0].href			
    			href
    		else
    			null
    	catch e
            console.log e

    _psetWindowLocation : (scrpt)->
        try
            console.log 'window.location:......' + scrpt
            return window.location = $(scrpt)[0].href
        catch _error
            e = _error
            return console.log(e)

    _psetPageOptions : (selector, value) ->
        try
            return $(selector).val(value).change()#$('#Select1').val('100').change()
        catch _error
            e = _error
            return console.log(e)
        return
        




    _psetSearchOptions : ->
        try
            return $('#Select1 option:last').val().change();
        catch _error
            e = _error
            return console.log(e)
  
    _peval : (scrpt) ->
        try
            return eval(scrpt)
        catch _error
            e = _error
            return console.log(e)
      
    evalInPage : (scrpt)->
      ### pass javascript as string and execute it in browser context ###
      try
          eval(scrpt)
      catch e
          console.log e

    _pchangeLang : (selector) ->
        try
            changeLang = $(selector)
            jQuery(selector)[0].href
            changeExists = changeLang.length>0
            if changeExists
                href = $(selector)[0].href
                href
            else 
                null
        catch _error
            e = _error
            return console.log(e)
    

    captureLinks : (LinksSelector) ->    
        hrefs = @evaluate @_pgetLinks(LinksSelector)
        links = []
        links.push.apply(links,hrefs)
        @echo 'No of links.....:' + links.length
        links


    getDataFromPage : (self,url)->
        ###
        Helper function to open and get data from a link
        ###
        casper.then ->
            casper.logDebug 'opening the link:'+url
            casper.open url
            #pageDriver.waitForDetailPage casper
        casper.then ->
            pageData = @evaluate _pprocessPage
            #casper.logDebug JSON.stringify(pageData)
            data.push '\n' + pageData
            casper.logDebug 'collected data from '+(currentLink+data.length)+' links/'+links.length
            casper.clear()
        casper.then ->
            if data.length is 500
                @exportData()

    getDataFromLinks : (casper, filename)->
        ###
        Helper function to collect data from all the links
        ###
        data.push header
        casper.each links,@getDataFromPage 
        casper.then ->
            @exportData()
            
    exportData : (casper)->
        ###
        write the data collected from links in to a file
        ###    
        if data.length > 0
            casper.then ->
                fs.write filename, data, 'a'
            casper.then ->
                #filePart += 1
                currentLink += data.length
                data = []
  



module.exports =
  get : ->
        ### Returns the instance of PageDriver ###
        new PageHelper