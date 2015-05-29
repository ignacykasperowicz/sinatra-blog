<% title 'Restangular promises' %>
<% date '29th June 2014' %>
<% author 'Ignacy Kasperowicz' %>

When consuming REST API with Angular I use [Restangular](https://github.com/mgonto/restangular). I also like to use Angular `factories` to handle separately each resource returned from API.

Simplest factory to handle API resource might look like:

``` javascript
angular.module('myApp').factory('carsFactory', [
  "Restangular", function(Restangular) {
    var getRes;
    getRes = function() {
      return Restangular.service("cars").one().get();
    };
    return {
      getRes: getRes
    };
  }
]);
```

And controller:

``` javascript
angular.module('myApp').controller("CarsCtrl", [
  "$stateParams", "$state", "carsFactory", function($stateParams, $state, carsFactory) {
    $state.reload();
    this._ = _;
    this.cars = carsFactory.getRes();
  }
]);
```

Unfortunately when we try to render `@cars` in Angular view the variable most likely will be empty. Nothing is wrong with that as Restangular returns promises.
The solution for that is to assign `@cars` variable when Restangular result is ready, so:

``` javascript
carsFactory.getRes().then(angular.bind(this, function(result) {
  return this.cars = result;
}));
```

As I use `controller as` syntax I have to use angular.bind to pass `this` variable to which I will assign `cars` variable. Otherwise notation `@cars` will assign my result to local `this` rather than to my controller.