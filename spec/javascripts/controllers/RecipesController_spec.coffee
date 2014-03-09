describe "RecipesController", ->
  scope        = null
  ctrl         = null
  location     = null
  routeParams  = null
  resource     = null

  setupController =(keywords)->
    inject(($location, $routeParams, $rootScope, $resource, $controller)->
      scope       = $rootScope.$new()
      location    = $location
      resource    = $resource
      routeParams = $routeParams
      routeParams.keywords = keywords

      ctrl        = $controller('RecipesController',
                                $scope: scope
                                $location: location)
    )

  beforeEach(module("receta"))
  beforeEach(setupController())

  it 'defaults to no recipes', ->
    expect(scope.recipes).toEqualData([])

