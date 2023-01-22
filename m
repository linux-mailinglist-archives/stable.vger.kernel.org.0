Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8021567701F
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjAVP2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjAVP2q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:28:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B943014EAE
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:28:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5570660C43
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6E4C433D2;
        Sun, 22 Jan 2023 15:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401324;
        bh=q8RxaKkZa3z1jD5IgvM8AuYwwoNN7WtEjrjvuHUlLYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=un9fK4jbbFfJGDRJv0lsc1yu3g9jtJpLDRlBdJ3DTMYdzrHC+xZAGj96HWJLj+dA9
         wmOqHxq4Ep2yi9e28YWWrxzC2Esug+ZM6B4sNMl9nC4Db5EIvXI+BY3GgVjhQGQ4D3
         F2RgJUYw62ITu3WMCgynbalQ9IjOxsbrZOhu5njw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yifan Zhang <yifan1.zhang@amd.com>,
        Aaron Liu <aaron.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 167/193] drm/amdgpu: add gfx support for GC 11.0.4
Date:   Sun, 22 Jan 2023 16:04:56 +0100
Message-Id: <20230122150254.041225679@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

commit 1763cb65e870e783e26d2dc9def4edbeadcb1050 upstream.

this patch to add GC 11.0.4 gfx support to gfx11 implementation.

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -77,6 +77,10 @@ MODULE_FIRMWARE("amdgpu/gc_11_0_3_pfp.bi
 MODULE_FIRMWARE("amdgpu/gc_11_0_3_me.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_3_mec.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_3_rlc.bin");
+MODULE_FIRMWARE("amdgpu/gc_11_0_4_pfp.bin");
+MODULE_FIRMWARE("amdgpu/gc_11_0_4_me.bin");
+MODULE_FIRMWARE("amdgpu/gc_11_0_4_mec.bin");
+MODULE_FIRMWARE("amdgpu/gc_11_0_4_rlc.bin");
 
 static const struct soc15_reg_golden golden_settings_gc_11_0_1[] =
 {
@@ -262,6 +266,7 @@ static void gfx_v11_0_init_golden_regist
 {
 	switch (adev->ip_versions[GC_HWIP][0]) {
 	case IP_VERSION(11, 0, 1):
+	case IP_VERSION(11, 0, 4):
 		soc15_program_register_sequence(adev,
 						golden_settings_gc_11_0_1,
 						(const u32)ARRAY_SIZE(golden_settings_gc_11_0_1));
@@ -856,6 +861,7 @@ static int gfx_v11_0_gpu_early_init(stru
 		adev->gfx.config.sc_earlyz_tile_fifo_size = 0x4C0;
 		break;
 	case IP_VERSION(11, 0, 1):
+	case IP_VERSION(11, 0, 4):
 		adev->gfx.config.max_hw_contexts = 8;
 		adev->gfx.config.sc_prim_fifo_size_frontend = 0x20;
 		adev->gfx.config.sc_prim_fifo_size_backend = 0x100;
@@ -1285,6 +1291,7 @@ static int gfx_v11_0_sw_init(void *handl
 	case IP_VERSION(11, 0, 1):
 	case IP_VERSION(11, 0, 2):
 	case IP_VERSION(11, 0, 3):
+	case IP_VERSION(11, 0, 4):
 		adev->gfx.me.num_me = 1;
 		adev->gfx.me.num_pipe_per_me = 1;
 		adev->gfx.me.num_queue_per_pipe = 1;
@@ -2486,7 +2493,8 @@ static int gfx_v11_0_wait_for_rlc_autolo
 	for (i = 0; i < adev->usec_timeout; i++) {
 		cp_status = RREG32_SOC15(GC, 0, regCP_STAT);
 
-		if (adev->ip_versions[GC_HWIP][0] == IP_VERSION(11, 0, 1))
+		if (adev->ip_versions[GC_HWIP][0] == IP_VERSION(11, 0, 1) ||
+				adev->ip_versions[GC_HWIP][0] == IP_VERSION(11, 0, 4))
 			bootload_status = RREG32_SOC15(GC, 0,
 					regRLC_RLCS_BOOTLOAD_STATUS_gc_11_0_1);
 		else


