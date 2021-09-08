Feature: Karate api test automation for reqres api endpoints

  Background:
    * url reqRes_baseUrl = 'https://reqres.in'

  # Single scenario
  Scenario: Login to application
   # Ideally URLs, password should be given in application.yml however for homeTest used in feature itself
    * def validBodyRequest =
    """
      {
       "email": "eve.holt@reqres.in",
       "password": "cityslicka"
      }
    """
    Given path '/api/login'
    When request validBodyRequest
    And method POST
    Then status 200
    And match response == {  token: '#notnull' }

  # Four scenarios using scenario outline
  Scenario Outline: Send multiple users to register
    * def validBodyRequest =
    """
     {
      "email": <email>,
      "password": <password>
     }
    """
    Given path '/api/register'
    When request validBodyRequest
    And method POST
    Then status <status>

    Examples:
      | email              | password | status |
      | eve.holt@reqres.in | pistol   | 200    |
      | eve.holt@abc.in    | xyz      | 400    |
      | eve.holt@reqres.in | pistol   | 200    |
      | xyz.holt@xyz.in    | abc      | 400    |

  Scenario: Get method to retrieve list of users
    # Large Json stored in separate file
    * def expected = read('../json/list-200.json')
    Given path '/api/users?page=2'
    When method GET
    Then status 200
    And match response == expected

  Scenario: Put method example
   # Ideally URLs, password should be given in application.yml however for homeTest used in feature itself
    * def validBodyRequest =
    """
      {
        "name": "morpheus",
        "job": "zion resident"
      }
    """
    Given path '/api/users/2'
    When request validBodyRequest
    And method PUT
    Then status 200
    And match response == {  "name": "morpheus",  "job": "zion resident",  "updatedAt": "#notnull" }

  Scenario: Delete method example
    Given path '/api/users/2'
    When method DELETE
    Then status 204