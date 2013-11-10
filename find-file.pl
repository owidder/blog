#!/opt/local/bin/perl

my $pattern = $ARGV[0]; # filename to search for as regex

##################################################################
# find all objects (blobs, trees, commits, tags) in .git/objects 
##################################################################

my @AllFiles = `find .git/objects/`;
my @AllSha1 = ();

for my $object (@AllFiles) {
	if($object =~ /([0-9a-f][0-9a-f])\/([0-9a-f]{38})/) {
		my $sha1 = $1 . $2; 
		push(@AllSha1, $sha1);
	}
}

##################################################################
# find all trees containing the file
##################################################################

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

##################################################################
# find all commits pointing to one of the trees found above
##################################################################

my @FoundCommits = ();

for my $commitSha1 (@AllSha1) {
	chomp $commitSha1;
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

##################################################################
# create a branch for each commit found
##################################################################

my $i = 0;
for my $foundSha1 (@FoundCommits) {
	my $branchName = "found/" . $i;
	`git branch $branchName $foundSha1`;
	printf "branch created: %s pointing to %s\n", $branchName, $foundSha1;
	$i++;
}
