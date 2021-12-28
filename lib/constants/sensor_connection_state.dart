/// The state of a connection to a sensor.
enum SensorConnectionState {
  /// The sensor is connected.
  connected,

  /// The sensor is currently connecting.
  connecting,

  /// The sensor is disconnected.
  disconnected,

  /// The sensor is currently disconnecting.
  disconnecting,
}
