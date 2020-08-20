Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC6824B113
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgHTIcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:32:39 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:40947 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbgHTIcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:32:24 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 695C21941098;
        Thu, 20 Aug 2020 04:32:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 20 Aug 2020 04:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SL3l/h
        85X/VXM6wZInV06OpXWEA3x2emHcaOss94H+8=; b=fgiebHO2rjbQp27yl52mzb
        WsZPmqBbYX52JCU+hNDLHRoqgszXr1uJSwgL2mXFNLwyCU9VLJhPVQ4JmrtBuyBH
        LJP2u6qF/JBhC2U6WkfDMRH0WoNJ6ADx/MgIQIklnTIlnT/ab6nSkn85KX8tWTap
        lgqeRKeazesXVQqaLuuoa9en9Z0Mvrumkg0tiAnn0Te8qxFLKyHAsVhbbM2BPNqw
        +KfIkQ+9mf17ax6EgFqgeyV60nMfOOHv1EEhpgSZCRdJ2npJZoz5oudDbwOJdB5R
        3izTKTXcG2MSvZyzTuH7g9L15IX/sJaLDWAjqew84hHlT48nP23r4wPrsHDAFsfw
        ==
X-ME-Sender: <xms:EjU-X3jqzZEjBaLSRdAuzS0Ikms6Tx9OK1jwnhLqu6D2RUKnBeFQQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddutddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduue
    ejhffhgfevuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:EjU-X0DB6pMIcxbNNzaiTPvp3IRyktM9TJxPFTRw6ZFXNvEIwf3ilA>
    <xmx:EjU-X3Eg9IIIH4W9WA9ssXVP2yOzgGiVXuEJbphkG9lfyAbaWZoEcQ>
    <xmx:EjU-X0TCJkLCr63JvUApRoSH8JhYTaKNNrwwVTrl_I1fdaeYnhIkFw>
    <xmx:EjU-XxvcTf2v8wsKsBwhZipxTjaoijuTxyHi6m7cp9NR22tn34JOcA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E21723280060;
        Thu, 20 Aug 2020 04:32:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/vgem: Replace opencoded version of" failed to apply to 4.19-stable tree
To:     chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 10:32:38 +0200
Message-ID: <1597912358197157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 119c53d2d4044c59c450c4f5a568d80b9d861856 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Wed, 8 Jul 2020 16:49:11 +0100
Subject: [PATCH] drm/vgem: Replace opencoded version of
 drm_gem_dumb_map_offset()

drm_gem_dumb_map_offset() now exists and does everything
vgem_gem_dump_map does and *ought* to do.

In particular, vgem_gem_dumb_map() was trying to reject mmapping an
imported dmabuf by checking the existence of obj->filp. Unfortunately,
we always allocated an obj->filp, even if unused for an imported dmabuf.
Instead, the drm_gem_dumb_map_offset(), since commit 90378e589192
("drm/gem: drm_gem_dumb_map_offset(): reject dma-buf"), uses the
obj->import_attach to reject such invalid mmaps.

This prevents vgem from allowing userspace mmapping the dumb handle and
attempting to incorrectly fault in remote pages belonging to another
device, where there may not even be a struct page.

v2: Use the default drm_gem_dumb_map_offset() callback

Fixes: af33a9190d02 ("drm/vgem: Enable dmabuf import interfaces")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: <stable@vger.kernel.org> # v4.13+
Link: https://patchwork.freedesktop.org/patch/msgid/20200708154911.21236-1-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/vgem/vgem_drv.c b/drivers/gpu/drm/vgem/vgem_drv.c
index e4dc7b267a0b..a775feda1cc7 100644
--- a/drivers/gpu/drm/vgem/vgem_drv.c
+++ b/drivers/gpu/drm/vgem/vgem_drv.c
@@ -230,32 +230,6 @@ static int vgem_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
 	return 0;
 }
 
-static int vgem_gem_dumb_map(struct drm_file *file, struct drm_device *dev,
-			     uint32_t handle, uint64_t *offset)
-{
-	struct drm_gem_object *obj;
-	int ret;
-
-	obj = drm_gem_object_lookup(file, handle);
-	if (!obj)
-		return -ENOENT;
-
-	if (!obj->filp) {
-		ret = -EINVAL;
-		goto unref;
-	}
-
-	ret = drm_gem_create_mmap_offset(obj);
-	if (ret)
-		goto unref;
-
-	*offset = drm_vma_node_offset_addr(&obj->vma_node);
-unref:
-	drm_gem_object_put(obj);
-
-	return ret;
-}
-
 static struct drm_ioctl_desc vgem_ioctls[] = {
 	DRM_IOCTL_DEF_DRV(VGEM_FENCE_ATTACH, vgem_fence_attach_ioctl, DRM_RENDER_ALLOW),
 	DRM_IOCTL_DEF_DRV(VGEM_FENCE_SIGNAL, vgem_fence_signal_ioctl, DRM_RENDER_ALLOW),
@@ -446,7 +420,6 @@ static struct drm_driver vgem_driver = {
 	.fops				= &vgem_driver_fops,
 
 	.dumb_create			= vgem_gem_dumb_create,
-	.dumb_map_offset		= vgem_gem_dumb_map,
 
 	.prime_handle_to_fd = drm_gem_prime_handle_to_fd,
 	.prime_fd_to_handle = drm_gem_prime_fd_to_handle,

