Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92554DF63
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 11:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfD2JZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 05:25:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57127 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727775AbfD2JZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Apr 2019 05:25:56 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C30E921EA0;
        Mon, 29 Apr 2019 05:25:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 29 Apr 2019 05:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ch59li
        tEedWYsgPPwAZvRYN+TDjrkyC8xECfIghHfZE=; b=0q/Ku+UvNAalZQdZZqhlMC
        Y58DqVz3guYFhc0AXRHEAWnqhZMDypHcGcm/0/7dVdSpo3TKs6abGn4DQX4G8Woh
        4r+J+2J0zkcYmMoM658mZ+M3gmecMH3ZLci9bUFairjg0A4bBrQU5l8J0GslDYNQ
        x6rBEx2sIas7hi+nR7cAg8/7PU9JRf5+Bv0bkBilhzrHCMUZZHkxBr4/si7Oxlf5
        SvuAbXUXrJ6SFweKXQgtGuSnv6T8AB6LhuQv8anPK8JbiAaIEu5AM0xsh7iMP8ot
        gc8ljbVuIjdJ0BWYoV/SALzXjuybMyWFwi5yrnYB8psA5bp7vKph+/DOeis8TmiQ
        ==
X-ME-Sender: <xms:I8PGXFYlair6ZV5tRuP2VjMYvfNGZZdlahSZWc9X3CLibIRDnwRjwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddriedvgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:I8PGXHzAjYQdYX8cTdd4ebfoF2MXBkHDp-1XSRXvE72f7dr0-s4NMA>
    <xmx:I8PGXF3hrx36pRlPX7eyz8pfpa24Dr6eTwYAaL62QoAlN8Tl1K_o6Q>
    <xmx:I8PGXOwLNbdp8kdtxrwjdprOrp-JK-fmNywvRxi3A7p5M9RIGRiTrQ>
    <xmx:I8PGXL-zrgBVWOjLVsVIud7a5VarFMakiunVq5ZcePS9FexyqaA-Kw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 951CAE407B;
        Mon, 29 Apr 2019 05:25:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Do not enable FEC without DSC" failed to apply to 5.0-stable tree
To:     ville.syrjala@linux.intel.com, anusha.srivatsa@intel.com,
        manasi.d.navare@intel.com, rodrigo.vivi@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Apr 2019 11:25:53 +0200
Message-ID: <155652995323242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5aae7832d1b4ec614996ea0f4fafc4d9855ec0b0 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Tue, 26 Mar 2019 16:49:02 +0200
Subject: [PATCH] drm/i915: Do not enable FEC without DSC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently we enable FEC even when DSC is no used. While that is
theoretically valid supposedly there isn't much of a benefit from
this. But more importantly we do not account for the FEC link
bandwidth overhead (2.4%) in the non-DSC link bandwidth computations.
So the code may think we have enough bandwidth when we in fact
do not.

Cc: stable@vger.kernel.org
Cc: Anusha Srivatsa <anusha.srivatsa@intel.com>
Cc: Manasi Navare <manasi.d.navare@intel.com>
Fixes: 240999cf339f ("i915/dp/fec: Add fec_enable to the crtc state.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190326144903.6617-1-ville.syrjala@linux.intel.com
Reviewed-by: Manasi Navare <manasi.d.navare@intel.com>
(cherry picked from commit 6fd3134ae3551d4802a04669c0f39f2f5c56f77d)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 8891f29a8c7f..48da4a969a0a 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1886,6 +1886,9 @@ static int intel_dp_dsc_compute_config(struct intel_dp *intel_dp,
 	int pipe_bpp;
 	int ret;
 
+	pipe_config->fec_enable = !intel_dp_is_edp(intel_dp) &&
+		intel_dp_supports_fec(intel_dp, pipe_config);
+
 	if (!intel_dp_supports_dsc(intel_dp, pipe_config))
 		return -EINVAL;
 
@@ -2116,9 +2119,6 @@ intel_dp_compute_config(struct intel_encoder *encoder,
 	if (adjusted_mode->flags & DRM_MODE_FLAG_DBLCLK)
 		return -EINVAL;
 
-	pipe_config->fec_enable = !intel_dp_is_edp(intel_dp) &&
-				  intel_dp_supports_fec(intel_dp, pipe_config);
-
 	ret = intel_dp_compute_link_config(encoder, pipe_config, conn_state);
 	if (ret < 0)
 		return ret;

