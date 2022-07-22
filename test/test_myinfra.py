def test_should_have_minecraft_user_with_uid_and_gid_of_1001(host):
    user = host.user('minecraft')
    assert user.exists
    assert user.uid == 1001
    assert user.gid == 1001


def test_should_have_minecraft_group_with_gid_1001(host):
    group = host.group('minecraft')
    assert group.exists
    assert group.gid == 1001


def test_should_have_service_minecraft_that_is_enabled(host):
    assert host.service('minecraft').is_enabled


def test_should_have_cloud_init_enabled(host):
    assert host.service('cloud-init').is_enabled
