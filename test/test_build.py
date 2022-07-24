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
    service = host.service('minecraft')
    with host.sudo():
        assert service.is_valid
    assert service.is_enabled


def test_should_have_cloud_init_enabled(host):
    assert host.service('cloud-init').is_enabled


def test_user_minecraft_should_have_java_17_available(host):
    result = host.run('sudo -iu minecraft java -version')
    assert result.rc == 0
    assert 'OpenJDK' in result.stderr
    assert '"17.0.3"' in result.stderr


def test_hugepages_sh_should_set_hugepages(host):
    with host.sudo():
        assert host.run_expect([0], 'cd /opt/minecraft;./hugepages.sh')
        assert host.check_output('cat /proc/sys/vm/nr_hugepages') != '0\n'
