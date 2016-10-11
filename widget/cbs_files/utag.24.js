//tealium universal tag - utag.24 ut4.0.201607062343, Copyright 2016 Tealium.com Inc. All Rights Reserved.
if(typeof utag.ut=="undefined"){utag.ut={};}
utag.ut.libloader2=function(o,a,b,c,l){a=document;b=a.createElement('script');b.language='javascript';b.type='text/javascript';b.src=o.src;if(o.id){b.id=o.id};if(typeof o.cb=='function'){b.hFlag=0;b.onreadystatechange=function(){if((this.readyState=='complete'||this.readyState=='loaded')&&!b.hFlag){b.hFlag=1;o.cb()}};b.onload=function(){if(!b.hFlag){b.hFlag=1;o.cb()}}}
l=o.loc||'head';c=a.getElementsByTagName(l)[0];if(c){if(l=='script'){c.parentNode.insertBefore(b,c);}else{c.appendChild(b)}
utag.DB("Attach to "+l+": "+o.src)}}
try{(function(id,loader){var u=utag.o[loader].sender[id]={};u.ev={'view':1};u.initialized=false;u.map={};u.extend=[];u.send=function(a,b){if(u.ev[a]||typeof u.ev.all!="undefined"){var c,d,e,f;u.data={"projectId":"2628570003","eventName":"purchase","orderId":"","revenue":""};for(d in utag.loader.GV(u.map)){if(typeof b[d]!=="undefined"&&b[d]!==""){e=u.map[d].split(",");for(f=0;f<e.length;f++){u.data[e[f]]=b[d];}}}
if(u.data.orderId===""&&b._corder!==undefined){u.data.orderId=b._corder;}
if(u.data.revenue===""&&b._csubtotal!==undefined){u.data.revenue=b._csubtotal;}
u.opt_callback=function(){u.initialized=true;window.optimizely=window.optimizely||[];if(u.data.orderId!==""){window.optimizely.push(["trackEvent",u.data.eventName,{"revenue":u.data.revenue.replace(".","")}]);}}
u.base_url="//cdn.optimizely.com/js/"+u.data.projectId+".js";if(!u.initialized){utag.ut.libloader2({src:u.base_url,cb:u.opt_callback});}else{u.opt_callback();}
}}
utag.o[loader].loader.LOAD(id);})('24','cbsi.cbsnewssite');}catch(e){}
