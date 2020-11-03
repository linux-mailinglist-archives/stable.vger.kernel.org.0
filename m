Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B57E2A4A2F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgKCPnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:43:50 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:40065 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728346AbgKCPnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:43:49 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0E0F81942BEA;
        Tue,  3 Nov 2020 10:43:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:43:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nCwkMI
        2+nNoO0Wu/EkTiq3qSdwmRx3sr+wa2SPq64oo=; b=N5eFx+gI+Reoi0TPw3BZin
        ldxsJDiQ10BlY3TyEE+42jIpU4Kq315/+2Rp6vUckjZxv4aEaDB0QHaNYf0qKxI3
        CVqMgWMvGBpHF8yzx5pevKAYme5X6hHSO4S861Yu08e3G5aQshN12D0ouc9zp+ee
        lwCbqc6KXu3PnqEjeTJF93wcOG7onQ+WCMz3z6JpITusqpjSikNfgLaAKI4wWFvk
        /DDN4N0JOyl9dNeZGIZbYQ+13vfIlczUpA1J3VTCRvVZLG7duwqYJHsyIwIyUB5x
        SEWhT4oIHnX6VdQS4FrRghRZBYA6777QlWrYvQenftfJZTlLRjx/GsNddOHNLNsQ
        ==
X-ME-Sender: <xms:s3qhXwSVbV_dF7OeG6ar7wRrKEzorGLu8mQ6LtJ_eCDNVv33G8hbzQ>
    <xme:s3qhX9wmMDU5zSWvpeq6Z1-OxLdUlQvBYXsboLHOGXK7I-BqfNVXb-6m3if5gnQVm
    _ubF8YoyFEUWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:s3qhX92Lmnoip1TSLEAHZ_R6nvi1Rblxf3W1zjT7_a3gTvC2k3uI6A>
    <xmx:s3qhX0CHFejmQhFx3R_gevngvt9IYAGATJjb7MQGqDH8kYtjCq3crw>
    <xmx:s3qhX5ja8ZPCpz_esxcUNaGz_L5yxNmNrxNt0PbivY3rtD6O9W9Z_w>
    <xmx:tHqhX-u7TuRZgnrB5cSCbLOzIE2F3ncWAvP82j9D95p4mXUPM2NJpA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9CE69328005A;
        Tue,  3 Nov 2020 10:43:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/display: Fix DSC force enable on SST" failed to apply to 5.9-stable tree
To:     eryk.brol@amd.com, Rodrigo.Siqueira@amd.com, Wenjing.Liu@amd.com,
        alexander.deucher@amd.com, mikita.lipski@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:44:41 +0100
Message-ID: <160441828183255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bcc6aa61c82d4f12df3ecc884a9eef9d566edae9 Mon Sep 17 00:00:00 2001
From: Eryk Brol <eryk.brol@amd.com>
Date: Fri, 19 Jun 2020 14:42:09 -0400
Subject: [PATCH] drm/amd/display: Fix DSC force enable on SST

[why]
Previously when force enabling DSC on SST display we unknowingly
supressed lane count, which caused DSC to be enabled automatically.

[how]
By adding an additional flag to force enable DSC in dc_dsc.c DSC can
always be enabled with debugfs dsc_clock_en forced to 1

Cc: stable@vger.kernel.org
Signed-off-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Mikita Lipski <mikita.lipski@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 0d121a3f2103..ad6b95d65f7b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4646,6 +4646,9 @@ create_stream_for_sink(struct amdgpu_dm_connector *aconnector,
 
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 		if (dsc_caps.is_dsc_supported) {
+			/* Set DSC policy according to dsc_clock_en */
+			dc_dsc_policy_set_enable_dsc_when_not_needed(aconnector->dsc_settings.dsc_clock_en);
+
 			if (dc_dsc_compute_config(aconnector->dc_link->ctx->dc->res_pool->dscs[0],
 						  &dsc_caps,
 						  aconnector->dc_link->ctx->dc->debug.dsc_min_slice_height_override,
diff --git a/drivers/gpu/drm/amd/display/dc/dc_dsc.h b/drivers/gpu/drm/amd/display/dc/dc_dsc.h
index 3800340a5b4f..768ab38d41cf 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dsc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dsc.h
@@ -51,6 +51,7 @@ struct dc_dsc_policy {
 	int min_slice_height; // Must not be less than 8
 	uint32_t max_target_bpp;
 	uint32_t min_target_bpp;
+	bool enable_dsc_when_not_needed;
 };
 
 bool dc_dsc_parse_dsc_dpcd(const struct dc *dc,
@@ -80,4 +81,6 @@ void dc_dsc_get_policy_for_timing(const struct dc_crtc_timing *timing,
 
 void dc_dsc_policy_set_max_target_bpp_limit(uint32_t limit);
 
+void dc_dsc_policy_set_enable_dsc_when_not_needed(bool enable);
+
 #endif
diff --git a/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c b/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
index 8cdaa6eef5d3..da1b654833d5 100644
--- a/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
+++ b/drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c
@@ -34,6 +34,9 @@
 /* default DSC policy target bitrate limit is 16bpp */
 static uint32_t dsc_policy_max_target_bpp_limit = 16;
 
+/* default DSC policy enables DSC only when needed */
+static bool dsc_policy_enable_dsc_when_not_needed;
+
 static uint32_t dc_dsc_bandwidth_in_kbps_from_timing(
 	const struct dc_crtc_timing *timing)
 {
@@ -360,7 +363,7 @@ static bool decide_dsc_target_bpp_x16(
 
 	get_dsc_bandwidth_range(policy->min_target_bpp, policy->max_target_bpp,
 			dsc_common_caps, timing, &range);
-	if (target_bandwidth_kbps >= range.stream_kbps) {
+	if (!policy->enable_dsc_when_not_needed && target_bandwidth_kbps >= range.stream_kbps) {
 		/* enough bandwidth without dsc */
 		*target_bpp_x16 = 0;
 		should_use_dsc = false;
@@ -961,9 +964,20 @@ void dc_dsc_get_policy_for_timing(const struct dc_crtc_timing *timing, struct dc
 	/* internal upper limit, default 16 bpp */
 	if (policy->max_target_bpp > dsc_policy_max_target_bpp_limit)
 		policy->max_target_bpp = dsc_policy_max_target_bpp_limit;
+
+	/* enable DSC when not needed, default false */
+	if (dsc_policy_enable_dsc_when_not_needed)
+		policy->enable_dsc_when_not_needed = dsc_policy_enable_dsc_when_not_needed;
+	else
+		policy->enable_dsc_when_not_needed = false;
 }
 
 void dc_dsc_policy_set_max_target_bpp_limit(uint32_t limit)
 {
 	dsc_policy_max_target_bpp_limit = limit;
 }
+
+void dc_dsc_policy_set_enable_dsc_when_not_needed(bool enable)
+{
+	dsc_policy_enable_dsc_when_not_needed = enable;
+}

