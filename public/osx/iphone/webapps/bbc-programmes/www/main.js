var domain = 'http://code.whomwah.com/bbcprogrammes';
var d = document;

// Handles displaying the top level content menu and building the handlers
// for when the user clicks a button so that they fetch the required data
// and send that on to its correct place before moving on 

var topController = {

    key: 'top',

    menuData: [ 
        {   label: "Radio", 
            url: '/radio/programmes/services.xml', 
            identifier: 'service', 
            fn: 'parseServiceXML' }, 
        {   label: "Television", 
            url: '/tv/programmes/services.xml', 
            identifier: 'service', 
            fn: 'parseServiceXML' }, 
    ],
    
    numberOfRows: function() {
        return this.menuData.length;
    },
    
    prepareRow: function(rowElement, rowIndex, templateElements) {

        if (templateElements.label1) {
            templateElements.label1.innerText = this.menuData[rowIndex].label;
        }
        
        var handler = function() {
            // set vars
            var item = topController.menuData[rowIndex];
            var url = domain + item.url;
            var pi = templateElements[topController.key + 'PI'];
            
            // set handler for the loading data
            var onloadHandler = function() { xmlLoaded(xmlRequest); };
        
            // start the progress bar
            pi.style.visibility = 'visible';

            // XMLHttpRequest setup code
            var xmlRequest = new XMLHttpRequest();
            xmlRequest.onload = onloadHandler;
            xmlRequest.open("GET", url);
            xmlRequest.setRequestHeader("Cache-Control", "no-cache");
            xmlRequest.send(null);

            function xmlLoaded(xmlRequest) {
                if (xmlRequest.status == 200) {
                    // call the function to handle the response data
                    var func = topController[item.fn];
                    func(xmlRequest.responseXML, item.identifier);
                    
                    // move onto the next window
                    var browser = d.getElementById('browser').object;
                    browser.goForward(d.getElementById(item.identifier + 'Level'), item.label);
                    
                    // stop the progress bar
                    pi.style.visibility = 'hidden';
                } else {
                    // something went wrong, tell the user
                    alert("Error fetching data: HTTP status " + xmlRequest.status);
                    pi.style.visibility = 'hidden';
                }
            }
        };
        
        // set handler for menu clicks
        rowElement.onclick = handler;
    },
    
    parseServiceXML: function(doc, identifier) {
        // loop though the XML results
        var services = d.evaluate("//*/service", doc, 
            null, XPathResult.ANY_TYPE, null);
        var service = services.iterateNext();
        
        // clear any existing data
        serviceController.menuData = [];
        
        while( service ) {
            
            // store service data
            var s = {
                name: d.evaluate("title", service, 
                    null, XPathResult.STRING_TYPE, null).stringValue,
                url_key: d.evaluate("@key", service, 
                    null, XPathResult.STRING_TYPE, null).stringValue,
            }
            
            // check for outlets
            var outlets = d.evaluate("*/outlet", service, 
                null, XPathResult.ANY_TYPE, null);
            var outlet = outlets.iterateNext();
                        
            if (outlet) {
                // outlets list
                var outlets_array = [];
                
                // loop through outlets
                while( outlet ) {
                    
                    var ol = {
                        name: d.evaluate("title", outlet, 
                            null, XPathResult.STRING_TYPE, null).stringValue,
                        url_key: d.evaluate("@key", outlet, 
                            null, XPathResult.STRING_TYPE, null).stringValue,
                    }
                    
                    // populate with outlet data
                    outlets_array.push({ 
                        service: s,
                        outlet: ol,
                        label: ol.name,
                        identifier: 'choice',
                    });
            
                    outlet = outlets.iterateNext();
                }
                
                // store the outlet data for later
                serviceController.menuData.push({ 
                    service: s,
                    label: s.name,
                    identifier: 'outlet',
                    outlets: outlets_array,
                });

            } else {
                // no outlets, just store service data
                serviceController.menuData.push({ 
                    service: s,
                    label: s.name,
                    identifier: 'choice',
                });
            }
            
            // move onto the next service
            service = services.iterateNext();
        };
                        
        // reload list to show new data
        var data = d.getElementById(identifier + 'List').object;
        data.reloadData();
    },
};


// Parse the services.xml and create some data containers
// to store the data in. We will need the service and outlet
// data in future pages the user may well move into

