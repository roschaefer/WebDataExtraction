public static int main (string[] args) {
	if (args.length != 2) {
		stdout.printf ("Usage: %s WORD\n", args[0]);
		return 0;
	}

	char[] word = args[1].to_utf8  ();
	char first_upper = word[0].toupper ();

	for (int i = 0; i < word.length; i++) {
		char c = word[i].toupper ();
		switch (c) {
		case 'B':
		case 'F':
		case 'P':
		case 'V':
			word[i] = '1';
			break;

		case 'C':
		case 'G':
		case 'J':
		case 'K':
		case 'Q':
		case 'S':
		case 'X':
		case 'Z':
			word[i] = '2';
			break;

		case 'D':
		case 'T':
			word[i] = '3';
			break;

		case 'L':
			word[i] = '4';
			break;

		case 'M':
		case 'N':
			word[i] = '5';
			break;

		case 'R':
			word[i] = '6';
			break;

		default:
			word[i] = '0';
			break;
		}
	}

	StringBuilder builder = new StringBuilder ();
	builder.append_c (first_upper);

	for (int i = 1; i < word.length; i++) {
		if (word[i] != word[i-1] && word[i] != '0') {
			builder.append_c (word[i]);
		}
	}

	if (builder.len > 4) {
		builder.erase (4, -1);
	} else {
		while (builder.len < 4) {
			builder.append_c ('0');
		}
	}

	stdout.printf ("Soundex: %s\n", builder.str);

	return 0;
}
