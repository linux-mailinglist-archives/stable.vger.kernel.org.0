Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0099DF66
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 11:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfD2J14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 05:27:56 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59317 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727325AbfD2J14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 05:27:56 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 940A321FEC;
        Mon, 29 Apr 2019 05:27:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 29 Apr 2019 05:27:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=U+2qVx
        iP3mgz6FJBNyx5sXKlIIjWyurM4qIr3Xxc3pA=; b=Tm67NQKybjS2BHCJ3ZlGgE
        bzMEwVBJdsoNMDvD0cBc7mBhwjRyocC4y5NThUIO3V01crh8Lt4XRAKP6Gjd5KDR
        +HVebNAjjgzIxQInIzMc1HUE8dGjpMTaowAR98O74Nu2qDACLq7JmSmQUY1daUwH
        7ub4hbWayaD2XwLLy/PnLz73rakSaOypI6BB3RJKo1KNMxwmMGj4hhJPA4kaLJBL
        W30a0bUba9roaMj6PQ59z3tTbZD0mY18nI0dyPxJAanypkTJZxJnPpvr5LAe5Ra7
        DmSO3O3I4hTIsuLsKCAZpnTwsOZc3PkMonkwk/52WF1Jt20Pcca2BpsTktXGGluA
        ==
X-ME-Sender: <xms:m8PGXPxHVBNfqRsPd2gXsdNOHz2Ya3Inkv9PGIeBS_zwL9FxHlSM2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddriedvgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:m8PGXA_xa7UdKx7O6BbKl_wyMlU1-OfOEmFKyfEVaYiDJKhGEwhNFg>
    <xmx:m8PGXIpevnRzepjiWwvIIGZiRCC210q_wxFCP9E645WomnsCkkbwcQ>
    <xmx:m8PGXBlbN6GQ1_z1iV0C8kGcorS1WcNV3JPgp5vmmM33vEhBgQNEDQ>
    <xmx:m8PGXOS0JSsYrXwi-UCHzkRm7ulpU76cjI2AteMseq7LtZ_pE2wzbw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB24E103CC;
        Mon, 29 Apr 2019 05:27:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Revert "drm/i915/fbdev: Actually configure untiled displays"" failed to apply to 4.9-stable tree
To:     airlied@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Apr 2019 11:27:52 +0200
Message-ID: <15565300729113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9fa246256e09dc30820524401cdbeeaadee94025 Mon Sep 17 00:00:00 2001
From: Dave Airlie <airlied@redhat.com>
Date: Wed, 24 Apr 2019 10:47:56 +1000
Subject: [PATCH] Revert "drm/i915/fbdev: Actually configure untiled displays"

This reverts commit d179b88deb3bf6fed4991a31fd6f0f2cad21fab5.

This commit is documented to break userspace X.org modesetting driver in certain configurations.

The X.org modesetting userspace driver is broken. No fixes are available yet. In order for this patch to be applied it either needs a config option or a workaround developed.

This has been reported a few times, saying it's a userspace problem is clearly against the regression rules.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=109806
Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: <stable@vger.kernel.org> # v3.19+

diff --git a/drivers/gpu/drm/i915/intel_fbdev.c b/drivers/gpu/drm/i915/intel_fbdev.c
index e8f694b57b8a..376ffe842e26 100644
--- a/drivers/gpu/drm/i915/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/intel_fbdev.c
@@ -338,8 +338,8 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
 				    bool *enabled, int width, int height)
 {
 	struct drm_i915_private *dev_priv = to_i915(fb_helper->dev);
+	unsigned long conn_configured, conn_seq, mask;
 	unsigned int count = min(fb_helper->connector_count, BITS_PER_LONG);
-	unsigned long conn_configured, conn_seq;
 	int i, j;
 	bool *save_enabled;
 	bool fallback = true, ret = true;
@@ -357,9 +357,10 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
 		drm_modeset_backoff(&ctx);
 
 	memcpy(save_enabled, enabled, count);
-	conn_seq = GENMASK(count - 1, 0);
+	mask = GENMASK(count - 1, 0);
 	conn_configured = 0;
 retry:
+	conn_seq = conn_configured;
 	for (i = 0; i < count; i++) {
 		struct drm_fb_helper_connector *fb_conn;
 		struct drm_connector *connector;
@@ -372,8 +373,7 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
 		if (conn_configured & BIT(i))
 			continue;
 
-		/* First pass, only consider tiled connectors */
-		if (conn_seq == GENMASK(count - 1, 0) && !connector->has_tile)
+		if (conn_seq == 0 && !connector->has_tile)
 			continue;
 
 		if (connector->status == connector_status_connected)
@@ -477,10 +477,8 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
 		conn_configured |= BIT(i);
 	}
 
-	if (conn_configured != conn_seq) { /* repeat until no more are found */
-		conn_seq = conn_configured;
+	if ((conn_configured & mask) != mask && conn_configured != conn_seq)
 		goto retry;
-	}
 
 	/*
 	 * If the BIOS didn't enable everything it could, fall back to have the

