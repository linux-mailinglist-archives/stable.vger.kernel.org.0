Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089C62E35FE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 11:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgL1Kph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:45:37 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:53977 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgL1Kph (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 05:45:37 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id CEAB41942808;
        Mon, 28 Dec 2020 05:44:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 05:44:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jd3WLw
        1uXdwArI34mcS27HAzLtGdjexoFO8tKh3H5/M=; b=LeaHZLIZmfylf2tUOXrFcv
        jZJiOwBRxl4DvqDdAShyib94Gue/0kJtedBAKXXBJAhONSgBLu6W5xR5pYVfBbRO
        PEjPXEcYljAj1GXXwPJXJryAnhBcSHL4dlZIx5+XWCHW48VY6fnqA7ec67T9iyzE
        nBN4uU82GLAna79w0mJArXPjYbybII3UGYAhtUahFr4MyWIkuvigQs8kUEf4ZLBI
        XeN51dVRPosXBCnHRIQpqve8TyMrqFP9gq/eym7a9M1hXPHEGnMZiO/mcErp3jho
        pgqcbSfbhJ8yimSwLeJwKUzHQUguEcS0faH33FTEWNmWuTVB1tqLoUNoWOgo/ejQ
        ==
X-ME-Sender: <xms:DrfpX8twLlGDXiP9vSkYEFqIRwJVGjpQ_JUORi_X4kyBqnYXN2mnIw>
    <xme:DrfpX5eENpf1OVGub2zbliL60kIw3DwYY5c1H_ls34WGIYwqaQEy9BYr8vp2J9Jh9
    iu2NP4Z18FrRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:DrfpX3x26oGXJDaQ20fK-oa3lYgWjMpuA5JhwRaO5hkO9AHmZBB6hQ>
    <xmx:DrfpX_NGe_5PxIo9MGEWw9bdh9R6tOE1sLGVkkobAePS1jRPkQ0ZRw>
    <xmx:DrfpX89Lg3pwaG82vvzvoQCv_MmYZ2t0S-5xE0trIgf3s8-nMCctuw>
    <xmx:DrfpX7l1_YWQUtN-JD55JC4ZT_IKJ0hMHSbUpJHSXLlN7Crj2Kz9uQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 20BC6240057;
        Mon, 28 Dec 2020 05:44:30 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/display: Add get_dig_frontend implementation for DCEx" failed to apply to 5.10-stable tree
To:     Rodrigo.Siqueira@amd.com, Harry.Wentland@amd.com,
        Nicholas.Kazlauskas@amd.com, alexander.deucher@amd.com,
        bp@alien8.de, bp@suse.de, chiawen.huang@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 11:45:53 +0100
Message-ID: <16091523531566@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6bdeff12a96c9a5da95c8d11fefd145eb165e32a Mon Sep 17 00:00:00 2001
From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Date: Tue, 15 Dec 2020 10:33:34 -0500
Subject: [PATCH] drm/amd/display: Add get_dig_frontend implementation for DCEx

Some old ASICs might not implement/require get_dig_frontend helper; in
this scenario, we can have a NULL pointer exception when we try to call
it inside vbios disable operation. For example, this situation might
happen when using Polaris12 with an eDP panel. This commit avoids this
situation by adding a specific get_dig_frontend implementation for DCEx.

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Harry Wentland <Harry.Wentland@amd.com>
Cc: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Cc: Chiawen Huang <chiawen.huang@amd.com>
Reported-and-tested-by: Borislav Petkov <bp@suse.de>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
index 4592ccdfa9b0..210466b2d863 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.c
@@ -120,6 +120,7 @@ static const struct link_encoder_funcs dce110_lnk_enc_funcs = {
 	.is_dig_enabled = dce110_is_dig_enabled,
 	.destroy = dce110_link_encoder_destroy,
 	.get_max_link_cap = dce110_link_encoder_get_max_link_cap,
+	.get_dig_frontend = dce110_get_dig_frontend,
 };
 
 static enum bp_result link_transmitter_control(
@@ -235,6 +236,44 @@ static void set_link_training_complete(
 
 }
 
+unsigned int dce110_get_dig_frontend(struct link_encoder *enc)
+{
+	struct dce110_link_encoder *enc110 = TO_DCE110_LINK_ENC(enc);
+	u32 value;
+	enum engine_id result;
+
+	REG_GET(DIG_BE_CNTL, DIG_FE_SOURCE_SELECT, &value);
+
+	switch (value) {
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGA:
+		result = ENGINE_ID_DIGA;
+		break;
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGB:
+		result = ENGINE_ID_DIGB;
+		break;
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGC:
+		result = ENGINE_ID_DIGC;
+		break;
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGD:
+		result = ENGINE_ID_DIGD;
+		break;
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGE:
+		result = ENGINE_ID_DIGE;
+		break;
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGF:
+		result = ENGINE_ID_DIGF;
+		break;
+	case DCE110_DIG_FE_SOURCE_SELECT_DIGG:
+		result = ENGINE_ID_DIGG;
+		break;
+	default:
+		// invalid source select DIG
+		result = ENGINE_ID_UNKNOWN;
+	}
+
+	return result;
+}
+
 void dce110_link_encoder_set_dp_phy_pattern_training_pattern(
 	struct link_encoder *enc,
 	uint32_t index)
@@ -1665,7 +1704,8 @@ static const struct link_encoder_funcs dce60_lnk_enc_funcs = {
 	.disable_hpd = dce110_link_encoder_disable_hpd,
 	.is_dig_enabled = dce110_is_dig_enabled,
 	.destroy = dce110_link_encoder_destroy,
-	.get_max_link_cap = dce110_link_encoder_get_max_link_cap
+	.get_max_link_cap = dce110_link_encoder_get_max_link_cap,
+	.get_dig_frontend = dce110_get_dig_frontend
 };
 
 void dce60_link_encoder_construct(
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.h b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.h
index cb714a48b171..fc6ade824c23 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_link_encoder.h
@@ -295,6 +295,8 @@ void dce110_link_encoder_connect_dig_be_to_fe(
 	enum engine_id engine,
 	bool connect);
 
+unsigned int dce110_get_dig_frontend(struct link_encoder *enc);
+
 void dce110_link_encoder_set_dp_phy_pattern_training_pattern(
 	struct link_encoder *enc,
 	uint32_t index);

