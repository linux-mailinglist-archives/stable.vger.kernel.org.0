Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 385E13A4AF
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 12:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfFIK3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 06:29:19 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:54513 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727853AbfFIK3T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 06:29:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A1A9E3DF;
        Sun,  9 Jun 2019 06:29:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Jun 2019 06:29:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=TZL1Pf
        DAdhVhBUZoibb5GtNRJWQCZssK1cCaCj3oQsc=; b=1w1JHPHP2/qzkPfufupDI3
        mwXO7oJo843ISTfvUKF9VFWI1zNbYpNGKF5IbIvEnPEpklTHpqDEPrC3ggg+TuEQ
        8HYB2LOmXfdLNKy+dnTZtFDmtiZ1hbcTKq1HNhHSXflecfFDWlfNobbXWvI6ekvz
        YrOKJs9Lt7mDNunJVL8t+qGKpWwdD4KASj9x4hhBLFXQApkMV+Yxvex9wI4VHy5Q
        t9OzQu7xI1welreMBti/9rRHZgxtbnVZfBLVS6vIroNB8MtFhmf01gREbXMeKJxh
        s9/SPa2wS6TpHHPlQfvpCjOeswlS9Fq98+R+tcpw0teAP+uB9/FJcyhuu6PssMeg
        ==
X-ME-Sender: <xms:fd_8XJVJcUR_GEYhhPNq86JnylSxFUdxcqdiJ5DS1vvjsgDzjSJALA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehtddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:fd_8XA2AK7_a3woc-IGH9LnmRX5402ZFtrsqM8ImEo_2RE_ojVy6Fw>
    <xmx:fd_8XAR7Df1o7bcr4w1Hetxb9jIuuar_e4_SSdD5USVoat7btKrGow>
    <xmx:fd_8XMSAXdq5xl8wggMVe5hAm1pHO7SgKO-4qBMdg3gxb_MTEabOsw>
    <xmx:ft_8XC-22sP12gPvDE0T5rhO-C7iF4xPYyZsRJYlmDMQ9EIdhrf9LA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5BB1B80062;
        Sun,  9 Jun 2019 06:29:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Fix fastset vs. pfit on/off on HSW EDP transcoder" failed to apply to 5.1-stable tree
To:     ville.syrjala@linux.intel.com, hdegoede@redhat.com,
        joonas.lahtinen@linux.intel.com, maarten.lankhorst@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Jun 2019 12:29:15 +0200
Message-ID: <15600761551228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From da471250706e2f103a1627d1d279c9de44325993 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Thu, 25 Apr 2019 19:29:05 +0300
Subject: [PATCH] drm/i915: Fix fastset vs. pfit on/off on HSW EDP transcoder
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On HSW the pipe A panel fitter lives inside the display power well,
and the input MUX for the EDP transcoder needs to be configured
appropriately to route the data through the power well as needed.
Changing the MUX setting is not allowed while the pipe is active,
so we need to force a full modeset whenever we need to change it.

Currently we may end up doing a fastset which won't change the
MUX settings, but it will drop the power well reference, and that
kills the pipe.

Cc: stable@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Fixes: d19f958db23c ("drm/i915: Enable fastset for non-boot modesets.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190425162906.5242-1-ville.syrjala@linux.intel.com
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
(cherry picked from commit 13b7648b7eab7e8259a2fb267b498bd9eba81ca0)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 3bd40a4a6739..5098228f1302 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -12082,6 +12082,7 @@ intel_pipe_config_compare(struct drm_i915_private *dev_priv,
 			  struct intel_crtc_state *pipe_config,
 			  bool adjust)
 {
+	struct intel_crtc *crtc = to_intel_crtc(current_config->base.crtc);
 	bool ret = true;
 	bool fixup_inherited = adjust &&
 		(current_config->base.mode.private_flags & I915_MODE_FLAG_INHERITED) &&
@@ -12303,6 +12304,14 @@ intel_pipe_config_compare(struct drm_i915_private *dev_priv,
 		PIPE_CONF_CHECK_X(gmch_pfit.pgm_ratios);
 	PIPE_CONF_CHECK_X(gmch_pfit.lvds_border_bits);
 
+	/*
+	 * Changing the EDP transcoder input mux
+	 * (A_ONOFF vs. A_ON) requires a full modeset.
+	 */
+	if (IS_HASWELL(dev_priv) && crtc->pipe == PIPE_A &&
+	    current_config->cpu_transcoder == TRANSCODER_EDP)
+		PIPE_CONF_CHECK_BOOL(pch_pfit.enabled);
+
 	if (!adjust) {
 		PIPE_CONF_CHECK_I(pipe_src_w);
 		PIPE_CONF_CHECK_I(pipe_src_h);
diff --git a/drivers/gpu/drm/i915/intel_pipe_crc.c b/drivers/gpu/drm/i915/intel_pipe_crc.c
index e94b5b1bc1b7..e7c7be4911c1 100644
--- a/drivers/gpu/drm/i915/intel_pipe_crc.c
+++ b/drivers/gpu/drm/i915/intel_pipe_crc.c
@@ -311,10 +311,17 @@ intel_crtc_crc_setup_workarounds(struct intel_crtc *crtc, bool enable)
 	pipe_config->base.mode_changed = pipe_config->has_psr;
 	pipe_config->crc_enabled = enable;
 
-	if (IS_HASWELL(dev_priv) && crtc->pipe == PIPE_A) {
+	if (IS_HASWELL(dev_priv) &&
+	    pipe_config->base.active && crtc->pipe == PIPE_A &&
+	    pipe_config->cpu_transcoder == TRANSCODER_EDP) {
+		bool old_need_power_well = pipe_config->pch_pfit.enabled ||
+			pipe_config->pch_pfit.force_thru;
+		bool new_need_power_well = pipe_config->pch_pfit.enabled ||
+			enable;
+
 		pipe_config->pch_pfit.force_thru = enable;
-		if (pipe_config->cpu_transcoder == TRANSCODER_EDP &&
-		    pipe_config->pch_pfit.enabled != enable)
+
+		if (old_need_power_well != new_need_power_well)
 			pipe_config->base.connectors_changed = true;
 	}
 

