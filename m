Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E836A38BF
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjB0Cgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjB0Cg0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:36:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BF130DC;
        Sun, 26 Feb 2023 18:35:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24AC7B80BA8;
        Mon, 27 Feb 2023 02:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF483C4339E;
        Mon, 27 Feb 2023 02:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463472;
        bh=ueJ+nRG4PDKA3zbcPD1cYaqDinX2Y+hIhptCIR1APdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRBr3Bkt2nMU9oGNEBXiOPw5Q4rc1IAKdv/m85zOmPBF14pm6I6JCtr2P404k248z
         K0MP2mhJKB8A7kdyai8N2ITwAtpYxSTaeSjN/5gLTRtvfsQ5efaIE4XMlpHO5AkkzZ
         ihQQQYC4Xt5JebaziGapMRj76RYtvE2vwRPHhgJDF5Xhb7SU+bT6sVHwANCtkPDYvn
         sSf7k+A6L6li/0eF0S8h3aPsP51BY6FjREDB9mF6gOZ5TPb3NhIwVHlJV4sqUjB636
         TkOA82NwuOLEXke42i9adKBK2xEtey7f35ZxX7HtFYd7AHZG0trtld9sMKFON5hs7M
         kX4cnuRg0vVlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Hansen Dsouza <hansen.dsouza@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Charlene.Liu@amd.com, alex.hung@amd.com,
        sancchen@amd.com, Daniel.Miess@amd.com, mwen@igalia.com,
        bernard@vivo.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 53/60] drm/amd/display: Disable HUBP/DPP PG on DCN314 for now
Date:   Sun, 26 Feb 2023 21:00:38 -0500
Message-Id: <20230227020045.1045105-53-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020045.1045105-1-sashal@kernel.org>
References: <20230227020045.1045105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit b7c67f72408b11b922f23f06c7df0f6743a2e89d ]

[Why]
The DMCUB implementation required to workaround corruption is
not currently stable and may cause intermittent corruption or hangs.

[How]
Disable PG until the sequence is stable.

Reviewed-by: Hansen Dsouza <hansen.dsouza@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
index bc7f2b735327e..73f519dbdb531 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -892,6 +892,8 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.force_abm_enable = false,
 	.timing_trace = false,
 	.clock_trace = true,
+	.disable_dpp_power_gate = true,
+	.disable_hubp_power_gate = true,
 	.disable_pplib_clock_request = false,
 	.pipe_split_policy = MPC_SPLIT_DYNAMIC,
 	.force_single_disp_pipe_split = false,
-- 
2.39.0

