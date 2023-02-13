Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A853694949
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjBMO6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbjBMO6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E281CAEB
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:57:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9131B8125E
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A69AC433EF;
        Mon, 13 Feb 2023 14:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300212;
        bh=Tihgh/mylCqlA7TzAXHgKBJZFsdP2JWzcIoW0QcXx48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jb7kMfj9+JtBQ133CZBGc/eVe58DI7E+W+fUF+jqf0lW8wJXzW85yjFoCYWvyITzP
         l1WfCo3/2f+/DpMN5YJRFm2FwPWZvZyMA4nMiv71tJ6yaHYawUW5XnQ3P8V1CyeQ+G
         l/26+vxQw3x3suGVULIqQ+fIpH0MOOx1PKC9DG/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Guchun Chen <guchun.chen@amd.com>
Subject: [PATCH 6.1 107/114] drm/amd/pm: bump SMU 13.0.7 driver_if header version
Date:   Mon, 13 Feb 2023 15:49:02 +0100
Message-Id: <20230213144747.739802174@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

commit dc38b996db968f51f0fe45845a519c5cd7f6bd04 upstream.

This can suppress the warning caused by version mismatch.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../inc/pmfw_if/smu13_driver_if_v13_0_7.h     | 29 ++++++++++---------
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h  |  2 +-
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h
index d6b13933a98f..48a3a3952ceb 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_7.h
@@ -113,20 +113,21 @@
 #define NUM_FEATURES                          64
 
 #define ALLOWED_FEATURE_CTRL_DEFAULT 0xFFFFFFFFFFFFFFFFULL
-#define ALLOWED_FEATURE_CTRL_SCPM        (1 << FEATURE_DPM_GFXCLK_BIT) | \
-                                         (1 << FEATURE_DPM_GFX_POWER_OPTIMIZER_BIT) | \
-                                         (1 << FEATURE_DPM_UCLK_BIT) | \
-                                         (1 << FEATURE_DPM_FCLK_BIT) | \
-                                         (1 << FEATURE_DPM_SOCCLK_BIT) | \
-                                         (1 << FEATURE_DPM_MP0CLK_BIT) | \
-                                         (1 << FEATURE_DPM_LINK_BIT) | \
-                                         (1 << FEATURE_DPM_DCN_BIT) | \
-                                         (1 << FEATURE_DS_GFXCLK_BIT) | \
-                                         (1 << FEATURE_DS_SOCCLK_BIT) | \
-                                         (1 << FEATURE_DS_FCLK_BIT) | \
-                                         (1 << FEATURE_DS_LCLK_BIT) | \
-                                         (1 << FEATURE_DS_DCFCLK_BIT) | \
-                                         (1 << FEATURE_DS_UCLK_BIT)
+#define ALLOWED_FEATURE_CTRL_SCPM	((1 << FEATURE_DPM_GFXCLK_BIT) | \
+					(1 << FEATURE_DPM_GFX_POWER_OPTIMIZER_BIT) | \
+					(1 << FEATURE_DPM_UCLK_BIT) | \
+					(1 << FEATURE_DPM_FCLK_BIT) | \
+					(1 << FEATURE_DPM_SOCCLK_BIT) | \
+					(1 << FEATURE_DPM_MP0CLK_BIT) | \
+					(1 << FEATURE_DPM_LINK_BIT) | \
+					(1 << FEATURE_DPM_DCN_BIT) | \
+					(1 << FEATURE_DS_GFXCLK_BIT) | \
+					(1 << FEATURE_DS_SOCCLK_BIT) | \
+					(1 << FEATURE_DS_FCLK_BIT) | \
+					(1 << FEATURE_DS_LCLK_BIT) | \
+					(1 << FEATURE_DS_DCFCLK_BIT) | \
+					(1 << FEATURE_DS_UCLK_BIT) | \
+					(1ULL << FEATURE_DS_VCN_BIT))
 
 //For use with feature control messages
 typedef enum {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index d9c4821bcfc8..992163e66f7b 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -32,7 +32,7 @@
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x07
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_5 0x04
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10 0x32
-#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_7 0x35
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_7 0x37
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_10 0x1D
 
 #define SMU13_MODE1_RESET_WAIT_TIME_IN_MS 500  //500ms
-- 
2.39.1



