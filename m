Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7896665D9C2
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239884AbjADQ2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240064AbjADQ2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:28:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F6048588
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:27:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FE38617A7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F05C433D2;
        Wed,  4 Jan 2023 16:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849662;
        bh=drLKn6ZLvpKRLw13uMuR29If7WKKAE1CG5y4kyxR0lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SuFGVOCsjjY1HHwPXk+ImPSjAqAZ/uQjgH5OxxzYAO21u2w5XuCiqW2MPAx0/zMYV
         mS5sgPgMmBTpN2nvBuHQA3XUliAulqQtRG9Lrt4DSGLeofudhlAkr+UzNnm1UDU2wH
         GcX4CwgzhQviJs1Lt4ElUC9eC6d1FEMftweawlBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 176/177] drm/amd/pm: bump SMU13.0.0 driver_if header to version 0x34
Date:   Wed,  4 Jan 2023 17:07:47 +0100
Message-Id: <20230104160513.020486685@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Evan Quan <evan.quan@amd.com>

commit 272b981416f8be0180c4d8066f90635fa7c1c501 upstream.

To fit the latest PMFW and suppress the warning emerged on driver loading.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0, 6.1
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h |    2 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h                       |    1 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c                     |    2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
@@ -522,9 +522,9 @@ typedef enum  {
   TEMP_HOTSPOT_M,
   TEMP_MEM,
   TEMP_VR_GFX,
+  TEMP_VR_SOC,
   TEMP_VR_MEM0,
   TEMP_VR_MEM1,
-  TEMP_VR_SOC,
   TEMP_VR_U,
   TEMP_LIQUID0,
   TEMP_LIQUID1,
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -28,6 +28,7 @@
 #define SMU13_DRIVER_IF_VERSION_INV 0xFFFFFFFF
 #define SMU13_DRIVER_IF_VERSION_YELLOW_CARP 0x04
 #define SMU13_DRIVER_IF_VERSION_ALDE 0x08
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_0 0x34
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x07
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_5 0x04
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10 0x32
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -288,6 +288,8 @@ int smu_v13_0_check_fw_version(struct sm
 		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_ALDE;
 		break;
 	case IP_VERSION(13, 0, 0):
+		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_0;
+		break;
 	case IP_VERSION(13, 0, 10):
 		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10;
 		break;


