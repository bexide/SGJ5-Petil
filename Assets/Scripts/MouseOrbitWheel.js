﻿// arange MouseOrbbit.js

var target : Transform;
var distance = 5.0;

var xSpeed = 100.0;
var ySpeed = 100.0;

var yMinLimit = -80.0;
var yMaxLimit = 80.0;

var distanceMin = 0.8;
var distanceMax = 6.0;

private var x = 0.0;
private var y = 0.0;

function Start () {
	var angles = transform.eulerAngles;
	x = angles.y;
	y = angles.x;

	if (GetComponent.<Rigidbody>())
		GetComponent.<Rigidbody>().freezeRotation = true;
}


function LateUpdate () {
	if (target) {
		//if (Input.GetButton("Fire2") || Input.GetMouseButton(0) || Input.GetMouseButton(1)) {
		if (Input.GetMouseButton(1)) { //MouseRightButton
			x += Input.GetAxis("Mouse X") * xSpeed * distance* 0.02;
			y -= Input.GetAxis("Mouse Y") * ySpeed * 0.02;
		}
	   y = ClampAngle(y, yMinLimit, yMaxLimit);

		var rotation = Quaternion.Euler(y, x, 0);

		distance = Mathf.Clamp(distance - Input.GetAxis("Mouse ScrollWheel")*2, distanceMin, distanceMax);

		var position = rotation * Vector3(0.0, 0.0, -distance) + target.position;

		transform.rotation = rotation;
		transform.position = position;
	}
}


static function ClampAngle (angle : float, min : float, max : float) {
	if (angle < -360)
		angle += 360;
	if (angle > 360)
		angle -= 360;
	return Mathf.Clamp (angle, min, max);
}