<?php
function extension_install_language()
{
    $commonObject = new ExtensionCommon;

    $commonObject -> sqlQuery(
        "ALTER TABLE `hardware`
        ADD COLUMN `OSLANG` VARCHAR(255) DEFAULT NULL;"
    );

    $commonObject -> sqlQuery(
        "ALTER TABLE `hardware`
        ADD COLUMN `KEYLAYOUT` VARCHAR(255) DEFAULT NULL;"
    );
}

function extension_delete_language()
{
    $commonObject = new ExtensionCommon;
    $commonObject -> sqlQuery(
        "ALTER TABLE `hardware`
        DROP COLUMN `OSLANG`;"
    );
    $commonObject -> sqlQuery(
        "ALTER TABLE `hardware`
        DROP COLUMN `KEYLAYOUT`;"
    );
}

function extension_upgrade_language()
{

}

?>