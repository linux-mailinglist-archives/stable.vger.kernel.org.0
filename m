Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7975F9528
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 02:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiJJAQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 20:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbiJJAP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 20:15:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20892140C2;
        Sun,  9 Oct 2022 16:52:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C259E60C9B;
        Sun,  9 Oct 2022 23:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F905C433C1;
        Sun,  9 Oct 2022 23:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665359531;
        bh=14NvLwA4fUXcofMhUIAAVbjoN/PdGvt5TBRz5MgG8d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPASQ4ElwvHpWbATuTzWdAkZhpo0gmFe4O5p1j4e4chUt/6D1GyHZ+ZMcXZ9/z5tL
         VC4HJS+yxFGC9RLiSXZIWgFhDoLSf2VKNZrT/rRJTJFYeCqM31XA+qxBR4BTEE+9hS
         eceqS488yiCrkTbZoo4ueZ32NCV7gWeXNBlDnKZXs51aveVbI9IWtc1Q5dSCZrId9j
         LtO8OzGlppOZjvFaCZCajNA3JDDJEcB1EN41OrE7YTc6KO9R03c+3TESRe2g86dbiz
         cCWuZyCV6oTs/ODoNPkB/CSgm2pRazYBtEa4DDTKnT23FdtX3G9pXrnA7F9d2UtGuj
         iGOqxCjMinoNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aric Cyr <aric.cyr@amd.com>, Jaehyun Chung <jaehyun.chung@amd.com>,
        Jasdeep Dhillon <jdhillon@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, Jun.Lei@amd.com, martin.leung@amd.com,
        Alvin.Lee2@amd.com, meenakshikumar.somasundaram@amd.com,
        Samson.Tam@amd.com, wenjing.liu@amd.com, alex.hung@amd.com,
        Dillon.Varone@amd.com, HaoPing.Liu@amd.com,
        aurabindo.pillai@amd.com, felipe.clark@amd.com,
        ahmad.othman@amd.com, Wayne.Lin@amd.com, Jerry.Zuo@amd.com,
        dingchen.zhang@amd.com, mairacanal@riseup.net,
        SyedSaaem.Rizvi@amd.com, Anthony.Koo@amd.com, roman.li@amd.com,
        Yi-Ling.Chen2@amd.com, mwen@igalia.com, martin.tsai@amd.com,
        agustin.gutierrez@amd.com, hanghong.ma@amd.com,
        isabbasso@riseup.net, Pavle.Kotarac@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 41/44] drm/amd/display: Remove interface for periodic interrupt 1
Date:   Sun,  9 Oct 2022 19:49:29 -0400
Message-Id: <20221009234932.1230196-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009234932.1230196-1-sashal@kernel.org>
References: <20221009234932.1230196-1-sashal@kernel.org>
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

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 97d8d6f075bd8f988589be02b91f6fa644d0b0b8 ]

[why]
Only a single VLINE interrupt is available so interface should not
expose the second one which is used by DMU firmware.

[how]
Remove references to periodic_interrupt1 and VLINE1 from DC interfaces.

