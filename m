Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0EDD65D639
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbjADOmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239662AbjADOmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:42:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915E637385
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:42:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FBFDB81694
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB5CC433F1;
        Wed,  4 Jan 2023 14:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843322;
        bh=0YXnPqmiSZ0a/lJyvbQRbF4R2gWPWqLAI152hUS+pkA=;
        h=Subject:To:Cc:From:Date:From;
        b=zr3l5e4yjcd2O3XSlY+VtxL6olAfIyzbz4Kaou3Vo2jXXaLOakaT9DpiCnKv/PFwl
         LmwOf82IWhSWzC+eWKLQXsTSsO4hUYqsU2mfphq4afHBKscqOUh2R5TrVyGoFj8AN7
         Pufl3hKWh5dNc4SGgWBx2XPeDIN+/PuwDrAvSCs0=
Subject: FAILED: patch "[PATCH] drm/amd/pm: update SMU IP v13.0.4 driver interface version" failed to apply to 6.1-stable tree
To:     tim.huang@amd.com, alexander.deucher@amd.com,
        mario.limonciello@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:41:52 +0100
Message-ID: <1672843312191182@kroah.com>
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


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

d1bb3afc0527 ("drm/amd/pm: update SMU IP v13.0.4 driver interface version")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d1bb3afc0527ab55d118852b398fd0f1d2fe802d Mon Sep 17 00:00:00 2001
From: Tim Huang <tim.huang@amd.com>
Date: Thu, 29 Sep 2022 14:39:21 +0800
Subject: [PATCH] drm/amd/pm: update SMU IP v13.0.4 driver interface version

Update the SMU driver interface version to V7.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h
index ae2d337158f3..f77401709d83 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h
@@ -27,7 +27,7 @@
 // *** IMPORTANT ***
 // SMU TEAM: Always increment the interface version if
 // any structure is changed in this file
-#define PMFW_DRIVER_IF_VERSION 5
+#define PMFW_DRIVER_IF_VERSION 7
 
 typedef struct {
   int32_t value;
@@ -163,8 +163,8 @@ typedef struct {
   uint16_t DclkFrequency;               //[MHz]
   uint16_t MemclkFrequency;             //[MHz]
   uint16_t spare;                       //[centi]
-  uint16_t UvdActivity;                 //[centi]
   uint16_t GfxActivity;                 //[centi]
+  uint16_t UvdActivity;                 //[centi]
 
   uint16_t Voltage[2];                  //[mV] indices: VDDCR_VDD, VDDCR_SOC
   uint16_t Current[2];                  //[mA] indices: VDDCR_VDD, VDDCR_SOC
@@ -199,6 +199,19 @@ typedef struct {
   uint16_t DeviceState;
   uint16_t CurTemp;                     //[centi-Celsius]
   uint16_t spare2;
+
+  uint16_t AverageGfxclkFrequency;
+  uint16_t AverageFclkFrequency;
+  uint16_t AverageGfxActivity;
+  uint16_t AverageSocclkFrequency;
+  uint16_t AverageVclkFrequency;
+  uint16_t AverageVcnActivity;
+  uint16_t AverageDRAMReads;          //Filtered DF Bandwidth::DRAM Reads
+  uint16_t AverageDRAMWrites;         //Filtered DF Bandwidth::DRAM Writes
+  uint16_t AverageSocketPower;        //Filtered value of CurrentSocketPower
+  uint16_t AverageCorePower;          //Filtered of [sum of CorePower[8]])
+  uint16_t AverageCoreC0Residency[8]; //Filtered of [average C0 residency %  per core]
+  uint32_t MetricsCounter;            //Counts the # of metrics table parameter reads per update to the metrics table, i.e. if the metrics table update happens every 1 second, this value could be up to 1000 if the smu collected metrics data every cycle, or as low as 0 if the smu was asleep the whole time. Reset to 0 after writing.
 } SmuMetrics_t;
 
 typedef struct {

