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


def test_should_have_executable_file_minecraft_sh_that_belongs_to_uid_gid_1001(host):
    file = host.file('/opt/minecraft/minecraft.sh')
    assert file.is_file
    assert file.uid == 1001
    assert file.gid == 1001
    assert file.mode == 0o774

def test_should_have_executable_file_hugepages_sh_that_belongs_to_root(host):
    file = host.file('/opt/minecraft/hugepages.sh')
    assert file.is_file
    assert file.user == 'root'
    assert file.group == 'root'
    assert file.mode == 0o774


def test_user_minecraft_should_have_java_17_available(host):
    output = host.check_output('sudo -iu minecraft java -version')
    assert 'OpenJDK' in output
    assert '"17.0.3"' in output
