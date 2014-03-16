describe "RecipeController", ->
  scope        = null
  ctrl         = null
  routeParams  = null
  httpBackend  = null
  flash        = null
  location     = null
  recipeId     = 42

  fakeRecipe   =
    id: recipeId
    name: "Baked Potatoes"
    instructions: "Pierce potato with fork, nuke for 20 minutes"

  setupController =(recipeExists=true,recipeId=42)->
    inject(($location, $routeParams, $rootScope, $httpBackend, $controller, _flash_)->
      scope       = $rootScope.$new()
      location    = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.recipeId = recipeId if recipeId
      flash = _flash_

      if recipeId
        request = new RegExp("\/recipes/#{recipeId}")
        results = if recipeExists
          [200,fakeRecipe]
        else
          [404]

        httpBackend.expectGET(request).respond(results[0],results[1])

      ctrl        = $controller('RecipeController',
                                $scope: scope)
    )

  beforeEach(module("receta"))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->
    describe 'recipe is found', ->
      beforeEach(setupController())
      it 'loads the given recipe', ->
        httpBackend.flush()
        expect(scope.recipe).toEqualData(fakeRecipe)
    describe 'recipe is not found', ->
      beforeEach(setupController(false))
      it 'loads the given recipe', ->
        httpBackend.flush()
        expect(scope.recipe).toBe(null)
        expect(flash.error).toBe("There is no recipe with ID #{recipeId}")

  describe 'create', ->
    newRecipe =
      id: 42
      name: 'Toast'
      instructions: 'put in toaster, push lever, add butter'

    beforeEach ->
      setupController(false,false)
      request = new RegExp("\/recipes")
      httpBackend.expectPOST(request).respond(201,newRecipe)

    it 'posts to the backend', ->
      scope.recipe.name         = newRecipe.name
      scope.recipe.instructions = newRecipe.instructions
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/recipes/#{newRecipe.id}")

  describe 'update', ->
    updatedRecipe =
      name: 'Toast'
      instructions: 'put in toaster, push lever, add butter'

    beforeEach ->
      setupController()
      httpBackend.flush()
      request = new RegExp("\/recipes")
      httpBackend.expectPUT(request).respond(204)

    it 'posts to the backend', ->
      scope.recipe.name         = updatedRecipe.name
      scope.recipe.instructions = updatedRecipe.instructions
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/recipes/#{scope.recipe.id}")

  describe 'delete' ,->
    beforeEach ->
      setupController()
      httpBackend.flush()
      request = new RegExp("\/recipes/#{scope.recipe.id}")
      httpBackend.expectDELETE(request).respond(204)

    it 'posts to the backend', ->
      scope.delete()
      httpBackend.flush()
      expect(location.path()).toBe("/")
