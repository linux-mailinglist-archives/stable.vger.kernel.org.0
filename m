Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143746280A1
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbiKNNHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237864AbiKNNHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:07:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700482AE2D
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:07:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01EB46116E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C9EC433D6;
        Mon, 14 Nov 2022 13:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431248;
        bh=mvFdGgjn8zYp7A7xzeSt2jWzAKWYCgs7eDNoq38LvSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmRPwLVloruOVF18yY2eis0g8SgbT3Kz0XECijTSDO6ksFpHxy0yqJ4sfPF8NuqUl
         CV+ivRIUt82GMXWkfHYF3Nx+nmYgTxLojRSAOFNeowZPeZ3X/LvVqtN+p0j9wF5v0Q
         6LBVHUgu5ypSpBP3mvIflAwEAVJm1KQrXdLWCetE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        Tim Huang <tim.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Yifan Zhang <yifan1.zhang@amd.com>
Subject: [PATCH 6.0 138/190] drm/amd/pm: update SMU IP v13.0.4 msg interface header
Date:   Mon, 14 Nov 2022 13:46:02 +0100
Message-Id: <20221114124504.837818284@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Huang <tim.huang@amd.com>

commit bc66c9ab162d2a633ee3eb864d7bc2369e79c1e4 upstream.

Some of the unused messages that were used earlier in development have
been freed up as spare messages, no intended functional changes.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Tim Huang <tim.huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../amd/pm/swsmu/inc/pmfw_if/smu_v13_0_4_ppsmc.h  | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu_v13_0_4_ppsmc.h b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu_v13_0_4_ppsmc.h
index d9b0cd752200..f4d6c07b56ea 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu_v13_0_4_ppsmc.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu_v13_0_4_ppsmc.h
@@ -54,14 +54,14 @@
 #define PPSMC_MSG_TestMessage                   0x01 ///< To check if PMFW is alive and responding. Requirement specified by PMFW team
 #define PPSMC_MSG_GetPmfwVersion                0x02 ///< Get PMFW version
 #define PPSMC_MSG_GetDriverIfVersion            0x03 ///< Get PMFW_DRIVER_IF version
-#define PPSMC_MSG_EnableGfxOff                  0x04 ///< Enable GFXOFF
-#define PPSMC_MSG_DisableGfxOff                 0x05 ///< Disable GFXOFF
+#define PPSMC_MSG_SPARE0                        0x04 ///< SPARE
+#define PPSMC_MSG_SPARE1                        0x05 ///< SPARE
 #define PPSMC_MSG_PowerDownVcn                  0x06 ///< Power down VCN
 #define PPSMC_MSG_PowerUpVcn                    0x07 ///< Power up VCN; VCN is power gated by default
 #define PPSMC_MSG_SetHardMinVcn                 0x08 ///< For wireless display
 #define PPSMC_MSG_SetSoftMinGfxclk              0x09 ///< Set SoftMin for GFXCLK, argument is frequency in MHz
-#define PPSMC_MSG_ActiveProcessNotify           0x0A ///< Needs update
-#define PPSMC_MSG_ForcePowerDownGfx             0x0B ///< Force power down GFX, i.e. enter GFXOFF
+#define PPSMC_MSG_SPARE2                        0x0A ///< SPARE
+#define PPSMC_MSG_SPARE3                        0x0B ///< SPARE
 #define PPSMC_MSG_PrepareMp1ForUnload           0x0C ///< Prepare PMFW for GFX driver unload
 #define PPSMC_MSG_SetDriverDramAddrHigh         0x0D ///< Set high 32 bits of DRAM address for Driver table transfer
 #define PPSMC_MSG_SetDriverDramAddrLow          0x0E ///< Set low 32 bits of DRAM address for Driver table transfer
@@ -73,8 +73,7 @@
 #define PPSMC_MSG_SetSoftMinFclk                0x14 ///< Set hard min for FCLK
 #define PPSMC_MSG_SetSoftMinVcn                 0x15 ///< Set soft min for VCN clocks (VCLK and DCLK)
 
-
-#define PPSMC_MSG_EnableGfxImu                  0x16 ///< Needs update
+#define PPSMC_MSG_EnableGfxImu                  0x16 ///< Enable GFX IMU
 
 #define PPSMC_MSG_GetGfxclkFrequency            0x17 ///< Get GFX clock frequency
 #define PPSMC_MSG_GetFclkFrequency              0x18 ///< Get FCLK frequency
@@ -102,8 +101,8 @@
 #define PPSMC_MSG_SetHardMinIspxclkByFreq       0x2C ///< Set HardMin by frequency for ISPXCLK
 #define PPSMC_MSG_PowerDownUmsch                0x2D ///< Power down VCN.UMSCH (aka VSCH) scheduler
 #define PPSMC_MSG_PowerUpUmsch                  0x2E ///< Power up VCN.UMSCH (aka VSCH) scheduler
-#define PPSMC_Message_IspStutterOn_MmhubPgDis   0x2F ///< ISP StutterOn mmHub PgDis
-#define PPSMC_Message_IspStutterOff_MmhubPgEn   0x30 ///< ISP StufferOff mmHub PgEn
+#define PPSMC_MSG_IspStutterOn_MmhubPgDis       0x2F ///< ISP StutterOn mmHub PgDis
+#define PPSMC_MSG_IspStutterOff_MmhubPgEn       0x30 ///< ISP StufferOff mmHub PgEn
 
 #define PPSMC_Message_Count                     0x31 ///< Total number of PPSMC messages
 /** @}*/
-- 
2.38.1



