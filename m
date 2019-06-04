Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E43733470D
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfFDMkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:40:02 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:45279 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727580AbfFDMkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:40:02 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id BFADB469;
        Tue,  4 Jun 2019 08:40:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 08:40:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=W8xT99
        rdy1VvYBpDwYbdj/302YfStsBTX3sbyn4qR3s=; b=TgBay0jplB5IhvRMCg6jYm
        7wX3UoGQc3hK9Pi/TQmn2wqH7o/63BZTTYAnUdTv6GljsTnn5dh8yFhDGUuqkF/Q
        4ctzBo+9MtZpJI069P8R5S7f92nvMDgkKd1rbFnIgdjiwJhNN8thpNZjsyE1l3aB
        jpQPCWQO1inLeGDT7E7J68vzocFse6YLqfj4wuOGR43/Q6mDew8vrs0HuTY9b7k6
        FhzQZFAdkNugsEqJf9maKAi8opX71GDQV9g+6ZiHiUb6EEtZzceeETJXhq03BS/9
        ZdoOsb4aI1VuWifT1+TRxYQheTYfTB4byAXbt78ACW+V0OvtN/smyNz5ozNfjZow
        ==
X-ME-Sender: <xms:n2b2XELi-O4_Fcp7oH5kAFP-T7Slyt-Hnwp6YDz_oi1x1lWAwUN8eg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:n2b2XLH_-kCYTKDg2OQ-PUD5Rp9G_0qoFjoHpnA2yAuXpO05N9ZoFw>
    <xmx:n2b2XJw2sxO5alClVmOjIBivuw3NTcGF_h2ZbTdnBTBoKFQvJTLEZg>
    <xmx:n2b2XIig5Crbii7ZSO8Ryf5vGFdauzzmM8l2zjJpYc5fPCY7pkhIWw>
    <xmx:oGb2XC9cPI9die1rkMcZC_krWn5m0lPdusu0265yujHczEMPTSTbrw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D86438008E;
        Tue,  4 Jun 2019 08:39:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/fb-helper: generic: Call drm_client_add() after setup is" failed to apply to 4.19-stable tree
To:     noralf@tronnes.org, daniel.vetter@ffwll.ch
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 14:39:57 +0200
Message-ID: <1559651997224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6e3f17ee73f7e3c2ef0e2c8fd8624b2ece8ef2c9 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>
Date: Mon, 1 Apr 2019 16:13:58 +0200
Subject: [PATCH] drm/fb-helper: generic: Call drm_client_add() after setup is
 done
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hotplug can happen while drm_fbdev_generic_setup() is running so move
drm_client_add() call after setup is done to avoid
drm_fbdev_client_hotplug() running in two threads at the same time.

Fixes: 9060d7f49376 ("drm/fb-helper: Finish the generic fbdev emulation")
Cc: stable@vger.kernel.org
Reported-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20190401141358.25309-1-noralf@tronnes.org

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 0d8384e30e16..84791dd4a90d 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -3312,8 +3312,6 @@ int drm_fbdev_generic_setup(struct drm_device *dev, unsigned int preferred_bpp)
 		return ret;
 	}
 
-	drm_client_add(&fb_helper->client);
-
 	if (!preferred_bpp)
 		preferred_bpp = dev->mode_config.preferred_depth;
 	if (!preferred_bpp)
@@ -3324,6 +3322,8 @@ int drm_fbdev_generic_setup(struct drm_device *dev, unsigned int preferred_bpp)
 	if (ret)
 		DRM_DEV_DEBUG(dev->dev, "client hotplug ret=%d\n", ret);
 
+	drm_client_add(&fb_helper->client);
+
 	return 0;
 }
 EXPORT_SYMBOL(drm_fbdev_generic_setup);

