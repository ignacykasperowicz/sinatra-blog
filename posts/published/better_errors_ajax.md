<% title 'Rails \'Better errors\' with AJAX calls' %>
<% date '1th June 2014' %>
<% author 'Ignacy Kasperowicz' %>

[Better_errors](https://github.com/charliesome/better_errors) gem along with [binding of caller](https://github.com/banister/binding_of_caller) gem are awesome pair of debug tools. It works great for normal HTTP request/response scenario but what if you need to debug async AJAX call?  

Thanks to following JS snippet any failed AJAX call will pop up new window with familiar 'better errors' debug page:

```
$(document)  
.on("ajaxError", function(e, request, textStatus, errorThrown) {
  window.open("/__better_errors", "error");
});
```