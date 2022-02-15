Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188574B7073
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236003AbiBOP3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:29:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239988AbiBOP2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:28:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9893AA2ED;
        Tue, 15 Feb 2022 07:28:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F6E8B81AEC;
        Tue, 15 Feb 2022 15:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D61C340EB;
        Tue, 15 Feb 2022 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644938883;
        bh=GN4rx9+/uSWbncndIG5kZ/xPlZ2HAEnyxXgODofDk6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6m4lrGOW+0esOm9S7e2wU04IW+fm74AWmfd2XpnXnwSEBujj/+P1/U6ikf+I82Mt
         QorO8HfCWjWPvClGsGayWD4qVreJUNousXRPNEU1Zvc2BKTlp7Mx0rt2LoMFp9hRLJ
         WQyOs/Yz8Kzy4dTc8D3Rh6SLBstWSSamQWDGaYpqmD27/MuPKKygl+e7UqfuoJjL7n
         4W7LNAph6fnupfbpxw3pMeWPUNtZ5fiSNyuDAHoXZMhHsTxz8QSRCCKTbldxXOD9nW
         1Jeho8MUglVLfw5VyUBHhhi7eBFVtDDSf3bZa2F9Cy1TjoLkEOqshcmpidbngVqAv6
         /a3gL615vSK/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Liu <aaron.liu@amd.com>, Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, Oak.Zeng@amd.com, Xiaomeng.Hou@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 29/34] drm/amdgpu: add utcl2_harvest to gc 10.3.1
Date:   Tue, 15 Feb 2022 10:26:52 -0500
Message-Id: <20220215152657.580200-29-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215152657.580200-1-sashal@kernel.org>
References: <20220215152657.580200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Liu <aaron.liu@amd.com>

[ Upstream commit a072312f43c33ea02ad88bff3375f650684a6f24 ]

Confirmed with hardware team, there is harvesting for gc 10.3.1.

Signed-off-by: Aaron Liu <aaron.liu@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_1.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfxhub_v2_1.c b/drivers/gpu/drm/amd/amdgpu/gfxhub_v2_1.c
index b4eddf6e98a6a..ff738e9725ee8 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfxhub_v2_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfxhub_v2_1.c
@@ -543,7 +543,9 @@ static void gfxhub_v2_1_utcl2_harvest(struct amdgpu_device *adev)
 		adev->gfx.config.max_sh_per_se *
 		adev->gfx.config.max_shader_engines);
 
-	if (adev->ip_versions[GC_HWIP][0] == IP_VERSION(10, 3, 3)) {
+	switch (adev->ip_versions[GC_HWIP][0]) {
+	case IP_VERSION(10, 3, 1):
+	case IP_VERSION(10, 3, 3):
 		/* Get SA disabled bitmap from eFuse setting */
 		efuse_setting = RREG32_SOC15(GC, 0, mmCC_GC_SA_UNIT_DISABLE);
 		efuse_setting &= CC_GC_SA_UNIT_DISABLE__SA_DISABLE_MASK;
@@ -566,6 +568,9 @@ static void gfxhub_v2_1_utcl2_harvest(struct amdgpu_device *adev)
 		disabled_sa = tmp;
 
 		WREG32_SOC15(GC, 0, mmGCUTCL2_HARVEST_BYPASS_GROUPS_YELLOW_CARP, disabled_sa);
+		break;
+	default:
+		break;
 	}
 }
 
-- 
2.34.1

