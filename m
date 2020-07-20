Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D282A225EC8
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgGTMrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:47:36 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:47673 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728461AbgGTMrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:47:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8602B1940357;
        Mon, 20 Jul 2020 08:47:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:47:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=KqgcsM
        R0AgE/SddBsMRC9ZPwCRrz6sSU/WTMfnv7Iyk=; b=dI18uRlAsGDvysjuZkGGR4
        G/uELxUeRD/X9Y5Wye8sxZ0McjSsuJd/3JdkpGUrBx5nwZRWcb6YEtO3DbnvTNr4
        Sn1kzAiUlicDH66ZpFMwekj+vI/xnNPOe+j1A7RL5lngYaRaE+9+hZxIIpimZ806
        HYuHhep7O+PRp+CVUnw0QRz41zJrk1ueqO6kqlcCE8dRAIqhQujZo/yd42kZ1qnD
        kmGC9kywzzGYq3aRKMH6Vkib8fxf0AJPQmTP1kTH+TNAxhl35a9lk1KBo47pQMXT
        4Mdrgh/Lskn1MCXrEn82SNi/Cm2cOk2sigMhBDft7BPsmb9+leA/mz/rNXBpKQUA
        ==
X-ME-Sender: <xms:ZpIVX7SaSqUQxe-n8tXANafgBjs6Itya2Qrhi2OCkfGtxJYfKqJf7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpedvffegjeejiedtieffjeeijeffgfehvdeiudejheefge
    evhffhvedvfeeuheekleenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ZpIVX8yyp2UfZG92_DBXd6KvQjuhqJQtOViiWNS-KwYHZ9njob2nVQ>
    <xmx:ZpIVXw3BeqbIVeqjSJxN31B6QuNtRgBNTWzV_yQpUjSkZa8JCUfNtA>
    <xmx:ZpIVX7BMla4UzEbaTA1-2Yf5YQDFBcQmO2IImCPT0V9Cw6HhV--pXw>
    <xmx:ZpIVX8IS6NXhcchLmtKqPepDfIQFNNU_nWEGphXmqx9U8l7BOLMCTQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E4EEF306005F;
        Mon, 20 Jul 2020 08:47:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Recalculate FBC w/a stride when needed" failed to apply to 5.7-stable tree
To:     ville.syrjala@linux.intel.com, jani.nikula@intel.com,
        jose.souza@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:47:44 +0200
Message-ID: <1595249264177183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 92e0575b99835b5b3aaab2132dd551e0e04eb96a Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Sat, 11 Jul 2020 11:03:36 +0300
Subject: [PATCH] drm/i915: Recalculate FBC w/a stride when needed
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently we're failing to recalculate the gen9 FBC w/a stride
unless something more drastic than just the modifier itself has
changed. This often leaves us with FBC enabled with the linear
fbdev framebuffer without the w/a stride enabled. That will cause
an immediate underrun and FBC will get promptly disabled.

Fix the problem by checking if the w/a stride is about to change,
and go through the full dance if so. This part of the FBC code
is still pretty much a disaster and will need lots more work.
But this should at least fix the immediate issue.

v2: Deactivate FBC when the modifier changes since that will
    likely require resetting the w/a CFB stride

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200711080336.13423-1-ville.syrjala@linux.intel.com
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
(cherry picked from commit 0428ab013fdd39dbfb8f4cd8ad2b60af3776c6b9)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_fbc.c b/drivers/gpu/drm/i915/display/intel_fbc.c
index a65d9d8b79a7..412572f88b67 100644
--- a/drivers/gpu/drm/i915/display/intel_fbc.c
+++ b/drivers/gpu/drm/i915/display/intel_fbc.c
@@ -719,6 +719,25 @@ static bool intel_fbc_cfb_size_changed(struct drm_i915_private *dev_priv)
 		fbc->compressed_fb.size * fbc->threshold;
 }
 
+static u16 intel_fbc_gen9_wa_cfb_stride(struct drm_i915_private *dev_priv)
+{
+	struct intel_fbc *fbc = &dev_priv->fbc;
+	struct intel_fbc_state_cache *cache = &fbc->state_cache;
+
+	if ((IS_GEN9_BC(dev_priv) || IS_BROXTON(dev_priv)) &&
+	    cache->fb.modifier != I915_FORMAT_MOD_X_TILED)
+		return DIV_ROUND_UP(cache->plane.src_w, 32 * fbc->threshold) * 8;
+	else
+		return 0;
+}
+
+static bool intel_fbc_gen9_wa_cfb_stride_changed(struct drm_i915_private *dev_priv)
+{
+	struct intel_fbc *fbc = &dev_priv->fbc;
+
+	return fbc->params.gen9_wa_cfb_stride != intel_fbc_gen9_wa_cfb_stride(dev_priv);
+}
+
 static bool intel_fbc_can_enable(struct drm_i915_private *dev_priv)
 {
 	struct intel_fbc *fbc = &dev_priv->fbc;
@@ -877,6 +896,7 @@ static void intel_fbc_get_reg_params(struct intel_crtc *crtc,
 	params->crtc.i9xx_plane = to_intel_plane(crtc->base.primary)->i9xx_plane;
 
 	params->fb.format = cache->fb.format;
+	params->fb.modifier = cache->fb.modifier;
 	params->fb.stride = cache->fb.stride;
 
 	params->cfb_size = intel_fbc_calculate_cfb_size(dev_priv, cache);
@@ -906,6 +926,9 @@ static bool intel_fbc_can_flip_nuke(const struct intel_crtc_state *crtc_state)
 	if (params->fb.format != cache->fb.format)
 		return false;
 
+	if (params->fb.modifier != cache->fb.modifier)
+		return false;
+
 	if (params->fb.stride != cache->fb.stride)
 		return false;
 
@@ -1185,7 +1208,8 @@ void intel_fbc_enable(struct intel_atomic_state *state,
 
 	if (fbc->crtc) {
 		if (fbc->crtc != crtc ||
-		    !intel_fbc_cfb_size_changed(dev_priv))
+		    (!intel_fbc_cfb_size_changed(dev_priv) &&
+		     !intel_fbc_gen9_wa_cfb_stride_changed(dev_priv)))
 			goto out;
 
 		__intel_fbc_disable(dev_priv);
@@ -1207,12 +1231,7 @@ void intel_fbc_enable(struct intel_atomic_state *state,
 		goto out;
 	}
 
-	if ((IS_GEN9_BC(dev_priv) || IS_BROXTON(dev_priv)) &&
-	    plane_state->hw.fb->modifier != I915_FORMAT_MOD_X_TILED)
-		cache->gen9_wa_cfb_stride =
-			DIV_ROUND_UP(cache->plane.src_w, 32 * fbc->threshold) * 8;
-	else
-		cache->gen9_wa_cfb_stride = 0;
+	cache->gen9_wa_cfb_stride = intel_fbc_gen9_wa_cfb_stride(dev_priv);
 
 	drm_dbg_kms(&dev_priv->drm, "Enabling FBC on pipe %c\n",
 		    pipe_name(crtc->pipe));
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index f79f118bf192..ae99a9190200 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -440,6 +440,7 @@ struct intel_fbc {
 		struct {
 			const struct drm_format_info *format;
 			unsigned int stride;
+			u64 modifier;
 		} fb;
 
 		int cfb_size;

