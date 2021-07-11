Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857563C3CB8
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 15:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhGKNHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 09:07:06 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:55693 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhGKNHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 09:07:05 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id D845919405A7;
        Sun, 11 Jul 2021 09:04:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 11 Jul 2021 09:04:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Mnifqe
        j9fi0mvIucmzi9I/BUY/yqsOJ1QxdJhPoFp9g=; b=UETsjHetS0dFrIvx2KhTww
        +KE7SZ6K9zLy1hfahO3WEM/qvKTT1q/LrbcSQCHKhHLXSWK6bSX8ezMun3rxoNuY
        whjY5vVJuinmTiuaRL+rIwZhXGcv2R3yWN+tQOmjXNur7Z1Z7r9tgs9o2t+yu3P7
        86L4oWT6geURgTNcLhnC9nuWXF2LOkJSC/qWx2SKmljQ1PdNM6HxnVSHE60b5g9+
        ShHa4nEIG6UDUEHqz+cR/xtaB2YJT+QGfnhGT7CJdk2uyWotqkjTPrLd9ZYsMEre
        yNoiRmyXWIbU1dapQfyk4U2IxOZWrccHL9/iP7u1U0pz4shcjOgjvs4hsGohvfIQ
        ==
X-ME-Sender: <xms:UuzqYNPxTnIQpc9HUVA8m100SyTikYqBMNiJRbpoDswsNOa0a_V_3Q>
    <xme:UuzqYP-kWskIkO93zXUhA1f06YkfkjxW_nxErMMyVw5d9inAGVNdJwNPYkTfBN1x6
    Fiu5JGrljY6Iw>
X-ME-Received: <xmr:UuzqYMSySWA2wyWVzso--7XqYdMVN4NTbzNYpb0nwvTSBi2uzB9QKfzqcvdk7NzmUM49aOlqQSbSIO7ZP3c9hMkM-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:UuzqYJuhkD_FENCG0n5n9PNollbLXOlqUuzXSZIyOsrH_kfV4f6NYg>
    <xmx:UuzqYFfV7aJEtANMvQ-F44TwuMsOyIJpzgr2ap8bODY05tlVnNaknw>
    <xmx:UuzqYF2cCqy8mHz4JAs0V2vD5CrMzqfmGnImJkMaoLvnk8sj3sm9EA>
    <xmx:UuzqYEzUmr5VMMyQ7qEn9EIhD_9BqQd8pm1P40rgM8HJsbqmHw7Aww>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 09:04:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Revert "drm/amd/display: Fix overlay validation by" failed to apply to 5.13-stable tree
To:     Rodrigo.Siqueira@amd.com, Harry.Wentland@amd.com,
        Nicholas.Kazlauskas@amd.com, alexander.deucher@amd.com,
        gregkh@linuxfoundation.org, harry.wentland@amd.com,
        hersenxs.wu@amd.com, markyacoub@chromium.org, seanpaul@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 15:04:17 +0200
Message-ID: <1626008657175201@kroah.com>
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

From e7d9560aeae51415f6c9bc343feb783a441ff4c5 Mon Sep 17 00:00:00 2001
From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Date: Wed, 16 Jun 2021 12:21:30 -0400
Subject: [PATCH] Revert "drm/amd/display: Fix overlay validation by
 considering cursors"

This reverts commit 33f409e60eb0c59a4d0d06a62ab4642a988e17f7.

The patch that we are reverting here was originally applied because it
fixes multiple IGT issues and flickering in Android. However, after a
discussion with Sean Paul and Mark, it looks like that this patch might
cause problems on ChromeOS. For this reason, we decided to revert this
patch.

Cc: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Cc: Harry Wentland <Harry.Wentland@amd.com>
Cc: Hersen Wu <hersenxs.wu@amd.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Mark Yacoub <markyacoub@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Reviewed-by: Sean Paul <seanpaul@chromium.org>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 2688a2e759de..cfb2f9e43661 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10120,8 +10120,8 @@ static int validate_overlay(struct drm_atomic_state *state)
 {
 	int i;
 	struct drm_plane *plane;
-	struct drm_plane_state *new_plane_state;
-	struct drm_plane_state *primary_state, *cursor_state, *overlay_state = NULL;
+	struct drm_plane_state *old_plane_state, *new_plane_state;
+	struct drm_plane_state *primary_state, *overlay_state = NULL;
 
 	/* Check if primary plane is contained inside overlay */
 	for_each_new_plane_in_state_reverse(state, plane, new_plane_state, i) {
@@ -10151,14 +10151,6 @@ static int validate_overlay(struct drm_atomic_state *state)
 	if (!primary_state->crtc)
 		return 0;
 
-	/* check if cursor plane is enabled */
-	cursor_state = drm_atomic_get_plane_state(state, overlay_state->crtc->cursor);
-	if (IS_ERR(cursor_state))
-		return PTR_ERR(cursor_state);
-
-	if (drm_atomic_plane_disabling(plane->state, cursor_state))
-		return 0;
-
 	/* Perform the bounds check to ensure the overlay plane covers the primary */
 	if (primary_state->crtc_x < overlay_state->crtc_x ||
 	    primary_state->crtc_y < overlay_state->crtc_y ||

