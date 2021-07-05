Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E29B3BB7A6
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 09:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhGEHTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 03:19:55 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:34771 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229935AbhGEHTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 03:19:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id D25E119407EF;
        Mon,  5 Jul 2021 03:17:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 05 Jul 2021 03:17:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VEykFy
        DDRG8HEUUtgkb2rfYgghhTzWjxKVjUBuZQ+Mw=; b=Y0HIMbGZz7HBlMhXM+/Y9U
        s3AFfqb7UfC9lbhYNhBKlK5/fW/FOhFjfCb9l9sbp4+/VCDl6TOuo4C952gGce3V
        4pNuiIXL1mIckmADexahVKf1BcobTHHDGQX7kGKJk0cSFkUnzRUBWGbnFMXSM83Z
        Md3BbULMR1eW3NF9JwDyY2gvW6IKsZhcJhHLRj4Wqj5XBSA2BaspRVv/TcPPACfM
        DssGkHutbUTCxW8oe5cHt08VEctArIn8YfmFVTYvGj1q9CqWblFtuC8sOovAcZKp
        SmKCZT4HKuLwnZWx18UiUBlr97DDEGkpkqsXUFNAMX5vAEDv9+kqxYuplWGKmafg
        ==
X-ME-Sender: <xms:_bHiYL8qWzOgFqgvMi0Nyo9ZbiA5fe-jmZS7fRgRExYIEDBjKOkn4g>
    <xme:_bHiYHvpQhhHybIWUDGWE8EEw2yahwbFZS0LgSDFlgp3cWvTrd2_Igr1eNL7e4K_e
    ER5uP8To0HU1Q>
X-ME-Received: <xmr:_bHiYJBDBlHy5IRmu4cq-lYAe4Bx6_c7Lr77CwgIX0QDDrKBFhXCX-dkjKFz8S-8ItaMMPbLIOaK_v_tyoJoAUhNFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeejfedguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtud
    eujefhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrh
    gvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_bHiYHeQAY7oAuIVaKFszu--1GsLO-tS3CpCpcQFl5ZJKqZFF_O7vw>
    <xmx:_bHiYAMxbXoLMPrtAa7ymr40rEY2p-UbjqlGW9x5TZYN_AA0YVejlw>
    <xmx:_bHiYJksMYQkXuR64K1sPzxFRgInDLTvJySRfnqyYu5EHS8eVKH6JA>
    <xmx:_bHiYNpdmrgL-Tcz1tb-XEzMhAKkbl7x6fkQb6L4JXSIG-iPmtnFsQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jul 2021 03:17:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: Revert "Guard ASSR with internal display" failed to apply to 5.13-stable tree
To:     stylon.wang@amd.com, Wesley.Chalmers@amd.com,
        alexander.deucher@amd.com, bindu.r@amd.com, daniel.wheeler@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Jul 2021 09:17:16 +0200
Message-ID: <162546943699238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 715bfff397634c44d616e27e11c873be1d442977 Mon Sep 17 00:00:00 2001
From: Stylon Wang <stylon.wang@amd.com>
Date: Thu, 10 Jun 2021 14:11:57 +0800
Subject: [PATCH] drm/amd/display: Revert "Guard ASSR with internal display
 flag"

This reverts commit 9127daa0a8d88a6e6452eb8b7c9be4c3f42a867e.

[Why]
1. Previous patch regresses on some embedded panels.
2. Project coreboot doesn't support passing of internal display flag.

[How]
This reverts "Guard ASSR with internal display flag" commit.

Fixes: 9127daa0a8d88a ("drm/amd/display: Guard ASSR with internal display flag")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1620
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Reviewed-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Acked-by: Bindu Ramamurthy <bindu.r@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 36a2dba54506..fdbf09cf0064 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -1760,42 +1760,6 @@ enum link_training_result dc_link_dp_perform_link_training(
 	return status;
 }
 
-static enum dp_panel_mode try_enable_assr(struct dc_stream_state *stream)
-{
-	struct dc_link *link = stream->link;
-	enum dp_panel_mode panel_mode = dp_get_panel_mode(link);
-#ifdef CONFIG_DRM_AMD_DC_HDCP
-	struct cp_psp *cp_psp = &stream->ctx->cp_psp;
-#endif
-
-	/* ASSR must be supported on the panel */
-	if (panel_mode == DP_PANEL_MODE_DEFAULT)
-		return panel_mode;
-
-	/* eDP or internal DP only */
-	if (link->connector_signal != SIGNAL_TYPE_EDP &&
-		!(link->connector_signal == SIGNAL_TYPE_DISPLAY_PORT &&
-		 link->is_internal_display))
-		return DP_PANEL_MODE_DEFAULT;
-
-#ifdef CONFIG_DRM_AMD_DC_HDCP
-	if (cp_psp && cp_psp->funcs.enable_assr) {
-		if (!cp_psp->funcs.enable_assr(cp_psp->handle, link)) {
-			/* since eDP implies ASSR on, change panel
-			 * mode to disable ASSR
-			 */
-			panel_mode = DP_PANEL_MODE_DEFAULT;
-		}
-	} else
-		panel_mode = DP_PANEL_MODE_DEFAULT;
-
-#else
-	/* turn off ASSR if the implementation is not compiled in */
-	panel_mode = DP_PANEL_MODE_DEFAULT;
-#endif
-	return panel_mode;
-}
-
 bool perform_link_training_with_retries(
 	const struct dc_link_settings *link_setting,
 	bool skip_video_pattern,
@@ -1808,7 +1772,7 @@ bool perform_link_training_with_retries(
 	uint8_t delay_between_attempts = LINK_TRAINING_RETRY_DELAY;
 	struct dc_stream_state *stream = pipe_ctx->stream;
 	struct dc_link *link = stream->link;
-	enum dp_panel_mode panel_mode;
+	enum dp_panel_mode panel_mode = dp_get_panel_mode(link);
 	struct link_encoder *link_enc;
 	enum link_training_result status = LINK_TRAINING_CR_FAIL_LANE0;
 	struct dc_link_settings current_setting = *link_setting;
@@ -1845,11 +1809,23 @@ bool perform_link_training_with_retries(
 			msleep(delay_dp_power_up_in_ms);
 		}
 
-		panel_mode = try_enable_assr(stream);
+#ifdef CONFIG_DRM_AMD_DC_HDCP
+		if (panel_mode == DP_PANEL_MODE_EDP) {
+			struct cp_psp *cp_psp = &stream->ctx->cp_psp;
+
+			if (cp_psp && cp_psp->funcs.enable_assr) {
+				if (!cp_psp->funcs.enable_assr(cp_psp->handle, link)) {
+					/* since eDP implies ASSR on, change panel
+					 * mode to disable ASSR
+					 */
+					panel_mode = DP_PANEL_MODE_DEFAULT;
+				}
+			} else
+				panel_mode = DP_PANEL_MODE_DEFAULT;
+		}
+#endif
+
 		dp_set_panel_mode(link, panel_mode);
-		DC_LOG_DETECTION_DP_CAPS("Link: %d ASSR enabled: %d\n",
-			 link->link_index,
-			 panel_mode != DP_PANEL_MODE_DEFAULT);
 
 		if (link->aux_access_disabled) {
 			dc_link_dp_perform_link_training_skip_aux(link, &current_setting);

