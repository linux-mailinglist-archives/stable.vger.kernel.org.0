Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA296C0E7F
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 11:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCTKRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 06:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjCTKRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 06:17:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8AE1166E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 03:17:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2873A61337
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3632CC433D2;
        Mon, 20 Mar 2023 10:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679307435;
        bh=tIA896qHFzRnvtwfLo5xdZqB5v5taIAejQUQpTGKsKM=;
        h=Subject:To:Cc:From:Date:From;
        b=Mswb8kAIS4qkFZIQlTleL71JoLKhVSHJT4u+Ppk4ZnDK1I74cCcX45NEjmgCu4qxb
         msTXFciDug5Bmi+KHin+pfNz+RhWB3DOOxUI4c1O6AP9a4BXf4Zf0A1Z+257dQt31M
         +k1Ki2AL5Vhfr4rEzUbX0OCd60CVwqKHYzAuQ5lc=
Subject: FAILED: patch "[PATCH] drm/sun4i: fix missing component unbind on bind errors" failed to apply to 4.19-stable tree
To:     johan+linaro@kernel.org, maxime@cerno.tech, mripard@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 11:17:02 +0100
Message-ID: <16793074223088@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x c22f2ff8724b49dce2ae797e9fbf4bc0fa91112f
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16793074223088@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

c22f2ff8724b ("drm/sun4i: fix missing component unbind on bind errors")
6848c291a54f ("drm/aperture: Convert drivers to aperture interfaces")
dc739820ff90 ("drm/ast: fix memory leak when unload the driver")
31856c8c1ce4 ("drm/vmwgfx: Remove stealth mode")
840462e6872d ("drm/vmwgfx: Remove references to struct drm_device.pdev")
5bbacc2e7ab1 ("drm/virtgpu: Remove references to struct drm_device.pdev")
cff0adca1edd ("drm/ast: Managed device release")
4bc85b82c8ba ("drm/ast: Manage release of firmware backup memory")
2c0b6566d621 ("drm/ast: Managed release of ast firmware")
e0f5a738cfe5 ("drm/ast: Embed struct drm_device in struct ast_private")
fbe01716ed4a ("drm/ast: Replace driver load/unload functions with device create/destroy")
d50ace1e72f0 ("drm/ast: Separate DRM driver from PCI code")
03ba7e00f805 ("drm/ast: Use managed MM initialization")
0149e7805b3c ("drm/ast: Move VRAM size detection to ast_mm.c")
8e46dc585389 ("drm/ast: Use managed VRAM-helper initialization")
e6949ff3ca85 ("drm/ast: Initialize mode setting in ast_mode_config_init()")
1728bf6402c3 ("drm/ast: Use managed mode-config init")
6bb18c9be6d2 ("drm/ast: Init cursors before creating modesetting structures")
3e9d787371ea ("drm/ast: Managed cursor release")
0d384eec10ea ("drm/ast: Keep cursor HW BOs mapped")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c22f2ff8724b49dce2ae797e9fbf4bc0fa91112f Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 6 Mar 2023 11:32:42 +0100
Subject: [PATCH] drm/sun4i: fix missing component unbind on bind errors

Make sure to unbind all subcomponents when binding the aggregate device
fails.

Fixes: 9026e0d122ac ("drm: Add Allwinner A10 Display Engine support")
Cc: stable@vger.kernel.org      # 4.7
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20230306103242.4775-1-johan+linaro@kernel.org

diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index cc94efbbf2d4..d6c741716167 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -95,12 +95,12 @@ static int sun4i_drv_bind(struct device *dev)
 	/* drm_vblank_init calls kcalloc, which can fail */
 	ret = drm_vblank_init(drm, drm->mode_config.num_crtc);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	/* Remove early framebuffers (ie. simplefb) */
 	ret = drm_aperture_remove_framebuffers(false, &sun4i_drv_driver);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	sun4i_framebuffer_init(drm);
 
@@ -119,6 +119,8 @@ static int sun4i_drv_bind(struct device *dev)
 
 finish_poll:
 	drm_kms_helper_poll_fini(drm);
+unbind_all:
+	component_unbind_all(dev, NULL);
 cleanup_mode_config:
 	drm_mode_config_cleanup(drm);
 	of_reserved_mem_device_release(dev);

