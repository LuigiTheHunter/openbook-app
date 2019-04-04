import 'dart:io';

import 'package:Openbook/services/httpie.dart';
import 'package:meta/meta.dart';

class AuthApiService {
  HttpieService _httpService;

  String apiURL;

  static const CHECK_USERNAME_PATH = 'api/auth/username-check/';
  static const CHECK_EMAIL_PATH = 'api/auth/email-check/';
  static const UPDATE_EMAIL_PATH = 'api/auth/user/settings/';
  static const VERIFY_EMAIL_TOKEN = 'api/auth/email/verify/';
  static const UPDATE_PASSWORD_PATH = 'api/auth/user/settings/';
  static const CREATE_ACCOUNT_PATH = 'api/auth/register/';
  static const DELETE_ACCOUNT_PATH = 'api/auth/user/delete/';
  static const GET_AUTHENTICATED_USER_PATH = 'api/auth/user/';
  static const UPDATE_AUTHENTICATED_USER_PATH = 'api/auth/user/';
  static const GET_USERS_PATH = 'api/auth/users/';
  static const GET_LINKED_USERS_PATH = 'api/auth/linked-users/';
  static const SEARCH_LINKED_USERS_PATH = 'api/auth/linked-users/search/';
  static const LOGIN_PATH = 'api/auth/login/';
  static const REQUEST_RESET_PASSWORD_PATH = 'api/auth/password/reset/';
  static const VERIFY_RESET_PASSWORD_PATH = 'api/auth/password/verify/';
  static const AUTHENTICATED_USER_NOTIFICATIONS_SETTINGS_PATH =
      'api/auth/user/notifications-settings/';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> deleteUser({@required String password}) {
    Map<String, dynamic> body = {'password': password};
    return _httpService.post('$apiURL$DELETE_ACCOUNT_PATH',
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> checkUsernameIsAvailable({@required String username}) {
    return _httpService
        .postJSON('$apiURL$CHECK_USERNAME_PATH', body: {'username': username});
  }

  Future<HttpieResponse> checkEmailIsAvailable({@required String email}) {
    return _httpService
        .postJSON('$apiURL$CHECK_EMAIL_PATH', body: {'email': email});
  }

  Future<HttpieStreamedResponse> updateUserEmail({@required String email}) {
    Map<String, dynamic> body = {};
    body['email'] = email;
    return _httpService.patchMultiform('$apiURL$UPDATE_EMAIL_PATH',
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> updateUserPassword(
      {@required String currentPassword, @required String newPassword}) {
    Map<String, dynamic> body = {};
    body['current_password'] = currentPassword;
    body['new_password'] = newPassword;
    return _httpService.patchMultiform('$apiURL$UPDATE_PASSWORD_PATH',
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> verifyEmailWithToken(String token) {
    return _httpService.get('$apiURL$VERIFY_EMAIL_TOKEN$token/',
        appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> updateUser({
    dynamic avatar,
    dynamic cover,
    String name,
    String username,
    String url,
    bool followersCountVisible,
    String bio,
    String location,
  }) {
    Map<String, dynamic> body = {};

    if (avatar is File) {
      body['avatar'] = avatar;
    } else if (avatar is String && avatar.isEmpty) {
      // This is what deletes the avatar. Ugly af.
      body['avatar'] = avatar;
    }

    if (cover is File) {
      body['cover'] = cover;
    } else if (cover is String && cover.isEmpty) {
      // This is what deletes the cover. Ugly af.
      body['cover'] = cover;
    }

    if (name != null) body['name'] = name;

    if (username != null) body['username'] = username;

    if (url != null) body['url'] = url;

    if (bio != null) body['bio'] = bio;

    if (followersCountVisible != null)
      body['followers_count_visible'] = followersCountVisible;

    if (location != null) body['location'] = location;

    return _httpService.patchMultiform('$apiURL$UPDATE_AUTHENTICATED_USER_PATH',
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> createUser(
      {@required String email,
      @required String token,
      @required String name,
      @required bool isOfLegalAge,
      @required String password,
      File avatar}) {
    Map<String, dynamic> body = {
      'email': email,
      'token': token,
      'name': name,
      'is_of_legal_age': isOfLegalAge,
      'password': password
    };

    if (avatar != null) {
      body['avatar'] = avatar;
    }

    return _httpService.postMultiform('$apiURL$CREATE_ACCOUNT_PATH',
        body: body);
  }

  Future<HttpieResponse> getUserWithAuthToken(String authToken) {
    Map<String, String> headers = {'Authorization': 'Token $authToken'};

    return _httpService.get('$apiURL$GET_AUTHENTICATED_USER_PATH',
        headers: headers);
  }

  Future<HttpieResponse> getUserWithUsername(String username,
      {bool authenticatedRequest = true}) {
    return _httpService.get('$apiURL$GET_USERS_PATH$username/',
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> getUsersWithQuery(String query,
      {bool authenticatedRequest = true}) {
    return _httpService.get('$apiURL$GET_USERS_PATH',
        queryParameters: {'query': query},
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> searchLinkedUsers(
      {@required String query, int count, String withCommunity}) {
    Map<String, dynamic> queryParams = {'query': query};

    if (count != null) queryParams['count'] = count;

    if (withCommunity != null) queryParams['with_community'] = withCommunity;

    return _httpService.get('$apiURL$SEARCH_LINKED_USERS_PATH',
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getLinkedUsers(
      {bool authenticatedRequest = true,
      int maxId,
      int count,
      String withCommunity}) {
    Map<String, dynamic> queryParams = {};

    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    if (withCommunity != null) queryParams['with_community'] = withCommunity;

    return _httpService.get('$apiURL$GET_LINKED_USERS_PATH',
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> loginWithCredentials(
      {@required String username, @required String password}) {
    return this._httpService.postJSON('$apiURL$LOGIN_PATH',
        body: {'username': username, 'password': password});
  }

  Future<HttpieResponse> requestPasswordReset(
      {String username, String email}) {
    var body = {};
    if (username != null && username != '') {
      body = {'username': username };
    }
    if (email != null && email != '') {
      body['email'] = email;
    }
    return this._httpService.postJSON('$apiURL$REQUEST_RESET_PASSWORD_PATH',
        body: body);
  }

  Future<HttpieResponse> verifyPasswordReset(
      {String newPassword, String passwordResetToken}) {
    return this._httpService.postJSON('$apiURL$VERIFY_RESET_PASSWORD_PATH',
        body: {'new_password': newPassword , 'token': passwordResetToken});
  }

  Future<HttpieResponse> getAuthenticatedUserNotificationsSettings() {
    return this._httpService.get(
        '$apiURL$AUTHENTICATED_USER_NOTIFICATIONS_SETTINGS_PATH',
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> updateAuthenticatedUserNotificationsSettings({
    bool postCommentNotifications,
    bool postReactionNotifications,
    bool followNotifications,
    bool connectionRequestNotifications,
    bool connectionConfirmedNotifications,
    bool communityInviteNotifications,
  }) {
    Map<String, dynamic> body = {};

    if (postCommentNotifications != null)
      body['post_comment_notifications'] = postCommentNotifications;

    if (postReactionNotifications != null)
      body['post_reaction_notifications'] = postReactionNotifications;

    if (followNotifications != null)
      body['follow_notifications'] = followNotifications;

    if (connectionRequestNotifications != null)
      body['connection_request_notifications'] = connectionRequestNotifications;

    if (communityInviteNotifications != null)
      body['community_invite_notifications'] = communityInviteNotifications;

    if (connectionConfirmedNotifications != null)
      body['connection_confirmed_notifications'] =
          connectionConfirmedNotifications;

    return _httpService.patchJSON(
        '$apiURL$AUTHENTICATED_USER_NOTIFICATIONS_SETTINGS_PATH',
        body: body,
        appendAuthorizationToken: true);
  }
}
