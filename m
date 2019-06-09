Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199993A4B2
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 12:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfFIKbH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 06:31:07 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48595 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727853AbfFIKbH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 06:31:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3F99721EFE;
        Sun,  9 Jun 2019 06:31:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 06:31:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WX3J83
        3BKZXqWJELabrXYjHWlLnQy8VI/VV60/gzpAw=; b=eECxIjGI62GCa8SqdVzLAG
        MTh390RGNCVbTpvdV+6NiyHqOg4M8XgLrwJZSAQLMxd6b8E8UM5QIeNwN5108sTU
        HUE4/yllgAHxkVbpirMHvXUywOtWELDuUkrNlwUxwVdsPBLVYIGlcTLW09nlD9Ae
        KGpLuRCxwE22Lb4d0xdDrcvmlsWxAMTQRT9KspbN41h+ymABRNVGpGcOD2mXauD4
        ak7DMHW1ECAHDm4QBHYyc5zeY5Mbh4y8iafA0ZRPwVW24FTaiHU/gI5P+V5quSqI
        i/KrdgcqFru7Vndvn0B61AcMTTRhZYSlpHEcZMZPHmHr0fNKZvE37G+1JdI9WGvg
        ==
X-ME-Sender: <xms:6d_8XLWeFh1Xz3ucgZWwaSFwWbyj9qk2BO-aPB4KPGpt4Oir3Uu4gQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:6d_8XP4dv7vqk3SnQeezTm6lAEMRcgv2RNyz2HUkgoFpRsvpr6gIZw>
    <xmx:6d_8XKICeZ5cIFVvS8WR8N6aNprvoeTt0Jy9ZvTy5Nu5-hmKNSROkw>
    <xmx:6d_8XIJKz_PZh2pPwaa6bx92wzn-OFUyJ-HadjlT4JEfZMqIezOyCA>
    <xmx:6t_8XOHuIvOFMI7UuUpgOkaIPKBIa2aTdtXr_oK4LveHL9SxeyZvBA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D463380073;
        Sun,  9 Jun 2019 06:31:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm: don't block fb changes for async plane updates" failed to apply to 4.14-stable tree
To:     helen.koike@collabora.com, boris.brezillon@collabora.com,
        nicholas.kazlauskas@amd.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 12:31:04 +0200
Message-ID: <156007626458164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 89a4aac0ab0e6f5eea10d7bf4869dd15c3de2cd4 Mon Sep 17 00:00:00 2001
From: Helen Koike <helen.koike@collabora.com>
Date: Mon, 3 Jun 2019 13:56:10 -0300
Subject: [PATCH] drm: don't block fb changes for async plane updates

In the case of a normal sync update, the preparation of framebuffers (be
it calling drm_atomic_helper_prepare_planes() or doing setups with
drm_framebuffer_get()) are performed in the new_state and the respective
cleanups are performed in the old_state.

In the case of async updates, the preparation is also done in the
new_state but the cleanups are done in the new_state (because updates
are performed in place, i.e. in the current state).

The current code blocks async udpates when the fb is changed, turning
async updates into sync updates, slowing down cursor updates and
introducing regressions in igt tests with errors of type:

"CRITICAL: completed 97 cursor updated in a period of 30 flips, we
expect to complete approximately 15360 updates, with the threshold set
at 7680"

Fb changes in async updates were prevented to avoid the following scenario:

- Async update, oldfb = NULL, newfb = fb1, prepare fb1, cleanup fb1
- Async update, oldfb = fb1, newfb = fb2, prepare fb2, cleanup fb2
- Non-async commit, oldfb = fb2, newfb = fb1, prepare fb1, cleanup fb2 (wrong)
Where we have a single call to prepare fb2 but double cleanup call to fb2.

To solve the above problems, instead of blocking async fb changes, we
place the old framebuffer in the new_state object, so when the code
performs cleanups in the new_state it will cleanup the old_fb and we
will have the following scenario instead:

