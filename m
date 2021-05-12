Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A549537B97C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhELJpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:45:25 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:46537 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELJpZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:45:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id F29331307;
        Wed, 12 May 2021 05:44:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 05:44:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BIkmY7
        Y4SqiCdvMidwmqQSmOzEJyJWUcYmywK+rGC4Y=; b=uBeczGTSebzERVV/DR65s1
        5MZOTDjDT86rVVJN0Dm1/qlcPFD1f/Yqdxu3iy8HWI7aa21ly7k6q1Uta4o7NioM
        F1W1lD2DCFRNeIBV9sRJ3nGWG3hYjCDpXuxydSnbCwD67S7MRO0SwX7IYJVjmYv7
        BOK0hanD7d2BG/lCFnOaREv//AKfrSsYJCw/tou42t6pfv00G1BsByZK8kHVfsB9
        g2CTJH5P2sd4BTUqG1GPTHKFcMVpxBG3kI4/AT7yC8zCbdiGOVZDSF04B7B09ZMK
        kn9xcujduelmTqlbbGxCtzLE8lc3bO4xBuXFU01wgG1RXzkKwrpcvnfo7m9hRVMw
        ==
X-ME-Sender: <xms:b6ObYFp8R5Y5RYyd_GyVU-eWgbDyqBrzpatqbN8WyIVOPPUmrglAeQ>
    <xme:b6ObYHrqFi0kOCivKCDoc4l_FTdN73Fe73KIKqx0t6lFlnCe3NtpArEiX_ZvpRoFM
    hV2PPkW7hepcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:b6ObYCPKQ7UvK0jlbpe-hh71gdXIQl8FRNam75azo9NFd2TvOc3PhQ>
    <xmx:b6ObYA7vnwxdIkN_TY7qTJNa5RF32AaiFMeRX7v9NmzjKu17NK3bgg>
    <xmx:b6ObYE4hC9L6BDfft41Zc43FcgFLBSWZVF8qVXJczqp8rf8rRI1Y6w>
    <xmx:cKObYEHKL_wbKEfkv_qhvOP6lFYj33EbNvcffwCQ-OVMY5FrUDVaBeD1nTE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:44:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/ingenic: Fix non-OSD mode" failed to apply to 5.10-stable tree
To:     paul@crapouillou.net, daniel.vetter@ffwll.ch, hns@goldelico.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:44:13 +0200
Message-ID: <162081265325486@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 7b4957684e5d813fcbdc98144e3cc5c4467b3e2e Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Sun, 24 Jan 2021 08:55:52 +0000
Subject: [PATCH] drm/ingenic: Fix non-OSD mode

Even though the JZ4740 did not have the OSD mode, it had (according to
the documentation) two DMA channels, but there is absolutely no
information about how to select the second DMA channel.

Make the ingenic-drm driver work in non-OSD mode by using the
foreground0 plane (which is bound to the DMA0 channel) as the primary
plane, instead of the foreground1 plane, which is the primary plane
when in OSD mode.

Fixes: 3c9bea4ef32b ("drm/ingenic: Add support for OSD mode")
Cc: <stable@vger.kernel.org> # v5.8+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Tested-by: H. Nikolaus Schaller <hns@goldelico.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210124085552.29146-5-paul@crapouillou.net

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index 54ee2cb61f3c..d60e1eefc9d1 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -561,7 +561,7 @@ static void ingenic_drm_plane_atomic_update(struct drm_plane *plane,
 		height = newstate->src_h >> 16;
 		cpp = newstate->fb->format->cpp[0];
 
-		if (priv->soc_info->has_osd && plane->type == DRM_PLANE_TYPE_OVERLAY)
+		if (!priv->soc_info->has_osd || plane->type == DRM_PLANE_TYPE_OVERLAY)
 			hwdesc = &priv->dma_hwdescs->hwdesc_f0;
 		else
 			hwdesc = &priv->dma_hwdescs->hwdesc_f1;
@@ -833,6 +833,7 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 	const struct jz_soc_info *soc_info;
 	struct ingenic_drm *priv;
 	struct clk *parent_clk;
+	struct drm_plane *primary;
 	struct drm_bridge *bridge;
 	struct drm_panel *panel;
 	struct drm_encoder *encoder;
@@ -947,9 +948,11 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 	if (soc_info->has_osd)
 		priv->ipu_plane = drm_plane_from_index(drm, 0);
 
-	drm_plane_helper_add(&priv->f1, &ingenic_drm_plane_helper_funcs);
+	primary = priv->soc_info->has_osd ? &priv->f1 : &priv->f0;
 
-	ret = drm_universal_plane_init(drm, &priv->f1, 1,
+	drm_plane_helper_add(primary, &ingenic_drm_plane_helper_funcs);
+
+	ret = drm_universal_plane_init(drm, primary, 1,
 				       &ingenic_drm_primary_plane_funcs,
 				       priv->soc_info->formats_f1,
 				       priv->soc_info->num_formats_f1,
@@ -961,7 +964,7 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 
 	drm_crtc_helper_add(&priv->crtc, &ingenic_drm_crtc_helper_funcs);
 
-	ret = drm_crtc_init_with_planes(drm, &priv->crtc, &priv->f1,
+	ret = drm_crtc_init_with_planes(drm, &priv->crtc, primary,
 					NULL, &ingenic_drm_crtc_funcs, NULL);
 	if (ret) {
 		dev_err(dev, "Failed to init CRTC: %i\n", ret);

