Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7C96CBF4E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjC1MiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjC1MiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:38:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6676A5C1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:37:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 671EC61751
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 12:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF94C433D2;
        Tue, 28 Mar 2023 12:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680007025;
        bh=zImLgfP4jJdMojImLGL2qrnCXQZm1obkYiyqxahBZX4=;
        h=Subject:To:Cc:From:Date:From;
        b=L1HWFQUPnNupyYsMsrdM4GmV5oWV0PF6RaOgUanGoMtekmrq1knVKTpVmTrTNGsza
         LC6zxdwDXawGkXqzPCwd7k0GiWsf4nENDs85p5CDsNakeDoxneL+7vK/YARmoKd9wp
         hz+jSo/qQh5TFWcltc+eR1QW6xAwh+cp64PGoZa4=
Subject: FAILED: patch "[PATCH] drm/meson: fix missing component unbind on bind errors" failed to apply to 5.4-stable tree
To:     johan+linaro@kernel.org, neil.armstrong@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 14:36:40 +0200
Message-ID: <1680007000120162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x ba98413bf45edbf33672e2539e321b851b2cfbd1
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1680007000120162@kroah.com' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

ba98413bf45e ("drm/meson: fix missing component unbind on bind errors")
fa747d75f65d ("drm/meson: Fix error handling when afbcd.ops->init fails")
e67f6037ae1b ("drm/meson: split out encoder from meson_dw_hdmi")
d4cb82aa2e4b ("drm/meson: Make use of the helper function devm_platform_ioremap_resourcexxx()")
65a969655cb9 ("drm/meson: Convert to Linux IRQ interfaces")
2b6cb81b95d1 ("drm/meson: dw-hdmi: Enable the iahb clock early enough")
1dfeea904550 ("drm/meson: dw-hdmi: Disable clocks on driver teardown")
b33340e33acd ("drm/meson: dw-hdmi: Ensure that clocks are enabled before touching the TOP registers")
0405f94a1ae0 ("drm/meson: dw-hdmi: Register a callback to disable the regulator")
e78ad18ba365 ("drm/meson: Unbind all connectors on module removal")
fa62ee25280f ("drm/meson: Free RDMA resources after tearing down DRM")
35a395f1134b ("drm: bridge: dw-hdmi: Constify mode argument to dw_hdmi_phy_ops .init()")
af05bba0fbe2 ("drm: bridge: dw-hdmi: Pass drm_display_info to .mode_valid()")
9bc78d6dc818 ("drm: meson: dw-hdmi: Use dw_hdmi context to replace hack")
96591a4b93fb ("drm: bridge: dw-hdmi: Pass private data pointer to .mode_valid()")
b54d830ccb65 ("drm/meson: Set GEM CMA functions with DRM_GEM_CMA_DRIVER_OPS_WITH_DUMB_CREATE")
48ab4b8f236c ("drm/meson: Use GEM CMA object functions")
8976eeee8de0 ("drm/meson: add mode selection limits against specific SoC revisions")
bd9ff7b521a6 ("drm/meson: Drop explicit drm_mode_config_cleanup call")
8496a2172d7c ("drm/meson: Add YUV420 output support")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ba98413bf45edbf33672e2539e321b851b2cfbd1 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Mon, 6 Mar 2023 11:35:33 +0100
Subject: [PATCH] drm/meson: fix missing component unbind on bind errors

Make sure to unbind all subcomponents when binding the aggregate device
fails.

Fixes: a41e82e6c457 ("drm/meson: Add support for components")
Cc: stable@vger.kernel.org      # 4.12
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230306103533.4915-1-johan+linaro@kernel.org

diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index 79bfe3938d3c..7caf937c3c90 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -325,23 +325,23 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 
 	ret = meson_encoder_hdmi_init(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = meson_plane_create(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = meson_overlay_create(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = meson_crtc_create(priv);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	ret = request_irq(priv->vsync_irq, meson_irq, 0, drm->driver->name, drm);
 	if (ret)
-		goto exit_afbcd;
+		goto unbind_all;
 
 	drm_mode_config_reset(drm);
 
@@ -359,6 +359,9 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 
 uninstall_irq:
 	free_irq(priv->vsync_irq, drm);
+unbind_all:
+	if (has_components)
+		component_unbind_all(drm->dev, drm);
 exit_afbcd:
 	if (priv->afbcd.ops)
 		priv->afbcd.ops->exit(priv);