Reviewed-by: Jaehyun Chung <jaehyun.chung@amd.com>
Acked-by: Jasdeep Dhillon <jdhillon@amd.com>
Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c      | 16 +++------
 drivers/gpu/drm/amd/display/dc/dc_stream.h    |  6 ++--
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c | 35 ++++++-------------
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.h |  3 +-
 .../gpu/drm/amd/display/dc/inc/hw_sequencer.h |  8 +----
 5 files changed, 18 insertions(+), 50 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index fb22c3d70528..18d6ee666297 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -2753,11 +2753,8 @@ static void copy_stream_update_to_stream(struct dc *dc,
 	if (update->abm_level)
 		stream->abm_level = *update->abm_level;
 
-	if (update->periodic_interrupt0)
-		stream->periodic_interrupt0 = *update->periodic_interrupt0;
-
-	if (update->periodic_interrupt1)
-		stream->periodic_interrupt1 = *update->periodic_interrupt1;
+	if (update->periodic_interrupt)
+		stream->periodic_interrupt = *update->periodic_interrupt;
 
 	if (update->gamut_remap)
 		stream->gamut_remap_matrix = *update->gamut_remap;
@@ -2987,13 +2984,8 @@ static void commit_planes_do_stream_update(struct dc *dc,
 
 		if (!pipe_ctx->top_pipe &&  !pipe_ctx->prev_odm_pipe && pipe_ctx->stream == stream) {
 
-			if (stream_update->periodic_interrupt0 &&
-					dc->hwss.setup_periodic_interrupt)
-				dc->hwss.setup_periodic_interrupt(dc, pipe_ctx, VLINE0);
-
-			if (stream_update->periodic_interrupt1 &&
-					dc->hwss.setup_periodic_interrupt)
-				dc->hwss.setup_periodic_interrupt(dc, pipe_ctx, VLINE1);
+			if (stream_update->periodic_interrupt && dc->hwss.setup_periodic_interrupt)
+				dc->hwss.setup_periodic_interrupt(dc, pipe_ctx);
 
 			if ((stream_update->hdr_static_metadata && !stream->use_dynamic_meta) ||
 					stream_update->vrr_infopacket ||
diff --git a/drivers/gpu/drm/amd/display/dc/dc_stream.h b/drivers/gpu/drm/amd/display/dc/dc_stream.h
index f87f852d4829..ae0922e98ef7 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_stream.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_stream.h
@@ -212,8 +212,7 @@ struct dc_stream_state {
 	/* DMCU info */
 	unsigned int abm_level;
 
-	struct periodic_interrupt_config periodic_interrupt0;
-	struct periodic_interrupt_config periodic_interrupt1;
+	struct periodic_interrupt_config periodic_interrupt;
 
 	/* from core_stream struct */
 	struct dc_context *ctx;
@@ -283,8 +282,7 @@ struct dc_stream_update {
 	struct dc_info_packet *hdr_static_metadata;
 	unsigned int *abm_level;
 
-	struct periodic_interrupt_config *periodic_interrupt0;
-	struct periodic_interrupt_config *periodic_interrupt1;
+	struct periodic_interrupt_config *periodic_interrupt;
 
 	struct dc_info_packet *vrr_infopacket;
 	struct dc_info_packet *vsc_infopacket;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
index 5b5d952b2b8c..bc9b92838ea9 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -3768,7 +3768,7 @@ void dcn10_calc_vupdate_position(
 {
 	const struct dc_crtc_timing *dc_crtc_timing = &pipe_ctx->stream->timing;
 	int vline_int_offset_from_vupdate =
-			pipe_ctx->stream->periodic_interrupt0.lines_offset;
+			pipe_ctx->stream->periodic_interrupt.lines_offset;
 	int vupdate_offset_from_vsync = dc->hwss.get_vupdate_offset_from_vsync(pipe_ctx);
 	int start_position;
 
@@ -3793,18 +3793,10 @@ void dcn10_calc_vupdate_position(
 static void dcn10_cal_vline_position(
 		struct dc *dc,
 		struct pipe_ctx *pipe_ctx,
-		enum vline_select vline,
 		uint32_t *start_line,
 		uint32_t *end_line)
 {
-	enum vertical_interrupt_ref_point ref_point = INVALID_POINT;
-
-	if (vline == VLINE0)
-		ref_point = pipe_ctx->stream->periodic_interrupt0.ref_point;
-	else if (vline == VLINE1)
-		ref_point = pipe_ctx->stream->periodic_interrupt1.ref_point;
-
-	switch (ref_point) {
+	switch (pipe_ctx->stream->periodic_interrupt.ref_point) {
 	case START_V_UPDATE:
 		dcn10_calc_vupdate_position(
 				dc,
@@ -3813,7 +3805,9 @@ static void dcn10_cal_vline_position(
 				end_line);
 		break;
 	case START_V_SYNC:
-		// Suppose to do nothing because vsync is 0;
+		// vsync is line 0 so start_line is just the requested line offset
+		*start_line = pipe_ctx->stream->periodic_interrupt.lines_offset;
+		*end_line = *start_line + 2;
 		break;
 	default:
 		ASSERT(0);
@@ -3823,24 +3817,15 @@ static void dcn10_cal_vline_position(
 
 void dcn10_setup_periodic_interrupt(
 		struct dc *dc,
-		struct pipe_ctx *pipe_ctx,
-		enum vline_select vline)
+		struct pipe_ctx *pipe_ctx)
 {
 	struct timing_generator *tg = pipe_ctx->stream_res.tg;
+	uint32_t start_line = 0;
+	uint32_t end_line = 0;
 
-	if (vline == VLINE0) {
-		uint32_t start_line = 0;
-		uint32_t end_line = 0;
+	dcn10_cal_vline_position(dc, pipe_ctx, &start_line, &end_line);
 
-		dcn10_cal_vline_position(dc, pipe_ctx, vline, &start_line, &end_line);
-
-		tg->funcs->setup_vertical_interrupt0(tg, start_line, end_line);
-
-	} else if (vline == VLINE1) {
-		pipe_ctx->stream_res.tg->funcs->setup_vertical_interrupt1(
-				tg,
-				pipe_ctx->stream->periodic_interrupt1.lines_offset);
-	}
+	tg->funcs->setup_vertical_interrupt0(tg, start_line, end_line);
 }
 
 void dcn10_setup_vupdate_interrupt(struct dc *dc, struct pipe_ctx *pipe_ctx)
diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
index 9ae07c77fdc0..0ef7bf7ddb75 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.h
@@ -175,8 +175,7 @@ void dcn10_set_cursor_attribute(struct pipe_ctx *pipe_ctx);
 void dcn10_set_cursor_sdr_white_level(struct pipe_ctx *pipe_ctx);
 void dcn10_setup_periodic_interrupt(
 		struct dc *dc,
-		struct pipe_ctx *pipe_ctx,
-		enum vline_select vline);
+		struct pipe_ctx *pipe_ctx);
 enum dc_status dcn10_set_clock(struct dc *dc,
 		enum dc_clock_type clock_type,
 		uint32_t clk_khz,
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
index ccb3c719fc4d..ac94dba72c18 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw_sequencer.h
@@ -32,11 +32,6 @@
 #include "inc/hw/link_encoder.h"
 #include "core_status.h"
 
-enum vline_select {
-	VLINE0,
-	VLINE1
-};
-
 struct pipe_ctx;
 struct dc_state;
 struct dc_stream_status;
@@ -116,8 +111,7 @@ struct hw_sequencer_funcs {
 			int group_index, int group_size,
 			struct pipe_ctx *grouped_pipes[]);
 	void (*setup_periodic_interrupt)(struct dc *dc,
-			struct pipe_ctx *pipe_ctx,
-			enum vline_select vline);
+			struct pipe_ctx *pipe_ctx);
 	void (*set_drr)(struct pipe_ctx **pipe_ctx, int num_pipes,
 			struct dc_crtc_timing_adjust adjust);
 	void (*set_static_screen_control)(struct pipe_ctx **pipe_ctx,
-- 
2.35.1