var serviceController = {

    menuData: [],
    
    numberOfRows: function() {
        return this.menuData.length;
    },
    
    prepareRow: function(rowElement, rowIndex, templateElements) {

        if (templateElements.label2) {
            templateElements.label2.innerText = this.menuData[rowIndex].label;
        }

        var handler = function() {
            var item = serviceController.menuData[rowIndex];
            
            // If we have outlets, show them
            // otherwise show the schedule data
            if (item.outlets) {
                // add all the outlet data
                outletController.menuData = item.outlets;
                
                // reload the new data into the outlet list
                var data = d.getElementById(item.identifier + 'List').object;
                data.reloadData();
            }
            
            // add the choices forwarding data
            choiceController.forwardingData = { service: item.service, outlet: undefined };
            
            var browser = d.getElementById('browser').object;
            browser.goForward(d.getElementById(item.identifier + 'Level'), item.label);            
        };
        rowElement.onclick = handler;
    }
};


// Build the page show the service names

var outletController = {

    menuData: [],

    numberOfRows: function() {
        return this.menuData.length;
    },
    
    prepareRow: function(rowElement, rowIndex, templateElements) {

        if (templateElements.label3) {
            templateElements.label3.innerText = this.menuData[rowIndex].label;
        }

        var handler = function() {
            var item = outletController.menuData[rowIndex];
            // add the choices forwarding data
            choiceController.forwardingData = { service: item.service, outlet: item.outlet };
            var browser = d.getElementById('browser').object;
            browser.goForward(d.getElementById(item.identifier + 'Level'), item.label); 
        };
        rowElement.onclick = handler;
    }
    
};


// Choices ( Schedules, Genres, Formats, Last On, Recent )

