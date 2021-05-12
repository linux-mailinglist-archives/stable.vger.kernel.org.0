Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E8E37B9B5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhELJyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:54:52 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:36173 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhELJyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:54:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id AB7E61429;
        Wed, 12 May 2021 05:53:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 05:53:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ObNeXx
        TKbhZOcAK5jHOSeij0xyAH2ICvUcQrfLVUh58=; b=GZ7GLUs2GtD1IMjYoj23Cp
        7MTolsYnGu7snVF4S+D+DFH+iZnKBRkoCxbn+FJVwmfzLvkqGwUKcBPOqlQ7KO53
        FcGKHqi9F5av0d2GLPXuHd+LKN8yn0zL/LpmvTs+MGVCvxxR/NgKSmldwEh9zvsX
        wgDXCltI8mv5uABmnKQwmBEEH9+I9/+PRxo3qbTyv3E9MyqsBJ9WrvsFuTxhbO0u
        KIk02HfYA75QzToFY6Ope17mrWJl62zQeUtOVPLRJzSQHSnc0dDAKkFvCLT+YNWk
        jxs6F2s9AzerzppMEda4+fHLZsagplDMBzR2M9i5Yo3f/2e5Rnmikw+6OdAuUvDw
        ==
X-ME-Sender: <xms:pqWbYM5utyaQi3ioTJ-0HXyrJznsbjYqaX1V_fky55Ui1FmI4lStqQ>
    <xme:pqWbYN5dhVtZPwXHpbADi_OPYLYxI55NjvMyZhryfwH2YE0lsRMfXvRb2NAzWZ6yv
    51bEmD5jJ364g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:pqWbYLfDJs6xgt9lf4nFqn5i2KUyaKBGpcLDLUqD_2Ir4FycNNGB0A>
    <xmx:pqWbYBIr7_29OTikWDpG5y8_J8oBUZPHoY1-x-XxLHVTZVtn83b0Zg>
    <xmx:pqWbYAJHY4yHn66wUwSmTworeeWFID56sNQwVZvA2YUUlhmcGMLFNg>
    <xmx:pqWbYKjGhcqx02mFWnCo8JN14Jh2xXUPM3WBN2ToD5BeBUhOMiPunU_mUGE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:53:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/ingenic: Register devm action to cleanup encoders" failed to apply to 5.11-stable tree
To:     paul@crapouillou.net, laurent.pinchart@ideasonboard.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:53:30 +0200
Message-ID: <16208132106179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e488b1023a4a4eab15b905871cf8e81f00336ed7 Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Sat, 27 Mar 2021 11:57:42 +0000
Subject: [PATCH] drm/ingenic: Register devm action to cleanup encoders

Since the encoders have been devm-allocated, they will be freed way
before drm_mode_config_cleanup() is called. To avoid use-after-free
conditions, we then must ensure that drm_encoder_cleanup() is called
before the encoders are freed.

v2: Use the new __drmm_simple_encoder_alloc() function

v3: Use the new drmm_plain_simple_encoder_alloc() macro

v4: Use drmm_plain_encoder_alloc() macro

Fixes: c369cb27c267 ("drm/ingenic: Support multiple panels/bridges")
Cc: <stable@vger.kernel.org> # 5.8+
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210327115742.18986-4-paul@crapouillou.net

diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index d60e1eefc9d1..29742ec5ab95 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -24,6 +24,7 @@
 #include <drm/drm_crtc.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_drv.h>
+#include <drm/drm_encoder.h>
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_fb_helper.h>
@@ -37,7 +38,6 @@
 #include <drm/drm_plane.h>
 #include <drm/drm_plane_helper.h>
 #include <drm/drm_probe_helper.h>
-#include <drm/drm_simple_kms_helper.h>
 #include <drm/drm_vblank.h>
 
 struct ingenic_dma_hwdesc {
@@ -1024,20 +1024,17 @@ static int ingenic_drm_bind(struct device *dev, bool has_components)
 			bridge = devm_drm_panel_bridge_add_typed(dev, panel,
 								 DRM_MODE_CONNECTOR_DPI);
 
-		encoder = devm_kzalloc(dev, sizeof(*encoder), GFP_KERNEL);
-		if (!encoder)
-			return -ENOMEM;
+		encoder = drmm_plain_encoder_alloc(drm, NULL, DRM_MODE_ENCODER_DPI, NULL);
+		if (IS_ERR(encoder)) {
+			ret = PTR_ERR(encoder);
+			dev_err(dev, "Failed to init encoder: %d\n", ret);
+			return ret;
+		}
 
 		encoder->possible_crtcs = 1;
 
 		drm_encoder_helper_add(encoder, &ingenic_drm_encoder_helper_funcs);
 
-		ret = drm_simple_encoder_init(drm, encoder, DRM_MODE_ENCODER_DPI);
-		if (ret) {
-			dev_err(dev, "Failed to init encoder: %d\n", ret);
-			return ret;
-		}
-
 		ret = drm_bridge_attach(encoder, bridge, NULL, 0);
 		if (ret) {
 			dev_err(dev, "Unable to attach bridge\n");

