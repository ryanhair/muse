Muse
====

Dart component based framework for simple dependency injection, with controller, service, and repo layers, along with tools for building and manipulating models.

For an easy way to see Muse in action, check out the CarLot example under the /examples directory.

IMPORTANT: In main, you must first run `Muse.init();`

Dependency Injection
--------

Muse makes extensive use of dependency injection, and therefore includes a simple dependency injector.  There are two ways to use this; manually, or with metadata.  

<h3>Manually:</h3>

`Injector.register(dynamic val, [String namespace=''])` - Registers singletons with the injector system, `Injector.getValue(Type type, [String namespace=''])` - Retrieves singleton from injector

<h3>Automatically:</h3>

On a class that is marked as `@Component()`, use `@Inject([namespace=''])` to inject any other registered dependency.  First, all classes marked with `@Component()` are registered with the injector.  Then, each `@Component()` singleton is checked for any properties marked with `@Inject()`, and pull the appropriate singleton from the appropriate namespace.

For example:

```dart
@Component()
class SomeService {

}

@Component()
class Test {
  @Inject()
  SomeService someService;
}
```


HttpController
--------------

Subclass of Controller that handles incoming web requests that match the RequestMapping metadata, and maps them to an appropriate handler on the class.

IMPORTANT:  In main, right after `Muse.init()`, add `HttpController.init('localhost', 8005);`

For example:

```dart
@Controller()
class CarController {
  @Inject
  CarService carService;

  @Get('/:id')
  Future<Car> getCar(@UrlParam('id') String id) {
    return carService.get(id);
  }

  @Post('/')
  Future<Car> createCar(@ContentBody Car car) {
    return carService.save(car);
  }
```

<h3>Request Mappers</h3>

There are a bunch of RequestMappers (like `@ContentBody` and `@UrlParam`) that help convert the incoming request to arguments to pass into a matching method.  These include:

`@ContentBody()` - convert the incoming request body to a parameter to be passed in.  Will automatically create and populate an instance of the specified class.

`@UrlParam()` - pull a value from the url (as specified in @Get, @Put, @Post, or @Delete). For example, If I specify `@Get('/test/:id')` and use `@UrlParam('id')`, it would pull '123' from '/test/123'.  Automatically converts strings to numbers, if necessary.

`@Param()` - pull a value from the query string.

If you want to add another, it's easy to do, just create a class that extends RequestMapper and overrides the `requestToData` and `matchesRequest` methods.

<h3>Response Mappers</h3>

Response mappers are responsible for taking a return value from a handler and sending it back in the response.  Built in: JsonResponseMapper.  Currently only uses JsonResponseMapper, and isn't pluggable yet.

MongoRepository
---------------

IMPORTANT: When using the MongoRepository, you must first run `MongoRepositoryBase.setDb('...')` before any other Muse code (before `Muse.init()`)

In order to use MongoRepository, have your repo class extend from MongoRepository<T>, and mark your class with `@Repository`.

For example:

```dart
@Repository()
class CarRepo extends MongoRepository<Car> {
  CarRepo() : super('Car') {}
}
```
