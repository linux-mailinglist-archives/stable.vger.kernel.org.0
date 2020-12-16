Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5D32DC03B
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 13:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgLPMYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 07:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgLPMYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 07:24:52 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80751C0617A6
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 04:23:33 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id g185so2262907wmf.3
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 04:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4QRYTM/POGqaZteOSbbcY00ri7MjQyvm2VHFU7rqJxg=;
        b=tbNrnrEm6hKxWIUd0T6gpb8o8mrxQwFsKkXJAfuwmiE9g/541eDBmC+f6N19md4zGT
         uFSmvVzD1K8dpBnUl0MpKxpbnzLgHptj6B47UAltLYJBsN7AComqCoG+A92AeAPhx1TD
         /ncKYFgEmI7ti/IeQnb4Sb4vCk5jIrqjV6irYo4pzTbIkCtrwx4uxt0+FHBCrs8t6OOS
         91Nss6Is3QyHS5NmzJy+LkZxeC7vRLbCc8fp0Cva3YEQWcQcFGrP9shDs9+okT6zUZRv
         dgaNZtfupNk9kPdVKlefK2QS/RwxUO4J71HwygRa+I8i9yaWaiPB+TBWSKGPsfnb7MMy
         jdDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4QRYTM/POGqaZteOSbbcY00ri7MjQyvm2VHFU7rqJxg=;
        b=Fq6JL7bt0iyAxybECTMivZk/UZqr9t4O7dkjw6Ngx5xAflKoOe/tuCGvNc1ZVnC4k0
         TOQUUijK5ud4JWn7je/T+9I3052DtAfLyQnCY6yiTzntKVZWohV+bUtvIjbC+I2hLZfU
         qeL5M9UYRaLr/J6pxx5RFUZUabmsRoDB+/e/VoxZWE4cmOc/Irwkk5BvIV1jaXm2gWaq
         vhpHd3V3ZwOnNVV57SLiiMFVbFOuNn2uj1E2gLtYjsCI1A7L0QoaRVfp7Ga+A+HXy457
         9V4qQqLOTuXWKFn9baXG4dOHGD7GqscLlKZy8P3zJ0xzkOrmXgJAwGFfaYzrVGgFDhNf
         GWNQ==
X-Gm-Message-State: AOAM530V4sogIHfDZn2Ldgvs6S156hHpYN0JJrgFIxcH6+vlBQGfpxNM
        P/6pQhc4Dejk2fre0JGpX5o3mOTNXhK7Vg==
X-Google-Smtp-Source: ABdhPJxe+ooZON2DoHVMRwFpXA2rsou4YRjm5Ie1J3EqgWxUrMyjTpDuhNDWfKIFfhpLP6AtSSGGfQ==
X-Received: by 2002:a1c:741a:: with SMTP id p26mr3202597wmc.47.1608121412313;
        Wed, 16 Dec 2020 04:23:32 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id h15sm2861946wru.4.2020.12.16.04.23.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Dec 2020 04:23:31 -0800 (PST)
Date:   Wed, 16 Dec 2020 12:23:29 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     oleksandr_andrushchenko@epam.com, dan.carpenter@oracle.com,
        jgross@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/xen-front: Fix misused IS_ERR_OR_NULL
 checks" failed to apply to 4.19-stable tree
Message-ID: <20201216122329.r3656l5cx3n4aam3@debian>
References: <1597669476206215@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rfj7j5wlnkx252px"
Content-Disposition: inline
In-Reply-To: <1597669476206215@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rfj7j5wlnkx252px
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Aug 17, 2020 at 03:04:36PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--rfj7j5wlnkx252px
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-drm-xen-front-Fix-misused-IS_ERR_OR_NULL-checks.patch"

From 73850653afb418bdf5d6cb09b08aee4b6ce478f7 Mon Sep 17 00:00:00 2001
From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Date: Thu, 13 Aug 2020 09:21:10 +0300
Subject: [PATCH] drm/xen-front: Fix misused IS_ERR_OR_NULL checks

commit 14dee058610446aa464254fc5c8e88c7535195e0 upstream

The patch c575b7eeb89f: "drm/xen-front: Add support for Xen PV
display frontend" from Apr 3, 2018, leads to the following static
checker warning:

	drivers/gpu/drm/xen/xen_drm_front_gem.c:140 xen_drm_front_gem_create()
	warn: passing zero to 'ERR_CAST'

