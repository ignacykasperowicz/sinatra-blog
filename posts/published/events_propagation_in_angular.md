<% title 'Events propagation in AngularJS' %>
<% date '19th August 2015' %>
<% author 'Ignacy Kasperowicz' %>

![Onion](/assets/onion.jpg)

Let's consider piece of application with two nested divs, one inside another like:

```html
+------------------------------------+
|                                    |
|      Outer div #1                  |
|                                    |
|   +----------------------------+   |
|   |                            |   |
|   |   Inner div #2             |   |
|   |                            |   |
|   |                            |   |
|   +----------------------------+   |
|                                    |
+------------------------------------+

```

Let's say you want to add `ng-click` directive to both of them and you expect
(intuitively) that:

* when clicking #2 the `ng-click` action attached to `div #2` will be fired
* and analogically for the `div #1`.

Actually what happens is that clicking div #2 fires both `ng-click` actions:

*  one attached to div #1
*  and the expected - attached to #div 2.

Why?

**Because click event from div #2 is bubbling up to div #1**

Here is the great description of the events order in browsers: [Link](http://www.quirksmode.org/js/events_order.html)

The solution would be to add Angular directive to stop event propagation for selected DOM elements like:

```javascript
angular.module('App').directive('stopClickEvent', function() {
  return {
    restrict: 'A',
    link: function(scope, element, attr) {
      return element.bind('click', function(e) {
        return e.stopPropagation();
      });
    }
  };
});
```

and use it in element like:

```html
  <div id="1">
    <div id="2" stop-click-event></div>
  </div>
```

This way the click event on div #2 will not propagate and will not trigger div #1 `ng-click` action.
