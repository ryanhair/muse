part of muse.core;

/**
 * For each subclass of Component, a singleton
 * is automatically created and registered with
 * the Injector.  Upon creating all component
 * singletons, every variable inside a component
 * marked with @Inject is then populated with
 * the appropriate singleton matching that type
 * (or if not found, a type in its heirarchy if
 * available) 
 */
class Component {
  const Component();
}