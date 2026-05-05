--------------------------------------------------------
--  DDL for Package Body PKG_LOCATION_MASTER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SMART_FACTORY_DB"."PKG_LOCATION_MASTER" IS
            -- insert location
            PROCEDURE location_insert (p_location_code locations.location_code%Type,
                                                        p_location_des locations.description%Type ) IS 
            BEGIN
                    INSERT INTO locations (location_code,description) 
                    VALUES (p_location_code,p_location_des);
            END location_insert;
            
            -- update location
            PROCEDURE location_code_update (p_location_id locations.location_id%Type,
                                                                p_location_code locations.location_code%Type)IS
            BEGIN
                    UPDATE locations SET location_code = p_location_code WHERE location_id = p_location_id;
            END location_code_update;
            
END pkg_location_master;

/
