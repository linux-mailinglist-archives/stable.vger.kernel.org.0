Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABF660A1A9
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiJXLcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiJXLb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:31:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F88955C58;
        Mon, 24 Oct 2022 04:31:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BB6C6125D;
        Mon, 24 Oct 2022 11:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F441C433C1;
        Mon, 24 Oct 2022 11:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611110;
        bh=pA708DfDAlUs9/8gMiAzDR60U/q1IY8dcr1tgyu+yFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBBJJXLxWGB5ZKRU7hJnDalV/cSFwKv/BvSh361z4uoYcDV2ORhZl81wlprhK6jHv
         rTnZNPZF7Z59sis5ZJBLgrl5gkXR5/mj8sXhXLZyxJ34s9nxE9V4x/vkB84jXP1Dk3
         WnfUqc9KxzzPyj78JHOQtSdhQY7sV/0LcpSmqyis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Huang <tim.huang@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 13/20] drm/amd/pm: update SMU IP v13.0.4 driver interface version
Date:   Mon, 24 Oct 2022 13:31:15 +0200
Message-Id: <20221024112934.963501610@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
References: <20221024112934.415391158@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Huang <tim.huang@amd.com>

commit 853fdb49160e9c30674fd8e4a2eabc06bf70b13a upstream.

Update the SMU driver interface version to V7.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_4.h |   17 ++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

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


