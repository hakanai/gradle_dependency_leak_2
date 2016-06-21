
Demonstrates a failure of Gradle to do what it's told.

The common subproject depends on icu4j, including one file that references it.

The util subproject depends on common subproject and also icu4j, including one file that references it.

All projects turn off transitive dependency resolution, which should be the default behaviour but isn't.
Turning this off is supposed to remove situations where this sort of thing occurs.

The dephell.rb script automates removal of dubious compile dependencies.
You will find that running this script in util will remove the dependency on icu4j, even though it should be required, as a class references it.
Despite the dependency being missing, icu4j somehow ends up on the classpath for compilation even though the configuration says not to include it.

