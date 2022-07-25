def test_service_minecraft_should_be_running(host):
    assert host.service('minecraft').is_running, host.run('systemctl status minecraft').stdout


def test_minecraft_port_should_be_listening(host):
    assert host.socket('tcp://0.0.0.0:25565').is_listening
