Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAFC2D9989
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgLNOON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 09:14:13 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:34257 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440033AbgLNOOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 09:14:03 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9B3931942821;
        Mon, 14 Dec 2020 09:12:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 14 Dec 2020 09:12:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RmeGjz
        SoGrfa9o+kh74l6d4Rp5dcCqSYvENWQb+belE=; b=gWvMLLZAu2fBNzuTaXKo5W
        OIlWeEBmycHg3psv57juVVpv47S60+xlZK2AaWSRSGbkdAf65yosGvxoTdu95/w3
        EHwGyiHnLTUqY9zRv8aVpajse1k57ZV52KWOUOf+Hn44exyLgjj3Bfp7OFWe6O/L
        ZJx3V/meiV9HLiPvrnb/XWu1LSo6LOWGllIZefYDXmfXulNDDYs/kSsBOtlgcfM1
        eHisvlR1hI1IfaolGQF9/ie2jt/goKkRaRpPEEKffxGqsY5AGaQrk6VKBTXfJdcl
        /WbDPXNW2LByXdURHrN8pbD1qoUet3NkxtLtLO1bPmiwaEnNMOmatAn4msIhLx9w
        ==
X-ME-Sender: <xms:6HLXX1h1sWnzMcsF3xv-FjNu2PpIseUQZM9cBy4qssy4-lIwInYHlQ>
    <xme:6HLXX6AiEjXDNGDcIwB77kl6hb9kcyrijMtlJ2m4eD7JZGsjHtWhWHRpcsPaos653
    FRs2H3S7T4b3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:6HLXX1HWtIYeDUWuN25_GOCUQiA0tsP-yqgjZURTrtEK7wHiFIHyvg>
    <xmx:6HLXX6RyG-llhSVHIIjuMg3EA7V-p2iwoSSXZeax90hpUCucCPKFbw>
    <xmx:6HLXXyzsIg00cYIC9axhvxIb-uoYPRZzvoQ2DBuKY-BB5uP09f5MAw>
    <xmx:6HLXX4YMbh9B562sqb0VN3sCpWS4wWg-d-SSBybynephJKNpZ8r7pg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E4781108005F;
        Mon, 14 Dec 2020 09:12:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu/powerplay: parse fan table for CI asics" failed to apply to 5.9-stable tree
To:     alexander.deucher@amd.com, evan.quan@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:14:01 +0100
Message-ID: <160795524117651@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0e830d2872cf6e75ef6619edd23050ddf3673358 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Tue, 1 Dec 2020 17:44:58 -0500
Subject: [PATCH] drm/amdgpu/powerplay: parse fan table for CI asics

Set up all the parameters required for SMU fan control if supported.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=201539
Acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
index 719597c5d27d..6606511891e3 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
@@ -24,6 +24,8 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/pci.h>
+
 #include <drm/amdgpu_drm.h>
 #include "processpptables.h"
 #include <atom-types.h>
