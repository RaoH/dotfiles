#
def "ps-node" [] {
	ps -l | where  name == 'node' | get pid | to text
}

