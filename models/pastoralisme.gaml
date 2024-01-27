/**
 *  pastoralisme
 *  Author: Administrateur
 *  Description: 
 */

model pastoralisme

/**
 *  ouled
 *  Author: Administrateur
 *  Description: 
 */



/* Insert your model definition here */

/**
 *  premcouche
 *  Author: Administrateur
 *  Description: 
 */



/* Insert your model definition here */
/************************debut global */
global{
/*map params <- 
      ['dbtype'::'mysql','database'::'../includes/mabase.sql'];*/
map params <- [
      'host'::'localhost',
      'dbtype'::'MySQL',
      'database'::'mabase', // it may be a null string
      'port'::'3306',
      'user'::'root',
      'passwd'::'0000'];
      
 /* string mesespeces <-
   'select nom, type, debutcycle, dureecycle, productivite, successeur,predecesseur, tauxgermination from espece';*/
string mesespeces<-'select nom, type, productivite, successeur, predecesseur, debutcycle, compatibilite_texture, dureecycle,tauxgermination,biomassmax,biomassinint from espece;';
string monclimat<-'select annee, etpjanvier, etpfevrier, etpmars, etpavril, etpmai, etpjuin, etpjuillet,etpaout,etpseptembre, etpoctobre, etpnovembre, etpdecembre, etrjanvier, etrfevrier, etrmars, etravril, etrmai, etrjuin, etrjuillet, etraout,etrseptembre,etroctobre, etrnovembre, etrdecembre,pjanvier,pfevrier,pmars,pavril,pmai,pjuin,pjuillet,paout,pseptembre,pnovembre,pdecembre from pluviometriee;';
string monvent<-'select annee,ventjanvier, ventfevrier,ventmars,ventavril,ventmai,ventjuin,ventjuillet,ventaout,ventseptembre,ventoctobre,ventnovembre,ventdecembre from vente;';
file gis_sol <-file('../gis/parforoule.shp');	
file gis_ped <-file('../gis/pedoule.shp');
file gis_puit<- file('../gis/puioule.shp');
list interm<-list(interme);
/*list portio<-list(portion_sol);
list parc<-list(parcours);*/

 var i type: int<-0;
var j type: int<-0;
var k type:int<-0;
var s type: int<-0;
var ss type:int<-0;
var matexture type:float;
  var maprofondeur type:float;
string pas <-'mois';
int pass<-1;
int annee<-1990 min:1990 max:2000;
int anneemax<-2000;
int anneemin<-1990;
int nbre_troupeau<-1; /*le nombre était 20 */
int effectif_troupeau<-10; /*le nombre était 25 */
string visuelmensuel <-'oui';
var lemois type :int<-0;
var nbrejours type:int<-1; /*c le nombre de jours du mois le l'initialise à 1 pour éviter la division par zéro au début */
 var nb_courant type:int<-0; /*représente le nombre de jours écoulés du mois */
var etr type:float;
var etp type:float;
var pluvio type: float;
var vitesse type:float;
var vitadeux type :float;
var rugosite type:float<-0.02;
var biomassse_totale type:float;
var richesse_per_totale type :float;
var richesse_annu_totale type:float;
var etat_couvert_total type:float;
var etat_couvert_perenne type:float;
var biomasse_per type:float;
  var volume_max type:float;
var scenario type:string<-'moyen';/*je veux dire si le mois précédent est pluvieux moyen ou sec */
var la_dimension_zone_paturage type:int<-200;
var la_dimension_zone_troupeau type:int<-100;
var la_dimension_zone_manger type:int<-2;
var dimension_zone_manger type:int<-2;
 var nombre_vise type:int<-0;
var pas_de_temps type:int<-0; /* c le pas de temps je considère 1/4 d'heure */
var debut_cycle_annuelle type: int<-1;
var duree_cycle_annuelle type:int<-9;
var productivite_annuelle type:float<-1.00;
var taux_germination_annuelle type:float<-0.04;
var pas_deux type:int<-0;
var controle_pas type:bool<-false; /*je cree cette variable pour dire que les niveaux inférieurs ne peuvent commencer qu'apres un mois du début de la simulation */
/* map BOUNDS <-
     ['dbtype'::'mysql','database'::'../includes/mabase.sql',
      "select"::"select * from mabase;"];
*/
var trouve type:bool;
init{
	set nbrejours<-30;
	if (pas=annee)
	{set annee<-anneemin;}
	let listeselection type:list<-[];
	let listemonclimat type:list<-[];
	let listevent type:list<-[];
	 
	create agentdb number: 1{
		do write message:'fffff';
		
		
		
		set listeselection <- list(self select [params:: params, select:: mesespeces]);
		
		do write message:'passe';
		do write message:'climmm';
		set listemonclimat<-list(self select [params:: params, select:: monclimat]);
		write("leclimatttt"+length(listemonclimat));
		do write message:'passe';
		set listevent<-list(self select[params::params, select::monvent]);
		write("levent"+length(listevent));
	}
	

 do write message:'c quoi';
  create climat from:listemonclimat
    with:[annee::"annee",etpjanvier::"etpjanvier",etpfevrier::"etpfevrier",etpmars::"etpmars",etpavril::"etpavril",etpmai::"etpmai",etpjuin::"etpjuin",etpjuillet::"etpjuillet",etpaout::"etpaout",etpseptembre::"etpseptembre",etpoctobre::"etpoctobre",etpnovembre::"etpnovembre",etpdecembre::"etpdecembre",etrjanvier::"etrjanvier",etrfevrier::"etrfevrier",etrmars::"etrmars",etravril::"etravril",etrmai::"etrmai",etrjuin::"etrjuin",etrjuillet::"etrjuillet",etraout::"etraout",etrseptembre::"etrseptembre",etroctobre::"etroctobre",etrnovembre::"etrnovembre",etrdecembre::"etrdecembre",pjanvier::"pjanvier",pfevrier::"pfevrier", pmars::"pmars",pavril::"pavril",pmai::"pmai",pjuin::"pjuin",pjuillet::"pjuillet",paout::"paout",pseptembre::"pseptembre",pnovembre::"pnovembre",pdecembre::"pdecembre"];
   	  create espece_vegetale from: listeselection
            with:[ nom:: "nom", letype:: "type", productivite::"productivite", successeur::"successeur", predecesseur::"predecesseur", debutcycle::"debutcycle", compatibilite_texture::"compatibilite_texture", dureecycle::"dureecycle", tauxgermination::"tauxgermination", biomassemax::"biomassmax", biomassinit::"biomassinint"];
     
  
    
  create vitessevent from:listevent
  with:[annee::"annee",ventjanvier::"ventjanvier",ventfevrier::"ventfevrier",ventmars::"ventmars",ventavril::"ventavril",ventmai::"ventmai",ventjuin::"ventjuin",ventjuillet::"ventjuillet",ventaout::"ventaout",ventseptembre::"ventseptembre",ventoctobre::"ventoctobre",ventnovembre::"ventnovembre",ventdecembre::"ventdecembre"];
  /*do write message: 'ssss'; */
    let bb type:int<-0;
    	let listclimat type:list<-list(climat);
    loop bb from :0 to: length(listclimat)-1	
    {
    	if (listclimat at bb).annee=annee
    	{set etp <-(listclimat at bb).etpseptembre;
    	write("letpduclimat"+etp);	
    	set etr<-(listclimat at bb).etrseptembre;
    	/*set pluvio<-(listclimat at bb).pseptembre;*/
    	}
    }
    let gg type:int<-0;
    	let listvent type:list<-list(vitessevent);
    loop gg from :0 to: length(vitessevent)-1	
    {if (listvent at gg).annee=annee
    	{set vitesse<-(listvent at gg).ventseptembre;
    	}
    }
    
	create interme from :gis_ped with:[profondeur::read('PROFOND'),texture::read('TEXTURE')];
	create puit from:gis_puit with:[nom::read('NOM'), volume::read('VOL_M3_AN')];
	create portion_sol from :gis_sol with:[recouvrement_par::read('RECOUVREME'),groupement_par::read('COMPO_U_PH'),unitefourragere_par::read('UF'),particularite_par::read('OBSERVATIO'), surface::read('SURFACE'), classe_par::read('CLA_PAR'),steppe_par::read('STEPPE'), taux_un ::read('TAUX_UN'), taux_deux::('TAUX_DEUX'), taux_trois::read('TAUX_TROIS')];
	let pui type: list<-list(puit); 
let sr type:int<-0;
let vol type :float<-0;
loop sr from :0 to: length(pui)-1
{
  set vol<-vol + (pui at sr).volume;
  
}
 
let srr type:int<-0;
loop srr from :0 to: length(pui)-1
{ask pui at srr {
 	set shape<-(pui at srr).shape;
set location_puit<-(pui at srr).shape.location;
 	set prob<-(pui at srr).volume/vol;
 write("probbbb"+ prob);}	
}
	
	
	
	let portio type: list<-list(portion_sol);
	let interm type: list<-list(interm);
	
	loop i from :0 to: length(portio)-1
	{set j<-0;
		/*do write message:('b');*/
		loop while :!(trouve)and (j<length(interm)){
			if ((portio at i).shape)intersects ((interm at j).shape)=true{
				/*do write message:'xxxx';*/
				set maprofondeur <-(interm at j) .profondeur;
				set matexture<-(interm at j).texture;
				 ask portio at i{
				 set profondeur_par<-maprofondeur;
				 set texture_par<-matexture;	
				 }
				 set trouve<-true;
			}
			else{set j<-j+1;}
		
		
		}
		
	}
	
	
	
	loop k from:1 to:length(portio)
	{create parcours;
			
	}
	let parco type:list<-list(parcours);
	set k<-0;
	loop k from:0 to :length(parco)-1	
		{
		ask parco at k 
		{set p_idpar<-k+1;
			set shape<-(portio at k).shape;
		set location_parcours<-(portio at k).shape.location;
		set p_espece_dominante<-(portio at k).groupement_par;
		set p_classe<-(portio at k).classe_par;
		set surface<-(portio at k).surface;
		set p_profondeur<-(portio at k).profondeur_par;
		set p_texture<-(portio at k).texture_par;
		set p_steppe<-(portio at k).steppe_par;
		set taux_un<-(portio at k).taux_un;
		set taux_deux<-(portio at k).taux_deux;
		set taux_trois<-(portio at k).taux_trois;
		write("en creation la surface" + surface);	}
	}
	let ps type :int <-0;
	loop ps from :0 to :length(parco)-1
	{if ((parco at ps).p_texture=300) or ((parco at ps).p_texture=301)
	{ask parco at ps
		{set struc<-1;}
		
	}	
	if ((parco at ps).p_texture=302	) or ((parco at ps).p_texture=303)
	{ask parco at ps
		{set struc<-0.7;}
	}
	
	if ((parco at ps).p_texture=304	) or ((parco at ps).p_texture=305) or((parco at ps).p_texture=306)
	{ask parco at ps
		{set struc<-0.4;}
	}
	if ((parco at ps).p_texture=307	) or ((parco at ps).p_texture=308)
	{ask parco at ps
		{set struc<-0.6;}
	}
	if ((parco at ps).p_texture=309	) or ((parco at ps).p_texture=310)
	{ask parco at ps
		{set struc<-0.1;}
	}
	if ((parco at ps).p_texture=311	) or ((parco at ps).p_texture=312) or ((parco at ps).p_texture=315)or ((parco at ps).p_texture=316)or ((parco at ps).p_texture=317)
	{ask parco at ps
		{set struc<-0.05;}
	}
	if ((parco at ps).p_texture=313	) or ((parco at ps).p_texture=314)
	{ask parco at ps
		{set struc<-0.4;}
	}
	if ((parco at ps).p_texture=318	) or ((parco at ps).p_texture=319)
	{ask parco at ps
		{set struc<-0.02;}
	}
	
	
	}
	
	let pss type:int<-0;
	loop pss from: 0 to :length(parco)-1
	{
	if (parco at pss).p_profondeur=204
	{ask parco at pss
		{set prof<-100;}
	}	
	if (parco at pss).p_profondeur=203
	{ask parco at pss
		{set prof<-80;}
	}
	if (parco at pss).p_profondeur=202
	{ask parco at pss
		{set prof<-60;}
	}
	if (parco at pss).p_profondeur=201
	{ask parco at pss
		{set prof<-40;}
	}
	if ((parco at pss).p_profondeur=200) or ((parco at pss).p_profondeur=199)
	{ask parco at pss
		{set prof<-20;}
	}
	
	}
	let ks type:int<-0;	
	loop ks from: 0 to:length(parco)-1
	{write("la steppe"+ (parco at ks).p_steppe );
		if (parco at ks).p_steppe=1
		{ask parco at ks
		{set p_espece<-'AS ET ZA';
			set moi<-1;}
		create vegetation number:1{set espece<-(parco at ks).p_espece;
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		}
		
		else if (parco at ks).p_steppe=2
		{ask parco at ks
		{set p_espece<-'GD ET AS ';
			do write message:('gymno decander');
			set moi<-1;}
		create vegetation number:1{set espece<-(parco at ks).p_espece;
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		}
		else if (parco at ks).p_steppe=3
		{ask parco at ks
		{set p_espece<-'GD ET HK';
			set moi<-1;}
		create vegetation number:1{set espece<-(parco at ks).p_espece;
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		}
		
		else if (parco at ks).p_steppe=4
		{ask parco at ks
		{set p_espece<-'HS ET HS';
			set moi<-1;}
		create vegetation number:1{set espece<-(parco at ks).p_espece;
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		}
		
		else if (parco at ks).p_steppe=5
		{ask parco at ks
		{set p_espece<-'HS ET SP';
			set moi<-1;}
		create vegetation number:1{set espece<-(parco at ks).p_espece;
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		}
		
		else if (parco at ks).p_steppe=6
		{ask parco at ks
		{set p_espece<-'HS ET HK';
			set moi<-1;}
		create vegetation number:1{set espece<-(parco at ks).p_espece;
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		}
		
		else if (parco at ks).p_steppe=7
		{ask parco at ks
		{set p_espece<-'HS ET NR';
			set moi<-1;}
		create vegetation number:1{set espece<-(parco at ks).p_espece;
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		}
		
		else if (parco at ks).p_steppe=8
		{ask parco at ks
		{set p_espece<-'HS ET RR';
			set moi<-1;}
		create vegetation number:1{set espece<-(parco at ks).p_espece;
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		}
		
		else if (parco at ks).p_steppe=9
		{ask parco at ks
		{set p_espece<-'LM ET TG';
			set moi<-1;}
		create vegetation number:1{set espece<-(parco at ks).p_espece;
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		}
		
		else if (parco at ks).p_steppe=10
		{ask parco at ks
		{set p_espece<-'OASIS';
			set moi<-1;}
		}
		
		else if (parco at ks).p_steppe=11
		{ask parco at ks
		{set p_espece<-'PC ET JM';
			set moi<-1;}
		create vegetation number:1{set espece<-(parco at ks).p_espece;
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		}
		else if (parco at ks).p_steppe=12
		{ask parco at ks
		{set p_espece<-'TM ET SM';
			set moi<-1;}
		create vegetation number:1{set espece<-(parco at ks).p_espece;
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		}
		else if (parco at ks).p_steppe=13
		{ask parco at ks
		{set p_espece<-'TM ET HS';
			set moi<-1;}
		create vegetation number:1{set espece<-(parco at ks).p_espece;
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		}
		
		else if (parco at ks).p_steppe=14
		{ask parco at ks
		{set p_espece<-'CULTURE';
			set moi<-1;}
		}
		if (parco at ks).p_steppe=15
		{ask parco at ks
		{set p_espece<-'AS ET ZA';
		set p_espece_deux<-'HS ET HS';
			set moi<-1;}
		create vegetation number:1{set espece<-'AS ET ZA';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		create vegetation number:1{set espece<-'HS ET HS';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_deux/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		
		}
		else if (parco at ks).p_steppe=16
		{ask parco at ks
		{set p_espece<-'GD ET AS';
		set p_espece_deux<-'GD ET HK';	
			set moi<-1;}
		create vegetation number:1{set espece<-'GD ET AS';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		create vegetation number:1{set espece<-'GD ET HK';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_deux/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		}
		if (parco at ks).p_steppe=17
		{ask parco at ks
		{set p_espece<-'GD ET HK';
			set p_espece_deux<-'HS ET SP';
			set moi<-1;}
		create vegetation number:1{
			set espece<-'GD ET HK';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;
		}
		create vegetation number:1{
			set espece<-'HS ET SP';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_deux/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;
		}
		}
		else if (parco at ks).p_steppe=18
		{ask parco at ks
		{set p_espece<-'GD ET AS';
			set p_espece_deux<-'GD ET HK';
			set p_espece_trois<-'TM ET HS';
			set moi<-1;}
		create vegetation number:1{
			set espece<-'GD ET AS';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;
		}
		create vegetation number:1{set espece<-'GD ET HK';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_deux/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		create vegetation number:1{set espece<-'TM ET HS';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_trois/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		
		}
		
		else if (parco at ks).p_steppe=19
		{ask parco at ks
		{set p_espece<-'TM ET HS';
		set p_espece_deux<-'GD ET AS';
		set p_espece_trois<-'GD ET HK';	
			set moi<-1;}
		create vegetation number:1{set espece<-'TM ET HS';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		create vegetation number:1{set espece<-'GD ET AS';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_deux/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		create vegetation number:1{
			set espece<-'GD ET HK';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_trois/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;
		}
		}
		else if (parco at ks).p_steppe=20
		{ask parco at ks
		{set p_espece<-'GD ET AS';
			set p_espece_deux<-' GD ET HK';
			set p_espece_trois<-'HS ET RR';
			set moi<-1;}
		create vegetation number:1{set espece<-'GD ET HK';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		create vegetation number:1{set espece<-'HS ET HS';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_deux/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		create vegetation number:1{set espece<-'HS ET RR';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_trois/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		
		}
		
		else if (parco at ks).p_steppe=21
		{ask parco at ks
		{set p_espece<-'HS ET HS';
		set p_espece_deux<-'HS ET SP';
		set p_espece_trois<-'HS ET NR';	
			set moi<-1;}
		create vegetation number:1{set espece<-'HS ET HS';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_un/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		create vegetation number:1{set espece<-'HS ET SP';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_deux/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		create vegetation number:1{set espece<-'HS ET NR';
				set densite<-70;
				set tauxducouvert<-(parco at ks).taux_trois/100;
				set surface_init<-tauxducouvert*(parco at ks).surface;
				set idpar<-(parco at ks).p_idpar;}
		
		}
		
		
		
		
		
		}
		
		
	 set s<-0;
	loop s from :0 to :length(parco)-1
	{if (parco at s).moi=1
		{
	create vegetation_annuelle;
		}}
		let vegetal type:list<-list(vegetation);
		let parcos type:list<-list(parcours)where (each.moi=1);
		let vegetalannuelle type:list<-list(vegetation_annuelle);
		let listbase type:list<-list(espece_vegetale);
		let sk type:int<-0;
		loop sk from:0 to: length(vegetation_annuelle)-1
		{ask vegetalannuelle at sk
			{set densite<-30;
				set surface_init<-(parcos at sk).surface;
				set idpar<-(parcos at sk).p_idpar;
				set debutcycle<-1;
				set dureecycle<-9;
				set productivite<-1;
				set tauxducouvert<-0.30;
				set biomassemax<-(800/10000)*(parcos at sk).surface*tauxducouvert;
				set tauxgermination<-0.04;
			}
		}
		
				let sss type:int<-0;
				let ssss type:int<-0;
		loop sss from :0 to: length(vegetal)-1
		{loop ssss from:0 to :length(listbase)-1
			{if (vegetal at sss).espece=(listbase at ssss).nom
				{ask vegetal at sss
					{ set debutcycle<-(listbase at ssss).debutcycle;
						 set dureecycle<-(listbase at ssss).dureecycle;
						set productivite<-(listbase at ssss).productivite;
						set successeur<-(listbase at ssss).successeur;
						set predecesseur<-(listbase at ssss).predecesseur;
						set biomassemax<-((listbase at ssss).biomassemax/10000)*surface_init;
						set tauxgermination<-((listbase at ssss).tauxgermination);
						set biomasse_init<-(listbase at ssss).biomassinit;
						
						set biomasse<-(biomasse_init/10000)*surface_init;
						
						set letype<-(listbase at ssss).letype;
						
					}
				}
			}
			
		}		
			
	
	

    

 

    
  
    
    	
    		
    		
    	
    		
    		
    	
    	
    	
    	


 create observateur_parcours number:1; 
let sd type:int<-0;

loop sd from:0 to:(nbre_troupeau)-1 
{create berger{set id_troup<-sd +1;
	 }
	let bergers type:list<-list(berger);
	create troupeau 
	{set id_troup<-sd+1;
	set effect_troup<-effectif_troupeau;	
	set nbre_male<-round(effectif_troupeau*0.75);
	set nbre_femelle<-effectif_troupeau-nbre_male;
	set mon_berger<-one_of((bergers)where(each.id_troup=sd +1));
	}
	 
	
	}
	
	
	let kk type:int<-0;
	let ppui type:list<-list(puit);
	let ff type :int<-0;
	let mestroup type:list<-list(troupeau);
	let mesberg type:list<-list(berger);
	let puitroup type:int<-0;
	let quota type :int<-0;
	loop kk from : 0 to :length(ppui)-1
	{write("maprob"+ (ppui at kk).prob);
		 set quota<-min ([nbre_troupeau-1, ff + round((ppui at kk).prob *nbre_troupeau)+1]);
		loop while :puitroup <=quota
		{
			ask mesberg at puitroup{
				set location_berger<-(ppui at kk).location_puit;
				
			}
			ask mestroup at puitroup
			{set location_troupeau<-(ppui at kk).location_puit;
				write("puitroup"+location);
			set puitroup<-puitroup +1;
			}
		
		
		}
		set ff<-puitroup-2 ;
	}
  write("entrernernenrnernenrnenr");  

  
    	
    	
    	}


reflex courant when:pas_de_temps mod (nbrejours*92) =0 and nbrejours>0 {
	write("lemoiscourant"+lemois);
	set nb_courant<-0;
	if pas='mois'
	{if lemois<12
	{set lemois<-lemois+1;	
	}
	else{ do halt;}
	
	}
	
	if pas='annee'
	{write("lepremiermois"+lemois);
		if lemois<12
		{set lemois<-lemois+1;}
	else
		{if annee<anneemax
			{set lemois<-1;
			set annee<-annee+1;}
			else{do halt;}
			}
			
		}
		
		
		

	 let listclimatt type:list<-list(climat);
	 let bb type:int<-0;
     write("leclimat"+length(listclimatt));
    loop bb from :0 to: length(listclimatt)-1	
    {if (listclimatt at bb).annee=annee
    	{if lemois=1
    	{set nbrejours<-30;
    	set etp <-(listclimatt at bb).etpseptembre;
    	write("letp"+etp);
    	set etr<-(listclimatt at bb).etrseptembre;
    	set pluvio<-(listclimatt at bb).pseptembre;
    	
    	}
    	else if lemois=2
    	{set nbrejours<-31;
    	set etp <-(listclimatt at bb).etpoctobre;
    	set etr<-(listclimatt at bb).etroctobre;
    	set pluvio<-(listclimatt at bb).poctobre;
    	if ((listclimatt at bb).pseptembre>=20)
    	{set scenario <-"pluvieux";}
    	else if((listclimatt at bb).pseptembre <20 and (listclimatt at bb).pseptembre >=10 )
    	{set scenario <-"moyen";}
    	else set scenario<-"sec";
    	}
    	else if lemois=3
    	{set nbrejours<-30;
    	set etp <-(listclimatt at bb).etpnovembre;
    	set etr<-(listclimatt at bb).etrnovembre;
    	set pluvio<-(listclimatt at bb).pnovembre;
    	if ((listclimatt at bb).poctobre>=20)
    	{set scenario <-"pluvieux";}
    	else if((listclimatt at bb).poctobre <20 and (listclimatt at bb).poctobre >=10 )
    	{set scenario <-"moyen";}
    	else set scenario<-"sec";
    	
    	}
        else if lemois=4
    	{set nbrejours<-31;
    	set etp <-(listclimatt at bb).etpdecembre;
    	set etr<-(listclimatt at bb).etrdecembre;
    	set pluvio<-(listclimatt at bb).pdecembre;
    	if ((listclimatt at bb).pnovembre>=20)
    	{set scenario <-"pluvieux";}
    	else if((listclimatt at bb).pnovembre <20 and (listclimatt at bb).pnovembre >=10 )
    	{set scenario <-"moyen";}
    	else set scenario<-"sec";
    	
    	}
    	else if lemois=5
    	{set nbrejours<-31;
    	set etp <-(listclimatt at bb).etpjanvier;
    	set etr<-(listclimatt at bb).etrjanvier;
    	set pluvio<-(listclimatt at bb).pjanvier;
    	if ((listclimatt at bb).pdecembre>=20)
    	{set scenario <-"pluvieux";}
    	else if((listclimatt at bb).pdecembre <20 and (listclimatt at bb).pdecembre >=10 )
    	{set scenario <-"moyen";}
    	else set scenario<-"sec";
    	
    	
    	}
        else if lemois=6
    	{set nbrejours<-28;
    	set etp <-(listclimatt at bb).etpfevrier;
    	set etr<-(listclimatt at bb).etrfevrier;
    	set pluvio<-(listclimatt at bb).pfevrier;
    	if ((listclimatt at bb).pjanvier>=20)
    	{set scenario <-"pluvieux";}
    	else if((listclimatt at bb).pjanvier <20 and (listclimatt at bb).pjanvier >=10 )
    	{set scenario <-"moyen";}
    	else set scenario<-"sec";
    	
    	}
    	else if lemois=7
    	{set nbrejours<-31;
    	set etp <-(listclimatt at bb).etpmars;
    	set etr<-(listclimatt at bb).etrmars;
    	set pluvio<-(listclimatt at bb).pmars;
    	if ((listclimatt at bb).pfevrier>=20)
    	{set scenario <-"pluvieux";}
    	else if((listclimatt at bb).pfevrier <20 and (listclimatt at bb).pfevrier >=10 )
    	{set scenario <-"moyen";}
    	else set scenario<-"sec";
    	
    	
    	}
    	else if lemois=8
    	{set nbrejours<-30;
    	set etp <-(listclimatt at bb).etpavril;
    	set etr<-(listclimatt at bb).etravril;
    	set pluvio<-(listclimatt at bb).pavril;
    	if ((listclimatt at bb).pmars>=20)
    	{set scenario <-"pluvieux";}
    	else if((listclimatt at bb).pmars <20 and (listclimatt at bb).pmars >=10 )
    	{set scenario <-"moyen";}
    	else set scenario<-"sec";
    	
    	}
    	else if lemois=9
    	{set nbrejours<-31;
    	set etp <-(listclimatt at bb).etpmai;
    	set etr<-(listclimatt at bb).etrmai;
    	set pluvio<-(listclimatt at bb).pmai;
    	if ((listclimatt at bb).pavril>=20)
    	{set scenario <-"pluvieux";}
    	else if((listclimatt at bb).pavril <20 and (listclimatt at bb).pavril >=10 )
    	{set scenario <-"moyen";}
    	else set scenario<-"sec";
    	
    	}
    	else if lemois=10
    	{set nbrejours<-30;
    	set etp <-(listclimatt at bb).etpjuin;
    	set etr<-(listclimatt at bb).etrjuin;
    	set pluvio<-(listclimatt at bb).pjuin;
    	if ((listclimatt at bb).pmai>=20)
    	{set scenario <-"pluvieux";}
    	else if((listclimatt at bb).pmai <20 and (listclimatt at bb).pmai >=10 )
    	{set scenario <-"moyen";}
    	else set scenario<-"sec";
    	
    	}
    	else if lemois=11
    	{set nbrejours<-31;
    	set etp <-(listclimatt at bb).etpjuillet;
    	set etr<-(listclimatt at bb).etrjuillet;
    	set pluvio<-(listclimatt at bb).pjuillet;
    	if ((listclimatt at bb).pjuin>=20)
    	{set scenario <-"pluvieux";}
    	else if((listclimatt at bb).pjuin <20 and (listclimatt at bb).pjuin >=10 )
    	{set scenario <-"moyen";}
    	else set scenario<-"sec";
    	
    	}
    	else if lemois=12
    	{set nbrejours<-31;
    	set etp <-(listclimatt at bb).etpaout;
    	set etr<-(listclimatt at bb).etraout;
    	set pluvio<-(listclimatt at bb).paout;
    	if ((listclimatt at bb).pjuillet>=20)
    	{set scenario <-"pluvieux";}
    	else if((listclimatt at bb).pjuillet <20 and (listclimatt at bb).pjuillet >=10 )
    	{set scenario <-"moyen";}
    	else set scenario<-"sec";
    	
    	}
    
    
    
    
    
    
    }
    }
let listvitesse type :list <-list(vitessevent);
let vs type:int<-0;


loop vs from:0 to: length(listvitesse)-1
{if (listvitesse at vs).annee=annee
    	{if lemois=1
    	{set vitesse <-(listvitesse at vs).ventseptembre;
    	
    	}
    	else if lemois=2
    	{set vitesse <-(listvitesse at vs).ventoctobre;
    	
    	}
    	else if lemois=3
    	{set vitesse <-(listvitesse at vs).ventnovembre;
    	
    	}
        else if lemois=4
    	{set vitesse<-(listvitesse at vs).ventdecembre;
    	
    	}
    	else if lemois=5
    	{set vitesse <-(listvitesse at vs).ventjanvier;
    	
    	}
        else if lemois=6
    	{set vitesse <-(listvitesse at vs).ventfevrier;
    	
    	}
    	else if lemois=7
    	{set vitesse <-(listvitesse at vs).ventmars;
    	
    	}
    	else if lemois=8
    	{set vitesse <-(listvitesse at vs).ventavril;
    	
    	}
    	else if lemois=9
    	{set vitesse <-(listvitesse at vs).ventmai;
    	
    	}
    	else if lemois=10
    	{set vitesse <-(listvitesse at vs).ventjuin;
    	 
    	}
    	else if lemois=11
    	{set vitesse <-(listvitesse at vs).ventjuillet;
    	
    	}
    	else if lemois=12
    	{set vitesse <-(listvitesse at vs).ventaout;
    	
    	}
    
    
    
    
    
    
    }
    
}





























let obspar type:list<-list(observateur_parcours);
set biomassse_totale<-(obspar at 0).biomassse_tot;
set richesse_per_totale <- (obspar at 0).richesse_per;
set richesse_annu_totale <-(obspar at 0).richesse_annu;
set	 etat_couvert_total <-(obspar at 0).etat_couvert;
set etat_couvert_perenne<-(obspar at 0).recouv_perenne;
set biomasse_per<-(obspar at 0).biomasse_per;




}/*fin reflex courant */
reflex pas_temps{
	
	write("je suis dans pas de temps");
	set pas_de_temps<-pas_de_temps + 1;
  write ("le pas de temps"+pas_de_temps);
  if pas_de_temps mod 92 = 0 
  { set nb_courant<-nb_courant+1;}


}

reflex save_result  {
		save [biomassse_totale] type: "text" to: "results.text";
	}
}

/*fin global debut entities */
entities{
species portion_sol{
	var surface type:float;
	var groupement_par type:string;
	var recouvrement_par type:string;
	var unitefourragere_par type:float;
	var particularite_par type:string;
	var profondeur_par type:float;
	var texture_par type:float;
	var classe_par type:int;
	var steppe_par type:int;
 var taux_un type:float;
 var taux_deux type:float;
 var taux_trois type:float;
  aspect basic{
  	draw geometry:shape;
  }	
	
}	
species interme{
var profondeur type:float;
var texture type:float;	
  aspect basic{
  	draw geometry:shape;
  }	  
    }
    
species puit{
var nom type:string;	
var volume type:float;
var prob type: float;
var taille type:int;	
var location_puit type:point;
init{
	write("probbbb"+ prob);
	set taille<-round(100* prob);
write ("ttttaallle" + taille);
set shape <- circle(taille*100);

}	
	aspect basic{
	draw geometry:shape at:location_puit  empty:false color:rgb('blue') z:2000 size:taille* 10000 ;
	}	
	
	
}    
    
 species agentdb skills: [SQLSKILL]{
 	
 	
 }
    
 species espece_vegetale {
 	var nom type:string;
 	var letype type:string;
 	var debutcycle type:int;
 	var dureecycle type:int;
 	var productivite type:float;
 	var successeur type:string;
 	var predecesseur type:string;
 	var compatibilite_texture type:string;
 	var tauxgermination type:float;
 	var biomassemax type:float;
 	var biomassinit type:float;
 	
 }
 
 /*fin unité espèce */
 
species vegetation {                   /*j'utilise vegetation pour dire groupement végétal élémentaire c'a d par exemple AS et SH */
	var letype type:string;
	var biomasse type :float;
	var biomassemax type:float;
	var idpar type:int;
	var part_du_parcours type:float;
	var densite type:float;
	var espece type:string;
	var debutcycle type:int;
	var dureecycle type:int;
 	var productivite type:float;
 	var successeur type:string;
 	var predecesseur type:string;
 	var compatibilite_texture type:string;
 	var tauxgermination type:float;
 	var tauxducouvert type:float;
 	var couvertcompetition type:float<-0.00;
 	var surface_init type:float;
 	var biomasse_init type:float;
 	var x type :float;
 reflex madensite when:pas_de_temps mod (nbrejours*92) =0 and nbrejours>0
 {	
  if lemois=debutcycle
 	{set densite<-densite*tauxgermination;}
 	
 		
 }	
reflex monrecouvrement when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0
{
	let vegetationmonparcours type:list<-list(vegetation);
	let ff type:int<-0;
	loop ff from:0 to: length(vegetationmonparcours)-1
	 { if ((vegetationmonparcours at ff).idpar=idpar) and ((vegetationmonparcours at ff).predecesseur=espece)
	 {set couvertcompetition<-couvertcompetition+ (vegetationmonparcours at ff).tauxducouvert;}	
	 }
	 
	/*if (pas='mois'){*/
	if lemois=debutcycle
	{set tauxducouvert<-tauxducouvert +tauxducouvert* (1-couvertcompetition)*tauxgermination;
	}
/*} */
/*write("monrecouvrement" +tauxgermination);*/
}

  reflex mabiomasse when: pas_de_temps mod (nbrejours*92 )=0 and nbrejours>0
 { 
 	let xs type:int<-0;
 	set xs<-debutcycle+dureecycle;
 	write("llllladdduurree"+xs);
 	
 	if (lemois>=debutcycle+dureecycle)
 	{
 		set biomasse<-x;
 		write("********"+biomasse);
 	}	
 	if (lemois=debutcycle)
 		{
 			 set biomassemax<-biomassemax+ biomassemax*tauxgermination;
 			
 			/*write("biomasseperinitiale" +biomasse);*/
 			set biomasse<-biomasse+(biomasse*tauxgermination*productivite)* ((biomassemax-biomasse)/biomassemax )* (etr/etp) ;
 		
 		}
 		
 		else if (lemois> debutcycle and lemois<debutcycle+dureecycle-1)
 		{if(lemois<=7) {set biomasse<-biomasse+(biomasse*productivite)* ((biomassemax-biomasse)/biomassemax) * (etr/etp) ;
 			set x<-biomasse*0.6;}
 		
 		}
 	/* }*/
 /*write("biomasseppppppppppp" +biomasse); */
 write("biomasseppppppppppp" +biomasse);
 }	
	
}

/*fin espece vegetation perenne */
species vegetation_annuelle
{var letype type:string;
	var biomasse type :float;
	var biomassemax type:float;
	var idpar type:int;
	var part_du_parcours type:float;
	var densite type:float;
	var espece type:string;
	var debutcycle type:int;
	var dureecycle type:int;
 	var productivite type:float;
 	var tauxgermination type:float;
 	var tauxducouvert type:float;
 	var couvertcompetition type:float<-0.00;
 	var surface_init type:float;
 reflex madensite when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0
 {/*if (pas='mois')	
 {*/
 if lemois=debutcycle
 	{set densite<-densite*tauxgermination;}
 	
 	}	
/* }*/	
reflex monrecouvrement when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0
{let vegetationmonparcours type:list<-list(vegetation);
	let tauxcoudiff type:float<-0;
	let ff type:int<-0;
	loop ff from:0 to: length(vegetationmonparcours)-1
	 { if (vegetationmonparcours at ff).idpar=idpar
	 {set couvertcompetition<-couvertcompetition+tauxducouvert+ (vegetationmonparcours at ff).tauxducouvert;
	 set tauxcoudiff<-tauxcoudiff+(vegetationmonparcours at ff).tauxducouvert;
	 	
	 }	
	 }
	 
	/*if (pas='mois')
	{*/if lemois=debutcycle
	{set tauxducouvert<-tauxducouvert +tauxducouvert*(1-couvertcompetition)*tauxgermination-tauxgermination*tauxducouvert*tauxcoudiff;
	/* }*/
}

}
 reflex mabiomasse when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0
 {let w type:int<-0;
 	/*write("bioannuelle"+biomassemax);*/
 	/*if (pas='mois')
 	{
 	*/if(lemois>=debutcycle+dureecycle)
 	{set biomasse<-0;}
 	 if (lemois=debutcycle)
 		{ set biomassemax<-biomassemax +biomassemax*tauxgermination;
 			write ("etr" + etr);
 			write ("etp"+etp);
 			set biomasse<-biomasse+(biomasse*productivite)* ((biomassemax-biomasse)/biomassemax) * (etr/etp) ;}
 			
 		else if (lemois> debutcycle and lemois<debutcycle+dureecycle)
 		{if(lemois<=7){set biomasse<-biomassemax;
			set w<-biomasse*0.6;}
		
 		}
 	}
 
/* }*/ 	
/*write("bioannuelleppppppp"+biomasse); */	


}
/* 
species ma_grille_parcours  {
var id_grille_de_parcours type:int;
var width type:float;
var height type:float;
var location type:point;
var dimension type:float;
var taille type:float;
var concerne_1 type:bool;
var pp type:geometry;
aspect basic{

}
action initial{
set shape<-polygon([{0,0}, {0,10},{10,10},{10,0}] );	
	
	}
}
species ma_parcelle{
var id_grille_de_parcours type:int;	
var location type:point;
var size type:int;
aspect basic{
draw shape:square  at :location size:1 color:rgb('red');	
}
}

*/

species parcours{
var moi type:int<-0;
 var p_idpar type:int;
 var surface type:float;
 var p_espece_dominante type:string;
 var p_richesse_perenne type :float;
 var p_richesse_annuelle type:float;
 var p_densite_couvert type:float;
 var p_densite_couvert_perenne type:float;
 var p_biomasse type:float;
 var p_etat_surface type: string;
 var recouvrement type:float;
 var recouvrement_perenne type:float;
 var p_classe type:int;
 var p_espece type:string;
 var p_espece_deux type:string;
 var p_espece_trois type:string;
 var taux_un type:float;
 var taux_deux type:float;
 var taux_trois type:float;
 var p_steppe type:int;
 var p_biomasse_perenne type:float;
 var mesvegetation type: list<-list(vegetation);
 var size type:float<-1.00;
 var erodabilite type:float;
 var struc type:float;
 var prof type:float;
 var p_texture type:float;
 var p_profondeur type:float;
 var qterosion type:float;
 var epaisseur_erodee type:float;
 var epaisseur_erodeetot type:float<-0.00;
var paturage type:bool <-false;/*veut dire que ce parcours a au moins été visité une fois je le fais pour les calculs de biomasse etc */
var vise type:bool<-false;/* vise veut dire que le berger a décidé de paturer sur ce parcours */
var surface_paturee type:float<-0.00;/*j'utilise cette variable pour calculer la somme des surfaces des zones_troupeaux paturees */
var zone_par_cree type:bool<-false;
var location_parcours type:point;
/*  ma_grille_parcours deplacement;*/
/*list deplacement <- [] of: ma_grille_parcours;*/
 aspect basic
 {
 if recouvrement<0.1
 {draw geometry:shape color:rgb('yellow');}
 if recouvrement>0.1 and recouvrement<0.5
 
  {draw geometry:shape color:rgb('green');}
 if recouvrement>0.5 and recouvrement<0.75
  {draw geometry:shape color:rgb('gray');}
  if recouvrement>0.75 and recouvrement<0.85
  {draw geometry:shape color:rgb('red');}
  if recouvrement>0.85 
  {draw geometry:shape color:rgb('black');}
  }
 aspect erosif
 {
 	if epaisseur_erodeetot<=20
 	{draw geometry:shape color:rgb('green');}
	if epaisseur_erodeetot>20 and epaisseur_erodeetot<=120
 	{draw geometry:shape color:rgb('red');} 	
 	if epaisseur_erodeetot>200
 	{draw geometry:shape color:rgb('blue');}
 	
 }
  
  aspect vise{
  	if vise=true{
  		draw geometry:shape color:rgb('green');}
  	else {draw geometry:shape color:rgb('red');}
  	
  }
  aspect verif{
	
	draw shape:square at:self.location size:1000 color:rgb('yellow');}
 /*  aspect grille
  {let sn type:int<-0;
  	loop i from:0 to :length(deplacement)
  	{if (!dead(deplacement at i))and (deplacement at i).concerne_1=true
  		{draw shape:square at:(deplacement at i).location size:1 color:rgb("yellow");}
  	}
  	if(!dead(deplacement at i)) and (deplacement at i).concerne_1=false
  	{draw shape:square at:(deplacement at i).location size:1 color:rgb("red");} 
 
 } */
 action reponse_commencer_paturage{}
 reflex viser{
	let ps type:list<-list(puit);
	let pps type :int<-0;
	loop pps from:0 to:length(ps)-1{
	if self.shape intersects (ps at pps ).location_puit=true 
	{
	if vise=false
		{ 
			set vise<-true;
			
			
			
		
			
	  
	
		
	}}
	
	
	
	


}
}
  reflex calcul_surface_paturee when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
  	let i type :int<-0;
    	let sp type:float<-0.00;
    	let listzone<-list(zone_troupeau) where ((each.id_parcours=p_idpar) and(each.paturage=true));
  loop i from:0 to:length(listzone)-1
    	{set surface_paturee<-surface_paturee+(listzone at i).dimension_zone_troupeau*(listzone at i).dimension_zone_troupeau;}
    	
    	}
  reflex biomasse_perenne when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
  
set p_biomasse_perenne<-0;/************ */
  	if moi=1
  	{let listveggge<-list(vegetation) where(each.idpar=p_idpar);
  	let yyy type:int<-0;
  	if length(listveggge)>0
  	{
  	loop yyy from:0 to :length(listveggge)-1
  	{set p_biomasse_perenne<-p_biomasse_perenne+((listveggge at yyy).biomasse);
  		}	
     }
    if paturage=true{
    	
    	set p_biomasse_perenne<-p_biomasse_perenne*(surface-surface_paturee)/surface;}
    	let listzone<-list(zone_troupeau) where ((each.id_parcours=p_idpar) and(each.paturage=true));
    let i type:int<-0;
    let biomasse_paturage_perenne type:float<-0.00;
    loop i from:0 to:length(listzone)-1{
    set biomasse_paturage_perenne<-biomasse_paturage_perenne + (listzone at i).biomasse_perenne_zone;}
    set p_biomasse_perenne<-p_biomasse_perenne + biomasse_paturage_perenne;
}
    
     write("parcoursbioperenne"+p_biomasse_perenne);
  }/*fin biomasee_perenne */
  reflex biomasse when: pas_de_temps mod (92*nbrejours)=1 and nbrejours>0{
  	set p_biomasse<-0;   /************** */
  	if moi=1
  	{let listveggg<-list(vegetation) where(each.idpar=p_idpar);
  	let listvegann<-list(vegetation_annuelle)where(each.idpar=p_idpar);
  	let yyye type:int<-0;
  	let yyy type:int<-0;
  	loop yyy from:0 to :length(listveggg)-1
  	{set p_biomasse<-p_biomasse+((listveggg at yyy).biomasse);}
  	loop yyye from:0 to :length(listvegann)-1
  	{set p_biomasse<-p_biomasse + (listvegann at yyye).biomasse;}
  	if paturage=true{
    	
    	set p_biomasse<-p_biomasse*(surface-surface_paturee)/surface;
    	let listzone<-list(zone_troupeau) where ((each.id_parcours=p_idpar) and(each.paturage=true));
    let i type:int<-0;
    let biomasse_paturage type:float<-0.00;
    loop i from:0 to:length(listzone)-1{
    set biomasse_paturage<-biomasse_paturage + (listzone at i).biomasse_zone;}
    set p_biomasse<-p_biomasse + biomasse_paturage;
  	}
  	write("lemois"+ lemois);
  	write("labioparcours"+p_biomasse);
  	}	
  
  }
  reflex etat_recouvrement_perenne when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
  	set recouvrement_perenne<-0;        /**************** */
  if moi=1
  {let listvege<-list(vegetation) where(each.idpar=p_idpar);
  	let ye type:int<-0;
  	loop ye from:0 to :length(listvege)-1
  	{set recouvrement_perenne<-recouvrement_perenne +((listvege at ye).tauxducouvert);}
 if (paturage=true)
 {set recouvrement_perenne<-recouvrement_perenne*(surface-surface_paturee)/surface;}
 let listzone<-list(zone_troupeau) where ((each.id_parcours=p_idpar) and(each.paturage=true));
    let i type:int<-0;
    let recouvrement_paturage type:float<-0.00;
    loop i from:0 to:length(listzone)-1{
    set recouvrement_paturage<-recouvrement_paturage + (listzone at i).etat_couvert_perenne_zone;}
    set recouvrement_perenne<-recouvrement_perenne *(surface-surface_paturee)/surface + recouvrement_paturage*surface_paturee/surface;
 
 
 }}
 
 
 
 reflex etat_recouvrement when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
 	set recouvrement<-0;
  if moi=1
  {let listvege<-list(vegetation) where(each.idpar=p_idpar);
  let listvegee<-list(vegetation_annuelle)where(each.idpar=p_idpar);
  let yee type:int<-0;
  	let ye type:int<-0;
  	loop ye from:0 to :length(listvege)-1
  	{set recouvrement<-recouvrement +((listvege at ye).tauxducouvert);}
  	loop yee from:0 to:length(listvegee)-1
  	{set recouvrement<-recouvrement +(listvegee at yee).tauxducouvert;}
 if (paturage=true)
 {set recouvrement<-recouvrement*(surface-surface_paturee)/surface;}
 let listzone<-list(zone_troupeau) where ((each.id_parcours=p_idpar) and(each.paturage=true));
    let i type:int<-0;
    let recouvrement_paturage type:float<-0.00;
    loop i from:0 to:length(listzone)-1{
    set recouvrement_paturage<-recouvrement_paturage + (listzone at i).etat_couvert_zone;}
    set recouvrement<-recouvrement *(surface-surface_paturee)/surface + recouvrement_paturage*surface_paturee/surface;
 
 
 
 
 }}
 


 reflex densite_parcours_perenne when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
 	set p_densite_couvert_perenne<-0;
 if moi=1
 {let listvegeee<-list(vegetation) where(each.idpar=p_idpar);
  	let yee type:int<-0;
  	loop yee from:0 to :length(listvegeee)-1
  	{set p_densite_couvert_perenne<-p_densite_couvert_perenne+((listvegeee at yee).densite);}	
if (paturage=true)
 {set p_densite_couvert_perenne<-p_densite_couvert_perenne*(surface-surface_paturee)/surface;}
 let listzone<-list(zone_troupeau) where ((each.id_parcours=p_idpar) and(each.paturage=true));
    let i type:int<-0;
    let densite_perenne_paturage type:float<-0.00;
    loop i from:0 to:length(listzone)-1{
    set densite_perenne_paturage<-densite_perenne_paturage + (listzone at i).densite_perenne_zone;}
    set p_densite_couvert_perenne<-p_densite_couvert_perenne *(surface-surface_paturee)/surface + densite_perenne_paturage*surface_paturee/surface; 
 
 
 }}
 reflex densite_parcours when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
 set p_densite_couvert<-0;	
 if moi=1
 {let listvegee<-list(vegetation) where(each.idpar=p_idpar);
 let listveget<-list(vegetation_annuelle) where(each.idpar=p_idpar);
  	let yee type:int<-0;
  	let yeet type:int<-0;
  	loop yee from:0 to :length(listvegee)-1
  	{set p_densite_couvert<-p_densite_couvert+((listvegee at yee).densite);}
  	loop yeet from:0 to :length(listveget)-1
  	{set p_densite_couvert<-p_densite_couvert+ (listveget at yeet).densite;}	
if (paturage=true)
 {set p_densite_couvert<-p_densite_couvert*(surface-surface_paturee)/surface;}
 let listzone<-list(zone_troupeau) where ((each.id_parcours=p_idpar) and(each.paturage=true));
    let i type:int<-0;
    let densite_paturage type:float<-0.00;
    loop i from:0 to:length(listzone)-1{
    set densite_paturage<-densite_paturage + (listzone at i).densite_zone;}
    set p_densite_couvert<-p_densite_couvert *(surface-surface_paturee)/surface + densite_paturage*surface_paturee/surface;



 }}
 reflex perenne when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0
  {set p_richesse_perenne<-0;
  	if moi=1
  	{if recouvrement!=0
  	{set p_richesse_perenne<-recouvrement_perenne/recouvrement;}
  	
  }	
  }
  reflex annuelle when: pas_de_temps mod nbrejours*92 =0 and nbrejours>0{
  	set p_richesse_annuelle<-0;
  if moi=1
  {set p_richesse_annuelle<-1-p_richesse_perenne;	
  }
 }
 reflex erosion when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
 	if recouvrement<=0.3 and vitesse>=6
 	{ do write message:'erosion';
 		let cal type :float<-0;
 		set cal<-ln(2/rugosite)/ln(10/rugosite);
 		set vitadeux<-vitesse*cal;
 		set erodabilite<-10^(4.03691- 0.384 *struc);
 	set qterosion<-erodabilite*((vitadeux^3)/100)*((etp-pluvio)/etp)*nbrejours;
 	set epaisseur_erodee<-qterosion/(1850*10);
 	set epaisseur_erodeetot<-epaisseur_erodeetot+epaisseur_erodee;
 	}
 }

 }
 /*fin parcours */


species berger  skills:[moving]{

var id_troup type:int;	
var location_berger type:point;
var rayon_de_deplacement type:int<-20;
var mon_parcours type:parcours; 
 var ma_zone_paturage type:zone_paturage;
var ma_zone_troupeau type:zone_troupeau;
var id_zone_troup type:int;
var perception_berger type:int<-1000;
var shape_perception_berger type:geometry value: circle(perception_berger ) at_location location_berger;
 var shape_deplacement_berger type:geometry;
 var surf type:float;
var decide_zone_troupeau type :bool<-false;/*j'utilise cette variable pour passer au déplacement après avoir décidé la destination */
var decide_quitter_zone_troupeau type:bool<-false;/*j'utilise cette variable pour dire que le berger a décidé de quitter la zone_troupeau */
 var duree_sans_abreuvement type:int;/*j'utilise cette variable pour dire la duree pendant laquelle le troupeau peut rester sans abreuvement */
var duree_ecoulee type:int; /*c la duree écoulée si elle est égale à la durée_sans_abreuvement, le berger quitte le site */
var strategie_abreuvement type:string; /*je veux dire si le berger va utiliser des citernes ou des puits pour le momentj'utilise les chaînes citerne et puit */
var strategie_complementation type:string; /* je veux dire si le berger fait de la complémentation ou non */
list list_zone_troupeau_perception<-list(zone_troupeau);
var temps_de_retour type:float; /*j'utilise cette variable pour calculer le temps nécessaire ppour retourner de la zone_troupeau vers le puit d'abreuvement */
var mon_puit type:puit;
var en_dep_zone_troup type:bool<-false;
var en_dep_ab type:bool<-false;
 var en_pat type:bool<-false;
var en_abr type:bool<-false;
var en_dep_rep type:bool<-false;
var en_rep type:bool<-false;
var mode type:string<-'semi_nomade'; /*j'utilise cette variable pour dire si le berger rentre vers la fin de journée ou non donc nomade ou semi_nomade*/
var residence type:point;
var duree_pour_retour_residence type:float;
 var dur_sans_repos type:float<-46.00 ;/* c a dire une journée */
var speed_berger type:float<-100.00;
var pas_deplacement type:float <-100.00;
var angle_deplacement type:float<-0.00;



aspect base{
draw shape:square at :location_berger size:50  color:rgb('green');	
}
aspect en_dep{
draw shape:square at :location_berger size:100  color:rgb('red');	
}
action initialisation{
  write('berger dans initialisation berger');
 set residence<-any_location_in(shape_perception_berger);
 	write('la résidence est' + residence);
 	
	
	}


 action calculer_ma_perception{
 write('berger dans calcul perception');
 let listzone<-list(parcours) where ( each.shape intersects shape_perception_berger =true);
/*let listzone<-(location_berger) neighbours_at(perception_berger) of_species(parcours);*/
/*let listzone<-list(parcours) overlapping( circle(perception_berger));*/
	let i type:int<-0;
	
	
	loop i from:0 to :length(listzone)-1
	{if (listzone at i).zone_par_cree=false{ do creation_zone_parcours with:[le_parcours::(listzone at i)];
									   ask(listzone at i){set zone_par_cree<-true;
									 }
	}								   
	}								   
	/*let listzone_parcours<-list (zone_parcours) where ((each.mon_parcours overlaps  (circle(perception_berger))=true) and (each.id_parcours=(listzone at i).p_idpar));*/
	/* let listzone_parcours<-list(zone_parcours) where (each.shape intersects (circle(perception_berger)));*/	
	let listzone_parcours <-list(zone_parcours)where (each.mon_parcours in(listzone));
	let is type:int<-0;
	loop is from:0 to :length(listzone_parcours)-1
	{write('xcxcxcxcxcccxcxcxcxcxx');
		if (listzone_parcours at is).zone_pat_cree=false
		{ask (listzone_parcours at is){do creation_zone_paturage;}}
	
	}
	
	 let listzone_paturage_perception <-(self.location_berger) neighbours_at(perception_berger)of_species(zone_paturage) where(each.mon_parcours in(listzone)) ; 
	/* let listzone_paturage_perception <-list (zone_paturage) where  (each.id_parcours=(listzone at i).p_idpar) overlapping  circle(perception_berger); */
		/*let listzone_paturage_perception <-(self.location_berger) neighbours_at(perception_berger)of_species(zone_paturage);*/
		 let j type:int<-0;	
		loop j from:0 to:length(listzone_paturage_perception)-1	
			{write ('bobobobobobob');
				if (listzone_paturage_perception at j).zone_troup_cree=false{ask (listzone_paturage_perception at j){set paturage<-true;
																	write ('je vais créer zone_troupeau');
																	do creation_zone_troupeau;
																	}}
		}
		 set list_zone_troupeau_perception <-list(zone_troupeau) where ((each.concerne_parcours=true) and (each.mon_parcours intersects  shape_perception_berger=true) and (each intersects  shape_perception_berger=true));
		write("la longueur de la listeperception " + length(list_zone_troupeau_perception));
			
	 
	
	}


reflex ma_duree when: pas_de_temps mod (92*nbrejours)=1 and pas_de_temps> 0 {/*ce reflex doit se faire au début de chaque mois */
	if scenario="sec"
	{set duree_sans_abreuvement<-192;}/* j'ai considéré le pas de temps est 1/4 pour deux jours */
	else if scenario="moyen"
	{set duree_sans_abreuvement<-672;}/*j'ai considéré une semaine */
	else {set duree_sans_abreuvement<-5760;}/* c' a d deux mois */
	}
action decider_zone_troupeau{
write ('berger dans decide_zone_troupeau');	
write ("la longueur de la perception" + length(list_zone_troupeau_perception));
set ma_zone_troupeau<-one_of(list_zone_troupeau_perception);	
set id_zone_troup<-ma_zone_troupeau.id_zone_troupeau;
set decide_zone_troupeau<-true;
set en_dep_zone_troup<-true;
ask ma_zone_troupeau{
	do reponse_decide_zone_troupeau;}
set angle_deplacement<-location_berger towards  ma_zone_troupeau.centre_zone_troupeau;	
	}

reflex choix_zone_troupeau when:pas_de_temps mod 92=1 and pas_de_temps>0{
 write ('berger dans choix_zone_troupeau');
set en_abr<-false;
set en_dep_zone_troup <-false;
set en_dep_ab <-false;
set en_pat <-false;
set en_abr <-false;
set en_rep <-false;
set en_dep_rep<-false;
set decide_zone_troupeau<-false;
 set duree_pour_retour_residence<--4; /*je fais ceci pour que l'abreuvement se fait avant le retour */
write ("****************121212");
do calculer_ma_perception;
do initialisation;

do decider_zone_troupeau;

/*if decide=true {do en_deplacement_vers_zone_troupeau;}*/
}
  reflex  en_deplacement_vers_zone_troupeau when:decide_zone_troupeau=true and en_pat=false  {
	write('berger se déplace vers zone troupeau');
	set duree_ecoulee<-0;
 write ('la  loc du berger'+ location_berger);
 if location_berger distance_to ma_zone_troupeau.centre_zone_troupeau<=pas_deplacement
 
 {set location_berger<-ma_zone_troupeau.centre_zone_troupeau;}
 else {set angle_deplacement<-location_berger towards ma_zone_troupeau.centre_zone_troupeau;
 write ('angle_dep' + angle_deplacement);
 
 set location_berger<-{location_berger.x + cos(angle_deplacement)*pas_deplacement,location_berger.y+ sin(angle_deplacement)* pas_deplacement}; 
}
 /*do goto target:ma_zone_troupeau.centre_zone_troupeau on:shape_deplacement_berger speed:speed_berger;*/
	write ('la nov loc du berger'+ location_berger);
	/*set location_berger<-self.destination;*/
	if self.location_berger= ma_zone_troupeau.centre_zone_troupeau 
	{set en_pat<-true;
	set en_dep_zone_troup<-false;}
}
reflex  en_paturage when:en_pat=true and en_dep_ab=false {
 set en_pat<-true;
set mon_parcours.paturage<-true;
	set ma_zone_paturage.paturage<-true;
	set ma_zone_troupeau.paturage<-true;
do calcul_temps_de_retour_abreuvement;
set duree_ecoulee<-duree_ecoulee+temps_de_retour;
if duree_ecoulee=duree_sans_abreuvement {set en_dep_ab<-true;}
	}

action calcul_temps_de_retour_abreuvement{
	
 if strategie_abreuvement='puit'	
{let list_puit type:list <-(self neighbours_at(perception_berger))of_species(puit);
	set mon_puit<- list_puit closest_to(self);
	set temps_de_retour<-speed_berger*(self distance_to mon_puit);}
	else{set temps_de_retour<-0;}
	}
/* je dois voir par la suite reflex calcul_temps_de_retour_residence when:en_dep_rep=false{
set duree_pour_retour_residence<- duree_pour_retour_residence +1;
let d type :float<- duree_pour_retour_residence + speed_berger*(self distance_to residence );	
	if d>=dur_sans_repos{set en_dep_rep<-true;}
 	}*/
reflex en_deplacement_vers_abreuvement when: strategie_abreuvement='puit'and en_dep_ab=true and en_abr=false {
	if location_berger=mon_puit.location_puit {
		set duree_ecoulee<-0;
		set en_abr<-true;
		}
	else {do goto target:mon_puit.location_puit  speed:self.speed_berger;}}
reflex en_deplacement_vers_residence when:  en_dep_rep=true and en_rep=false  {
	if location_berger=residence {
		
		set en_rep<-true;
		}
	else {do goto target:residence  speed:self.speed_berger;}}

reflex en_abreuvement when:strategie_abreuvement='puit' and en_abr=true {
	 
	}
reflex calcul_duree_pour_repos {}

action creation_zone_parcours {
arg le_parcours type:parcours;

 if le_parcours.zone_par_cree=false
{create zone_parcours number:1{
set id_parcours<- le_parcours.p_idpar;	
set mon_parcours<-le_parcours;
write ("la location du parcours" + le_parcours.location_parcours);
set location_zone_parcours<-{le_parcours.location_parcours.x +(sqrt(le_parcours.surface)),le_parcours.location_parcours.y+(sqrt(le_parcours.surface))};
/*set location_zone_parcours<-{myself.mon_parcours.location.x+sqrt(myself.mon_parcours.surface)/2, myself.mon_parcours.location.y+sqrt(myself.mon_parcours.surface)/2};*/
write("la location de zone_parcours" + location_zone_parcours);
set dimension_zone_parcours<-2*sqrt(le_parcours.surface);
set shape<-square(dimension_zone_parcours)at_location{location_zone_parcours.x-dimension_zone_parcours/2,location_zone_parcours.y-dimension_zone_parcours/2};
write("la dimension de la zone parcours" + dimension_zone_parcours);				} 
	
	}}
	
	
action decider_zone_paturage{
write("je décide ma_zone_paturage");
let zones type:list<-(zone_paturage as list)where(each.id_parcours=self.mon_parcours.p_idpar);	
 set ma_zone_paturage<-one_of(zones);
 ask ma_zone_paturage{do reponse_decide_zone_paturage;}
}



}/*fin berger, je vais l'utiliser pour diriger  le troupeau, son id est le même que le troupeau*/



 species zone_parcours{
var id_zone_parcours type:int;	
var id_parcours type:int;
var dimension_zone_parcours type:float;
var location_zone_parcours type:point; 
var mon_parcours type:parcours;
var decide_parcours type:bool<-false;/*je veux dire le parcours a été décidé par un berger */
var decide_parcours_prem type:bool<-false; /*je veux dire si le parcours est déjà visité avant */
var zone_pat_cree type:bool<-false;
aspect basic{
 	draw shape:square at:location_zone_parcours  color:rgb('pink') size:dimension_zone_parcours;}
aspect verif{
	draw shape:square at:location_zone_parcours size:1000 color:rgb('black');}
 

 action creation_zone_paturage{
 	set zone_pat_cree<-true;
 	/*set shape<-square(dimension_zone_parcours);*/
 	write("ttototilocatio "+ location_zone_parcours);
 	write("dim "+ dimension_zone_parcours);
 	let nb type:int<-1;
 let loc type:point<-self.location_zone_parcours;
 set la_dimension_zone_paturage<-min([self.dimension_zone_parcours,la_dimension_zone_paturage]);
 if round(self.dimension_zone_parcours/la_dimension_zone_paturage)=self.dimension_zone_parcours/la_dimension_zone_paturage
 {set nb<-self.dimension_zone_parcours/la_dimension_zone_paturage;}
 else{set nb<-round (self.dimension_zone_parcours/la_dimension_zone_paturage)+1;}


 write("je suis apres nb");

write ("je suis apres laffectation de dimension");
/*set loc<-{loc.x,loc.y- dimension_zone_paturage};*/	
write ("je suis apres laffectation de location");	
	let s type:int<-1;
	let j type:int<-1;
	let idd type:int<-1;
	loop i from:1 to:nb{
		loop j from: 1 to :nb{
			
			write("je suis dans la boucle avant create");
			create zone_paturage number:1{
			 	write ("je suis dans create");
			 	set id_parcours<-myself.id_parcours;
			 	set location_zone_paturage<-loc;
				 set dimension_zone_paturage<-la_dimension_zone_paturage;
				 set mon_parcours<-myself.mon_parcours;
				 set mon_parcours.shape<-myself.mon_parcours.shape;
				 set id_zone_paturage<-idd;
				 set shape<-square(dimension_zone_paturage) at_location{location_zone_paturage.x-dimension_zone_paturage/2,location_zone_paturage.y - dimension_zone_paturage/2}; 
				 }
				  set loc <-{loc.x- la_dimension_zone_paturage, loc.y};  
			 
			write("creation termineé");
			set idd<-idd+ 1;
			}
	       set loc<-{loc.x+nb*la_dimension_zone_paturage,loc.y-la_dimension_zone_paturage };
	
	}
do verif;
	
	}
 action verif{let listzone type:list<-list(zone_paturage)where(each.id_parcours=self.id_parcours);
	if (self.mon_parcours=nil){write("le parcours est null");}
	write ("je suis dans reflex verif");
	let ps type:int<-0;
	loop ps from:0 to: length(listzone)-1
	{if ((self.mon_parcours).shape intersects (listzone at ps).shape)=false
		{write("pas intersection");
			 ask (listzone at ps)
			{set concerne_parcours<-false;
				do die;}}
		else{ write("intersection");
			ask (listzone at ps){set concerne_parcours<-true;}
		              
		              }
		
		} }
}/*fin zone_parcours cette zone represente le carré du parcours qui est décomposé en zone_paturage la zone paturage est la zone de déplacement du troupeau */

species zone_paturage{
var id_zone_paturage type:int;
var id_parcours type:int;
var dimension_zone_paturage type:int;	
var location_zone_paturage type:point;
var concerne_parcours type:bool<-false;
var mon_parcours type:parcours;
var decide_zone_paturage type:bool<-false;/*veut dire que la zone_paturage a été décidée par un berger apres avoir sorti du parcours elle se remet à false */
var decide_zone_paturage_prem type:bool<-false;/*veut dire que la zone paturage a été visité avant */
const sh type:geometry<-square(dimension_zone_paturage);
var paturage type:bool<-false;/*je veux dire si cette zone a été paturée dans au moins une zone_troupeau */
var biomasse_perenne_un type:float;
var biomasse_perenne_deux type:float;
var biomasse_perenne_trois type:float;
var biomasse_annuelle type:float;
var recouvrement_perenne_un type:float;
var recouvrement_perenne_deux type:float;
var recouvrement_perenne_trois type:float;
var recouvrement_annuelle type:float;
var zone_troup_cree type:bool<-false;

aspect basic{
draw shape:square at: location_zone_paturage	size:dimension_zone_paturage color:rgb('blue');
}
 aspect concerner_parcours{                                                                                                                                                                               
	let bx type:float<-location_zone_paturage.x-dimension_zone_paturage/2;
	let by type:float<-location_zone_paturage.y-dimension_zone_paturage/2;
	if concerne_parcours=true
	{draw shape:square at :{bx,by} size:dimension_zone_paturage  color:rgb('yellow');}
	else{draw shape:square at :{bx,by} size:dimension_zone_paturage  color:rgb('blue');}}
init{
	let bx type:float<-location_zone_paturage.x-dimension_zone_paturage/2;
	let by type:float<-location_zone_paturage.y-dimension_zone_paturage/2;
	set self.shape<-square(dimension_zone_paturage) at_location{bx, by} ;
}
action reponse_decide_zone_paturage{
	
set decide_zone_paturage<-true;	
if decide_zone_paturage_prem=false
{set decide_zone_paturage_prem<-true;	
do creation_zone_troupeau;}	
	} 

 action creation_zone_troupeau{         	
 	let nbb type:int<-1;
 let locc type:point<-self.location_zone_paturage;
 set la_dimension_zone_troupeau<-min([self.dimension_zone_paturage,la_dimension_zone_troupeau]);
 if round(self.dimension_zone_paturage/la_dimension_zone_troupeau)=self.dimension_zone_paturage/la_dimension_zone_troupeau
 {set nbb<-self.dimension_zone_paturage/la_dimension_zone_troupeau;}
 else{set nbb<-round (self.dimension_zone_paturage/la_dimension_zone_troupeau)+1;}



	
	let ss type:int<-1;
	let jj type:int<-1;
	let iddd type :int<-1;
	loop ii from:1 to:nbb{
		loop jj from: 1 to :nbb{
			write("je suis dans la boucle avant create");
			create zone_troupeau number:1{
			 	write ("je suis dans create");
			 	set id_parcours<-myself.id_parcours;
			 	set location_zone_troupeau<-locc;
				 set dimension_zone_troupeau<-la_dimension_zone_troupeau;
				 set id_zone_paturage<-myself.id_zone_paturage;
				 set id_zone_troupeau<-iddd;
				set mon_parcours<-myself.mon_parcours;
				set shape<-square(dimension_zone_troupeau) at_location{location_zone_troupeau.x-dimension_zone_troupeau/2,location_zone_troupeau.y-dimension_zone_troupeau/2};
				 }
				  set locc <-{locc.x- la_dimension_zone_troupeau, locc.y};  
			 set iddd<-iddd+ 1;
			write("creation zone_troupeau termineé");
			}
	       set locc<-{locc.x+nbb*la_dimension_zone_troupeau,locc.y-la_dimension_zone_troupeau };
	
	}
do verif;

	}
action verif{let listzone type:list<-list(zone_troupeau)where(each.id_zone_paturage=self.id_zone_paturage);
	
	
	let ps type:int<-0;
	loop ps from:0 to: length(listzone)-1
	{if ((self.mon_parcours).shape intersects (listzone at ps).shape)=false
		{write("pas intersection");
			 ask (listzone at ps)
			{set concerne_parcours<-false;
				do die;}}
		else{ write("intersection");
			ask (listzone at ps){set concerne_parcours<-true;}
		              
		              }
		
		} }

reflex calcul_biomasse_perenne_un when:decide_zone_paturage_prem=true and pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
let i type :int<-0;
    	let listzone<-list(zone_troupeau) where (each.id_zone_paturage=id_zone_paturage);
  loop i from:0 to:length(listzone)-1
    	{set biomasse_perenne_un<-biomasse_perenne_un+(listzone at i).biomasse_perenne_un;}	}

reflex calcul_biomasse_perenne_deux when:decide_zone_paturage_prem=true and pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
let i type :int<-0;
    	let listzone<-list(zone_troupeau) where (each.id_zone_paturage=id_zone_paturage);
  loop i from:0 to:length(listzone)-1
    	{set biomasse_perenne_deux<-biomasse_perenne_deux+(listzone at i).biomasse_perenne_deux;}	}

reflex calcul_biomasse_perenne_trois when:decide_zone_paturage_prem=true and pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
let i type :int<-0;
    	let listzone<-list(zone_troupeau) where (each.id_zone_paturage=id_zone_paturage);
  loop i from:0 to:length(listzone)-1
    	{set biomasse_perenne_trois<-biomasse_perenne_trois+(listzone at i).biomasse_perenne_trois;}	}

reflex calcul_biomasse_annuelle when:decide_zone_paturage_prem=true  and pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
let i type :int<-0;
    	let listzone<-list(zone_troupeau) where (each.id_zone_paturage=id_zone_paturage);
  loop i from:0 to:length(listzone)-1
    	{set biomasse_annuelle<-biomasse_annuelle+(listzone at i).biomasse_annuelle;}	}

reflex recouvrement_perenne_un when:decide_zone_paturage_prem=true and pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
let i type :int<-0;
let listzone<-list(zone_troupeau) where (each.id_zone_paturage=id_zone_paturage);
  loop i from:0 to:length(listzone)-1
    	{set recouvrement_perenne_un<-recouvrement_perenne_un+(listzone at i).recouvrement_perenne_un;}
    	set recouvrement_perenne_un<-recouvrement_perenne_un/length(listzone);	}

reflex recouvrement_perenne_deux when:decide_zone_paturage_prem=true and pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
let i type :int<-0;
let listzone<-list(zone_troupeau) where (each.id_zone_paturage=id_zone_paturage);
  loop i from:0 to:length(listzone)-1
    	{set recouvrement_perenne_deux<-recouvrement_perenne_deux+(listzone at i).recouvrement_perenne_un;}
    	set recouvrement_perenne_deux<-recouvrement_perenne_deux/length(listzone);	}

reflex recouvrement_perenne_trois when:decide_zone_paturage_prem=true and pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
let i type :int<-0;
let listzone<-list(zone_troupeau) where (each.id_zone_paturage=id_zone_paturage);
  loop i from:0 to:length(listzone)-1
    	{set recouvrement_perenne_trois<-recouvrement_perenne_trois+(listzone at i).recouvrement_perenne_un;}
    	set recouvrement_perenne_trois<-recouvrement_perenne_trois/length(listzone);	}

reflex recouvrement_annuelle when:decide_zone_paturage_prem=true and pas_de_temps mod (nbrejours*92)=0 and nbrejours>0{
let i type :int<-0;
let listzone<-list(zone_troupeau) where (each.id_zone_paturage=id_zone_paturage);
  loop i from:0 to:length(listzone)-1
    	{set recouvrement_annuelle<-recouvrement_annuelle+(listzone at i).recouvrement_perenne_un;}
    	set recouvrement_annuelle<-recouvrement_annuelle/length(listzone);	}

}/*fin zone_paturage, cette zone est créée autour du point_pasteur qui est choisi par le pasteur elle represente le lieu de déplacement du troupeau*/
species zone_troupeau{
var id_zone_troupeau type:int;
var id_zone_paturage type:int;
var location_zone_troupeau type:point;
var dimension_zone_troupeau type:int;
var id_parcours type:int;
var concerne_parcours type:bool<-false;
var mon_parcours type:parcours;
var decide_zone_troupeau type:bool<-false;
var decide_zone_troupeau_prem type:bool<-false;
const sh type:geometry<-square(dimension_zone_troupeau);
var centre_zone_troupeau type:point;
var paturage type:bool<-false;/*veut dire si cette zone a été paturée au moins une fois */
var biomasse_zone type:float;
var biomasse_perenne_zone type:float;
var etat_couvert_zone type:float;
var etat_couvert_perenne_zone type:float;
var densite_zone type:float;
var densite_perenne_zone type:float;
var biomasse_perenne_un type:float;
var biomasse_perenne_deux type:float;
var biomasse_perenne_trois type:float;
var biomasse_annuelle type:float;
var recouvrement_perenne_un type:float;
var recouvrement_perenne_deux type:float;
var recouvrement_perenne_trois type:float;
var recouvrement_annuelle type:float;
var choix_berger type:bool<-false;
aspect basic{
draw shape:square at: location_zone_troupeau	size:dimension_zone_troupeau color:rgb('pink');
}
aspect concerner_parcours{
	
	if concerne_parcours=true
	{if choix_berger=true
		{draw shape:square at :location_zone_troupeau size:dimension_zone_troupeau  color:rgb('green');}
		else {draw shape:square at :location_zone_troupeau size:dimension_zone_troupeau  color:rgb('pink');}}
	else{draw shape:square at :location_zone_troupeau size:dimension_zone_troupeau  color:rgb('blue');}}


action creation_zone_manger
{let bx type:float<-location_zone_troupeau.x-dimension_zone_troupeau/2;
	let by type:float<-location_zone_troupeau.y-dimension_zone_troupeau/2;
	set centre_zone_troupeau<-{bx,by};
	set self.shape<-square(dimension_zone_troupeau) at_location{bx, by} ;

let nbbb type:int<-1;
 let loccc type:point<-self.location_zone_troupeau;
 set la_dimension_zone_manger<-min([self.dimension_zone_troupeau,la_dimension_zone_manger]);
 if round(self.dimension_zone_troupeau/la_dimension_zone_manger)=self.dimension_zone_troupeau/la_dimension_zone_manger
 {set nbbb<-self.dimension_zone_troupeau/la_dimension_zone_manger;}
 else{set nbbb<-round (self.dimension_zone_troupeau/la_dimension_zone_manger)+1;}



	
	let ss type:int<-1;
	let jj type:int<-1;
	let iddd type :int<-1;
	let listvegetation<-list(vegetation) where (each.idpar=mon_parcours.p_idpar);
	let vg type :int<-0;
	loop ii from:1 to:nbbb{
		loop jj from: 1 to :nbbb{
			write("je suis dans la boucle avant create");
			create zone_manger number:1{
			 	write ("je suis dans create manger");
			 	set id_parcours<-myself.id_parcours;
			 	set id_zone_troupeau<-myself.id_zone_troupeau;
			 	set id_zone_paturage<-myself.id_zone_paturage;
			 	set location_zone_manger<-loccc;
				 set dimension_zone_manger<-la_dimension_zone_manger;
				 set id_zone_manger<-iddd;
				set mon_parcours<-myself.mon_parcours; 
				/*set mon_parcours.shape<-myself.mon_parcours.shape;*/
				set shape<-square(dimension_zone_manger) at_location{location_zone_manger.x-dimension_zone_manger/2,location_zone_manger.y-dimension_zone_manger/2};
				 }
				  set loccc <-{loccc.x- la_dimension_zone_manger, loccc.y};  
			 set iddd<-iddd+ 1;
			write("creation zone_manger termineé");
			}
	       set loccc<-{loccc.x+nbbb*la_dimension_zone_manger,loccc.y-la_dimension_zone_manger };
	  
	}
  do verif;
let listvegetation<-list(vegetation) where (each.idpar=mon_parcours.p_idpar);
let listvegetation_annuelle<-list(vegetation_annuelle) where (each.idpar=mon_parcours.p_idpar);
let listmanger<-list(zone_manger) where(each.id_parcours=mon_parcours.p_idpar);
let lm type:int<-length(listmanger);
let ji type:int<-0;
let mi type:int<-1;

let nombre_des_zones_manger type:int<-0;
let nombre_des_zones_manger_annuelle type:int<-0;
let listespece<-list(espece_vegetale);
loop ji from:0 to:length(listvegetation)-1
{if round((listvegetation at ji).tauxducouvert*lm)= ((listvegetation at ji).tauxducouvert)*lm
	{set nombre_des_zones_manger<-round((listvegetation at ji).tauxducouvert*lm) ; }
 else	{set nombre_des_zones_manger<-round((listvegetation at ji).tauxducouvert*lm) + 1;}
let bi type:int<-1;
 loop while: bi<=nombre_des_zones_manger{
 	ask (listmanger at bi)
               {
               	set espece_zone_manger<-one_of((listespece) where (each.nom=(listvegetation at ji).espece));
               	set espece_zone_manger.nom<-(listvegetation at ji).espece;
               	set recouvrement_perenne_un<-1; 
				set biomasse_zone_manger<-((listvegetation at ji).biomasse/nombre_des_zones_manger);
				}
				set bi<-bi+1;}
}
loop ji from:0 to:length(listvegetation_annuelle)-1
{if round((listvegetation_annuelle at ji).tauxducouvert*lm)= ((listvegetation_annuelle at ji).tauxducouvert)*lm
	{set nombre_des_zones_manger_annuelle<-round((listvegetation_annuelle at ji).tauxducouvert*lm) ; }
 else	{set nombre_des_zones_manger_annuelle<-round((listvegetation_annuelle at ji).tauxducouvert*lm) + 1;}
let bi type:int<-1;
 loop while: bi<=nombre_des_zones_manger_annuelle{
 	ask (listmanger at bi)
               {
               	set recouvrement_annuelle<-1; 
				set biomasse_annuelle<-((listvegetation_annuelle at ji).biomasse/nombre_des_zones_manger_annuelle);
				}
				set bi<-bi+1;}
}






}


action reponse_decide_zone_troupeau{
set choix_berger <-true;
write('je suis dans reponse roupeaudecide zone_t+++++++++');
if decide_zone_troupeau_prem=false{set decide_zone_troupeau_prem<-true;
	do creation_zone_manger;}	
set decide_zone_troupeau<-true;	
	}
 action verif{let listzone type:list<-list(zone_manger)where(each.id_zone_troupeau=self.id_zone_troupeau);
	
	
	let ps type:int<-0;
	loop ps from:0 to: length(listzone)-1
	{if ((self.mon_parcours).shape intersects (listzone at ps).shape)=false
		{write("pas intersection");
			 ask (listzone at ps)
			{set concerne_parcours<-false;
				do die;}}
		else{ write("intersection");
			ask (listzone at ps){set concerne_parcours<-true;}
		              
		              }
		
		} }

  	
    	
    	
reflex calcul_biomasse_perenne_un when:decide_zone_troupeau_prem=true and pas_de_temps mod 92 =1{
let i type :int<-0;
    	let listzone<-list(zone_manger) where (each.id_zone_troupeau=id_zone_troupeau);
  loop i from:0 to:length(listzone)-1
    	{set biomasse_perenne_un<-biomasse_perenne_un+(listzone at i).biomasse_perenne_un;}	}

reflex calcul_biomasse_perenne_deux when:decide_zone_troupeau_prem=true and pas_de_temps mod 92 =1{
let i type :int<-0;
let listzone<-list(zone_manger) where (each.id_zone_troupeau=id_zone_troupeau);
  loop i from:0 to:length(listzone)-1
    	{set biomasse_perenne_deux<-biomasse_perenne_deux+(listzone at i).biomasse_perenne_deux;}		}

reflex calcul_biomasse_perenne_trois when:decide_zone_troupeau_prem=true and pas_de_temps mod 92 =1{
	let i type :int<-0;
    	let listzone<-list(zone_manger) where (each.id_zone_troupeau=id_zone_troupeau);
  loop i from:0 to:length(listzone)-1
    	{set biomasse_perenne_trois<-biomasse_perenne_trois+(listzone at i).biomasse_perenne_trois;}	}

reflex calcul_biomasse_annuelle when:decide_zone_troupeau_prem=true and pas_de_temps mod 92 =1{
let i type :int<-0;
let listzone<-list(zone_manger) where (each.id_zone_troupeau=id_zone_troupeau);
  loop i from:0 to:length(listzone)-1
    	{set biomasse_annuelle<-biomasse_annuelle+(listzone at i).biomasse_annuelle;}	}

reflex recouvrement_perenne_un when:decide_zone_troupeau_prem=true and pas_de_temps mod 92 =1{
let i type :int<-0;
let listzone<-list(zone_manger) where (each.id_zone_troupeau=id_zone_troupeau);
  loop i from:0 to:length(listzone)-1
    	{set recouvrement_perenne_un<-recouvrement_perenne_un+(listzone at i).recouvrement_perenne_un;}
    	set recouvrement_perenne_un<-recouvrement_perenne_un/length(listzone);	}

reflex recouvrement_perenne_deux when:decide_zone_troupeau_prem=true{
let i type :int<-0;
let listzone<-list(zone_manger) where (each.id_zone_troupeau=id_zone_troupeau);
  loop i from:0 to:length(listzone)-1
    	{set recouvrement_perenne_deux<-recouvrement_perenne_deux+(listzone at i).recouvrement_perenne_deux;}
    	set recouvrement_perenne_deux<-recouvrement_perenne_deux/length(listzone);	
	}
reflex recouvrement_perenne_trois when:decide_zone_troupeau_prem=true and pas_de_temps mod 92 =1{
let i type :int<-0;
let listzone<-list(zone_manger) where (each.id_zone_troupeau=id_zone_troupeau);
  loop i from:0 to:length(listzone)-1
    	{set recouvrement_perenne_trois<-recouvrement_perenne_trois+(listzone at i).recouvrement_perenne_trois;}
    	set recouvrement_perenne_trois<-recouvrement_perenne_trois/length(listzone);	
	}
reflex recouvrement_annuelle when:decide_zone_troupeau_prem=true and pas_de_temps mod 92 =1{
	let i type :int<-0;
let listzone<-list(zone_manger) where (each.id_zone_troupeau=id_zone_troupeau);
  loop i from:0 to:length(listzone)-1
    	{set recouvrement_annuelle<-recouvrement_annuelle+(listzone at i).recouvrement_annuelle;}
    	set recouvrement_annuelle<-recouvrement_annuelle/length(listzone);}
reflex recouvrement_total when:decide_zone_troupeau_prem=true and pas_de_temps mod 92 =1{
	set etat_couvert_zone<-recouvrement_annuelle+ recouvrement_perenne_un + recouvrement_perenne_deux + recouvrement_perenne_trois;}


}/* fin zone_troupeau représente la vue du troupeau divise la zone_paturage en 4 */

species zone_manger{
var id_zone_troupeau type:int;
var id_zone_manger type:int;	
var id_zone_paturage type:int;
var location_zone_manger type:point;
var dimension_zone_manger type:int<-2;
var id_parcours type:int;
var concerne_parcours type:bool<-false;
var biomasse_zone_manger type:float;
var biomasse_annuelle type:float;
var biomasse_annuelle_max type:float;
var recouvrement_annuelle type:float;
var biomasse_perenne_un type:float;
var biomasse_perenne_deux type:float;
var biomasse_perenne_trois type:float;
var recouvrement_zone_manger type:float;
var recouvrement_perenne_un type:float;
var recouvrement_perenne_deux type:float;
var recouvrement_perenne_trois type:float;
var x_un type:float;
var x_deux type:float;
var x_trois type:float;
var biomasse_max_un type:float;
var biomasse_max_deux type:float;
var biomasse_max_trois type:float;
var espece_zone_manger type:espece_vegetale;             
var deuxieme_espece type:espece_vegetale;                  /*j'utilise pour la compétition entre les espèces */
var troisieme_espece type:espece_vegetale;
var manger type:bool<-false;
const sh type:geometry<-square(dimension_zone_manger);
var mon_parcours type:parcours;
aspect base{
draw shape:square at:location_zone_manger size:	dimension_zone_manger color:rgb('red');
}
aspect au_paturage{
if concerne_parcours=true
{
let rrrs type :float<-0.00;
if biomasse_annuelle=rrrs
{draw shape:square at :location_zone_manger size:dimension_zone_manger  color:rgb('yellow');}
else if biomasse_perenne_un=rrrs
{draw shape:square at :location_zone_manger size:dimension_zone_manger  color:rgb ('green');}
else if biomasse_perenne_deux=rrrs
{draw shape:square at :location_zone_manger size:dimension_zone_manger  color:rgb ('blue');}
else if biomasse_perenne_trois=rrrs
{draw shape:square at :location_zone_manger size:dimension_zone_manger  color:rgb('red');}
else{draw shape:square at :location_zone_manger size:dimension_zone_manger  color:rgb('grey');}
	
	}	
}


aspect concerne_parcours{
if concerne_parcours=true
	{draw shape:square at :location_zone_manger size:dimension_zone_manger  color:rgb('yellow');}
	else{draw shape:square at :location_zone_manger size:dimension_zone_manger  color:rgb('blue');}	
	}

init{
	if biomasse_annuelle!=0{set biomasse_annuelle_max<-800*dimension_zone_manger*dimension_zone_manger*recouvrement_annuelle/10000;}
	let bx type:float<-location_zone_manger.x-dimension_zone_manger/2;
	let by type:float<-location_zone_manger.y-dimension_zone_manger/2;
	set self.shape<-square(dimension_zone_manger) at_location{bx, by} ;
	if espece_zone_manger!=nil
	 {set biomasse_max_un<-(espece_zone_manger.biomassemax)*dimension_zone_manger*dimension_zone_manger*recouvrement_perenne_un/10000;}
	if deuxieme_espece!=nil
	{set biomasse_max_deux<-(deuxieme_espece.biomassemax)*dimension_zone_manger*dimension_zone_manger*recouvrement_perenne_deux/10000;}
	if troisieme_espece!=nil
	{set biomasse_max_trois<-(troisieme_espece.biomassemax)*dimension_zone_manger*dimension_zone_manger*recouvrement_perenne_trois/10000;}
	}

reflex calcul_biomasse_perenne_premiere_espece when:espece_zone_manger!=nil and pas_de_temps mod 92 =1{
	let xs type:int<-0;
 	set xs<-espece_zone_manger.debutcycle+espece_zone_manger.dureecycle;
 
 	
 	if (lemois>=espece_zone_manger.debutcycle+espece_zone_manger.dureecycle)
 	{
 		 set biomasse_perenne_un<-x_un;
 		
 	}	
 	if (lemois=espece_zone_manger.debutcycle)
 		{
 			 set biomasse_max_un<-biomasse_max_un+ biomasse_max_un *espece_zone_manger.tauxgermination;
 			
 			
 			 set biomasse_perenne_un<-biomasse_perenne_un+(biomasse_perenne_un*espece_zone_manger.tauxgermination*espece_zone_manger.productivite)* ((biomasse_max_un-biomasse_perenne_un)/biomasse_max_un )* (etr/etp) ;
 		
 		}
 		
 		else if (lemois> espece_zone_manger.debutcycle and lemois<espece_zone_manger.debutcycle+espece_zone_manger.dureecycle-1)
 		{if(lemois<=7) {set biomasse_perenne_un<-biomasse_perenne_un +(biomasse_perenne_un*espece_zone_manger.productivite)* ((biomasse_max_un-biomasse_perenne_un)/biomasse_max_un) * (etr/etp) ;
 			set x_un<-biomasse_perenne_un*0.6;}
 		
 		}}


reflex calcul_biomasse_perenne_deuxieme_espece when:deuxieme_espece!=nil and pas_de_temps mod 92 =1{
	let xs type:int<-0;
 	set xs<-deuxieme_espece.debutcycle+deuxieme_espece.dureecycle;
 
 	
 	if (lemois>=deuxieme_espece.debutcycle+deuxieme_espece.dureecycle)
 	{
 		set biomasse_perenne_deux<-x_deux;
 		
 	}	
 	if (lemois=deuxieme_espece.debutcycle)
 		{
 			 set biomasse_max_deux<-biomasse_max_deux+ biomasse_max_deux *deuxieme_espece.tauxgermination;
 			
 			
 			 set biomasse_perenne_deux<-biomasse_perenne_deux+(biomasse_perenne_deux*deuxieme_espece.tauxgermination*deuxieme_espece.productivite)* ((biomasse_max_deux-biomasse_perenne_deux)/biomasse_max_deux )* (etr/etp) ;
 		
 		}
 		
 		else if (lemois> deuxieme_espece.debutcycle and lemois<deuxieme_espece.debutcycle+deuxieme_espece.dureecycle-1)
 		{if(lemois<=7) {set biomasse_perenne_deux<-biomasse_perenne_deux +(biomasse_perenne_deux*deuxieme_espece.productivite)* ((biomasse_max_deux-biomasse_perenne_deux)/biomasse_max_deux) * (etr/etp) ;
 			set x_deux<-biomasse_perenne_deux*0.6;}
 		
 		}
	}

reflex calcul_biomasse_perenne_troisieme_espece when:troisieme_espece!=nil and pas_de_temps mod 92 =1{
	let xs type:int<-0;
 	set xs<-troisieme_espece.debutcycle+troisieme_espece.dureecycle;
 
 	
 	if (lemois>=troisieme_espece.debutcycle+troisieme_espece.dureecycle)
 	{
 		set biomasse_perenne_trois<-x_trois;
 		
 	}	
 	if (lemois=troisieme_espece.debutcycle)
 		{
 			 set biomasse_max_trois<-biomasse_max_trois+ biomasse_max_trois *troisieme_espece.tauxgermination;
 			
 			
 			 set biomasse_perenne_trois<-biomasse_perenne_trois+(biomasse_perenne_trois*troisieme_espece.tauxgermination*troisieme_espece.productivite)* ((biomasse_max_trois-biomasse_perenne_trois)/biomasse_max_trois )* (etr/etp) ;
 		
 		}
 		
 		else if (lemois> troisieme_espece.debutcycle and lemois<troisieme_espece.debutcycle+troisieme_espece.dureecycle-1)
 		{if(lemois<=7) {set biomasse_perenne_trois<-biomasse_perenne_trois +(biomasse_perenne_trois*troisieme_espece.productivite)* ((biomasse_max_trois-biomasse_perenne_trois)/biomasse_max_trois) * (etr/etp) ;
 			set x_trois<-biomasse_perenne_trois*0.6;}
 		
 		}}
reflex calcul_biomasse_perenne when:pas_de_temps mod 92 =1
{set biomasse_zone_manger<-biomasse_perenne_un +biomasse_perenne_deux + biomasse_perenne_trois;
	}
reflex calcul_biomasse_annuelle when: biomasse_annuelle>0 and pas_deux mod 92 =1{
let w type:int<-0;
 	if(lemois>=debut_cycle_annuelle +duree_cycle_annuelle)
 	{set biomasse_annuelle<-0;}
 	 if (lemois=debut_cycle_annuelle)
 		{ set biomasse_annuelle_max<-biomasse_annuelle_max +biomasse_annuelle_max*taux_germination_annuelle;
 			
 			set biomasse_annuelle<-biomasse_annuelle+(biomasse_annuelle*productivite_annuelle)* ((biomasse_annuelle_max-biomasse_annuelle)/biomasse_annuelle_max) * (etr/etp) ;}
 			
 		else if (lemois> debut_cycle_annuelle and lemois<debut_cycle_annuelle +duree_cycle_annuelle)
 		{if(lemois<=7){set biomasse_annuelle<-biomasse_annuelle_max;
			set w<-biomasse_annuelle*0.6;}
		
 		}	
	
	}


reflex calcul_recouvrement_perenne_premiere_espece when:espece_zone_manger!=nil and pas_de_temps mod 92 =1{
	let couvert_competition type:float<-0;
	let fact_deux type:int<-0;
	let fact_trois type:int<-0;
	
	if (deuxieme_espece!=nil) and (deuxieme_espece.predecesseur=espece_zone_manger.nom)
	{set fact_deux<-1;}
	if (troisieme_espece!=nil) and (troisieme_espece.predecesseur=espece_zone_manger.nom)
	{set fact_trois<-1;}
	set couvert_competition<-couvert_competition+ recouvrement_perenne_deux*fact_deux + recouvrement_perenne_trois*fact_trois ;	
	 
	 
	/*if (pas='mois'){*/
	if lemois=espece_zone_manger.debutcycle
	{set recouvrement_perenne_un<- recouvrement_perenne_un +recouvrement_perenne_un * (1- couvert_competition)*(espece_zone_manger.tauxgermination);
	
	if recouvrement_perenne_un>=0.95
	{let voisin_competition type: zone_manger<-one_of(list(zone_manger) where (each in(topology(self) neighbours_of self)));
	if voisin_competition.espece_zone_manger=nil{
		ask voisin_competition{set espece_zone_manger<-self.espece_zone_manger;
			set recouvrement_perenne_un<-0.1;
			set biomasse_max_un<-(espece_zone_manger.biomassemax)*dimension_zone_manger*dimension_zone_manger*recouvrement_perenne_un/10000;}}
	else if voisin_competition.deuxieme_espece=nil{
	ask voisin_competition{set deuxieme_espece<-self.espece_zone_manger;
			set recouvrement_perenne_deux<-0.1;
			set biomasse_max_deux<-(espece_zone_manger.biomassemax)*dimension_zone_manger*dimension_zone_manger*recouvrement_perenne_deux/10000;}	
		}
	else if voisin_competition.troisieme_espece=nil{ask voisin_competition{set troisieme_espece<-self.espece_zone_manger;
			set recouvrement_perenne_trois<-0.1;
			set biomasse_max_trois<-(espece_zone_manger.biomassemax)*dimension_zone_manger*dimension_zone_manger*recouvrement_perenne_trois/10000;}	}
	}}
}
reflex calcul_recouvrement_perenne_deuxieme_espece when :deuxieme_espece!=nil and pas_de_temps mod 92 =1{
	let couvert_competition type:float<-0;
	let fact_deux type:int<-0;
	let fact_trois type:int<-0;
	
	if (espece_zone_manger!=nil) and (espece_zone_manger.predecesseur=deuxieme_espece.nom)
	{set fact_deux<-1;}
	if (troisieme_espece!=nil) and (troisieme_espece.predecesseur=deuxieme_espece.nom)
	{set fact_trois<-1;}
	set couvert_competition<-couvert_competition+ recouvrement_perenne_un*fact_deux + recouvrement_perenne_trois*fact_trois ;	
	 
	 
	/*if (pas='mois'){*/
	if lemois=deuxieme_espece.debutcycle
	{set recouvrement_perenne_deux<- recouvrement_perenne_deux +recouvrement_perenne_deux * (1- couvert_competition)*(deuxieme_espece.tauxgermination);
	}
	
	}
reflex calcul_recouvrement_perenne_troisieme_espece when: troisieme_espece!=nil and pas_de_temps mod 92 =1{
	let couvert_competition type:float<-0;
	let fact_deux type:int<-0;
	let fact_trois type:int<-0;
	
	if (espece_zone_manger!=nil) and (espece_zone_manger.predecesseur=troisieme_espece.nom)
	{set fact_deux<-1;}
	if (deuxieme_espece!=nil) and (deuxieme_espece.predecesseur=troisieme_espece.nom)
	{set fact_trois<-1;}
	set couvert_competition<-couvert_competition+ recouvrement_perenne_un*fact_deux + recouvrement_perenne_deux*fact_trois ;	
	 
	 
	/*if (pas='mois'){*/
	if lemois=troisieme_espece.debutcycle
	{set recouvrement_perenne_trois<- recouvrement_perenne_trois +recouvrement_perenne_trois * (1- couvert_competition)*(troisieme_espece.tauxgermination);
	}
	
	}
reflex calcul_recouvrement_annuelle when: biomasse_annuelle >0 and pas_de_temps mod 92 =1{
let couvert_competition type:float<-0;
	let fact_un type:int<-0;
	let fact_deux type:int<-0;
	let fact_trois type:int<-0;
	
	if (espece_zone_manger!=nil) 
	{set fact_un<-1;}
	if (deuxieme_espece!=nil) 
	{set fact_deux<-1;}
	if (troisieme_espece!=nil) 
	 {set fact_trois<-1;}
	set couvert_competition<-couvert_competition+ recouvrement_perenne_un*fact_un + recouvrement_perenne_deux*fact_deux+recouvrement_perenne_trois*fact_trois ;	
	 
	 
	/*if (pas='mois'){*/
	if lemois=debut_cycle_annuelle
	{set recouvrement_annuelle<- recouvrement_annuelle +recouvrement_annuelle * (1- couvert_competition)*taux_germination_annuelle;
	if recouvrement_perenne_un>=0.95
	{let voisin_competition type: zone_manger<-one_of(list(zone_manger) where (each in(topology(self) neighbours_of self)));
	if voisin_competition.espece_zone_manger=nil and voisin_competition.deuxieme_espece=nil and voisin_competition.troisieme_espece=nil{
		ask voisin_competition{set biomasse_annuelle<-10;
			set recouvrement_annuelle<-0.1;
			set biomasse_annuelle_max<-biomasse_annuelle_max*dimension_zone_manger*dimension_zone_manger*recouvrement_annuelle/10000;}}
	
	
	}	
	
	}}
reflex calcul_recouvrement when: pas_de_temps mod 92 =1{
	set recouvrement_zone_manger<-recouvrement_perenne_un + recouvrement_perenne_deux + recouvrement_perenne_trois + recouvrement_annuelle;}

}/*fin zone manger c'est la zone d'exploitation d'un animal une zone_paturage est formée d'un ensemble de zone_manger */



species troupeau control:fsm frequency:1
{ var id_troup type: int<-1;
	var effect_troup type:int<-100;
	var nbre_male type:int;
var nbre_femelle type:int;
var location_troupeau type:point;
var mon_berger type:berger;
var leader type:animal;
var goal type:point;/*j'utilise cette variable pour que le troupeau la suit */	

var location type:point;
rgb couleur;
aspect base {
			draw shape: circle size:60000 color: rgb ('yellow') at:location_troupeau ;
		}
init{
	
	
	 
	create femelle number:1{
		set id_troup<-myself.id_troup;
	    set mon_berger<-myself.mon_berger;
	     set mon_troup<-myself;
	     set location_animal<-myself.location_troupeau; 
	     set dominance<-6;
	     set chef_troupeau<-true;
	     set appet_1<-'stipa_tenacissima'; 
	     set appet_2<-'artemisia _herba_alba';
	set appet_3<- 'gymnocarpos_decander';
	     set couleur<-rgb("red");
	     
	     }
	
	set leader<-one_of((femelle as list)where(each.chef_troupeau=true));
	
	create femelle number:nbre_femelle-1{
		set id_troup<-myself.id_troup;
	     set mon_berger<-myself.mon_berger;
	     set mon_chef<-myself.leader;
	     set chef_troupeau<-false;
	     set location_animal<-myself.location_troupeau; 
	     set mon_troup<-myself;
	   
	    
	     set dominance<-rnd(5);
	     set appet_1<-'stipa_tenacissima';
	     set appet_2<-'artemisia _herba_alba';
	set appet_3<- 'gymnocarpos_decander';
	     set couleur<-rgb([40*dominance,0,0]); }
	 create male number:nbre_male{
	set id_troup<-myself.id_troup;
	set mon_berger<-myself.mon_berger;
	set mon_chef<-myself.leader;
    set location_animal<-myself.location_troupeau; 
	set mon_troup<-myself;
	set dominance<-rnd(5)+1;
	set appet_1<-'stipa_tenacissima';
	set appet_2<-'artemisia _herba_alba';
	set appet_3<- 'gymnocarpos_decander';
	 set couleur<-rgb([40*dominance,0,0]);
	 }
	}
	
}/*fin */
species animal  skills:[moving]
{var mon_berger type:berger;
var location_animal type:point;
var id_zone_troup type:int;
var mon_chef type:animal;
var id_troup type:int;
var mon_troup type:troupeau;
int cohesion_factor <- 200;
	int alignment_factor <- 100; 
	int maximal_turn <- 90 min: 0 max: 359; 	
var chef_troupeau type:bool;
var distance_cohesion type:int<-50;
var shape_cohesion_berger type:geometry; 
var location_prob type:point<-{0,0};
var perception_animal type:float<-100.00; /* ici g considéré que la zone de perception est la mêmede cohesion, */
list mes_proches<-list(animal); 
 list mes_proches_femelle<-list(femelle);
 list mes_proches_male<-list(male);
 /*list mes_proches update: ((((animal as list) where (each.id_troup=self.id_troup)) overlapping (circle (distance_cohesion)))  - self);je l'utilise pour désigner mes proches dans la zone de cohésion */
list mes_proches_zone_manger<-list(zone_manger);
/*list mes_proches_zone_manger update: (zone_manger as list) where ( (each.id_zone_troupeau=mon_berger.id_zone_troup))at_distance(perception);*/
point le_centre;
var shape_cohesion_centre type:geometry; 
 /*point le_centre update:  (length(mes_proches) > 0) ? (mean (mes_proches collect (each.location_animal)) ) as point : location_animal;je l'utilise pour calculer le centre de la cohésion */
list mes_annuelles<-list(zone_manger);
/*list mes_annuelles update:mes_proches_zone_manger where (each.biomasse_annuelle!=0);*/
list mes_premiers_pref<-list(zone_manger);
/*list mes_premiers_pref update:mes_proches_zone_manger where (((each.espece_zone_manger.nom=appet_1) or(each.deuxieme_espece.nom=appet_1)or (each.troisieme_espece.nom=appet_1)) and (empty(animal inside(each))));*/
list mes_second_pref<-list(zone_manger);

/*list mes_second_pref update: mes_proches_zone_manger where(((each.espece_zone_manger.nom=appet_2) or(each.deuxieme_espece.nom=appet_2))or (each.troisieme_espece.nom=appet_2)and (empty(animal inside(each))));*/
list mes_tertier_pref<-list(zone_manger);
/*list mes_tertier_pref update: mes_proches_zone_manger where (((each.espece_zone_manger.nom=appet_3) or(each.deuxieme_espece.nom=appet_3)or (each.troisieme_espece.nom=appet_3)) and (empty(animal inside(each))));*/
list zone_cohesion<-list(zone_manger);
/*list zone_cohesion  update:(zone_manger as list)where( (each.id_zone_troupeau=mon_berger.ma_zone_troupeau.id_zone_troupeau)and (each in (le_centre neighbours_at(distance_cohesion)))) ;*/
var poids type:float;
var besoin_journ type:float;
var reserve_energ type:float;
var reserve_energ_max type:float;
var quantite_ingestion type:float<-0.06;
var age type:float;
var indice_besoin type:float;
var besoin_dep type:float;
var energie_acquise type:float;
var appet_1 type:string;
var appet_2 type:float;
var appet_3 type:float;
var ma_zone_manger type:zone_manger;
var pas_deplacement type:float<-100.00;
var angle_deplacement type:float<-0.00;
var le_centre type:point;
var deplacement_chef_effectue type:bool<-false;

init{
	set location_animal <- any_location_in (circle(distance_cohesion ) at_location mon_berger.location_berger);
	set self.shape<-square(20) at_location location_animal ;
	if (age<5)
	{set besoin_journ<-poids*0.055;}
	else{set besoin_journ<-0.053*poids;}
	set reserve_energ_max<-3*besoin_journ;
	set reserve_energ<-reserve_energ_max;}

reflex mes_zones{

 set mes_proches_femelle<-((((femelle as list) where (each.id_troup=self.id_troup)) overlapping (circle (distance_cohesion)))  - self);
/*set mes_proches_male<-(male as list) where (((each.id_troup=self.id_troup)  and ((each.location_animal)  at_distance(distance_cohesion))));*/
set mes_proches_male<-((((male as list) where (each.id_troup=self.id_troup)) overlapping (circle (distance_cohesion)))  - self);
 
 /*let listzone_paturage_perception <-(self.location_berger) neighbours_at(perception_berger)of_species(zone_paturage) where(each.mon_parcours in(listzone)) ; */
/*set mes_proches_male<-(self.location_animal)neighbours_at(distance_cohesion) of_species(male) where(each.id_troup=self.id_troup);*/
set mes_proches<-mes_proches_femelle + mes_proches_male;
/*set mes_proches_zone_manger<-(zone_manger as list) where ( (each.id_zone_troupeau=mon_berger.id_zone_troup))at_distance(perception);*/
set mes_proches_zone_manger<-(zone_manger as list) where (each.id_zone_troupeau=mon_berger.id_zone_troup) overlapping(circle(perception_animal));
set le_centre<-	 mean (mes_proches collect (each.location_animal));
	
	write('mes proches_fem'+ length(mes_proches_femelle));
	write('mes proches_mal'+ length(mes_proches_male));
	write('mes proches'+ length(mes_proches));
	write('mes proches zones_manger'+ length(mes_proches_zone_manger));
write('cohesion'+ length(zone_cohesion));
}
 reflex inspection when: pas_de_temps mod 46 =1{
	write ('je suis dans inspection');
	set indice_besoin<-(reserve_energ +energie_acquise-besoin_journ- besoin_dep)/reserve_energ_max;
	set energie_acquise<-0;}

reflex poids when: pas_de_temps mod 46 =1 
{write('je suis dans poids');
	if indice_besoin<=0.75
	{set poids<-poids-0.2;
		}
		else{ set poids<-poids+ 0.2;
			 do mon_besoin;} 
if indice_besoin<1{set reserve_energ<-reserve_energ +energie_acquise-besoin_journ- besoin_dep;}
}

 action mon_besoin{if (age<5)
	{write('je suis dans mon_besoin');
		set besoin_journ<-poids*0.055;
	}
	else{set besoin_journ<-0.053*poids;}}

reflex suivre_berger  when : ((mon_berger.en_dep_zone_troup=true) or (mon_berger.en_dep_ab=true) or (mon_berger.en_dep_rep=true)) {
write ('je suis dans suivre_berger');
write('mon_berger en_dep_zone_troup'+ mon_berger.en_dep_zone_troup);
write('mon_berger en_dep_ab' + mon_berger.en_dep_ab); 
write('mon_berger en_dep_rep' + mon_berger.en_dep_rep);
let loc_prob type:point<-{0,0};
if chef_troupeau=true{
	set shape_cohesion_berger<- circle(distance_cohesion/2 ) at_location mon_berger.location_berger;/*je fais ceci pour que le chef reste dans un cercle plus proche du berger */
	/*set ma_zone_manger<-one_of((mes_proches_zone_manger) where (each in(mon_berger neighbours_at(distance_cohesion))));*/
set location_animal<-any_location_in(shape_cohesion_berger);

/*do se_deplacer_vers dest:loc_prob;*/
write('je me déplace vers zone' + location_animal);
}
else{
set le_centre<-	 mean (mes_proches collect (each.location_animal));
set shape_cohesion_centre<- circle(distance_cohesion ) at_location le_centre;
set location_animal<-any_location_in(shape_cohesion_centre);
/*set ma_zone_manger<-one_of  (mes_proches_zone_manger);*/	
write('je non chef vais me déplacer vers zone' + location_animal);

}


set location_prob <- location_prob + (mon_berger.location_berger - location_animal) / cohesion_factor;		

}	

 reflex en_paturage when:mon_berger.en_pat=true{
write('je suis en paturage');	
if energie_acquise+reserve_energ-besoin_journ<reserve_energ_max
{if chef_troupeau=true{
	if empty(mes_annuelles)=false{
		set ma_zone_manger<-mes_annuelles closest_to(self);
		do se_deplacer_vers dest:ma_zone_manger.location_zone_manger;
		do manger appet:'annuelle';}
	
	else if empty(mes_premiers_pref)=false{
	set ma_zone_manger<-mes_premiers_pref closest_to(self);
	do se_deplacer_vers dest:ma_zone_manger.location_zone_manger;
	do manger appet:appet_1;
	}
	else if empty(mes_second_pref)=false{
	set ma_zone_manger<-mes_second_pref closest_to(self);
	do manger appet:appet_2;}
	else if empty(mes_tertier_pref)=false{
		set ma_zone_manger<-mes_tertier_pref closest_to(self);
	do se_deplacer_vers dest:ma_zone_manger.location_zone_manger;
	do manger appet:appet_3;}
	}	
	}
	
	}/*fin reflex en_paturage, c pour le chef_troupeau */


reflex alignement when:mon_berger.en_pat=true {         /*je n'ai pas besoin d'utiliser separation c a dire la collision ne m'interesse pas  */
write ('je suis dans alignement');
if chef_troupeau=false{
if energie_acquise+reserve_energ-besoin_journ<reserve_energ_max
{
let ann_coh<-zone_cohesion where (each in(mes_annuelles));
let pr_coh<-zone_cohesion where (each in(mes_premiers_pref));
let sec_coh<-zone_cohesion where (each in(mes_second_pref));
let ter_coh<-zone_cohesion where (each in (mes_tertier_pref));
if(empty(ann_coh)=false)
{set ma_zone_manger<-one_of(ann_coh);
do se_deplacer_vers dest:ma_zone_manger.location_zone_manger;
		do manger appet:'annuelle';	
}
else if(empty(pr_coh)=false)	
	{set ma_zone_manger<-one_of(pr_coh);
		do se_deplacer_vers dest:ma_zone_manger.location_zone_manger;
		do manger appet:appet_1;}
else if (empty(sec_coh)=false)	
	{set ma_zone_manger<-one_of(sec_coh);
		do se_deplacer_vers dest:ma_zone_manger.location_zone_manger;
		do manger appet:appet_2;}
else if (empty (ter_coh)=false)	
	{set ma_zone_manger<-one_of(ter_coh);
	do se_deplacer_vers dest:ma_zone_manger.location_zone_manger;
	do manger appet: appet_3;}
else{set ma_zone_manger<-one_of(zone_cohesion where (each in(mes_proches_zone_manger)));
	do se_deplacer_vers dest:ma_zone_manger.location_zone_manger;	}	
	}
	else do suivre_troupeau;
	}}

reflex suivre_chef_troupeau when:mon_berger.en_pat=true{
	if chef_troupeau=false
	{write ('je suis dan suivre chef_troupeau');
	write ('la lo du chef'+ mon_chef.location_animal );
	set location_prob <- location_prob + ((mon_chef.location_animal) - (location_animal)) / cohesion_factor;	
}	
}

action suivre_troupeau{        /*je crée cette action pour le déplacement d'animal qui n'a pas faim */
	write('je suis dans suivre_zone_troupeau');
	set ma_zone_manger<-one_of(zone_cohesion where (each in(mes_proches_zone_manger)));
	do goto target:ma_zone_manger.location;
	}

action se_deplacer_vers{
	arg dest type:point;
	if location_animal distance_to dest<=pas_deplacement
 
 {set location_animal<-dest;}
 else {set angle_deplacement<-location_animal towards dest;
 write ('angle_dep' + angle_deplacement);
 
 set location_animal<-{location_animal.x + cos(angle_deplacement)*pas_deplacement,location_animal.y+ sin(angle_deplacement)* pas_deplacement}; 
}
	
	
	}


action manger{
	write('je suis dans action_manger');
	arg appet type:string;
	let  bx type:float<-0.00;
	let rx type:float<-0.00;
	ask ma_zone_manger{set manger<-true;}
	
	if ma_zone_manger.biomasse_annuelle!=0{
		set bx<-ma_zone_manger.biomasse_annuelle;
		set rx <-ma_zone_manger.recouvrement_annuelle;
		set energie_acquise<-min([quantite_ingestion,ma_zone_manger.biomasse_annuelle*0.8]);/*je considère que l'animal ne consomme pas la totalité du couvert */
		ask ma_zone_manger{
			
			set biomasse_annuelle <-biomasse_annuelle - myself.energie_acquise;
			set recouvrement_annuelle<-(recouvrement_annuelle/bx)* biomasse_annuelle;
			set biomasse_zone_manger<-biomasse_zone_manger-bx+biomasse_annuelle;
			set recouvrement_zone_manger<-recouvrement_zone_manger-rx +recouvrement_annuelle;
			}}
	else if ma_zone_manger.espece_zone_manger=appet{
		set bx<-ma_zone_manger.biomasse_perenne_un;
		set rx <-ma_zone_manger.recouvrement_perenne_un;
		set energie_acquise<-min([quantite_ingestion,ma_zone_manger.biomasse_perenne_un*0.8]);/*je considère que l'animal ne consomme pas la totalité du couvert */
		ask ma_zone_manger{
			
			set biomasse_perenne_un <-biomasse_perenne_un - myself.energie_acquise;
			set recouvrement_perenne_un<-(recouvrement_perenne_un/bx)* biomasse_perenne_un;
			set biomasse_zone_manger<-biomasse_zone_manger-bx+biomasse_perenne_un;
			set recouvrement_zone_manger<-recouvrement_zone_manger-rx +recouvrement_perenne_un;
			}
												}
	else if ma_zone_manger.deuxieme_espece=appet{
	set bx<-ma_zone_manger.biomasse_perenne_deux;
	set rx <-ma_zone_manger.recouvrement_perenne_deux;
	set energie_acquise<-min([quantite_ingestion,ma_zone_manger.biomasse_perenne_deux*0.8]);	
	
	ask ma_zone_manger{
		set biomasse_perenne_deux <-biomasse_perenne_deux - myself.energie_acquise;
		set recouvrement_perenne_deux <-(recouvrement_perenne_deux/bx)* biomasse_perenne_deux;
		set biomasse_zone_manger<-biomasse_zone_manger-bx + biomasse_perenne_deux;
		set recouvrement_zone_manger<-recouvrement_zone_manger-rx +recouvrement_perenne_deux;}
	}
	else if ma_zone_manger.troisieme_espece=appet{
		set bx<-ma_zone_manger.biomasse_perenne_trois;
		set rx <-ma_zone_manger.recouvrement_perenne_trois;
		set energie_acquise<-min([quantite_ingestion,ma_zone_manger.biomasse_perenne_trois*0.8]);
		ask ma_zone_manger{
		 set biomasse_perenne_trois <-biomasse_perenne_trois - myself.energie_acquise;
			set recouvrement_perenne_trois<-(recouvrement_perenne_trois/bx)* biomasse_perenne_trois;
		set biomasse_zone_manger<-biomasse_zone_manger- bx + biomasse_perenne_trois;
		set recouvrement_zone_manger<-recouvrement_zone_manger-rx +recouvrement_perenne_trois;}
		}
	
	}/* fin action manger */



}
/*fin species animal */





species male parent:animal frequency:1
{
var mon_berger type:berger;
var perception_animal type:float<-100.00;
var id_zone_troup type:int;
rgb couleur;
var id_troup type:int;
var id type:int;
var type type :string;
var poids type: float<-30.0;
var age type: int<-5;
var dominance type:int;
var reserve_energ type:float;
var besoin_journ type: float;
var energie_acquise type:float;
var besoin_dep type:float<-0.002;
var indice_besoin type :float;
var location type:point;
var perception type: int<-7;
var quantite_ingestion type:float<-0.06;
male plus_proche_dom;
femelle plus_prochee_dom;
var dmax type:int<-10;

var domf type:bool<-false;/*indique le sexe du dominant true femelle */
 

male mon_dom;
femelle mon_domf;
male mon_domprec;
femelle mon_domfprec;
 var appet_1 type:string;
var appet_2 type:string;
var appet_3 type:string;
var gmange type:bool<-false;
var cequegmange type:string;



var temps_ecoule type:int<-0;

var en_deplacement type:bool<-false;
var angle_deplacement type:float<-0.00;
init{
	set self.shape<-square(20) at_location location_animal ;
	if (age<5)
	{set besoin_journ<-poids*0.055;}
	else{set besoin_journ<-0.053*poids;}
	set reserve_energ_max<-3*besoin_journ;
	set reserve_energ<-reserve_energ_max;}
aspect base{
draw shape:circle  color:rgb('red') size:20 at:location_animal	;
	}
action manger{
	arg appet type:string;}
action suivre_troupeau{}

action se_deplacer_vers{
	arg dest type:point;
	}
}/*fin male*/

species femelle parent:animal frequency:1
{rgb couleur;
	var perception_animal type:float<-100.00;
	var id_zone_troup type:int;
	var mon_berger type:berger;
	 var id_troup type:int;
	var id type:int;
  var type type:string;
  var poids type:float<-30.0;
  var age type:int<-5;/*5 mois */
  var etat_physio type:string;
  var dominance type:int;
   var reserve_energ type:float;
  var besoin_journ type:float;
  var taux_fert type:float;
  var duree_gestation type: int<-150;
  var duree type :int;
  var prob_male type:float<-0.6;
  var energie_acquise type:float;
  var besoin_dep type:float<-0.002; /*besoin de déplacement de 1m */
  var indice_besoin type :float;
  var location type:point;
  var perception type: int<-5;
  var quantite_ingestion type:float<-0.06;
  var temps_ecoule type:int<-0;
var appet_1 type:string;
var appet_2 type:string;
var appet_3 type:string;
var gmange type:bool<-false;
var cequegmange type:string;
var reserve_energmax type:float;





var premier type:bool<-false;
var en_deplacement type:bool<-false;
var dmax type:int<-10;
var angle_deplacement type:float<-0.00;
init{set self.shape<-square(20) at_location location_animal ;
	if (age<5)
	{set besoin_journ<-poids*0.055;}
	else{set besoin_journ<-0.053*poids;}
	set reserve_energ_max<-3*besoin_journ;
	set reserve_energ<-reserve_energ_max;}

aspect base{
draw shape:circle  color:rgb('pink') at:location_animal size:30;	
	}

action manger{
	arg appet type:string;}

action suivre_troupeau{}

action se_deplacer_vers{
	arg dest type:point;
	}


}/*fin femelle*/





species observateur_parcours
{var mesvegetation type: list<-list(vegetation);
	var biomassse_tot type:float;
	var biomasse_per type:float;
	var biomasse_annu type:float;
	var richesse_per type :float;
	var richesse_annu type:float;
	var recouv_perenne type:float;
	var recouv_annuelle type:float;
	var densite_tot type: float;
	var densite_annu type:float;
	var densite_per type:float;
	var etat_couvert type:float;
	

reflex ma_biomasse when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
	set biomassse_tot<-0;
let listparcours<-list(parcours) where(each.moi=1);
  	let aa type:int<-0;
  	loop aa from:0 to :length(listparcours)-1
  	{set biomassse_tot<-biomassse_tot+((listparcours at aa).p_biomasse);
  		 
  	}		
		
}

reflex ma_bio_per when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0
{set biomasse_per<-0;
	let listparcourss<-list(parcours)where(each.moi=1);
  	let aass type:int<-0;
  	loop aass from:0 to :length(listparcourss)-1
  	{set biomasse_per<-biomasse_per+((listparcourss at aass).p_biomasse_perenne);
  	
  	}
  	write("bioperennetot" +biomasse_per);
 	}
  	
  	
  	
  	
reflex mon_couvert_perennes when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
let listparcourss<-list(parcours)where(each.moi=1);
let surfacee type:float<-0;
let totcouv type:float<-0;
  	let aao type:int<-0;
  	loop aao from:0 to :length(listparcourss)-1
  	{set surfacee<-surfacee+((listparcourss at aao).surface);
  	set totcouv<-totcouv+((listparcourss at aao).recouvrement_perenne)*((listparcourss at aao).surface);
  	set  recouv_perenne<-totcouv/surfacee;	
  	
  	}
}


reflex couvert when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
let listparcourss<-list(parcours)where(each.moi=1);
let surfacee type:float<-0;
let totcouv type:float<-0;
  	let aao type:int<-0;
  	loop aao from:0 to :length(listparcourss)-1
  	{set surfacee<-surfacee+((listparcourss at aao).surface);
  	set totcouv<-totcouv+((listparcourss at aao).recouvrement)*((listparcourss at aao).surface);
  	set etat_couvert<-totcouv/surfacee;	
  	}	
  write("observateuretatcouv" +totcouv);
  write("observateuretatcouv" + etat_couvert);		
}
reflex richesse_p when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
	if etat_couvert!=0
	{set richesse_per<-recouv_perenne/etat_couvert;}
	else{set richesse_per<-0;}
}
reflex richesse_a when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
	if etat_couvert!=0
	{set richesse_annu<-1-(recouv_perenne/etat_couvert);}
	else{set richesse_annu<-0;}
}
reflex densite_tot when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
	set densite_tot<-0;
let listparcourss<-list(parcours)where(each.moi=1);
let aao type:int<-0;
  	loop aao from:0 to :length(listparcourss)-1	
{set densite_tot<- densite_tot + (listparcourss at aao).p_densite_couvert;
}
	
}
reflex densite_perenne when: pas_de_temps mod (nbrejours*92) =0 and nbrejours>0{
	set densite_per<-0;
let listparcoursss<-list(parcours)where(each.moi=1);
let aaos type:int<-0;
  	loop aaos from:0 to :length(listparcoursss)-1	
{set densite_per<- densite_per + (listparcoursss at aaos).p_densite_couvert;
}
	
}
}
species climat{
	var annee type:int;
	var etrjanvier type:float;
	var etrfevrier type:float;
	var etrmars type:float;
	var etravril type:float;
	var etrmai type:float;
	var etrjuin type:float;
	var etrjuillet type:float;
	var etraout type:float;
	var etrseptembre type:float;
	var etroctobre type:float;
	var etrnovembre type:float;
	var etrdecembre type:float;
	var etpjanvier type:float;
	var etpfevrier type:float;
	var etpmars type:float;
	var etpavril type:float;
	var etpmai type:float;
	var etpjuin type:float;
	var etpjuillet type:float;
	var etpaout type:float;
	 var etpseptembre type:float;
	var etpoctobre type:float;
	var etpnovembre type:float;
	var etpdecembre type:float;
	var pjanvier type:float;
	var pfevrier type:float;
	var pmars type:float;
	var pavril type:float;
	var pmai type:float;
	var pjuin type:float;
	var pjuillet type:float;
	var paout type:float;
	var pseptembre type:float;
	var poctobre type:float;
	var pnovembre type:float;
	var pdecembre type:float;
}
species vitessevent{
	var annee type:int;
	var ventjanvier type:float;
	var ventfevrier type:float;
	var ventmars type: float;
	var ventavril type:float;
	var ventmai type:float;
	var ventjuin type:float;
	var ventjuillet type:float;
	var ventaout type:float;
	var ventseptembre type:float;
	var ventoctobre type:float;
	var ventnovembre type:float;
	var ventdecembre type:float;
	
}		
 
 
 }
/*fin entities debut environment */

environment bounds:gis_sol
{
	
	
	
}
/*fin environment debut experiment */
experiment first_layer type :gui {
	parameter 'pas_de_simulation'var: pas category:'simulation_step';
	parameter 'annnee' var:annee category:'anneetude';
	parameter 'visualisation_mensuelle' var: visuelmensuel category:'visualisation';
	parameter 'intervalle_max' var:anneemax category:'intervalle';
	parameter 'intervalle_min' var:anneemin category:'intervalle';
	parameter 'nbre_troupeau' var :nbre_troupeau category :'Cheptel';
	parameter 'effectif_troupeau' var :effectif_troupeau category :'Cheptel';
	
	output{
		    
       file  "results" type: text data: 'cycle: '+ time
                              + '; biomasse_totale: ' + biomassse_totale;
	do write message:'resulsssssssssss'; 
	

		display ma_simulation type: opengl  {
		/*species portion_sol aspect:basic z:0;*/
       /*  species interme aspect:basic;*/
           /*species parcours aspect:vise z:0 ;*/
          /*species zone_parcours aspect:verif;*/
         
          /*species parcours aspect: verif z:0;*/
         /*species zone_troupeau aspect :basic z:0;*/
        species zone_troupeau aspect:concerner_parcours z:0;
          species berger aspect:en_dep z:0;
         
          /*species puit aspect: basic z:0 ;*/
          /*species zone_parcours aspect:basic z:0;*/
          /*  species zone_parcours aspect:verif z:0;*/
          /*  species zone_paturage aspect:concerner_parcours z:0; */
         /*  species male aspect:basic ;*/
        /*   species femelle aspect:basic z: 0.5;*/
        /*species ma_grille_parcours aspect:basic  z:0.5;*/
       
        
         }
        display grille_deplacement type:opengl{
        species parcours aspect:vise z:0;
       species zone_parcours aspect:basic z:0.5;
      /* species ma_grille_parcours aspect:basic z:0.5;*/ 
       /*species ma_parcelle aspect:basic z:0.5;*/
       /*species zone_parcours aspect: basic z:0;*/
       /*agents lagrille value: ma_grille_parcours as list where (each.concerne_1=false) aspect:basic; */	
        } 
	display le_parcours type:opengl{
	species zone_manger aspect:concerne_parcours z:0;	
species berger aspect:base z:0;
	species male aspect:base z:0;
	species femelle aspect:base z:0;
	}
	
	/*display erosif type:opengl{
		species parcours  transparency:0.5 aspect:erosif z:0.5;
	}*/
	
	display evolution_indicateur refresh_every:1{
	chart "Evolution_biomasse" type: series background: rgb('white') position: {0, 0} {
            data biomasse_totale value: biomassse_totale color: rgb('black') ;
            data biomasse_perenne value: biomasse_per color: rgb('gray') ;	
	}
	chart "Richesse_perenne_annuelle" type: series background: rgb('white') position: {0, 0} {
            data richesse_annuelle value: richesse_per_totale color: rgb('black') ;
            data richesse_perenne value: richesse_annu_totale color: rgb('red') ;}
     
     chart "Evolution_couvert" type: series background: rgb('white') position: {0, 0} {
            data couvert_total value: etat_couvert_total color: rgb('black') ;
            data etat_couvert_perenne value: etat_couvert_perenne color: rgb('red') ;
         }
       
                             
                                	
	}
	inspect name: 'Species' type: species refresh_every: 5;
	
	
	
	
	
	}
	/*fin output */
	 
}
/*fin experiments et tout le projet */



