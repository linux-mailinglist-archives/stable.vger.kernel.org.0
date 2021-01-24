Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCBF301C43
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbhAXNev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:34:51 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:48795 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726398AbhAXNeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:34:50 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 09785E9F;
        Sun, 24 Jan 2021 08:34:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:34:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PYB0vj
        +SkWMQmKI/mUKue1SqCeZL82NFT1LznPmL+40=; b=jhMTYn+gTfGY/aiUJTiXmo
        +x7Q2SO7TjhTF9UI3XSYij8Sa2u+1DgD1yWeiol+afDi+lP7jmWtDecV8ioaAAJF
        LldA69Dd+dAhytlK4ChMnmNsgRW0BM3VgjqImcDARMukDmBk6iGhihc7yZsFb0pf
        BVLzCt/mFb7V4GpcSGXVI1Sd+18rMhrUyPXBEuZ/qqsDTakaMo2KRpYcCn6w9asa
        TLSPBlYLWph5Q1KCvdY7I5TQLAhpdxEvs7wGjbWiUtKRUWDyTGo6EGEDvZtJKGzG
        4dybCTIZcTQPZCVFWhvT5MKbd23KfXS6eC5sMLip/b+9SdwsMcsZu4Z0z2ljsa3Q
        ==
X-ME-Sender: <xms:S3cNYI1JbaRezncoQqd9fdRrOOghKuzn-GRivpdYWxrvJ2jQ9LUe0A>
    <xme:S3cNYDEbj47TyuaYg0rNWWJByoKBy-9CuZ3Vu4r2SuNM1UbjqON4f4pbDvt-4Idw1
    fnNwOLftJZS1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpedvffegjeejiedtieffjeeijeffgfehvdeiudejheefge
    evhffhvedvfeeuheekleenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:S3cNYA7y6MsaI0qKib6yZf0eODlJkoxuxxjk4nl3EbY-mGZtiHSUPw>
    <xmx:S3cNYB0Qc6mslMwR_-xnVNQk_3qaoy1yX5RTv4Qk01Bz0ActSLUMVQ>
    <xmx:S3cNYLGud8ME-MgpxR8-wdGYBOYnZhRAj_CrCUkQREFfOQ1w64YKtQ>
    <xmx:S3cNYOMCsc04Pdh4KHDyyaEqqeQ7KVjSr9O-fNt73em6ldxzABNjlfnRw0I>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5164A108005C;
        Sun, 24 Jan 2021 08:34:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: Only enable DFP 4:4:4->4:2:0 conversion when" failed to apply to 5.10-stable tree
To:     ville.syrjala@linux.intel.com, jani.nikula@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:34:02 +0100
Message-ID: <161149524220215@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 1c4995b0a576d24bb7ead991fb037c8b47ab6e32 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Mon, 18 Jan 2021 17:43:55 +0200
Subject: [PATCH] drm/i915: Only enable DFP 4:4:4->4:2:0 conversion when
 outputting YCbCr 4:4:4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Let's not enable the 4:4:4->4:2:0 conversion bit in the DFP unless we're
actually outputting YCbCr 4:4:4. It would appear some protocol
converters blindy consult this bit even when the source is outputting
RGB, resulting in a visual mess.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2914
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210111164111.13302-1-ville.syrjala@linux.intel.com
Fixes: 181567aa9f0d ("drm/i915: Do YCbCr 444->420 conversion via DP protocol converters")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 3170a21f7059c4660c469f59bf529f372a57da5f)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210118154355.24453-1-ville.syrjala@linux.intel.com

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 92940a0c5ef8..d5ace48b1ace 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3725,7 +3725,7 @@ static void hsw_ddi_pre_enable_dp(struct intel_atomic_state *state,
 	intel_ddi_init_dp_buf_reg(encoder, crtc_state);
 	if (!is_mst)
 		intel_dp_set_power(intel_dp, DP_SET_POWER_D0);
-	intel_dp_configure_protocol_converter(intel_dp);
+	intel_dp_configure_protocol_converter(intel_dp, crtc_state);
 	intel_dp_sink_set_decompression_state(intel_dp, crtc_state,
 					      true);
 	intel_dp_sink_set_fec_ready(intel_dp, crtc_state);
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 37f1a10fd021..09123e8625c4 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -4014,7 +4014,8 @@ static void intel_dp_enable_port(struct intel_dp *intel_dp,
 	intel_de_posting_read(dev_priv, intel_dp->output_reg);
 }
 
-void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp)
+void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp,
+					   const struct intel_crtc_state *crtc_state)
 {
 	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
 	u8 tmp;
@@ -4033,8 +4034,8 @@ void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp)
 		drm_dbg_kms(&i915->drm, "Failed to set protocol converter HDMI mode to %s\n",
 			    enableddisabled(intel_dp->has_hdmi_sink));
 
-	tmp = intel_dp->dfp.ycbcr_444_to_420 ?
-		DP_CONVERSION_TO_YCBCR420_ENABLE : 0;
+	tmp = crtc_state->output_format == INTEL_OUTPUT_FORMAT_YCBCR444 &&
+		intel_dp->dfp.ycbcr_444_to_420 ? DP_CONVERSION_TO_YCBCR420_ENABLE : 0;
 
 	if (drm_dp_dpcd_writeb(&intel_dp->aux,
 			       DP_PROTOCOL_CONVERTER_CONTROL_1, tmp) != 1)
@@ -4088,7 +4089,7 @@ static void intel_enable_dp(struct intel_atomic_state *state,
 	}
 
 	intel_dp_set_power(intel_dp, DP_SET_POWER_D0);
-	intel_dp_configure_protocol_converter(intel_dp);
+	intel_dp_configure_protocol_converter(intel_dp, pipe_config);
 	intel_dp_start_link_train(intel_dp, pipe_config);
 	intel_dp_stop_link_train(intel_dp, pipe_config);
 
diff --git a/drivers/gpu/drm/i915/display/intel_dp.h b/drivers/gpu/drm/i915/display/intel_dp.h
index b871a09b6901..05f7ddf7a795 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.h
+++ b/drivers/gpu/drm/i915/display/intel_dp.h
@@ -51,7 +51,8 @@ int intel_dp_get_link_train_fallback_values(struct intel_dp *intel_dp,
 int intel_dp_retrain_link(struct intel_encoder *encoder,
 			  struct drm_modeset_acquire_ctx *ctx);
 void intel_dp_set_power(struct intel_dp *intel_dp, u8 mode);
-void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp);
+void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp,
+					   const struct intel_crtc_state *crtc_state);
 void intel_dp_sink_set_decompression_state(struct intel_dp *intel_dp,
 					   const struct intel_crtc_state *crtc_state,
 					   bool enable);

