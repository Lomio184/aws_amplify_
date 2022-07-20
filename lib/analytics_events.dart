import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';

abstract class AbstractAnalyticsEvent {
  final AnalyticsEvent value;
  AbstractAnalyticsEvent.withName({required String eventName})
    :value = AnalyticsEvent(eventName);
  
  AbstractAnalyticsEvent.withEvent({required AnalyticsEvent event})
    :value = event;
}

class LoginEvent extends AbstractAnalyticsEvent {
  LoginEvent() : super.withName(eventName: 'login');
}

class SignUpEvent extends AbstractAnalyticsEvent {
  SignUpEvent() : super.withName(eventName: 'sign_up');
}

class VerificationEvent extends AbstractAnalyticsEvent {
  VerificationEvent() : super.withName(eventName: 'verification');
}

class ViewGalleryEvent extends AbstractAnalyticsEvent {
  ViewGalleryEvent() : super.withName(eventName: 'view_gallery');
}

class TakePictureEvent extends AbstractAnalyticsEvent {
  TakePictureEvent._fromEvent(AnalyticsEvent event)
      : super.withEvent(event: event);

  factory TakePictureEvent({required String cameraDirection}) {
    final event = AnalyticsEvent('take_picture');

    event.properties.addStringProperty('camera_direction', cameraDirection);
    return TakePictureEvent._fromEvent(event);
  }
}