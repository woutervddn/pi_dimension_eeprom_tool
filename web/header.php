<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Cr3do Fortus EEPROM Reset</title>

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    <style>
      .btn{
        margin-bottom: 5px
      }
    </style>
  </head>
  <body>
    <div class="spacer" style="height: 30px"></div>
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <div class="well">
            <h1><a href="index.php">Cr3do EEPROM Writer</a></h1>
	    <p>This tool is made to regenerate Stratasys Cartridge EEPROMS.</p>
		<hr/>
	    <p>Usage is simple and straightforward. First click the <strong>Read EEPROM</strong> button in order to get a readout from the currently place eeprom. If the suggested new information is correct, proceed by clicking <strong>Regenerate EEPROM</strong>.</p>
	    <p>If all worked correctly you can now press <strong>read EEPROM</strong> again to verify that the eeprom has been regenerated.</p>
		<hr/>
		<p><span style="text-align: right;">Project Author: Wouter Vandenneucker - 2016 - for Makerspace PXL-Uhasselt &amp; Cr3do</span></p>
          </div>
        </div>
      </div>
    </div>