drivers/gpu/drm/xen/xen_drm_front_gem.c
   133  struct drm_gem_object *xen_drm_front_gem_create(struct drm_device *dev,
   134                                                  size_t size)
   135  {
   136          struct xen_gem_object *xen_obj;
   137
   138          xen_obj = gem_create(dev, size);
   139          if (IS_ERR_OR_NULL(xen_obj))
   140                  return ERR_CAST(xen_obj);

Fix this and the rest of misused places with IS_ERR_OR_NULL in the
driver.

Fixes:  c575b7eeb89f: "drm/xen-front: Add support for Xen PV display frontend"

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200813062113.11030-3-andr2000@gmail.com
Signed-off-by: Juergen Gross <jgross@suse.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/gpu/drm/xen/xen_drm_front.c     | 2 +-
 drivers/gpu/drm/xen/xen_drm_front_gem.c | 8 ++++----
 drivers/gpu/drm/xen/xen_drm_front_kms.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/xen/xen_drm_front.c b/drivers/gpu/drm/xen/xen_drm_front.c
index 6b6d5ab82ec3..1f6c91496d93 100644
--- a/drivers/gpu/drm/xen/xen_drm_front.c
+++ b/drivers/gpu/drm/xen/xen_drm_front.c
@@ -410,7 +410,7 @@ static int xen_drm_drv_dumb_create(struct drm_file *filp,
 	args->size = args->pitch * args->height;
 
 	obj = xen_drm_front_gem_create(dev, args->size);
-	if (IS_ERR_OR_NULL(obj)) {
+	if (IS_ERR(obj)) {
 		ret = PTR_ERR(obj);
 		goto fail;
 	}
diff --git a/drivers/gpu/drm/xen/xen_drm_front_gem.c b/drivers/gpu/drm/xen/xen_drm_front_gem.c
index 802662839e7e..cba7852123d6 100644
--- a/drivers/gpu/drm/xen/xen_drm_front_gem.c
+++ b/drivers/gpu/drm/xen/xen_drm_front_gem.c
@@ -85,7 +85,7 @@ static struct xen_gem_object *gem_create(struct drm_device *dev, size_t size)
 
 	size = round_up(size, PAGE_SIZE);
 	xen_obj = gem_create_obj(dev, size);
-	if (IS_ERR_OR_NULL(xen_obj))
+	if (IS_ERR(xen_obj))
 		return xen_obj;
 
 	if (drm_info->front_info->cfg.be_alloc) {
@@ -119,7 +119,7 @@ static struct xen_gem_object *gem_create(struct drm_device *dev, size_t size)
 	 */
 	xen_obj->num_pages = DIV_ROUND_UP(size, PAGE_SIZE);
 	xen_obj->pages = drm_gem_get_pages(&xen_obj->base);
-	if (IS_ERR_OR_NULL(xen_obj->pages)) {
+	if (IS_ERR(xen_obj->pages)) {
 		ret = PTR_ERR(xen_obj->pages);
 		xen_obj->pages = NULL;
 		goto fail;
@@ -138,7 +138,7 @@ struct drm_gem_object *xen_drm_front_gem_create(struct drm_device *dev,
 	struct xen_gem_object *xen_obj;
 
 	xen_obj = gem_create(dev, size);
-	if (IS_ERR_OR_NULL(xen_obj))
+	if (IS_ERR(xen_obj))
 		return ERR_CAST(xen_obj);
 
 	return &xen_obj->base;
@@ -196,7 +196,7 @@ xen_drm_front_gem_import_sg_table(struct drm_device *dev,
 
 	size = attach->dmabuf->size;
 	xen_obj = gem_create_obj(dev, size);
-	if (IS_ERR_OR_NULL(xen_obj))
+	if (IS_ERR(xen_obj))
 		return ERR_CAST(xen_obj);
 
 	ret = gem_alloc_pages_array(xen_obj, size);
diff --git a/drivers/gpu/drm/xen/xen_drm_front_kms.c b/drivers/gpu/drm/xen/xen_drm_front_kms.c
index a3479eb72d79..d9700c69e5b7 100644
--- a/drivers/gpu/drm/xen/xen_drm_front_kms.c
+++ b/drivers/gpu/drm/xen/xen_drm_front_kms.c
@@ -59,7 +59,7 @@ fb_create(struct drm_device *dev, struct drm_file *filp,
 	int ret;
 
 	fb = drm_gem_fb_create_with_funcs(dev, filp, mode_cmd, &fb_funcs);
-	if (IS_ERR_OR_NULL(fb))
+	if (IS_ERR(fb))
 		return fb;
 
 	gem_obj = drm_gem_object_lookup(filp, mode_cmd->handles[0]);
-- 
2.11.0


--rfj7j5wlnkx252px--
