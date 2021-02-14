Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF1F31AFB4
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 09:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhBNIOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 03:14:03 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:49341 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229673AbhBNIOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 03:14:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 5B394B0A;
        Sun, 14 Feb 2021 03:12:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 14 Feb 2021 03:12:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=awfo3z
        ISjDDiOg0gNsw/dW+Yw6NtDjwGtaABaF6sNYc=; b=pm/vCeFejFMXUiM8h8wwdV
        dg5HHkFmZkQorVxtEuUwaWWslepgmketMTR/iQV5VCRVV13vC5UMxqBSPrGTtRQ/
        i0U7UzU5MZqBuol2DEC/SZ6kt4lFyh+Qvq6APCCzFKoTuAKlg0XQJSSYy8NGSlLq
        1mU88jbeCZQg4DGd0i4N4i8Jw1maY10ljHfmvxRHfYdyvNOUCb4GpDJLGZFfm7dt
        ljgQVMmPYXt+VizK2S9Us3AT9CPrMTB5JcucF0FT0qNU4b6TOrr0yyN8vR3EDxnw
        bQNqTvladUk8qOpjQfn0dOFsL9D61Hi003DFk+//5gcu/vegQXacv8OQK9KRQE+A
        ==
X-ME-Sender: <xms:hdsoYGWsAGpRbB6h0WoRl5HzVgwqSMl2ndbvqnaWwOxHBJOnXi7uPA>
    <xme:hdsoYClBPohDsiAfPFyO50zMiosfkn1cXSUoTuoNa9U9BZazvhD-Gs-B0vfLMHZqs
    Div8uy5-wxVmg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrieeggdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:hdsoYKbsOIib-83XUCvIBsU9NyFrv7BMBVO1qoRVriFAekmPAAsgfw>
    <xmx:hdsoYNVSxYZTYxMlNre8D34klrhsQP1sGIa3Jujln_to8gTMLoJj2g>
    <xmx:hdsoYAlnD_mufyK8gXbMwcDw3xHbDaa08WAYqUqlG16rIF4us_G9GQ>
    <xmx:htsoYFzsEuSRkWMiGF4WJwWO4fTctxwKoX21Od769YE0JhjRNthp_Cd7I4U>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D60724005A;
        Sun, 14 Feb 2021 03:12:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: Fix overlay frontbuffer tracking" failed to apply to 5.4-stable tree
To:     ville.syrjala@linux.intel.com, chris@chris-wilson.co.uk,
        jani.nikula@intel.com, joonas.lahtinen@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Feb 2021 09:12:50 +0100
Message-ID: <16132903708565@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5feba0e905c495a217aea9db4ea91093d8fe5dde Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Tue, 9 Feb 2021 04:19:17 +0200
Subject: [PATCH] drm/i915: Fix overlay frontbuffer tracking
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We don't have a persistent fb holding a reference to the frontbuffer
object, so every time we do the get+put we throw the frontbuffer object
immediately away. And so the next time around we get a pristine
frontbuffer object with bits==0 even for the old vma. This confuses
the frontbuffer tracking code which understandably expects the old
frontbuffer to have the overlay's bit set.

Fix this by hanging on to the frontbuffer reference until the next
flip. And just to make this a bit more clear let's track the frontbuffer
explicitly instead of just grabbing it via the old vma.

Cc: stable@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1136
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210209021918.16234-2-ville.syrjala@linux.intel.com
Fixes: 8e7cb1799b4f ("drm/i915: Extract intel_frontbuffer active tracking")
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
(cherry picked from commit 553c23bdb4775130f333f07a51b047276bc53f79)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_overlay.c b/drivers/gpu/drm/i915/display/intel_overlay.c
index 0095c8cac9b4..b73d51e766ce 100644
--- a/drivers/gpu/drm/i915/display/intel_overlay.c
+++ b/drivers/gpu/drm/i915/display/intel_overlay.c
@@ -182,6 +182,7 @@ struct intel_overlay {
 	struct intel_crtc *crtc;
 	struct i915_vma *vma;
 	struct i915_vma *old_vma;
+	struct intel_frontbuffer *frontbuffer;
 	bool active;
 	bool pfit_active;
 	u32 pfit_vscale_ratio; /* shifted-point number, (1<<12) == 1.0 */
@@ -282,21 +283,19 @@ static void intel_overlay_flip_prepare(struct intel_overlay *overlay,
 				       struct i915_vma *vma)
 {
 	enum pipe pipe = overlay->crtc->pipe;
-	struct intel_frontbuffer *from = NULL, *to = NULL;
+	struct intel_frontbuffer *frontbuffer = NULL;
 
 	drm_WARN_ON(&overlay->i915->drm, overlay->old_vma);
 
-	if (overlay->vma)
-		from = intel_frontbuffer_get(overlay->vma->obj);
 	if (vma)
-		to = intel_frontbuffer_get(vma->obj);
+		frontbuffer = intel_frontbuffer_get(vma->obj);
 
-	intel_frontbuffer_track(from, to, INTEL_FRONTBUFFER_OVERLAY(pipe));
+	intel_frontbuffer_track(overlay->frontbuffer, frontbuffer,
+				INTEL_FRONTBUFFER_OVERLAY(pipe));
 
-	if (to)
-		intel_frontbuffer_put(to);
-	if (from)
-		intel_frontbuffer_put(from);
+	if (overlay->frontbuffer)
+		intel_frontbuffer_put(overlay->frontbuffer);
+	overlay->frontbuffer = frontbuffer;
 
 	intel_frontbuffer_flip_prepare(overlay->i915,
 				       INTEL_FRONTBUFFER_OVERLAY(pipe));

