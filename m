Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D872100874
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 16:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfKRPlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 10:41:20 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:47453 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727185AbfKRPlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 10:41:19 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4DA3E619;
        Mon, 18 Nov 2019 10:41:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 18 Nov 2019 10:41:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7xKWdQ
        8P8Z0C/6AInUDor/FENHYE11DPXQCJUToLG+k=; b=yA+bT+aKDHDUOPoI7iWmv8
        j9mnb9iEY+SnD/eun5cEuIPMptxABB5QWAXR4DYrh8mspJRh+qxtGEN2qXQvbLZi
        LfjnBFRRRNGF3FOj8hzwVNOJcH5Ao1htzsoZ8Sl5jh9ZyeXdFmjkGjGNo3Yr3IOT
        Ma+YENzECQuj7gToT+J4zclYuz48oj4EA5I/dg0d0G5/QczBwgHn6kNOer0E5q+i
        iJ2dstBBq9xJx0FywwEX2o8QaSBmyWNC5gh9qnW2VjMcTxEy8CKGm+IS5jDhlSgb
        FaNrKxqdgLSgd47k+W11JkrizRfvv8bgJnCTJf/tnzQnv+vEGfDgvWw5L9xGXEhA
        ==
X-ME-Sender: <xms:nbvSXbUe0z2aPLV55oFyTFgL_-ae0RHxMrTGjKmSD4cjxOrdvfT20w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudegiedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:nbvSXf6dAQcPiPuYTVGkxHOjwxJCfhzjuGNQg4nDmF_HQKS-ASsNEQ>
    <xmx:nbvSXaKCyWgm24A2MGDU6zRkBqzLpuuX0pxkRYbbPWobuD4xLvsVnw>
    <xmx:nbvSXYLKFWu8p0jJHNc_3RcfcMsj7sNg11dbbHOs1Q3DvnqBDfomYQ>
    <xmx:nbvSXXHfStBFf44Ud5Hni9XIP7xoimy5OsDMjGifpazSBtYndvM8wQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2CBD38005A;
        Mon, 18 Nov 2019 10:41:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915: update rawclk also on resume" failed to apply to 4.19-stable tree
To:     jani.nikula@intel.com, rodrigo.vivi@intel.com,
        shawn.c.lee@intel.com, stable@vger.kernel.org,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Nov 2019 16:41:15 +0100
Message-ID: <157409167539188@kroah.com>
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

From 2f216a8507153578efc309c821528a6b81628cd2 Mon Sep 17 00:00:00 2001
From: Jani Nikula <jani.nikula@intel.com>
Date: Fri, 1 Nov 2019 16:20:24 +0200
Subject: [PATCH] drm/i915: update rawclk also on resume
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since CNP it's possible for rawclk to have two different values, 19.2
and 24 MHz. If the value indicated by SFUSE_STRAP register is different
from the power on default for PCH_RAWCLK_FREQ, we'll end up having a
mismatch between the rawclk hardware and software states after
suspend/resume. On previous platforms this used to work by accident,
because the power on defaults worked just fine.

Update the rawclk also on resume. The natural place to do this would be
intel_modeset_init_hw(), however VLV/CHV need it done before
intel_power_domains_init_hw(). Thus put it there even if it feels
slightly out of place.

v2: Call intel_update_rawclck() in intel_power_domains_init_hw() for all
    platforms (Ville).

Reported-by: Shawn Lee <shawn.c.lee@intel.com>
Cc: Shawn Lee <shawn.c.lee@intel.com>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Shawn Lee <shawn.c.lee@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191101142024.13877-1-jani.nikula@intel.com
(cherry picked from commit 59ed05ccdded5eb18ce012eff3d01798ac8535fa)
Cc: <stable@vger.kernel.org> # v4.15+
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_display_power.c b/drivers/gpu/drm/i915/display/intel_display_power.c
index 12099760d99e..c002f234ff31 100644
--- a/drivers/gpu/drm/i915/display/intel_display_power.c
+++ b/drivers/gpu/drm/i915/display/intel_display_power.c
@@ -4896,6 +4896,9 @@ void intel_power_domains_init_hw(struct drm_i915_private *i915, bool resume)
 
 	power_domains->initializing = true;
 
+	/* Must happen before power domain init on VLV/CHV */
+	intel_update_rawclk(i915);
+
 	if (INTEL_GEN(i915) >= 11) {
 		icl_display_core_init(i915, resume);
 	} else if (IS_CANNONLAKE(i915)) {
diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index bb6f86c7067a..916e6ca86a1d 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -364,9 +364,6 @@ static int i915_driver_modeset_probe(struct drm_device *dev)
 	if (ret)
 		goto cleanup_vga_client;
 
-	/* must happen before intel_power_domains_init_hw() on VLV/CHV */
-	intel_update_rawclk(dev_priv);
-
 	intel_power_domains_init_hw(dev_priv, false);
 
 	intel_csr_ucode_init(dev_priv);

