<?php require("header.php") ?>

<div class="container">
 <div class="row">
    <div class="col-sm-4 text-center">
      <a href="read.php" class="btn btn-block btn-primary"><i class="glyphicon glyphicon-search"></i> Read EEPROM</a>
    </div>
    <div class="col-sm-4 text-center">
      <a href="regenerate.php" class="btn btn-block btn-primary" disabled="disabled"><i class="glyphicon glyphicon-refresh"></i> Regenerate EEPROM</a>
    </div>
    <div class="col-sm-4 text-center">
      <a href="custom.php" class="btn btn-block btn-primary" disabled="disabled"><i class="glyphicon glyphicon-cog"></i> Custom EEPROM</a>
    </div>
  </div>
</div>

<div class="spacer" style="height: 30px"></div>
<div class="container">
  <div class="row">
    <div class="col-md-8 col-md-offset-2">
        <?php
	if( $_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['centimeter-amount']) ){
	        // outputs the username that owns the running php/httpd process
	        // (on a system with the "whoami" executable in the path)
		$diameter = 0.175; //diameter in centimeter
		$quantity_centi = round ( $_POST['centimeter-amount'] * ( 3.14159265359 * ($diameter/2) * ($diameter/2) ), 1); //Material in centimeter ^ 3
		$quantity = $quantity_centi * 0.061024; //Material in inch ^3
	      echo '<div class="well well-lg" style="font-family:monospace;">';
	        echo nl2br(shell_exec(dirname(__FILE__) . '/scripts/custom-eeprom.sh ' . $quantity));
	      echo '</div>';
	} else {
		echo '<div class="spacer" style="height: 30px"></div>';
		echo '<form method="POST" class="form-inline"> 
			<div class="form-group"> 
				<label for="centimeter-amount">New material length: </label> 
				<div class="input-group">
					<input type="text" class="form-control" id="centimeter-amount" name="centimeter-amount" placeholder="Length"> 
					<div class="input-group-addon">centimeter</div>
				</div>
			</div> 
			<button type="submit" class="btn btn-primary">Write to EEPROM</button> 
			<a href="reset.php" class="btn btn-default">Reset material length</a> 
		</form>';
		echo '<div class="spacer" style="height: 30px"></div>';
	}
        ?>
    </div>
  </div>
</div>

<div class="spacer" style="height: 30px"></div>
<div class="container">
 <div class="row">
    <div class="col-sm-4 text-center">
      <a href="read.php" class="btn btn-block btn-primary"><i class="glyphicon glyphicon-search"></i> Read EEPROM</a>
    </div>
    <div class="col-sm-4 text-center">
      <a href="regenerate.php" class="btn btn-block btn-primary" disabled="disabled"><i class="glyphicon glyphicon-refresh"></i> Regenerate EEPROM</a>
    </div>
    <div class="col-sm-4 text-center">
      <a href="custom.php" class="btn btn-block btn-primary" disabled="disabled"><i class="glyphicon glyphicon-cog"></i> Custom EEPROM</a>
    </div>
  </div>
</div>

<?php require("footer.php") ?>
