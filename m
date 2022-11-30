Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5116463DC31
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 18:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiK3Ris (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 12:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiK3Rio (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 12:38:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF56948401
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 09:38:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DC0F61D21
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 17:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAEBC433C1;
        Wed, 30 Nov 2022 17:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669829922;
        bh=r6I7pnqpq7P1R/pxdQgVTleOXi1FmUUX+uqskzh53EE=;
        h=Subject:To:Cc:From:Date:From;
        b=g32KqXDlJTaGQ+ZAWjRzZ2FgmRjc4wqVRPqAvUTrWtEzvHpyOXfVf3Fm0GdjnPAmJ
         Xb3LdgAZKcjMotIOt462whzMY74/SjG6ChDDNXoD7vMK679zlHiEkVIX1h5AaReK2c
         GvRhHaCNqpxfrc2bBFfc5QTA02gEGo8E1M9LEamA=
Subject: FAILED: patch "[PATCH] drm/amd/pm: update driver if header for smu_13_0_7" failed to apply to 6.0-stable tree
To:     Lyndon.Li@amd.com, Hawking.Zhang@amd.com,
        alexander.deucher@amd.com, evan.quan@amd.com, kenneth.feng@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 18:38:26 +0100
Message-ID: <166982990670159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f2e1aa267f12 ("drm/amd/pm: update driver if header for smu_13_0_7")
09aef0258a32 ("drm/amd/pm: update driver-if header for smu_v13_0_10")
8e039cd176c6 ("drm/amd/pm: add smu_v13_0_10 driver if version")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f2e1aa267f12b82e03927d1e918d2844ddd3eea5 Mon Sep 17 00:00:00 2001
From: lyndonli <Lyndon.Li@amd.com>
Date: Mon, 21 Nov 2022 09:08:42 +0800
Subject: [PATCH] drm/amd/pm: update driver if header for smu_13_0_7

update driver if header for smu_13_0_7

Signed-off-by: lyndonli <Lyndon.Li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h
index 25c08f963f49..d6b13933a98f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h
@@ -25,10 +25,10 @@
 
 // *** IMPORTANT ***
 // PMFW TEAM: Always increment the interface version on any change to this file
-#define SMU13_DRIVER_IF_VERSION  0x2C
+#define SMU13_DRIVER_IF_VERSION  0x35
 
 //Increment this version if SkuTable_t or BoardTable_t change
-#define PPTABLE_VERSION 0x20
+#define PPTABLE_VERSION 0x27
 
 #define NUM_GFXCLK_DPM_LEVELS    16
 #define NUM_SOCCLK_DPM_LEVELS    8
@@ -96,7 +96,7 @@
 #define FEATURE_MEM_TEMP_READ_BIT             47
 #define FEATURE_ATHUB_MMHUB_PG_BIT            48
 #define FEATURE_SOC_PCC_BIT                   49
-#define FEATURE_SPARE_50_BIT                  50
+#define FEATURE_EDC_PWRBRK_BIT                50
 #define FEATURE_SPARE_51_BIT                  51
 #define FEATURE_SPARE_52_BIT                  52
 #define FEATURE_SPARE_53_BIT                  53
@@ -282,15 +282,15 @@ typedef enum {
 } I2cControllerPort_e;
 
 typedef enum {
-  I2C_CONTROLLER_NAME_VR_GFX = 0,
-  I2C_CONTROLLER_NAME_VR_SOC,
-  I2C_CONTROLLER_NAME_VR_VMEMP,
-  I2C_CONTROLLER_NAME_VR_VDDIO,
-  I2C_CONTROLLER_NAME_LIQUID0,
-  I2C_CONTROLLER_NAME_LIQUID1,
-  I2C_CONTROLLER_NAME_PLX,
-  I2C_CONTROLLER_NAME_OTHER,
-  I2C_CONTROLLER_NAME_COUNT,
+	I2C_CONTROLLER_NAME_VR_GFX = 0,
+	I2C_CONTROLLER_NAME_VR_SOC,
+	I2C_CONTROLLER_NAME_VR_VMEMP,
+	I2C_CONTROLLER_NAME_VR_VDDIO,
+	I2C_CONTROLLER_NAME_LIQUID0,
+	I2C_CONTROLLER_NAME_LIQUID1,
+	I2C_CONTROLLER_NAME_PLX,
+	I2C_CONTROLLER_NAME_FAN_INTAKE,
+	I2C_CONTROLLER_NAME_COUNT,
 } I2cControllerName_e;
 
 typedef enum {
@@ -302,6 +302,7 @@ typedef enum {
   I2C_CONTROLLER_THROTTLER_LIQUID0,
   I2C_CONTROLLER_THROTTLER_LIQUID1,
   I2C_CONTROLLER_THROTTLER_PLX,
+  I2C_CONTROLLER_THROTTLER_FAN_INTAKE,
   I2C_CONTROLLER_THROTTLER_INA3221,
   I2C_CONTROLLER_THROTTLER_COUNT,
 } I2cControllerThrottler_e;
@@ -309,8 +310,9 @@ typedef enum {
 typedef enum {
   I2C_CONTROLLER_PROTOCOL_VR_XPDE132G5,
   I2C_CONTROLLER_PROTOCOL_VR_IR35217,
-  I2C_CONTROLLER_PROTOCOL_TMP_TMP102A,
+  I2C_CONTROLLER_PROTOCOL_TMP_MAX31875,
   I2C_CONTROLLER_PROTOCOL_INA3221,
+  I2C_CONTROLLER_PROTOCOL_TMP_MAX6604,
   I2C_CONTROLLER_PROTOCOL_COUNT,
 } I2cControllerProtocol_e;
 
@@ -690,6 +692,9 @@ typedef struct {
 #define PP_OD_FEATURE_UCLK_BIT      8
 #define PP_OD_FEATURE_ZERO_FAN_BIT      9
 #define PP_OD_FEATURE_TEMPERATURE_BIT 10
+#define PP_OD_FEATURE_POWER_FEATURE_CTRL_BIT 11
+#define PP_OD_FEATURE_ASIC_TDC_BIT 12
+#define PP_OD_FEATURE_COUNT 13
 
 typedef enum {
   PP_OD_POWER_FEATURE_ALWAYS_ENABLED,
@@ -697,6 +702,11 @@ typedef enum {
   PP_OD_POWER_FEATURE_ALWAYS_DISABLED,
 } PP_OD_POWER_FEATURE_e;
 
+typedef enum {
+  FAN_MODE_AUTO = 0,
+  FAN_MODE_MANUAL_LINEAR,
+} FanMode_e;
+
 typedef struct {
   uint32_t FeatureCtrlMask;
 
@@ -708,8 +718,8 @@ typedef struct {
   uint8_t                RuntimePwrSavingFeaturesCtrl;
 
   //Frequency changes
-  int16_t               GfxclkFmin;           // MHz
-  int16_t               GfxclkFmax;           // MHz
+  int16_t                GfxclkFmin;           // MHz
+  int16_t                GfxclkFmax;           // MHz
   uint16_t               UclkFmin;             // MHz
   uint16_t               UclkFmax;             // MHz
 
@@ -730,7 +740,12 @@ typedef struct {
   uint8_t                MaxOpTemp;
   uint8_t                Padding[4];
 
-  uint32_t               Spare[12];
+  uint16_t               GfxVoltageFullCtrlMode;
+  uint16_t               GfxclkFullCtrlMode;
+  uint16_t               UclkFullCtrlMode;
+  int16_t                AsicTdc;
+
+  uint32_t               Spare[10];
   uint32_t               MmHubPadding[8]; // SMU internal use. Adding here instead of external as a workaround
 } OverDriveTable_t;
 
@@ -748,8 +763,8 @@ typedef struct {
   uint8_t                IdlePwrSavingFeaturesCtrl;
   uint8_t                RuntimePwrSavingFeaturesCtrl;
 
-  uint16_t               GfxclkFmin;           // MHz
-  uint16_t               GfxclkFmax;           // MHz
+  int16_t                GfxclkFmin;           // MHz
+  int16_t                GfxclkFmax;           // MHz
   uint16_t               UclkFmin;             // MHz
   uint16_t               UclkFmax;             // MHz
 
@@ -769,7 +784,12 @@ typedef struct {
   uint8_t                MaxOpTemp;
   uint8_t                Padding[4];
 
-  uint32_t               Spare[12];
+  uint16_t               GfxVoltageFullCtrlMode;
+  uint16_t               GfxclkFullCtrlMode;
+  uint16_t               UclkFullCtrlMode;
+  int16_t                AsicTdc;
+
+  uint32_t               Spare[10];
 
 } OverDriveLimits_t;
 
@@ -903,7 +923,8 @@ typedef struct {
   uint16_t  FanStartTempMin;
   uint16_t  FanStartTempMax;
 
-  uint32_t Spare[12];
+  uint16_t  PowerMinPpt0[POWER_SOURCE_COUNT];
+  uint32_t  Spare[11];
 
 } MsgLimits_t;
 
@@ -1086,11 +1107,13 @@ typedef struct {
   uint32_t        GfxoffSpare[15];
 
   // GFX GPO
-  float           DfllBtcMasterScalerM;
+  uint32_t        DfllBtcMasterScalerM;
   int32_t         DfllBtcMasterScalerB;
-  float           DfllBtcSlaveScalerM;
+  uint32_t        DfllBtcSlaveScalerM;
   int32_t         DfllBtcSlaveScalerB;
-  uint32_t        GfxGpoSpare[12];
+  uint32_t        DfllPccAsWaitCtrl; //GDFLL_AS_WAIT_CTRL_PCC register value to be passed to RLC msg
+  uint32_t        DfllPccAsStepCtrl; //GDFLL_AS_STEP_CTRL_PCC register value to be passed to RLC msg
+  uint32_t        GfxGpoSpare[10];
 
   // GFX DCS
 
@@ -1106,7 +1129,10 @@ typedef struct {
   uint16_t        DcsTimeout;           //This is the amount of time SMU FW waits for RLC to put GFX into GFXOFF before reverting to the fallback mechanism of throttling GFXCLK to Fmin.
 
 
-  uint32_t        DcsSpare[16];
+  uint32_t        DcsSpare[14];
+
+  // UCLK section
+  uint16_t     ShadowFreqTableUclk[NUM_UCLK_DPM_LEVELS];     // In MHz
 
   // UCLK section
   uint8_t      UseStrobeModeOptimizations; //Set to indicate that FW should use strobe mode optimizations
@@ -1163,13 +1189,14 @@ typedef struct {
   uint16_t IntakeTempHighIntakeAcousticLimit;
   uint16_t IntakeTempAcouticLimitReleaseRate;
 
-  uint16_t FanStalledTempLimitOffset;
+  int16_t FanAbnormalTempLimitOffset;
   uint16_t FanStalledTriggerRpm;
-  uint16_t FanAbnormalTriggerRpm;
-  uint16_t FanPadding;
-
-  uint32_t     FanSpare[14];
+  uint16_t FanAbnormalTriggerRpmCoeff;
+  uint16_t FanAbnormalDetectionEnable;
 
+  uint8_t      FanIntakeSensorSupport;
+  uint8_t      FanIntakePadding[3];
+  uint32_t     FanSpare[13];
   // SECTION: VDD_GFX AVFS
 
   uint8_t      OverrideGfxAvfsFuses;
@@ -1193,7 +1220,6 @@ typedef struct {
   uint32_t   dGbV_dT_vmin;
   uint32_t   dGbV_dT_vmax;
 
-  //Unused: PMFW-9370
   uint32_t   V2F_vmin_range_low;
   uint32_t   V2F_vmin_range_high;
   uint32_t   V2F_vmax_range_low;
@@ -1238,8 +1264,21 @@ typedef struct {
   // SECTION: Advanced Options
   uint32_t          DebugOverrides;
 
+  // Section: Total Board Power idle vs active coefficients
+  uint8_t     TotalBoardPowerSupport;
+  uint8_t     TotalBoardPowerPadding[3];
+
+  int16_t     TotalIdleBoardPowerM;
+  int16_t     TotalIdleBoardPowerB;
+  int16_t     TotalBoardPowerM;
+  int16_t     TotalBoardPowerB;
+
+  QuadraticInt_t qFeffCoeffGameClock[POWER_SOURCE_COUNT];
+  QuadraticInt_t qFeffCoeffBaseClock[POWER_SOURCE_COUNT];
+  QuadraticInt_t qFeffCoeffBoostClock[POWER_SOURCE_COUNT];
+
   // SECTION: Sku Reserved
-  uint32_t         Spare[64];
+  uint32_t         Spare[43];
 
   // Padding for MMHUB - do not modify this
   uint32_t     MmHubPadding[8];
@@ -1304,7 +1343,8 @@ typedef struct {
   // SECTION: Clock Spread Spectrum
 
   // UCLK Spread Spectrum
-  uint16_t     UclkSpreadPadding;
+  uint8_t      UclkTrainingModeSpreadPercent; // Q4.4
+  uint8_t      UclkSpreadPadding;
   uint16_t     UclkSpreadFreq;      // kHz
 
   // UCLK Spread Spectrum
@@ -1317,11 +1357,7 @@ typedef struct {
 
   // Section: Memory Config
   uint8_t      DramWidth; // Width of interface to the channel for each DRAM module. See DRAM_BIT_WIDTH_TYPE_e
-  uint8_t      PaddingMem1[3];
-
-  // Section: Total Board Power
-  uint16_t     TotalBoardPower;     //Only needed for TCP Estimated case, where TCP = TGP+Total Board Power
-  uint16_t     BoardPowerPadding;
+  uint8_t      PaddingMem1[7];
 
   // SECTION: UMC feature flags
   uint8_t      HsrEnabled;
@@ -1423,8 +1459,11 @@ typedef struct {
   uint16_t Vcn1ActivityPercentage  ;
 
   uint32_t EnergyAccumulator;
-  uint16_t AverageSocketPower    ;
+  uint16_t AverageSocketPower;
+  uint16_t AverageTotalBoardPower;
+
   uint16_t AvgTemperature[TEMP_COUNT];
+  uint16_t AvgTemperatureFanIntake;
 
   uint8_t  PcieRate               ;
   uint8_t  PcieWidth              ;
@@ -1592,5 +1631,7 @@ typedef struct {
 #define IH_INTERRUPT_CONTEXT_ID_AUDIO_D0            0x5
 #define IH_INTERRUPT_CONTEXT_ID_AUDIO_D3            0x6
 #define IH_INTERRUPT_CONTEXT_ID_THERMAL_THROTTLING  0x7
+#define IH_INTERRUPT_CONTEXT_ID_FAN_ABNORMAL        0x8
+#define IH_INTERRUPT_CONTEXT_ID_FAN_RECOVERY        0x9
 
 #endif
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index b7f4569aff2a..865d6358918d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -31,7 +31,7 @@
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x07
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_5 0x04
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10 0x32
-#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_7 0x2C
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_7 0x35
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_10 0x1D
 
 #define SMU13_MODE1_RESET_WAIT_TIME_IN_MS 500  //500ms

