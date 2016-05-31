<?php require("header.php") ?>

<div class="container">
  <div class="row">
    <div class="col-sm-4 text-center">
      <a href="read.php" class="btn btn-block btn-primary"><i class="glyphicon glyphicon-search"></i> Read EEPROM information</a>
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
