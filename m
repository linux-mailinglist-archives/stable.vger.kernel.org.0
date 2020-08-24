Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6812501C6
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgHXQKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgHXQKm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 12:10:42 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0F1C061573
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 09:10:42 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b14so7866495qkn.4
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 09:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=78jEgqpKRYPj/B1QBFUJyVzlU5cRhZeyLjUawliZWAM=;
        b=CuJudGTdPMFR07yhx6YmAdG2UZWB77YS9BqJ1pJZhqL2zXIuUiENLu0Zowleju3COH
         VeMUDrC/NygqhL1KLs7nr8/wydnFMWb3pGc4nTpsEWKWu9XCU8sazo+K0ozY8eWaHyvI
         Qdcg3L4dDEXog+UjmCKgOrvumyPoOhsGwBzU8gjjAYo6k+FMS3bgCyxV0iZtqs6smEm9
         2B/5BFUfc1U75/yy2+FdKTm/XchFPdFwfY6bpovVWQK5y1ha2CCRWv8hF/wQXW7PptKu
         PjPpN9es1PRCJZCwz9CLJ1CbY/DdTqYkxzNmgsp5wdUUz0TsvTpMii6SHMN5ewT4C5aU
         k15g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=78jEgqpKRYPj/B1QBFUJyVzlU5cRhZeyLjUawliZWAM=;
        b=g8vWEHfpgUffV6Anxzj2TTG52NuttO3SmqlSOphfZXMEnwS70GDrTkmr+qvc2LjbTh
         6RALvDUg9G/4aH4hczcdDwfi1FmHcMRIVCKoZhecdBrF3vQDq8+xaPI4/a/6sXHQBzkF
         TJY0peNIziWosT003JzTzfmqFvGc5NKuBCq86/rnt57QV6CKYH7SgczRrDjsaBWBnovi
         p4DFFPoPCsaRNez4tlJMGVwuEeNtptyc+VtQO5nP+MWWj1LxDWWI2qOIw9A1hxrJCnxu
         AIJe8tQUhz+MkvRYv+5/la0TRZldFMSIwuRjsvM9X3jI9vvNIYvk4RnSvKJ6ewCF0DLf
         GQuw==
X-Gm-Message-State: AOAM5306+ZcO/5+QjFzlMVSLC/Ufrjx70TdTMv9WxFNJ9TDJcdPyaGLf
        aQgjEbBBDjbpQ3rorqTJhnz7Bn4llX0=
X-Google-Smtp-Source: ABdhPJzjyHvmFmd9yDaWSC+M90H8EchZ1ZzLOuNPlMgbUmKFfOoFKxKN+pIfuNamdipXqOuneALlYQ==
X-Received: by 2002:a05:620a:1a:: with SMTP id j26mr5377815qki.183.1598285437173;
        Mon, 24 Aug 2020 09:10:37 -0700 (PDT)
Received: from localhost.localdomain ([71.219.66.138])
        by smtp.gmail.com with ESMTPSA id b2sm11105284qto.82.2020.08.24.09.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 09:10:36 -0700 (PDT)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     sashal@kernel.org, Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH] Revert "drm/amd/display: Improve DisplayPort monitor interop"
Date:   Mon, 24 Aug 2020 12:10:29 -0400
Message-Id: <20200824161029.2001401-1-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 1adb2ff1f6b170cdbc3925a359c8f39d2215dc20.

This breaks display wake up in stable kernels (5.7.x and 5.8.x).

Note that there is no upstream equivalent to this
revert. This patch was targeted for stable by Sasha's stable
patch process. Presumably there are some other changes necessary
for this patch to work properly on stable kernels.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1266
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.7.x, 5.8.x
Cc: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c    |  4 +---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 16 ++++++----------
 .../amd/display/dc/dce110/dce110_hw_sequencer.c  | 11 +----------
 3 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 841cc051b7d0..48ab51533d5d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -3298,11 +3298,9 @@ void core_link_disable_stream(struct pipe_ctx *pipe_ctx)
 			write_i2c_redriver_setting(pipe_ctx, false);
 		}
 	}
-
-	disable_link(pipe_ctx->stream->link, pipe_ctx->stream->signal);
-
 	dc->hwss.disable_stream(pipe_ctx);
 
+	disable_link(pipe_ctx->stream->link, pipe_ctx->stream->signal);
 	if (pipe_ctx->stream->timing.flags.DSC) {
 		if (dc_is_dp_signal(pipe_ctx->stream->signal))
 			dp_set_dsc_enable(pipe_ctx, false);
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 6124af571bff..91cd884d6f25 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1102,10 +1102,6 @@ static inline enum link_training_result perform_link_training_int(
 	dpcd_pattern.v1_4.TRAINING_PATTERN_SET = DPCD_TRAINING_PATTERN_VIDEOIDLE;
 	dpcd_set_training_pattern(link, dpcd_pattern);
 
-	/* delay 5ms after notifying sink of idle pattern before switching output */
-	if (link->connector_signal != SIGNAL_TYPE_EDP)
-		msleep(5);
-
 	/* 4. mainlink output idle pattern*/
 	dp_set_hw_test_pattern(link, DP_TEST_PATTERN_VIDEO_MODE, NULL, 0);
 
@@ -1555,12 +1551,6 @@ bool perform_link_training_with_retries(
 	struct dc_link *link = stream->link;
 	enum dp_panel_mode panel_mode = dp_get_panel_mode(link);
 
-	/* We need to do this before the link training to ensure the idle pattern in SST
-	 * mode will be sent right after the link training
-	 */
-	link->link_enc->funcs->connect_dig_be_to_fe(link->link_enc,
-							pipe_ctx->stream_res.stream_enc->id, true);
-
 	for (j = 0; j < attempts; ++j) {
 
 		dp_enable_link_phy(
@@ -1577,6 +1567,12 @@ bool perform_link_training_with_retries(
 
 		dp_set_panel_mode(link, panel_mode);
 
+		/* We need to do this before the link training to ensure the idle pattern in SST
+		 * mode will be sent right after the link training
+		 */
+		link->link_enc->funcs->connect_dig_be_to_fe(link->link_enc,
+								pipe_ctx->stream_res.stream_enc->id, true);
+
 		if (link->aux_access_disabled) {
 			dc_link_dp_perform_link_training_skip_aux(link, link_setting);
 			return true;
diff --git a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
index 2af1d74d16ad..b77e9dc16086 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
+++ b/drivers/gpu/drm/amd/display/dc/dce110/dce110_hw_sequencer.c
@@ -1069,17 +1069,8 @@ void dce110_blank_stream(struct pipe_ctx *pipe_ctx)
 		link->dc->hwss.set_abm_immediate_disable(pipe_ctx);
 	}
 
-	if (dc_is_dp_signal(pipe_ctx->stream->signal)) {
+	if (dc_is_dp_signal(pipe_ctx->stream->signal))
 		pipe_ctx->stream_res.stream_enc->funcs->dp_blank(pipe_ctx->stream_res.stream_enc);
-
-		/*
-		 * After output is idle pattern some sinks need time to recognize the stream
-		 * has changed or they enter protection state and hang.
-		 */
-		if (!dc_is_embedded_signal(pipe_ctx->stream->signal))
-			msleep(60);
-	}
-
 }
 
 
-- 
2.25.4

