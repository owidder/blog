#!/opt/local/bin/perl

my $pattern = $ARGV[0];

my @AllObjects = `find .git/objects/`;
my @AllSha1 = ();

for my $object (@AllObjects) {
	if($object =~ /([0-9a-f][0-9a-f])\/([0-9a-f]{38})/) {
		my $sha1 = $1 . $2; 
		push(@AllSha1, $sha1);
	}
}

my @FoundTrees = ();

for my $treeSha1 (@AllSha1) {
	chomp $treeSha1;
	my $type = `git cat-file -t $treeSha1`;
	chomp $type;

	if($type eq "tree") {

		my @Lines = `git cat-file -p $treeSha1`;
		for my $line (@Lines) {
			if($line =~ /$pattern/) {
				printf "found tree: %s\n", $treeSha1;
				push(@FoundTrees, $treeSha1);
				break;
			}
		}
	}
}

my @FoundCommits = ();

for my $commitSha1 (@AllSha1) {
	chomp $commitSha1;
		if(!($commitSha1 =~ /pack/)) {
		# printf "%s\n", $commitSha1;
		my $type = `git cat-file -t $commitSha1`;
		chomp $type;

		if($type eq "commit") {

			my @Lines = `git cat-file -p $commitSha1`;
			for my $line (@Lines) {
				for my $foundTreeSha1 (@FoundTrees) {
					if($line =~ /$foundTreeSha1/) {
						printf "found commit: %s\n", $commitSha1;
						push(@FoundCommits, $commitSha1);
						break;
					}
				}
			}
		}
	}
}

my $i = 0;
for my $foundSha1 (@FoundCommits) {
	`git branch found/$i $foundSha1`;
	$i++;
}
