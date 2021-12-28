/// The type of the input.
enum InputType {
  /// The latitude, as part of the geographical position.
  latitude,
  /// The longitude, as part of the geographical position.
  longitude,
  /// The altitude, as part of the geographical position.
  altitude,
  /// The acceleration on the X axis.
  accelerationX,
  /// The acceleration on the Y axis.
  accelerationY,
  /// The acceleration on the Z axis.
  accelerationZ,
  /// The rotation of the bike around the X axis.
  rotationX,
  /// The rotation of the bike around the Y axis.
  rotationY,
  /// The rotation of the bike around the Z axis.
  rotationZ,
  /// The wheel rotation.
  wheelRotationSpeed,
  /// The steering rotation.
  steeringRotation,
  /// The pedal rotation.
  pedalRotation,
  /// The selected gear.
  gear,
  /// The position of the left break lever.
  leftBreakLeverPosition,
  /// The position of the right break lever.
  rightBreakLeverPosition,
  /// The travel of the front suspension.
  frontSuspensionTravel,
  /// The travel of the rear suspension.
  rearSuspensionTravel,
  /// The position of the seat.
  seatPosition,
}