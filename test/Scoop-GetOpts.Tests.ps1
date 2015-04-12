. "$psscriptroot\Scoop-TestLib.ps1"
. "$psscriptroot\..\lib\getopt.ps1"

describe "getopt" {
	it 'handle short option with required argument missing' {
		$null, $null, $err = getopt '-x' 'x:' ''
		$err | should be 'option -x requires an argument'

		$null, $null, $err = getopt '-xy' 'x:y' ''
		$err | should be 'option -x requires an argument'
	}

	it 'handle long option with required argument missing' {
		$null, $null, $err = getopt '--arb' '' 'arb='
		$err | should be 'option --arb requires an argument'
	}

	it 'handle unrecognized short option' {
		$null, $null, $err = getopt '-az' 'a' ''
		$err | should be 'option -z not recognized'
	}

	it 'handle unrecognized long option' {
		$null, $null, $err = getopt '--non-exist' '' ''
		$err | should be 'option --non-exist not recognized'

		$null, $null, $err = getopt '--global','--another' 'abc:de:' 'global','one'
		$err | should be 'option --another not recognized'
	}

	it 'remaining args returned' {
		$opt, $rem, $err = getopt '-g','rem' 'g' ''
		$err | should be $null
		$opt.g | should be $true
		$rem | should not be $null
		$rem.length | should be 1
		$rem[0] | should be 'rem'
	}

	it 'get a long flag and a short option with argument' {
		$a = "--global -a 32bit test" -split ' '
		$opt, $rem, $err = getopt $a 'ga:' 'global','arch='

		$err | should be $null
		$opt.global | should be $true
		$opt.a | should be '32bit'
	}
}