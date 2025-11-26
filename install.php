<?php
function extension_install_softwareactivity()
{
    $commonObject = new ExtensionCommon;

    $commonObject -> sqlQuery(
        "CREATE TABLE `language` (
        ID INTEGER NOT NULL AUTO_INCREMENT, 
        HARDWARE_ID INTEGER NOT NULL,
        OSLANG VARCHAR(255) DEFAULT NULL,
        KEYLAYOUT VARCHAR(255) DEFAULT NULL,
        PRIMARY KEY (ID,HARDWARE_ID)) ENGINE=INNODB;"
    );
}

function extension_delete_softwareactivity()
{
    $commonObject = new ExtensionCommon;
    $commonObject -> sqlQuery("DROP TABLE IF EXISTS `softwareactivity`");
}

function extension_upgrade_softwareactivity()
{

}

?>