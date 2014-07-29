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
my $nick = 'DrColo';
my $port = 6667;

my $ircname = 'Bot du groupe 4 !';
my $username = 'DrColo';
my $password = 'azerty';

my @channels = ('#alpha', '#alphiste');

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
my $bot_owner = 'Alpha';

my @citations = (
	"colo colo",
	"COLOSCOPIE !",
	"ASCII 594D",
	"Groupe 4 FTW !",
	"COLO TERRORISTA !!!!!",
	"Tu veux voir mes coloscopies ?",
	"Une petite coloscopie ? mmh ?",
	"ALLOOOOOOOOOOOOOOOOOOOOOOOOOO",
	"Que dirais-tu d'une petite photo de ton anus ?",
	"Je l'ai vue, j'ai perdu... :(",
	"Tu l'as vue, t'as perdu !! :)",
	"Vous n'Ãªtes qu'une bande de concierges.",
	"Tu sais pas qui je suis ? Google moi, enculÃ© !",
	"Qu'Ã  cela ne tienne, fils de pute !",
	"Mange plus de fromage !",
	"T 1 99 C wesh",
	"Semi AUTO, comme ma MOTO !",
	"Qui est l'auteur ? Qui est le narrateur ?"
);

my @citations_bite = (
	"J'me lave le pÃ©nis Ã  l'eau bÃ©nite !",
	"Tu veux connaÃ®tre le goÃ»t de ma bite ? Bah roule une pelle Ã  ta meuf !",
	"C'est toi la bite.",
	"Chuck Norris n'est rien face Ã  ma bite.",
	"Si je plais autant aux femmes, c'est sÃ»rement parce que j'ai une grosse bite.",
	"Une petite biffle, peut Ãªtre ?",
	"La bite ne fait pas le curÃ©.",
	"Je suis tombÃ© dans le viagra quand j'Ã©tais petit.",
	"Coucou ! Tu veux voir ma bite ?"
);

my @citations_gay = (
	"You're the only gay here...",
	"GAAAYYYYYYYYYYYYYYYYYYYY",
	"ArrÃªtons de parler de Gaby, s'il vous plait.",
	"SUCER DES BITES !",
	"Ta gueule, pÃ©dale.",
	"You like fishsticks ? You like to put them in your mouth ? Then you're a gay fish !",
	"Si c'est sur un bateau, c'est pas gay..."
);

my @citations_avion = (
	"L'avion, l'avion, l'avion, Ã§a fait lever les yeux...",
	"J'ai un visuel.", 
	"Visuel Ã  13h.",
	"Cible en vue !",
	"Tour de contrÃ´le, ici le commandant de bord. Demande permission de dÃ©coller."
);

my @ops = (
	"Alpha"
);

sub bot_start {
	$irc->yield(register => "all");
	$irc->yield(
		connect => {
			Nick     => $nick,
			Username => $username, 
			Ircname  => $ircname,
			Server   => $serveur,
			Port     => $port,
		}
	);
}

# capture du ^c
$SIG{INT} = \&sig_int;

sub sig_int {
	$irc->yield(shutdown => 'Cette coloscopie m\'a Ã©tÃ© fatale...');
	sleep 1;
}

my $precmd = '>';
my %commandes = (
		"quote"  	=> sub {
				$irc->delay([privmsg => $_[0] => &pickrandom], 1);
					},
		"help"     	=> sub {
				$irc->delay([privmsg => $_[0] => $precmd."quote : affiche une citation alÃ©atoirement"], 1);				}
			);

# Choose a random quote from the @citations array.
sub pickrandom {
    return $citations[ rand scalar @citations ];
}

sub pickrandom_bite {
    return $citations_bite[ rand scalar @citations_bite ];
}

sub pickrandom_gay {
    return $citations_gay[ rand scalar @citations_gay ];
}

sub pickrandom_avion {
    return $citations_avion[ rand scalar @citations_avion ];
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
}