var choiceController = {

    key: 'choice',
    
    currentDateStored: new Date(),

    menuData: [ 
        {   label: "Schedule", 
            identifier: 'schedule' }, 
    ],
    
    forwardingData: {},

    numberOfRows: function() {
        return this.menuData.length;
    },
    
    prepareRow: function(rowElement, rowIndex, templateElements) {
        var self = this;
                
        if (templateElements.label4) {
            templateElements.label4.innerText = self.menuData[rowIndex].label;
        }

        var handler = function() {   
            // progress
            var progress = templateElements[self.key + 'PI'];
            
            // row data
            var rd = self.menuData[rowIndex];
            
            // fetch and parse the XML
            self[rd.identifier + 'Fetcher'](rd, progress);
        };
        rowElement.onclick = handler;
    },
    
    scheduleFetcher: function(rowData, progress) {
        var self = this;
        self.currentDateStored = new Date();
                
        // build the url
        var fd = self.forwardingData;
        var url = domain;
        url += (fd.service == undefined) ? '' : '/' + fd.service.url_key;
        url += '/programmes/schedules';
        url += (fd.outlet == undefined) ? '' : '/' + fd.outlet.url_key;
        url += '.xml';
        
        // go get the data
        self.fetchSchedule(url, progress, 
            function(xmlRequest) {
                if (xmlRequest.status == 200) {
                    // handle the XML
                    self.scheduleParser(xmlRequest.responseXML, rowData);
                    
                    // set schedule page info                  
                    scheduleController.pageData['service'] = self.forwardingData.service;
                    scheduleController.pageData['outlet'] = self.forwardingData.outlet;
                    scheduleController.pageData['date'] = self.currentDateStored;
                    scheduleController.pageData['filter'] = 'ataglance';
                    scheduleController.setHead();
                    
                    // move onto the next window
                    var browser = d.getElementById('browser').object;
                    browser.goForward(d.getElementById(rowData.identifier + 'Level'), rowData.label);
                } else {
                    alert("Sorry, Service not available for " + url);
                }
                
                // hide the progress bar
                progress.style.visibility = 'hidden';
            }
        );
    },
    
    scheduleFetcherWithDate: function(rowData, progress) {
        var self = this;
        var date = self.currentDateStored;
        
        // build the url
        var fd = self.forwardingData;
        var url = domain;
        url += (fd.service == undefined) ? '' : '/' + fd.service.url_key;
        url += '/programmes/schedules';
        url += (fd.outlet == undefined) ? '' : '/' + fd.outlet.url_key;
        url += date ? '/' + date.yyyymmdd() : '';
        url += '.xml';
        
        // go get the data
        self.fetchSchedule(url, progress, 
            function(xmlRequest) {
                if (xmlRequest.status == 200) {
                    // handle the XML
                    self.scheduleParser(xmlRequest.responseXML, rowData);
                        
                    // set schedule head info
                    scheduleController.pageData['service'] = self.forwardingData.service;
                    scheduleController.pageData['outlet'] = self.forwardingData.outlet;
                    scheduleController.pageData['date'] = date;
                    scheduleController.pageData['filter'] = 'ataglance';
                    scheduleController.setHead();
                } else {
                    alert("Sorry, Service not available");
                }
                
                // hide the progress bar
                progress.style.visibility = 'hidden';
            }
        );
    },
    
    fetchSchedule: function(url, progress, callback) {
        // show the progress indicator
        progress.style.visibility = 'visible'; 
        
        // set handler
        var onloadHandler = function() { callback(xmlRequest) };
        
        // XMLHttpRequest setup code
        var xmlRequest = new XMLHttpRequest();
        xmlRequest.onload = onloadHandler;
        xmlRequest.open("GET", url);
        xmlRequest.setRequestHeader("Cache-Control", "no-cache");
        xmlRequest.send(null);
    },
    
    scheduleParser: function(doc, rowData) {                
        // clear existing data
        scheduleController.menuData = [];
        
        // set pageDate
        var has_next_day = d.evaluate("//day[@has_next]", doc, 
            null, XPathResult.ANY_TYPE, null);
        var has_prev_day = d.evaluate("//day[@has_previous]", doc, 
            null, XPathResult.ANY_TYPE, null);
        scheduleController.pageData['has_next_day'] = has_next_day;
        scheduleController.pageData['has_prev_day'] = has_prev_day;
        
        var broadcasts = d.evaluate("//*/broadcast", doc, 
            null, XPathResult.ANY_TYPE, null);
        var broadcast = broadcasts.iterateNext();
        
        while( broadcast ) {
            // reset data
            var episode = {}
            var series = {};
            var brand = {};
                
            //broadcast start time
            var start = d.evaluate("start", broadcast, 
                null, XPathResult.STRING_TYPE, null).stringValue;
            if (start) {
                start = start.substring(11,16);

            }
            var is_repeat = d.evaluate("@is_repeat", broadcast, 
                null, XPathResult.NUMBER_TYPE, null).numberValue;

            // brand
            var b_title = d.evaluate("programme[@type='brand']/title", broadcast, 
                null, XPathResult.STRING_TYPE, null).stringValue;
            if (b_title) {
                brand = { title: b_title };
            }
            
            // series
            var s_title = d.evaluate("programme[@type='series']/display_titles/title", broadcast, 
                null, XPathResult.STRING_TYPE, null).stringValue;
            if (s_title) {
                series = { title: s_title };
            }
            
            // episode
            var e_title = d.evaluate("programme[@type='episode']/display_titles/title", broadcast, 
                null, XPathResult.STRING_TYPE, null).stringValue;
            var e_short_synopsis = d.evaluate("programme[@type='episode']/short_synopsis", broadcast, 
                null, XPathResult.STRING_TYPE, null).stringValue;
            var e_availability = d.evaluate("programme[@type='episode']/media/availability", broadcast, 
                null, XPathResult.STRING_TYPE, null).stringValue;
            var e_pid = d.evaluate("programme[@type='episode']/pid", broadcast, 
                null, XPathResult.STRING_TYPE, null).stringValue;
            var e_dis_title = d.evaluate("programme[@type='episode']/display_titles/title", broadcast, 
                null, XPathResult.STRING_TYPE, null).stringValue;
            var e_dis_subtitle = d.evaluate("programme[@type='episode']/display_titles/subtitle", broadcast, 
                null, XPathResult.STRING_TYPE, null).stringValue;
                
            if (is_repeat) {
                e_short_synopsis += ' (repeat)';
            }
                
            episode = {
                title: e_dis_title,
                subtitle: e_dis_subtitle,
                short_synopsis: e_short_synopsis,
                availability: e_availability,
                pid: e_pid,
            }; 
            
            scheduleController.menuData.push({
                start: start,
                episode: episode,
                series: series,
                brand: brand,
            });
            
            broadcast = broadcasts.iterateNext();
        }

    },
    
};


