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
      <div class="well well-lg" style="font-family:monospace;">
        <?php
        // outputs the username that owns the running php/httpd process
        // (on a system with the "whoami" executable in the path)
        echo nl2br(shell_exec('sudo ' . dirname(__FILE__) . '/scripts/update-eeprom.sh'));
        ?>
      </div>
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
