#= require support/bind-poly
#= require application
#= require angular-mocks/angular-mocks
#= require support/phantomjs-shims

beforeEach ->
  jasmine.addMatchers(
    toEqualData: (util, customEqualityTesters) ->
      compare: (actual, expected) ->
        pass: angular.equals actual, expected
  )
