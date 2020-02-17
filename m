Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C28CC161B5F
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgBQTQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:16:29 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56349 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729129AbgBQTQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:16:29 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6B35A21B62;
        Mon, 17 Feb 2020 14:16:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:16:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lwlzix
        gbp/C8DU3Ddz3SUCL+WG2SiKcXWN/npuoOdss=; b=e1u3u1GAmDhg2tHe86B82J
        5EmhL3MPMd4gJpbWNnTQfcA1XnBrhgivlee5p+lO9aHrfIAE5dNa5I3xSgBYvhdf
        MT2WKPVjEi/pDNHq280Y4lv1o3/Y6OdBatlXjvwpkbGwbc1Uuql0x+XeuFx6de8h
        PXXQAH7aWyMVuO+ZpeOMpve3XSF5PiaTt5pfO5t/Aa0PrFVoA9OV0HYe3W9EFS65
        R0CnmQt9lVQZiQQQ+zVL8BwY1Y/DhY0fpCR1lGrNzXrzuIa3dLqtsB3aBbKPpROe
        QX14w8Z1dZfXTjT1+LubvJtZrdyUMn5kkgi4zASvCNj7qsFYuVZjQOEm1o1POPAg
        ==
X-ME-Sender: <xms:i-ZKXlDavVRPghJyNWa7XdqvCBwJGgdF44RM7AYzzZv5AAEowVWKoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrke
    eirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:i-ZKXobHCkuoFJggU2N9Ee52yk4dxwtx0Euts4U2n67Yx0A0z8qrkA>
    <xmx:i-ZKXuJojR6GG7mi1I6NAgQ32MgurJS8mYUZBsBXt-kqVDXrTUR3wQ>
    <xmx:i-ZKXh2Ea8fM_JAz5BOmdSJQdJZe1MhMhS9QuqiFYX9jEzLU7Fs8zw>
    <xmx:jOZKXpyBqaq6vZyYU1nOoqbab77YTzN96iaJvZ2F_NK8sV1QBriqnA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5CFEF3060EF2;
        Mon, 17 Feb 2020 14:16:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/gem: Detect overflow in calculating dumb buffer size" failed to apply to 5.5-stable tree
To:     chris@chris-wilson.co.uk, jani.nikula@intel.com,
        joonas.lahtinen@linux.intel.com, ramalingam.c@intel.com,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 20:16:23 +0100
Message-ID: <1581966983116241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 051c89cf4ac487e795d87e6f3b9e0ff788da8fb4 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Thu, 23 Jan 2020 12:59:34 +0000
Subject: [PATCH] drm/i915/gem: Detect overflow in calculating dumb buffer size
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

To multiply 2 u32 numbers to generate a u64 in C requires a bit of
forewarning for the compiler.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ramalingam C <ramalingam.c@intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200123125934.1401755-1-chris@chris-wilson.co.uk
(cherry picked from commit 0f8f8a64300092852b9361cd835395ee71e6a7d6)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 94f993e4c12f..c2de2f45b459 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -265,7 +265,10 @@ i915_gem_dumb_create(struct drm_file *file,
 						    DRM_FORMAT_MOD_LINEAR))
 		args->pitch = ALIGN(args->pitch, 4096);
 
-	args->size = args->pitch * args->height;
+	if (args->pitch < args->width)
+		return -EINVAL;
+
+	args->size = mul_u32_u32(args->pitch, args->height);
 
 	mem_type = INTEL_MEMORY_SYSTEM;
 	if (HAS_LMEM(to_i915(dev)))

