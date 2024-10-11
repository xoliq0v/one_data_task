abstract class Failure {}

class LocationServiceFailure extends Failure {}
class PermissionDeniedFailure extends Failure {}
class DatabaseFailure extends Failure {}