// Build the page show the service names

var scheduleController = {

    menuData: [],
    
    pageData: {},
    
    setHead: function() {
        // reload the new data into the broadcasts list
        var data = d.getElementById('scheduleList').object;
        data.reloadData();
    
        var sh = d.getElementById('scheduleHeader');
        sh.innerHTML = this.pageData.date.humanReadableDate();
        // build schedule heading
        var scheduleForAry = [];
        if (this.pageData.service != undefined) { 
            scheduleForAry.push(this.pageData.service.name)
        };
        if (this.pageData.outlet != undefined) { 
            scheduleForAry.push(this.pageData.name)
        };
        scheduleForAry.push('Schedule for');
        var ssh = d.getElementById('scheduleServiceHeading');
        ssh.innerHTML = scheduleForAry.join(' ');
        
        // prev and next buttons
        var nd = d.getElementById('nextDay').object;
        nd.setEnabled(this.pageData.has_next_day);
        nd.onclick = function() { nextDaySchedule(event) };
        
        var pd = d.getElementById('previousDay').object;
        pd.setEnabled(this.pageData.has_prev_day);
        pd.onclick = function() { previousDaySchedule(event) };
        
        // Reset More or Less date
        var moreorless = d.getElementById('NowOn');
        moreorless.object.setText('More info');
    },

    numberOfRows: function() {
        return this.menuData.length;
    },
    
    prepareRow: function(rowElement, rowIndex, templateElements) {
    
        var m = this.menuData[rowIndex];

        if (templateElements.start) {
            templateElements.start.innerText = m.start;
        }
        
        if (templateElements.title && m.episode) {
            templateElements.title.innerText = m.episode.title;
        }

        if (templateElements.availability && m.episode) {
            templateElements.availability.innerText = m.episode.availability;
        }
        
        if (this.pageData.filter && this.pageData.filter == 'ataglance') {
        
            if (templateElements.subtitle && m.episode) {
                templateElements.subtitle.innerText = '';
            }
            
            if (templateElements.description && m.episode) {
                templateElements.description.innerText = '';
            }
        
        } else {
        
            if (templateElements.subtitle && m.episode) {
                templateElements.subtitle.innerText = m.episode.subtitle;
            }
            
            if (templateElements.description && m.episode) {
                templateElements.description.innerText = m.episode.short_synopsis;
            }

        }

    }
    
};


function nextDaySchedule(event)
{    
    // progress
    var progress = d.getElementById('genericPI');
    
    // data
    var data = {
        label: "Schedule", 
        identifier: 'schedule',
    }
    
    var cd = choiceController.currentDateStored;
    choiceController.currentDateStored = cd.tomorrow();
            
    // fetch and parse the XML
    choiceController['scheduleFetcherWithDate'](data, progress);
}

function previousDaySchedule(event)
{
    // progress
    var progress = d.getElementById('genericPI');
    
    // data
    var data = {
        label: "Schedule", 
        identifier: 'schedule',
    }
    
    var cd = choiceController.currentDateStored;
    choiceController.currentDateStored = cd.yesterday();
            
    // fetch and parse the XML
    choiceController['scheduleFetcherWithDate'](data, progress);
}

function toggleAtAGlance(event)
{
    // toogle text and meta data
    var butt = d.getElementById('NowOn');
    var txt = butt.innerText;
    var list = d.getElementById('scheduleList').object;
    
    if (txt == 'More info') {
        txt = 'Less';
        for (i=0; i <= list.rows.length-1; i++) {
            var data = scheduleController.menuData[i].episode;
            var row = list.rows[i].object;
            row.templateElements.subtitle.innerText = data.subtitle;
            row.templateElements.availability.innerText = data.availability;
            row.templateElements.description.innerText = data.short_synopsis;
        }
    } else {
        txt = 'More';    
        for (i=0; i <= list.rows.length-1; i++) {
            var row = list.rows[i].object;
            row.templateElements.subtitle.innerText = '';
            row.templateElements.description.innerText = '';
        }
    }
    
    butt.object.setText(txt + ' info');
}


function load()
{
    setTimeout(function() { window.scrollTo(0, 1); }, 5000);
    dashcode.setupParts();
};