- Async update, oldfb = NULL, newfb = fb1, prepare fb1, no cleanup
- Async update, oldfb = fb1, newfb = fb2, prepare fb2, cleanup fb1
- Non-async commit, oldfb = fb2, newfb = fb1, prepare fb1, cleanup fb2

Where calls to prepare/cleanup are balanced.

Cc: <stable@vger.kernel.org> # v4.14+
Fixes: 25dc194b34dd ("drm: Block fb changes for async plane updates")
Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Helen Koike <helen.koike@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190603165610.24614-6-helen.koike@collabora.com

diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 2e0cb4246cbd..22a5c617f670 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1607,15 +1607,6 @@ int drm_atomic_helper_async_check(struct drm_device *dev,
 	    old_plane_state->crtc != new_plane_state->crtc)
 		return -EINVAL;
 
-	/*
-	 * FIXME: Since prepare_fb and cleanup_fb are always called on
-	 * the new_plane_state for async updates we need to block framebuffer
-	 * changes. This prevents use of a fb that's been cleaned up and
-	 * double cleanups from occuring.
-	 */
-	if (old_plane_state->fb != new_plane_state->fb)
-		return -EINVAL;
-
 	funcs = plane->helper_private;
 	if (!funcs->atomic_async_update)
 		return -EINVAL;
@@ -1646,6 +1637,8 @@ EXPORT_SYMBOL(drm_atomic_helper_async_check);
  * drm_atomic_async_check() succeeds. Async commits are not supposed to swap
  * the states like normal sync commits, but just do in-place changes on the
  * current state.
+ *
+ * TODO: Implement full swap instead of doing in-place changes.
  */
 void drm_atomic_helper_async_commit(struct drm_device *dev,
 				    struct drm_atomic_state *state)
@@ -1656,6 +1649,9 @@ void drm_atomic_helper_async_commit(struct drm_device *dev,
 	int i;
 
 	for_each_new_plane_in_state(state, plane, plane_state, i) {
+		struct drm_framebuffer *new_fb = plane_state->fb;
+		struct drm_framebuffer *old_fb = plane->state->fb;
+
 		funcs = plane->helper_private;
 		funcs->atomic_async_update(plane, plane_state);
 
@@ -1664,11 +1660,17 @@ void drm_atomic_helper_async_commit(struct drm_device *dev,
 		 * plane->state in-place, make sure at least common
 		 * properties have been properly updated.
 		 */
-		WARN_ON_ONCE(plane->state->fb != plane_state->fb);
+		WARN_ON_ONCE(plane->state->fb != new_fb);
 		WARN_ON_ONCE(plane->state->crtc_x != plane_state->crtc_x);
 		WARN_ON_ONCE(plane->state->crtc_y != plane_state->crtc_y);
 		WARN_ON_ONCE(plane->state->src_x != plane_state->src_x);
 		WARN_ON_ONCE(plane->state->src_y != plane_state->src_y);
+
+		/*
+		 * Make sure the FBs have been swapped so that cleanups in the
+		 * new_state performs a cleanup in the old FB.
+		 */
+		WARN_ON_ONCE(plane_state->fb != old_fb);
 	}
 }
 EXPORT_SYMBOL(drm_atomic_helper_async_commit);
diff --git a/include/drm/drm_modeset_helper_vtables.h b/include/drm/drm_modeset_helper_vtables.h
index f9c94c2a1364..f7bbd0b0ecd1 100644
--- a/include/drm/drm_modeset_helper_vtables.h
+++ b/include/drm/drm_modeset_helper_vtables.h
@@ -1185,6 +1185,14 @@ struct drm_plane_helper_funcs {
 	 * current one with the new plane configurations in the new
 	 * plane_state.
 	 *
+	 * Drivers should also swap the framebuffers between current plane
+	 * state (&drm_plane.state) and new_state.
+	 * This is required since cleanup for async commits is performed on
+	 * the new state, rather than old state like for traditional commits.
+	 * Since we want to give up the reference on the current (old) fb
+	 * instead of our brand new one, swap them in the driver during the
+	 * async commit.
+	 *
 	 * FIXME:
 	 *  - It only works for single plane updates
 	 *  - Async Pageflips are not supported yet

