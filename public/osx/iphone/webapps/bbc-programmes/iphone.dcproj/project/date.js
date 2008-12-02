Date.prototype.setISO8601 = function(string) {
    var regexp = "([0-9]{4})(-([0-9]{2})(-([0-9]{2})" +
        "(T([0-9]{2}):([0-9]{2})(:([0-9]{2})(\.([0-9]+))?)?" +
        "(Z|(([-+])([0-9]{2}):([0-9]{2})))?)?)?)?";
    var d = string.match(new RegExp(regexp));

    var offset = 0;
    var date = new Date(d[1], 0, 1);

    if (d[3]) { date.setMonth(d[3] - 1); }
    if (d[5]) { date.setDate(d[5]); }
    if (d[7]) { date.setHours(d[7]); }
    if (d[8]) { date.setMinutes(d[8]); }
    if (d[10]) { date.setSeconds(d[10]); }
    if (d[12]) { date.setMilliseconds(Number("0." + d[12]) * 1000); }
    if (d[14]) {
        offset = (Number(d[16]) * 60) + Number(d[17]);
        offset *= ((d[15] == '-') ? 1 : -1);
    }

    offset -= date.getTimezoneOffset();
    time = (Number(date) + (offset * 60 * 1000));
    this.setTime(Number(time));
    
    return this;
}

Date.prototype.dateNameWithOrdinal = function() {
    var d = this.getDate();
    var cmp = this.getDate() % 10;
    var ext = '';
    
    switch(cmp) {
        case 1: ext = 'st'; break;    
        case 2: ext = 'nd'; break;
        case 3: ext = 'rd'; break;
        default: ext = 'th';
    };

    return d + ext;
}

Date.prototype.dayName = function() {
    var weekdayNames = "Sunday Monday Tuesday Wednesday Thursday Friday Saturday".split(" ");
    return weekdayNames[this.getDay()];
}

Date.prototype.monthName = function() {
    var monthNames = "January February March April May June July August September October November December".split(" ");
    return monthNames[this.getMonth()];
}

Date.prototype.humanReadableDate = function() {
    return this.dayName() + ' ' + this.getDate() + ' ' + this.monthName() + ' ' + this.getFullYear();
}

Date.prototype.yyyymmdd = function() {
    return this.getFullYear() + '/' + (this.getMonth()+1) + '/' + this.getDate();
}

Date.prototype.epoch = function() {
    return Math.round(this.getTime()/1000.0);
}

Date.prototype.tomorrow = function() {
    this.setDate(this.getDate()+1);
    return this;
}

Date.prototype.yesterday = function() {
    this.setDate(this.getDate()-1);
    return this;
}

Date.prototype.coarse_time_remaining = function() {

        var unit = '';
        var now = new Date();
        var i = this.epoch() - now.epoch();
        if (!i) { return; }

        if (i >= 86400) {
            i = Math.floor((i / 86400) + 0.5);
            unit = 'day';
        } else if (i >= 3600) {
            i = Math.floor((i / 3600) + 0.5);
            unit = 'hour';
        } else {
            i = Math.floor((i / 60) + 0.5);
            unit = 'minute';
        }
        if (i != 1) {
            unit = unit + 's';
        }
        return i + ' ' + unit;
}
