// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      id: json['_id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      notes: json['notes'] as String?,
      picture: (json['picture'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList(),
      phone: json['phone'] as String?,
      errorMessage: json['error'] as String?,
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      '_id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'notes': instance.notes,
      'picture': instance.picture,
      'phone': instance.phone,
    };
