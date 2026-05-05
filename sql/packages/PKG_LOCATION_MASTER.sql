--------------------------------------------------------
--  DDL for Package PKG_LOCATION_MASTER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "SMART_FACTORY_DB"."PKG_LOCATION_MASTER" IS
                -- insert location
                PROCEDURE location_insert (p_location_code locations.location_code%Type,
                                                            p_location_des locations.description%Type);
                -- update location
                PROCEDURE location_code_update (p_location_id locations.location_id%Type ,
                                                                        p_location_code locations.location_code%Type);
END pkg_Location_master;

/
