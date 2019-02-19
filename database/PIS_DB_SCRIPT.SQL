use pis;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema pis
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `pis` ;

-- -----------------------------------------------------
-- Schema pis
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pis` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema pis
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `pis` ;

-- -----------------------------------------------------
-- Schema pis
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pis` DEFAULT CHARACTER SET latin1 ;
USE `pis` ;

-- -----------------------------------------------------
-- Table `pis`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user` ;

CREATE TABLE IF NOT EXISTS `pis`.`user` (
  `USERID` INT(11) NOT NULL AUTO_INCREMENT,
  `USERNAME` VARCHAR(50) CHARACTER SET 'utf8' NOT NULL,
  `PASSWORD` CHAR(10) NOT NULL,
  `FIRSTNAME` VARCHAR(50) CHARACTER SET 'utf8' NOT NULL,
  `MIDDLENAME` VARCHAR(50) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `LASTNAME` VARCHAR(50) CHARACTER SET 'utf8' NOT NULL,
  `DOB` DATE NOT NULL,
  `DTUPDATED` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`USERID`, `USERNAME`),
  INDEX `USERNAME` (`USERNAME` ASC, `FIRSTNAME` ASC, `LASTNAME` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`organization`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`organization` ;

CREATE TABLE IF NOT EXISTS `pis`.`organization` (
  `ORGANIZATIONID` INT(11) NOT NULL AUTO_INCREMENT,
  `ORGANIZATIONNAME` VARCHAR(100) CHARACTER SET 'utf8' NOT NULL,
  `DTJOINED` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ORGANIZATIONID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`training_package`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`training_package` ;

CREATE TABLE IF NOT EXISTS `pis`.`training_package` (
  `PACKAGEID` INT(11) NOT NULL,
  `ORGANIZATIONID` INT(11) NOT NULL,
  `DTCREATED` DATE NOT NULL,
  `PACKAGENAME` VARCHAR(45) NULL DEFAULT NULL,
  `PACKAGEDESCRIPTION` VARCHAR(100) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `TOTALSESSION` INT(11) NOT NULL,
  `DURATION` INT(11) NULL DEFAULT NULL COMMENT 'Duration in month',
  `PRICE` DOUBLE NULL DEFAULT NULL COMMENT 'Price in IDR\n',
  PRIMARY KEY (`PACKAGEID`),
  INDEX `FK_ORGANIZATION_TRAINING_PACKAGE_idx` (`ORGANIZATIONID` ASC),
  CONSTRAINT `FK_ORGANIZATION_TRAINING_PACKAGE`
    FOREIGN KEY (`ORGANIZATIONID`)
    REFERENCES `pis`.`organization` (`ORGANIZATIONID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`feedback`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`feedback` ;