@@ -984,6 +986,8 @@ static int init_thermal_controller(
 			struct pp_hwmgr *hwmgr,
 			const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
+	struct amdgpu_device *adev = hwmgr->adev;
+
 	hwmgr->thermal_controller.ucType =
 			powerplay_table->sThermalController.ucType;
 	hwmgr->thermal_controller.ucI2cLine =
@@ -1008,7 +1012,104 @@ static int init_thermal_controller(
 		   ATOM_PP_THERMALCONTROLLER_NONE != hwmgr->thermal_controller.ucType,
 		   PHM_PlatformCaps_ThermalController);
 
-	hwmgr->thermal_controller.use_hw_fan_control = 1;
+        if (powerplay_table->usTableSize >= sizeof(ATOM_PPLIB_POWERPLAYTABLE3)) {
+		const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3 =
+			(const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
+
+		if (0 == le16_to_cpu(powerplay_table3->usFanTableOffset)) {
+			hwmgr->thermal_controller.use_hw_fan_control = 1;
+			return 0;
+		} else {
+			const ATOM_PPLIB_FANTABLE *fan_table =
+				(const ATOM_PPLIB_FANTABLE *)(((unsigned long)powerplay_table) +
+							      le16_to_cpu(powerplay_table3->usFanTableOffset));
+
+			if (1 <= fan_table->ucFanTableFormat) {
+				hwmgr->thermal_controller.advanceFanControlParameters.ucTHyst =
+					fan_table->ucTHyst;
+				hwmgr->thermal_controller.advanceFanControlParameters.usTMin =
+					le16_to_cpu(fan_table->usTMin);
+				hwmgr->thermal_controller.advanceFanControlParameters.usTMed =
+					le16_to_cpu(fan_table->usTMed);
+				hwmgr->thermal_controller.advanceFanControlParameters.usTHigh =
+					le16_to_cpu(fan_table->usTHigh);
+				hwmgr->thermal_controller.advanceFanControlParameters.usPWMMin =
+					le16_to_cpu(fan_table->usPWMMin);
+				hwmgr->thermal_controller.advanceFanControlParameters.usPWMMed =
+					le16_to_cpu(fan_table->usPWMMed);
+				hwmgr->thermal_controller.advanceFanControlParameters.usPWMHigh =
+					le16_to_cpu(fan_table->usPWMHigh);
+				hwmgr->thermal_controller.advanceFanControlParameters.usTMax = 10900;
+				hwmgr->thermal_controller.advanceFanControlParameters.ulCycleDelay = 100000;
+
+				phm_cap_set(hwmgr->platform_descriptor.platformCaps,
+					    PHM_PlatformCaps_MicrocodeFanControl);
+			}
+
+			if (2 <= fan_table->ucFanTableFormat) {
+				const ATOM_PPLIB_FANTABLE2 *fan_table2 =
+					(const ATOM_PPLIB_FANTABLE2 *)(((unsigned long)powerplay_table) +
+								       le16_to_cpu(powerplay_table3->usFanTableOffset));
+				hwmgr->thermal_controller.advanceFanControlParameters.usTMax =
+					le16_to_cpu(fan_table2->usTMax);
+			}
+
+			if (3 <= fan_table->ucFanTableFormat) {
+				const ATOM_PPLIB_FANTABLE3 *fan_table3 =
+					(const ATOM_PPLIB_FANTABLE3 *) (((unsigned long)powerplay_table) +
+									le16_to_cpu(powerplay_table3->usFanTableOffset));
+
+				hwmgr->thermal_controller.advanceFanControlParameters.ucFanControlMode =
+					fan_table3->ucFanControlMode;
+
+				if ((3 == fan_table->ucFanTableFormat) &&
+				    (0x67B1 == adev->pdev->device))
+					hwmgr->thermal_controller.advanceFanControlParameters.usDefaultMaxFanPWM =
+						47;
+				else
+					hwmgr->thermal_controller.advanceFanControlParameters.usDefaultMaxFanPWM =
+						le16_to_cpu(fan_table3->usFanPWMMax);
+
+				hwmgr->thermal_controller.advanceFanControlParameters.usDefaultFanOutputSensitivity =
+					4836;
+				hwmgr->thermal_controller.advanceFanControlParameters.usFanOutputSensitivity =
+					le16_to_cpu(fan_table3->usFanOutputSensitivity);
+			}
+
+			if (6 <= fan_table->ucFanTableFormat) {
+				const ATOM_PPLIB_FANTABLE4 *fan_table4 =
+					(const ATOM_PPLIB_FANTABLE4 *)(((unsigned long)powerplay_table) +
+								       le16_to_cpu(powerplay_table3->usFanTableOffset));
+
+				phm_cap_set(hwmgr->platform_descriptor.platformCaps,
+					    PHM_PlatformCaps_FanSpeedInTableIsRPM);
+
+				hwmgr->thermal_controller.advanceFanControlParameters.usDefaultMaxFanRPM =
+					le16_to_cpu(fan_table4->usFanRPMMax);
+			}
+
+			if (7 <= fan_table->ucFanTableFormat) {
+				const ATOM_PPLIB_FANTABLE5 *fan_table5 =
+					(const ATOM_PPLIB_FANTABLE5 *)(((unsigned long)powerplay_table) +
+								       le16_to_cpu(powerplay_table3->usFanTableOffset));
+
+				if (0x67A2 == adev->pdev->device ||
+				    0x67A9 == adev->pdev->device ||
+				    0x67B9 == adev->pdev->device) {
+					phm_cap_set(hwmgr->platform_descriptor.platformCaps,
+						    PHM_PlatformCaps_GeminiRegulatorFanControlSupport);
+					hwmgr->thermal_controller.advanceFanControlParameters.usFanCurrentLow =
+						le16_to_cpu(fan_table5->usFanCurrentLow);
+					hwmgr->thermal_controller.advanceFanControlParameters.usFanCurrentHigh =
+						le16_to_cpu(fan_table5->usFanCurrentHigh);
+					hwmgr->thermal_controller.advanceFanControlParameters.usFanRPMLow =
+						le16_to_cpu(fan_table5->usFanRPMLow);
+					hwmgr->thermal_controller.advanceFanControlParameters.usFanRPMHigh =
+						le16_to_cpu(fan_table5->usFanRPMHigh);
+				}
+			}
+		}
+	}
 
 	return 0;
 }

