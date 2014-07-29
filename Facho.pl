
#!/usr/bin/perl -w
use strict;
use warnings;
use Date::Calc;
use POSIX;
use POE;
use POE::Component::IRC;
use DBI;

# Nom du fichier.
my $bot = $0;

# Identifiants.
my $serveur = 'IRC.iiens.net';
my $nick = 'Facho';
my $port = 6667;

my $krcname = 'Bot de DiiCTATURe';
my $username = 'Facho';
my $password = 'hk4yia;o47u';

my @channels = ('#alphiste', '#bde');

# CONNEXION
my ($irc) = POE::Component::IRC->spawn();

# Evenements que le bot va gÃ©rer
POE::Session->create(
	inline_states => {
		_start     => \&bot_start,
		irc_001    => \&on_connect,
		irc_public => \&on_speak,
		irc_invite => \&on_invite,
		irc_msg    => \&on_query,
	},
);

# Vars
my $bot_owner = 'Smurf';

my @citations = (
	"Prosternez-vous devant moi !",
	"La DiiCTATURe c'est FERME TA GUEULE !",
	"La DiiCTATURe du micro est aussi celle des idiots.",
	"Chaque fois que vous avez un gouvernement efficace, c'est une DiiCTATURe.",
	"Mieux vaut la DiiCTATURe du fer que l'anarchIIE de l'or.", 
	"DiiCTATURe : rÃ©gime oÃ¹ l'opinion publique ne peut s'exprimer qu'en privÃ©.", 
	"Le peuple n'a pas besoin de libertÃ©, car la libertÃ© est une des formes de la DiiCTATURe bourgeoise.",
	"Si nous Ã©tions en DiiCTATURe, les choses seraient plus simples - du moment que ce serait moi le DiiCTATeUR.",
	"La dÃ©mocratIIE est la pire des DiiCTATUReS, parce qu'elle est la DiiCTATURe exercÃ©e par le plus grand nombre sur la minoritÃ©.",
	"La DiiCTATURe est une forme autoritaire de la dÃ©mocratIIE dans laquelle tout ce qui n'est pas obligatoire est interdit.",
);

my @ops = (
	"Alpha",
	"Allo",
	"GeonPi",
	"Benef",
	"Smurf",
	"O-P",
	"Chuck",
	"Loopy",
	"Inco",
	"Samy",
	"Cold",
	"Foufoune",
	"frtoms",
);

my @mots_interdits = (
	"nazi",
	"nsdap",
	"connard",
);

sub bot_start {
	$irc->yield(register => "all");
	$irc->yield(
		connect => {
			Nick     => $nick,
			Username => $username, 
			Ircname  => $krcname,
			Server   => $serveur,
			Port     => $port,
		}
	);
}

# capture du ^c
$SIG{INT} = \&sig_int;

sub sig_int {
	$irc->yield(shutdown => 'Facho ne meurt jamais !');
	sleep 1;
}

my $precmd = '>';

my %commandes = (
		"quote"  	=> sub {
				$irc->delay([privmsg => $_[0] => &pickrandom], 1);
					},
		"bonjour"	=> sub { 
				$irc->delay([privmsg => $_[0] => "ImbÃ©cile ! Tu te crois au pays des bisounours ?"], 1); 
					},
		"play"		=> sub {
				$irc->delay([privmsg => $_[0] => "ImbÃ©cile ! On ne joue pas ici, c'est la DiiCTATURe. OKI ?"], 1); 
					},
		"help"     	=> sub {
				$irc->delay([privmsg => $_[0] => $precmd."bonjour : dire bonjour à Facho"], 1);
				$irc->delay([privmsg => $_[0] => $precmd."quote : affiche une citation alÃ©atoirement"], 1);
				$irc->delay([privmsg => $_[0] => $precmd."play : commencer Ã  jouer"], 1);
				}
			);

# Choose a random quote from the @citations array.
sub pickrandom {   								
    return $citations[ rand scalar @citations ];
}


# GESTION EVENTS

# A la connexion
sub on_connect
{
	$irc->yield(join => $_) for @channels;
	$irc->yield(privmsg => 'nickserv',"identify $password"); # identification
}

# Quand un user nous invite sur un chan
sub on_invite
{
	my ($user_,$chan) = @_[ARG0, ARG1];
	my $user = (split(/!/,$user_))[0];

	$irc->delay([privmsg => $bot_owner => $user . " m'invite sur " . $chan], 1);
}

# Discussion privÃ©e
sub on_query
{
	my ($user_, $msg) = @_[ARG0, ARG2];
	my $user = (split (/!/, $user_))[0];

	if ($msg =~ m/^$precmd/) {
		my $commande = ( $msg =~ m/^$precmd([^ ]*)/ )[0]; 
		my @params = grep {!/^\s*$/} split(/\s+/, substr($msg, length($precmd.$commande)));
	}
	else {
		setopt_resp ($user, $irc, $msg);
	}
}


sub on_speak {
	my ($kernel, $user_, $msg) = @_[KERNEL, ARG0, ARG2];
	my $chan = $_[ARG1];

	my $user = ( split(/!/,$user_) )[0];

	my $mastmd_en_cours = 0;
	my @adeviner;
	my @jouer;


# Gestion des kicks.
if ("@mots_interdits" =~ /$msg/i) {
	print "<$user> $msg\n";
	if ("@ops" !~ /$user/i) {
		$irc->delay([privmsg => $chan => "Surveille ton langage !"], 1);
		$irc->delay([privmsg => "chanserv" => "KICK $chan $user Toute l'Allemagne n'Ã©tait pas nazie..."], 1);
	}
}

if ($msg =~ m/^$precmd/) {
	my $commande = ( $msg =~ m/^$precmd([^ ]*)/ )[0]; 
	my @params = grep {!/^\s*$/} split(/\s+/, substr($msg, length($precmd.$commande)));

	foreach (keys(%commandes)) {
		if ($commande eq $_) {
			$commandes{$_}->($chan,$user,$kernel,$irc,@params);
			last;
		}
	}
}

$poe_kernel->run();
exit 0;