CREATE TABLE IF NOT EXISTS `pis`.`feedback` (
  `FEEDBACKID` INT(11) NOT NULL,
  `USERID` INT(11) NOT NULL,
  `TRAINERID` INT(11) NOT NULL,
  `DTCREATED` DATE NOT NULL,
  `RATING` INT(5) NOT NULL COMMENT '5 Stars rating',
  `COMMENT` NVARCHAR(100) NULL,
  `PACKAGEID` INT(11) NULL,
  PRIMARY KEY (`FEEDBACKID`),
  INDEX `FK_USER_FEEDBACK_idx` (`USERID` ASC),
  INDEX `FK_PACKAGE_FEEDBACK_idx` (`PACKAGEID` ASC),
  CONSTRAINT `FK_USER_FEEDBACK`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_TRAINER_FEEDBACK`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_PACKAGE_FEEDBACK`
    FOREIGN KEY (`PACKAGEID`)
    REFERENCES `pis`.`training_package` (`PACKAGEID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `pis` ;

-- -----------------------------------------------------
-- Table `pis`.`chat_message`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`chat_message` ;

CREATE TABLE IF NOT EXISTS `pis`.`chat_message` (
  `MESSAGEID` INT(11) NOT NULL AUTO_INCREMENT,
  `USERID` INT(11) NOT NULL,
  `MESSAGE` VARCHAR(256) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `DTCREATED` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`MESSAGEID`),
  INDEX `USERID` (`USERID` ASC),
  CONSTRAINT `chat_message_ibfk_1`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`chat_session`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`chat_session` ;

CREATE TABLE IF NOT EXISTS `pis`.`chat_session` (
  `CHATID` INT(11) NOT NULL AUTO_INCREMENT,
  `DTCREATED` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`CHATID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_exercise`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_exercise` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_exercise` (
  `USEREXERCISEID` INT(11) NOT NULL AUTO_INCREMENT,
  `ORGANIZATIONID` INT(11) NOT NULL,
  `USERID` INT(11) NOT NULL,
  PRIMARY KEY (`USEREXERCISEID`),
  INDEX `ORGANIZATIONID` (`ORGANIZATIONID` ASC, `USERID` ASC),
  INDEX `USERID` (`USERID` ASC),
  CONSTRAINT `user_exercise_ibfk_1`
    FOREIGN KEY (`ORGANIZATIONID`)
    REFERENCES `pis`.`organization` (`ORGANIZATIONID`),
  CONSTRAINT `user_exercise_ibfk_2`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`exercise_status`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`exercise_status` ;

CREATE TABLE IF NOT EXISTS `pis`.`exercise_status` (
  `EXERCISESTATUSID` INT(11) NOT NULL,
  `USEREXERCISEID` INT(11) NULL DEFAULT NULL,
  `USERAPPROVAL` TINYINT(4) NULL DEFAULT NULL,
  `USERAPPROVALDATE` DATE NULL DEFAULT NULL,
  `TRAINERAPPROVAL` TINYINT(4) NULL DEFAULT NULL,
  `TRAINERAPPROVALDATE` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`EXERCISESTATUSID`),
  INDEX `FK_USER_EXERCISE_EXERCISE_STATUS_idx` (`USEREXERCISEID` ASC),
  CONSTRAINT `FK_USER_EXERCISE_EXERCISE_STATUS`
    FOREIGN KEY (`USEREXERCISEID`)
    REFERENCES `pis`.`user_exercise` (`USEREXERCISEID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`rf_movement`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`rf_movement` ;

CREATE TABLE IF NOT EXISTS `pis`.`rf_movement` (
  `MOVEMENTID` INT(11) NOT NULL AUTO_INCREMENT COMMENT '10, Bench press, 1. lay on bench. 2. lift weight. 3 etc, \'path to video\', null\n',
  `MOVEMENT` VARCHAR(45) NULL DEFAULT NULL,
  `STEPS` TEXT NOT NULL,
  `VIDEOPATH` VARCHAR(100) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `NOTES` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`MOVEMENTID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`rf_bodypart`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`rf_bodypart` ;

CREATE TABLE IF NOT EXISTS `pis`.`rf_bodypart` (
  `BODYPARTID` INT(11) NOT NULL COMMENT '1, weight (kg)\n2, Height (cm)\n20, head\n25, neck\n30, right shoulder\n50, Blood preassure (whatever som)\n55, Heart rate (bpm)\n70, diabetic (yes no)\n100, front body shot --> to hold pic\n105, left body shot  --> to hold pic\n',
  `BODYPARTDESC` VARCHAR(100) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  PRIMARY KEY (`BODYPARTID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`movemement_bodypart`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`movemement_bodypart` ;

CREATE TABLE IF NOT EXISTS `pis`.`movemement_bodypart` (
  `MOVEMENTID` INT(11) NOT NULL,
  `BODYPARTID` INT(11) NOT NULL,
  `NOTES` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`MOVEMENTID`, `BODYPARTID`),
  INDEX `BODYPARTID` (`BODYPARTID` ASC),
  CONSTRAINT `movemement_bodypart_ibfk_1`
    FOREIGN KEY (`MOVEMENTID`)
    REFERENCES `pis`.`rf_movement` (`MOVEMENTID`),
  CONSTRAINT `movemement_bodypart_ibfk_2`
    FOREIGN KEY (`BODYPARTID`)
    REFERENCES `pis`.`rf_bodypart` (`BODYPARTID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`organization_contact`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`organization_contact` ;

CREATE TABLE IF NOT EXISTS `pis`.`organization_contact` (
  `ORGANIZATIONID` INT(11) NOT NULL,
  `PIC` INT(11) NOT NULL,
  `CONTACTTYPE` SMALLINT(6) NOT NULL,
  `CONTACTVALUE` VARCHAR(200) CHARACTER SET 'utf8' NOT NULL,
  `DTSTART` DATE NOT NULL,
  INDEX `ORGANIZATIONID` (`ORGANIZATIONID` ASC, `PIC` ASC, `CONTACTTYPE` ASC, `CONTACTVALUE` ASC, `DTSTART` ASC),
  INDEX `PIC` (`PIC` ASC),
  CONSTRAINT `organization_contact_ibfk_1`
    FOREIGN KEY (`ORGANIZATIONID`)
    REFERENCES `pis`.`organization` (`ORGANIZATIONID`),
  CONSTRAINT `organization_contact_ibfk_2`
    FOREIGN KEY (`PIC`)
    REFERENCES `pis`.`user` (`USERID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`rf_contacttype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`rf_contacttype` ;

CREATE TABLE IF NOT EXISTS `pis`.`rf_contacttype` (
  `CONTACTTYPE` SMALLINT(6) NOT NULL COMMENT '1, Address\n2, Mobile Phone\n3, Home Phone\n4, Work Phone\n5, email\netc',
  `DESCRIPTION` VARCHAR(60) CHARACTER SET 'utf8' NOT NULL,
  PRIMARY KEY (`CONTACTTYPE`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`rf_relation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`rf_relation` ;

CREATE TABLE IF NOT EXISTS `pis`.`rf_relation` (
  `RELATIONID` INT(11) NOT NULL AUTO_INCREMENT,
  `RELATIONDESC` VARCHAR(50) CHARACTER SET 'utf8' NOT NULL,
  PRIMARY KEY (`RELATIONID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`rf_role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`rf_role` ;

CREATE TABLE IF NOT EXISTS `pis`.`rf_role` (
  `ROLEID` INT(11) NOT NULL AUTO_INCREMENT,
  `ROLEDESC` VARCHAR(50) CHARACTER SET 'utf8' NOT NULL,
  PRIMARY KEY (`ROLEID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_activity`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_activity` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_activity` (
  `USERID` INT(11) NOT NULL,
  `ACTIVITY` VARCHAR(20) CHARACTER SET 'utf8' NOT NULL,
  `ACTIVITYDESC` TEXT NOT NULL,
  `DTSTART` DATE NULL DEFAULT NULL,
  `DTEND` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`USERID`, `ACTIVITY`),
  CONSTRAINT `user_activity_ibfk_1`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_chat_session`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_chat_session` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_chat_session` (
  `USERID` INT(11) NOT NULL,
  `CHATID` INT(11) NOT NULL,
  INDEX `USERID` (`USERID` ASC, `CHATID` ASC),
  INDEX `CHATID` (`CHATID` ASC),
  CONSTRAINT `user_chat_session_ibfk_1`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`),
  CONSTRAINT `user_chat_session_ibfk_2`
    FOREIGN KEY (`CHATID`)
    REFERENCES `pis`.`chat_session` (`CHATID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_contact`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_contact` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_contact` (
  `USERID` INT(11) NOT NULL,
  `CONTACTTYPE` SMALLINT(6) NOT NULL,
  `CONTACTVALUE` VARCHAR(200) CHARACTER SET 'utf8' NOT NULL,
  `DTSTART` DATE NOT NULL,
  INDEX `USERID` (`USERID` ASC, `CONTACTTYPE` ASC, `CONTACTVALUE` ASC, `DTSTART` ASC),
  INDEX `FK_RF_CONTACTTYPE_USER_CONTACT` (`CONTACTTYPE` ASC),
  CONSTRAINT `FK_RF_CONTACTTYPE_USER_CONTACT`
    FOREIGN KEY (`CONTACTTYPE`)
    REFERENCES `pis`.`rf_contacttype` (`CONTACTTYPE`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_contact_ibfk_1`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_exercise_detail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_exercise_detail` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_exercise_detail` (
  `USEREXERCISEID` INT(11) NOT NULL,
  `MOVEMENTID` INT(11) NOT NULL,
  `EXERCISESEQ` INT(11) NOT NULL,
  `SETS` INT(11) NULL DEFAULT NULL,
  `REPS` INT(11) NULL DEFAULT NULL,
  `SECONDDURATION` INT(11) NULL DEFAULT NULL,
  `RESTDURATION` INT(11) NULL DEFAULT NULL,
  `NOTES` VARCHAR(200) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `VIDEOPATH` VARCHAR(100) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  PRIMARY KEY (`USEREXERCISEID`),
  INDEX `MOVEMENTID` (`MOVEMENTID` ASC, `EXERCISESEQ` ASC),
  CONSTRAINT `user_exercise_detail_ibfk_1`
    FOREIGN KEY (`USEREXERCISEID`)
    REFERENCES `pis`.`user_exercise` (`USEREXERCISEID`),
  CONSTRAINT `user_exercise_detail_ibfk_2`
    FOREIGN KEY (`MOVEMENTID`)
    REFERENCES `pis`.`rf_movement` (`MOVEMENTID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_exercise_schedule`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_exercise_schedule` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_exercise_schedule` (
  `USEREXERCISESCHEDULEID` INT(11) NOT NULL COMMENT 'Enable schedule training with different trainers',
  `USEREXERCISEID` INT(11) NULL DEFAULT NULL,
  `DTEXERCISE` DATETIME NULL DEFAULT NULL,
  `TRAINERID` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`USEREXERCISESCHEDULEID`),
  INDEX `FK_USER_EXERCISE_USER_EXERCISE_SCHEDULE_idx` (`USEREXERCISEID` ASC),
  INDEX `FK_USER_USER_EXERCISE_SCHEDULE_idx` (`TRAINERID` ASC),
  CONSTRAINT `FK_USER_EXERCISE_USER_EXERCISE_SCHEDULE`
    FOREIGN KEY (`USEREXERCISEID`)
    REFERENCES `pis`.`user_exercise` (`USEREXERCISEID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_USER_USER_EXERCISE_SCHEDULE`
    FOREIGN KEY (`TRAINERID`)
    REFERENCES `pis`.`user` (`USERID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_health_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_health_history` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_health_history` (
  `USERID` INT(11) NOT NULL,
  `BODYPARTID` INT(11) NOT NULL,
  `DTSTART` DATE NOT NULL,
  `DTEND` DATE NOT NULL,
  `SCALE` DOUBLE NULL DEFAULT NULL,
  `REASON` VARCHAR(100) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `NOTES` VARCHAR(100) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  `PICPATH` VARCHAR(100) CHARACTER SET 'utf8' NULL DEFAULT NULL,
  PRIMARY KEY (`USERID`, `BODYPARTID`, `DTSTART`, `DTEND`),
  INDEX `BODYPARTID` (`BODYPARTID` ASC),
  CONSTRAINT `user_health_history_ibfk_1`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`),
  CONSTRAINT `user_health_history_ibfk_2`
    FOREIGN KEY (`BODYPARTID`)
    REFERENCES `pis`.`rf_bodypart` (`BODYPARTID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_nok`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_nok` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_nok` (
  `USERID` INT(11) NOT NULL,
  `FIRSTNAME` VARCHAR(50) CHARACTER SET 'utf8' NOT NULL,
  `LASTNAME` VARCHAR(50) CHARACTER SET 'utf8' NOT NULL,
  `MOBILENO` VARCHAR(15) CHARACTER SET 'utf8' NOT NULL,
  `EMAIL` VARCHAR(50) CHARACTER SET 'utf8' NOT NULL,
  `RELATIONID` INT(11) NOT NULL,
  PRIMARY KEY (`USERID`),
  INDEX `FIRSTNAME` (`FIRSTNAME` ASC, `LASTNAME` ASC, `MOBILENO` ASC, `EMAIL` ASC),
  INDEX `RELATIONID` (`RELATIONID` ASC),
  CONSTRAINT `user_nok_ibfk_1`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`),
  CONSTRAINT `user_nok_ibfk_2`
    FOREIGN KEY (`RELATIONID`)
    REFERENCES `pis`.`rf_relation` (`RELATIONID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_organization`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_organization` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_organization` (
  `USERID` INT(11) NOT NULL,
  `ORGANIZATIONID` INT(11) NOT NULL,
  `DTJOINED` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `USERID` (`USERID` ASC),
  INDEX `ORGANIZATIONID` (`ORGANIZATIONID` ASC),
  CONSTRAINT `user_organization_ibfk_1`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`),
  CONSTRAINT `user_organization_ibfk_2`
    FOREIGN KEY (`ORGANIZATIONID`)
    REFERENCES `pis`.`organization` (`ORGANIZATIONID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_target`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_target` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_target` (
  `USERTARGETID` INT(11) NOT NULL AUTO_INCREMENT,
  `USERID` INT(11) NOT NULL,
  `BODYPARTID` INT(11) NOT NULL,
  `DTTARGET` DATE NOT NULL,
  `SOM` VARCHAR(10) CHARACTER SET 'utf8' NOT NULL,
  `TARGETVALUE` DOUBLE NOT NULL,
  PRIMARY KEY (`USERTARGETID`),
  INDEX `USERID` (`USERID` ASC, `BODYPARTID` ASC),
  INDEX `BODYPARTID` (`BODYPARTID` ASC),
  CONSTRAINT `user_target_ibfk_1`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`),
  CONSTRAINT `user_target_ibfk_2`
    FOREIGN KEY (`BODYPARTID`)
    REFERENCES `pis`.`rf_bodypart` (`BODYPARTID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_package`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_package` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_package` (
  `USERPACKAGEID` INT(11) NOT NULL,
  `PACKAGEID` INT(11) NULL DEFAULT NULL,
  `USERID` INT(11) NULL DEFAULT NULL,
  `TRAINERID` INT(11) NULL DEFAULT NULL,
  `DTSTART` DATE NULL DEFAULT NULL,
  `PRICE` DOUBLE NULL DEFAULT NULL COMMENT 'sometimes price advertised is not fixed. this enable negotiation between client and trainer',
  `USERTARGETID` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`USERPACKAGEID`),
  INDEX `FK_TRAINING_PACKAGE_USER_PACKAGE_idx` (`PACKAGEID` ASC),
  INDEX `FK_USER_USER_PACKAGE_idx` (`USERID` ASC),
  INDEX `FK_TRAINER_USER_PACKAGE_idx` (`TRAINERID` ASC),
  INDEX `FK_USER_TARGET_USER_PACKAGE_idx` (`USERTARGETID` ASC),
  CONSTRAINT `FK_TRAINER_USER_PACKAGE`
    FOREIGN KEY (`TRAINERID`)
    REFERENCES `pis`.`user` (`USERID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_TRAINING_PACKAGE_USER_PACKAGE`
    FOREIGN KEY (`PACKAGEID`)
    REFERENCES `pis`.`training_package` (`PACKAGEID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_USER_TARGET_USER_PACKAGE`
    FOREIGN KEY (`USERTARGETID`)
    REFERENCES `pis`.`user_target` (`USERTARGETID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_USER_USER_PACKAGE`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_pic`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_pic` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_pic` (
  `USERID` INT(11) NOT NULL,
  `PICPATH` VARCHAR(100) CHARACTER SET 'utf8' NOT NULL,
  `DTSTART` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`USERID`),
  CONSTRAINT `user_pic_ibfk_1`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_role` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_role` (
  `USERID` INT(11) NULL DEFAULT NULL,
  `ROLEID` INT(11) NULL DEFAULT NULL,
  INDEX `USERID` (`USERID` ASC),
  INDEX `ROLEID` (`ROLEID` ASC),
  CONSTRAINT `user_role_ibfk_1`
    FOREIGN KEY (`USERID`)
    REFERENCES `pis`.`user` (`USERID`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `user_role_ibfk_2`
    FOREIGN KEY (`ROLEID`)
    REFERENCES `pis`.`rf_role` (`ROLEID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `pis`.`user_target_detail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pis`.`user_target_detail` ;

CREATE TABLE IF NOT EXISTS `pis`.`user_target_detail` (
  `USERTARGETID` INT(11) NOT NULL,
  `TARGETTEXT` VARCHAR(300) CHARACTER SET 'utf8' NOT NULL,
  `DTTARGET` DATE NOT NULL,
  `ACHIEVED` TINYINT(1) NULL DEFAULT '0',
  `DTENTERED` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`USERTARGETID`),
  INDEX `TARGETTEXT` (`TARGETTEXT` ASC, `DTTARGET` ASC, `DTENTERED` ASC),
  CONSTRAINT `user_target_detail_ibfk_1`
    FOREIGN KEY (`USERTARGETID`)
    REFERENCES `pis`.`user_target` (`USERTARGETID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
