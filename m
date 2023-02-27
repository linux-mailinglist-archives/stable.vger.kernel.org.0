Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E006A3652
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjB0CBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjB0CBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:01:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D979C12868;
        Sun, 26 Feb 2023 18:00:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CC1460CA3;
        Mon, 27 Feb 2023 02:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78E1C4339E;
        Mon, 27 Feb 2023 02:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463258;
        bh=yDEmqvxwsg0vE2JAlr2G8lYxZpQza/IUr6UE/jPyzYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GK8uIQcy3rgE5Qb/jwnYzAuF6y/PnylBW/nyN6fFjd5MdxLQzBvSJ/SACD2a+QW0z
         QiIyG+Y3BdIuiDkNoRaM7VwjvrPfMEQ8tDavgiBrBXFsydTKbQ6KZk6hEEqeJWHlzy
         CrqEgAVRMWZqzFYIUUA0A9sqzcBPj4jLn0TTtodZZk+fJVr5l7Bv3V6p013AIj1kiV
         Vc+QQAE9h1NvrTgYD3hGWZeVMpf6KNrjDiq6Roq0l/srsBNmY87q6aQIDIdXxvQjjl
         alnYw/Zd8Q/X3QAJU1+3wJJV3IWlAyivOmKgR4GQ5tINTxL+saV/ClYU+DPZ/NfeR8
         x8WDz1PzBiPAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dillon Varone <Dillon.Varone@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, alvin.lee2@amd.com, george.shen@amd.com,
        Samson.Tam@amd.com, yang.lee@linux.alibaba.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 03/60] drm/amd/display: Reduce expected sdp bandwidth for dcn321
Date:   Sun, 26 Feb 2023 20:59:48 -0500
Message-Id: <20230227020045.1045105-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dillon Varone <Dillon.Varone@amd.com>

[ Upstream commit 6b81090d6d4cc0fd818c9ec9dbb6906f921ad396 ]

[Description]
Modify soc BB to reduce expected sdp bandwidth and align with measurements to
fix underflow issues.

Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Dillon Varone <Dillon.Varone@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
index f4b176599be7a..0ea406145c1d7 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c
@@ -136,7 +136,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn3_21_soc = {
 	.urgent_out_of_order_return_per_channel_pixel_only_bytes = 4096,
 	.urgent_out_of_order_return_per_channel_pixel_and_vm_bytes = 4096,
 	.urgent_out_of_order_return_per_channel_vm_only_bytes = 4096,
-	.pct_ideal_sdp_bw_after_urgent = 100.0,
+	.pct_ideal_sdp_bw_after_urgent = 90.0,
 	.pct_ideal_fabric_bw_after_urgent = 67.0,
 	.pct_ideal_dram_sdp_bw_after_urgent_pixel_only = 20.0,
 	.pct_ideal_dram_sdp_bw_after_urgent_pixel_and_vm = 60.0, // N/A, for now keep as is until DML implemented
-- 
2.39.0

