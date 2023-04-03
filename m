Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7CC6D3FAF
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 11:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjDCJEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 05:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbjDCJEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 05:04:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530A472BA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 02:04:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2B2161558
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 09:03:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D74C433D2;
        Mon,  3 Apr 2023 09:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680512639;
        bh=jWGIUEoVIz9pYilWlHNoOwJ1TKLt2g9VhTGhREyJ9Oo=;
        h=Subject:To:Cc:From:Date:From;
        b=J530KIV3GrSJJkFC1mqy2WPq8kZyvA5oVva0oXtm99NF7kNFt9KglyxhgqR+ykU1I
         1wJZJauGhoN+hzgSt5iLYuahZQH/SzGFfBSh2H+vFYkmkCV24fduSkQzOf3drIvFkS
         oTUAcGqKmTx64SGIMU5wmGNbpI7OTUSOTRZwuI94=
Subject: FAILED: patch "[PATCH] drm/i915: Split icl_color_commit_noarm() from" failed to apply to 6.1-stable tree
To:     ville.syrjala@linux.intel.com, ddavenport@chromium.org,
        imre.deak@intel.com, jani.nikula@intel.com,
        jouni.hogander@intel.com, navaremanasi@google.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 11:03:40 +0200
Message-ID: <2023040340-kinswoman-generic-1bb5@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 76b767d4d1cd052e455cf18e06929e8b2b70101d
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040340-kinswoman-generic-1bb5@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

76b767d4d1cd ("drm/i915: Split icl_color_commit_noarm() from skl_color_commit_noarm()")
48205f42ae9b ("drm/i915: Get rid of glk_load_degamma_lut_linear()")
b1d9092240b7 ("drm/i915: Assert {pre,post}_csc_lut were assigned sensibly")
18f1b5ae7eca ("drm/i915: Introduce crtc_state->{pre,post}_csc_lut")
5ca1493e252a ("drm/i915: Make ilk_load_luts() deal with degamma")
a2b1d9ecaa75 ("drm/i915: Clean up some namespacing")
adc831bfc885 ("drm/i915: Make DRRS debugfs per-crtc/connector")
2e25c1fba714 ("drm/i915: Make the DRRS debugfs contents more consistent")
61564e6c5a4a ("drm/i915: Move DRRS debugfs next to the implementation")
296cd8ecfd30 ("drm/i915: Change glk_load_degamma_lut() calling convention")
7671fc626526 ("drm/i915: Clean up intel_color_init_hooks()")
2a40e5848a95 ("drm/i915: Simplify the intel_color_init_hooks() if ladder")
064751a6c5dc ("drm/i915: Split up intel_color_init()")
319b0869f51c ("drm/i915: Remove PLL asserts from .load_luts()")
1bed8b073420 ("drm/i915/hotplug: move hotplug storm debugfs to intel_hotplug.c")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 76b767d4d1cd052e455cf18e06929e8b2b70101d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Mon, 20 Mar 2023 11:54:33 +0200
Subject: [PATCH] drm/i915: Split icl_color_commit_noarm() from
 skl_color_commit_noarm()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We're going to want different behavior for skl/glk vs. icl
in .color_commit_noarm(), so split the hook into two. Arguably
we already had slightly different behaviour since
csc_enable/gamma_enable are never set on icl+, so the old
code was perhaps a bit confusing as well.

Cc: <stable@vger.kernel.org> #v5.19+
Cc: Manasi Navare <navaremanasi@google.com>
Cc: Drew Davenport <ddavenport@chromium.org>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-2-ville.syrjala@linux.intel.com
Reviewed-by: Imre Deak <imre.deak@intel.com>
(cherry picked from commit f161eb01f50ab31f2084975b43bce54b7b671e17)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_color.c b/drivers/gpu/drm/i915/display/intel_color.c
index 8d97c299e657..ce2c3819146c 100644
--- a/drivers/gpu/drm/i915/display/intel_color.c
+++ b/drivers/gpu/drm/i915/display/intel_color.c
@@ -677,6 +677,25 @@ static void skl_color_commit_arm(const struct intel_crtc_state *crtc_state)
 			  crtc_state->csc_mode);
 }
 
+static void icl_color_commit_arm(const struct intel_crtc_state *crtc_state)
+{
+	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
+	struct drm_i915_private *i915 = to_i915(crtc->base.dev);
+	enum pipe pipe = crtc->pipe;
+
+	/*
+	 * We don't (yet) allow userspace to control the pipe background color,
+	 * so force it to black.
+	 */
+	intel_de_write(i915, SKL_BOTTOM_COLOR(pipe), 0);
+
+	intel_de_write(i915, GAMMA_MODE(crtc->pipe),
+		       crtc_state->gamma_mode);
+
+	intel_de_write_fw(i915, PIPE_CSC_MODE(crtc->pipe),
+			  crtc_state->csc_mode);
+}
+
 static struct drm_property_blob *
 create_linear_lut(struct drm_i915_private *i915, int lut_size)
 {
@@ -3067,7 +3086,7 @@ static const struct intel_color_funcs i9xx_color_funcs = {
 static const struct intel_color_funcs icl_color_funcs = {
 	.color_check = icl_color_check,
 	.color_commit_noarm = icl_color_commit_noarm,
-	.color_commit_arm = skl_color_commit_arm,
+	.color_commit_arm = icl_color_commit_arm,
 	.load_luts = icl_load_luts,
 	.read_luts = icl_read_luts,
 	.lut_equal = icl_lut_equal,

