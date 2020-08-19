Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB23E249FBA
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgHSNZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:25:39 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:37807 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728516AbgHSNYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:24:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B5CF5C36;
        Wed, 19 Aug 2020 09:24:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=w0QqPd
        ekdxRMpKzYGE6tSy0HBtAosxQeGdGKr2Ou3Nw=; b=JpeCPbI2lydb0/KBRLfQP5
        LEXLmDWt9NZJTMm4lcTL9ym8arqcAf/A/EPYI1P1wU/dc3dnYeURmdjr3hL9BmDf
        Ob2qKXHEoo/KEiuMUvHVlorkhYQ2lUdEuQ556+Es/sJp9/m4ZxIEgHVRPqCwuD0X
        in5ilwGaa3HhOoZHejM6NIOflwigpMrKaQT5kbB9+icG0rPEZmQGX4ugfkXkKF7O
        EYT8NvB2JXEvwnax2lp1a743VXZAWwllsb1YukRJSQXZoiw7DrliH6h+Bhi57YxS
        580kFYkUJPTmepsA33I26Wcpl6hZqVIjLPleOK7bJt7i/LeK3oIpBB/AvSQDZEWQ
        ==
X-ME-Sender: <xms:_ic9X2aWy9m5pVuahzNkF7i_CJ-bh_hO6N1LvNVQ4e3Newzj8e8ziQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_ic9X5bJzAbHF_RY1xfz1Mz-_orbhzJyLaAcG2Gm2zOo7njZC1ocjA>
    <xmx:_ic9Xw_x9sMpeFXbY9hE512dDvJujLlbGvrTYXH4iImDTfHPY4arMg>
    <xmx:_ic9X4qJb83UeTv7NkDxsTk_kS-JgSxD1YCvOLbAjVptZadd44I0zQ>
    <xmx:ASg9Xydhg_VsVhOgkfkDKRCnncA3cGOvTJ3YYSHASiiPUP9vh1WL641RwRs>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 389393280064;
        Wed, 19 Aug 2020 09:24:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/ast: Initialize DRAM type before posting GPU" failed to apply to 5.8-stable tree
To:     tzimmermann@suse.de, airlied@redhat.com, benh@kernel.crashing.org,
        daniel.vetter@ffwll.ch, emil.l.velikov@gmail.com, joel@jms.id.au,
        kraxel@redhat.com, sam@ravnborg.org, stable@vger.kernel.org,
        yc_chen@aspeedtech.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:24:36 +0200
Message-ID: <159784347624436@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 244d012801dae30c91983b360457c78d481584b0 Mon Sep 17 00:00:00 2001
From: Thomas Zimmermann <tzimmermann@suse.de>
Date: Thu, 16 Jul 2020 14:53:52 +0200
Subject: [PATCH] drm/ast: Initialize DRAM type before posting GPU

Posting the GPU requires the correct DRAM type to be stored in
struct ast_private. Therefore first initialize the DRAM info and
then post the GPU. This restores the original order of instructions
in this function.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Fixes: bad09da6deab ("drm/ast: Fixed vram size incorrect issue on POWER")
Cc: Joel Stanley <joel@jms.id.au>
Cc: Y.C. Chen <yc_chen@aspeedtech.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
Cc: <stable@vger.kernel.org> # v4.11+
Link: https://patchwork.freedesktop.org/patch/msgid/20200716125353.31512-6-tzimmermann@suse.de

diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index b162cc82204d..87e5baded2a7 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -418,15 +418,15 @@ int ast_driver_load(struct drm_device *dev, unsigned long flags)
 
 	ast_detect_chip(dev, &need_post);
 
-	if (need_post)
-		ast_post_gpu(dev);
-
 	ret = ast_get_dram_info(dev);
 	if (ret)
 		goto out_free;
 	drm_info(dev, "dram MCLK=%u Mhz type=%d bus_width=%d\n",
 		 ast->mclk, ast->dram_type, ast->dram_bus_width);
 
+	if (need_post)
+		ast_post_gpu(dev);
+
 	ret = ast_mm_init(ast);
 	if (ret)
 		goto out_free;

