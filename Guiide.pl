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
my $nick = 'Le_Guiide';
my $port = 6667;

my $krcname = 'Bot de DiiCTATURe';
my $username = 'Le_Guiide';
my $password = 'azerty';

my @channels = ('#alpha', '#diictature');

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
);

my @mots_interdits = (
	"nazi",
	"nsdap",
	"hitler",
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
	$irc->yield(shutdown => 'Le Guiide ne meurt jamais !');
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
				$irc->delay([privmsg => $_[0] => $precmd."bonjour : dire bonjour au Guiide"], 1);
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

# Gestion des HL.
if ($msg =~ /$nick/i) {                 	# if our nick appears in the message.
	print "<$user> $msg\n";
	if ($user eq "Alpha") {
		if ($msg =~ /Go away/i) {     		# Tell him to leave, and he does.
			$irc->yield(shutdown => 'Oui maÃ®tre !');
			sleep 1;
		}
		else {
			$irc->delay([privmsg => $chan => "Je me prosterne devant vous, maÃ®tre !"], 1);
		}
	}
	else {
		$irc->delay([privmsg => $chan => "Prosterne-toi !"], 1);
	}
	if ($msg =~ /Bonne annÃ©e/i) {
		$irc->delay([privmsg => $chan => "Je vous souhaite :"], 1);
		$irc->delay([privmsg => $chan => "2 fois plus de joie,"], 1);
		$irc->delay([privmsg => $chan => "0 souci,"], 1);
		$irc->delay([privmsg => $chan => "1 santÃ© dâ€™enfer,"], 1);
		$irc->delay([privmsg => $chan => "3 tonnes de bonnes nouvelles !"], 1);
		$irc->delay([privmsg => $chan => "Bonne annÃ©e 2013 !"], 1);
		$irc->delay([privmsg => $chan => "Bonne rÃ©solution : Votez DiiCTATURe !!"], 1);
	}
}

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
	# Jeu du Mastermind
	if ($commande eq "mastermind") {
		if ($mastmd_en_cours == 1) {
			$irc->delay([privmsg => $chan => "Une partie est dÃ©jÃ  en cours."], 1);
		}
		else {
			my @couleurs = ("w", "r", "g", "b");
			my @adeviner = ("", "", "", "");
			my @jouer = @adeviner;
			for (my $k=1; $k<=4; $k++) {
				$adeviner[$k] = $couleurs[ int (rand (4)) ];
			}

			$irc->delay([privmsg => $chan => "Vous pouvez commencer Ã  jouer."], 1);
		}
	}	
}

	if ($msg =~ /jouer/i) {
			my $jeu = ($msg =~ /^([^r|g|b|w]*)/)[0];
			if ($jeu ne '') {
				$irc->delay([privmsg => $chan => $jeu], 1);
				@jouer = split(',', $jeu);
				my $compt = 0;
				my $rep = "";
				for (my $k=1; $k<=4; $k++) {
					if ($jouer[$k] eq $adeviner[$k]) {
						$rep .= "OK ";
						$compt++;
					}
					else {
						$rep .= "__ ";
					}
				}						
				$irc->delay([privmsg => $chan => $rep], 1);
				if ($compt == 4) {
					$irc->delay([privmsg => $chan => $user." gagne."], 1);
					$mastmd_en_cours = 0;	
				}
			}
			else {
				$irc->delay([privmsg => $chan => "Aide."], 1);	
			}
		}
}


$poe_kernel->run();
exit 0;