sub on_speak {
	my ($kernel, $user_, $msg) = @_[KERNEL, ARG0, ARG2];
	my $chan = $_[ARG1];

	my $user = ( split(/!/,$user_) )[0];

	my $mastmd_en_cours = 0;
	my @adeviner;
	my @jouer;

# Gestion des HL.
if ($msg =~ /$nick/i) {                 	# if our nick appears in the message.
	print "<$user> $msg\n";
	if ($user eq "Alpha") {
		if ($msg =~ /d(Ã©|e)gage/i || $msg =~ /(casse|barre) toi/i) {     		# Tell him to leave, and he does.
			$irc->yield(shutdown => 'Je vais faire des coloscopies ailleurs.');
			sleep 1;
		}
		elsif ($msg =~ /bonjour/i) { 
			$irc->delay([privmsg => $chan => "Bonjour, MaÃ®tre Alpha ! :)"], 1); 
		}
		else {
			$irc->delay([privmsg => $chan => &pickrandom], 1);
		}
	}
	else {
			if ($msg =~ /bonjour/i) { 
				$irc->delay([privmsg => $chan => "Tu n'es qu'un sac Ã  merde pour moi."], 1); 
			}
			else {
				$irc->delay([privmsg => $chan => &pickrandom], 1);
			}
	}
}

if ($msg =~ /colo colo/i || $msg =~ /coloscopie/i) {
	if ($msg =~ /alaa/i) {
		$irc->delay([privmsg => $chan => "Allez Alaa, debout, s'il te plait ! :)"], 1);
	}
	else {
		$irc->delay([privmsg => $chan => "colo colo"], 1);
	}
}
elsif ($msg =~ /voil(Ã |a)+/i) {
	$irc->delay([privmsg => $chan => "Voilaaaaaa voilaaaaaa"], 1);
}
elsif ($msg =~ /a+ll+o+/i) {
	$irc->delay([privmsg => $chan => "AAALLLLLOOOOOOOOOOOOOOO"], 1);
}
elsif ($msg =~ /alaa+/i) {
	$irc->delay([privmsg => $chan => "Oh l'Alaa !"], 1);
}
elsif ($msg =~ /d(e|Ã©)f/i) {
	$irc->delay([privmsg => $chan => "Owiiii la soeur Ã  Def ! o/"], 1);
}
elsif ($msg =~ /lilie/i || $msg =~ /perdu/i) {
	$irc->delay([privmsg => $chan => "J'ai perdu."], 1);
}
elsif ($msg =~ /cherami/i ||$msg =~ /cher ami/i) {
	$irc->delay([privmsg => $chan => "Toi ! Fais gaffe ! Ok ? La prochaine fois... TU VAS VOIR ! Fais gaffe !"], 1);
}
elsif ($msg =~ /anus/i || $msg =~ /cul/i) {
	$irc->delay([privmsg => $chan => "Une petite photo peut-Ãªtre ?"], 1);
}
elsif ($msg =~ /bite/i || $msg =~ /zizi/i || $msg =~ /p(Ã©|e)nis?/i) {
	$irc->delay([privmsg => $chan => &pickrandom_bite], 1);
}
elsif ($msg =~ /gay/i || $msg =~ /p(e|Ã©)d(Ã©|e)/i || $msg =~ /pds?/i || $msg =~ /swa+g+/i) {
	$irc->delay([privmsg => $chan => &pickrandom_gay], 1);
}
elsif ($msg =~ /askipar(e|Ã©)/i || $msg =~ /(Ã  ce qu'il|ASCII|aski) (par(Ã©|e)|parait|594D)/i) {
	$irc->delay([privmsg => $chan => "Oui, mais deux fois ?"], 1);
}
elsif ($msg =~ /fois/i) {
	if ($msg =~ /(2|deux)/i) {
		$irc->delay([privmsg => $chan => "Ah si c'est deux fois, c'est vrai !"], 1);
	}
	else {
		$irc->delay([privmsg => $chan => "Alors c'est faux..."], 1);
	}
}
elsif ($msg =~ /boo+bs/i) {
	$irc->delay([privmsg => $chan => "NEED !"], 1);
}
elsif ($msg =~ /capi?taine? flag/i) {
	$irc->delay([privmsg => $chan => "Qu'Ã  cela ne tienne, fils de pute !"], 1);
}
elsif ($msg =~ /bails?/i) {
	$irc->delay([privmsg => $chan => "C'est quoi le bail ?"], 1);
}
elsif ($msg =~ /avion/i) {
	$irc->delay([privmsg => $chan => &pickrandom_avion], 1);
}
elsif ($msg =~ /MrConnard/i) {
	$irc->delay([privmsg => $chan => "DrConnard, Mister colo"], 1);
}

# Gestion des kicks.
# if ("@mots_interdits" =~ /$msg/i) {
#	print "<$user> $msg\n";
#	if ("@ops" !~ /$user/i) {
#		$irc->delay([privmsg => $chan => "Surveille ton langage !"], 1);
#	}
#}

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
}

$poe_kernel->run();
exit 0;
