<% title 'Angular services & \'controller as\' syntax' %>
<% date '27th June 2014' %>
<% author 'Ignacy Kasperowicz' %>

I'd like to share how I use Angular services concept to bind two controllers and views. I believe code is almost always self explanatory so here we go.

First our routing:

``` javascript
.state "base",
  abstract: true
  url: ''
  views:
    'navbar':
      templateUrl: "views/templates/navbar.html"

    'graph':
      templateUrl: "views/templates/graph.html"
      controller: "GraphCtrl as graph"
    
# --- BASE: HOME ---
.state "base.home",
  url: '/'
  views:          
    'content@':
      templateUrl: "views/templates/home/content.html"
      controller: "BaseCtrl as base"
```

I like to use [angular-ui](https://github.com/angular-ui/ui-router) router because concept of 'states' reflects real app usage scenarios. Here I use one `abstract` state for my layout which is parent for all other states.
I do not like `$scope` concept in Angular, it is somehow too similar to using global variables and global namespace for all controllers. Instead I like to use `controller as` syntax which allows to use namespaced controllers within Angular views.

Here we have controllers:

``` javascript
angular.module('myApp')

  .controller "BaseCtrl", [
    "$stateParams"
    "$state"
    "highlighterService"
    ($stateParams, $state, highlighterService) ->
      $state.reload()
      @_=_

      ...

      @highlighter = highlighterService

      ...

      return
  ]

```

``` javascript
angular.module('myApp')

  .controller "GraphCtrl", [
    "$stateParams"
    "$state"
    "highlighterService"
    ($stateParams, $state, highlighterService) ->
      $state.reload()
      @_=_

      ...

      @highlighter = highlighterService

      ...

      return
  ]

```

Here we inject our dependency: `highlighterService` service and next we assign it to `@highlighter` variable. We can access our service variables in both controllers because Angular treats services as singletons, so we have one instance of our service used in each controller.

I also use [underscore library](http://underscorejs.org) and as long as we use `controller as` syntax it has to be assigned to instance variable, best would be `@_` so it can be used in view with named controller as prefix e.g. `graph._.range(10)`.

Time for service:

``` javascript
angular.module('myApp')
  .service 'highlighterService', ->

    service = {}
    service.highlightList = 
      'foo': false
      'bar': false

    service.setName = (name) ->
      @highlightList[name] = true

    service.clearName = (name) ->
      @highlightList[name] = false

    service.getName = (name)->      
      if @highlightList[name]
        'highlight'
      else
        'lowlight'

    service
```

It is very simple service which holds JavaScript hash for two boolean options and returns CSS class name when option is set to `true`.

Our views:

`views/templates/graph.html`

``` html
<div class="container">
  <div id="foo" ng-class="graph.highlighter.getName('foo')">
    <img src="images/foo.png" />
  </div>
  <div id="bar" ng-class="graph.highlighter.getName('bar')">
    <img src="images/bar.png" />
  </div>
</div>
```

`views/templates/home/content.html`

``` html
<a href="#" id="foo" 
  ng-mouseenter="base.highlighter.setName('foo')" 
  ng-mouseleave="base.highlighter.clearName('foo')">
  Foo
</a>

<a href="#" id="bar" 
  ng-mouseenter="base.highlighter.setName('bar')" 
  ng-mouseleave="base.highlighter.clearName('bar')">
  Bar
</a>
```

It should be easy to get how it works now:

  * in view `content.html` we have two links `foo` and `bar` which we use to change our boolean options in `highlighterService` on hoover action (Angular `ng-mouseenter` and `ng-mouseleave`)
  * when mouse pointer is over the link we assign `highlight` CSS class to proper image parent div in `graph.html` view

It is awesome how easily service can bind two controllers and further two views to interact with each other. I see it very useful especially when working with `angular-ui router` when I have few states on one visible page and have to interact with each other on proper level of abstraction. 