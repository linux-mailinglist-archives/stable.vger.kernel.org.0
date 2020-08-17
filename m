Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5E82466E7
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgHQNE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:04:27 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:55115 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728022AbgHQNE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:04:27 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 00FA91941474;
        Mon, 17 Aug 2020 09:04:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 09:04:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=juEHym
        NPofG8TT/nBsl9i824MAhcgALQOcgYcLS8Q2k=; b=Xmp0MpjeKKxBZ+Rz4ggcqo
        UplwhjsXQSiugwZ97W+YnIovsBdLBnIMqBPM0YokUgsfRdoszIyvsQtYIEoQ/QzP
        LjJR9E7lFv15w1Qti7sVZvLYJxFjF6HnwIa5dkjfKYeFHZIUaxsIy4PUrOFLBagX
        QodFhIoTu7Kxv+WT+Hd9giHkZxcu2laSKbWyKQaKq+n7llYy+SqCfRvYJcYZ5oCz
        UlqA9Zh/te5Al3CcJ50djHRLQQ8hWkKTMPAwKg4brZcvrj0E+X/uVjQ7Fj8XM8Rd
        lYKW5TdMA9Ig3XKdhfT+kjR9LaNpElvrP2HYssGP7hK7FLUIUkrVs1Qhug5I55Yw
        ==
X-ME-Sender: <xms:WYA6XwQmDZv8zPlsaMjUbYZU2vnOvVn7GcpXZ1x8GmUZXKVdGIjGRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:WYA6X9zjZqAHmm7fIlhtziRvQJFf0RaQfjBcLz4orA7Eep0VkGrTnQ>
    <xmx:WYA6X90Et4roykxC5CiuksjaNezAifMCXsksmpxqyQRdRUn0-qUbPQ>
    <xmx:WYA6X0AM6-Ry5TotvV1rZrNYf0vUtpPWO_ryoxZHObqkfdu93mRONA>
    <xmx:WYA6X5IA26zrlWOxURhuE7sRPGo9s7F9EBnpcac5WP-_qt2Vpvwzrw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22E2C3280068;
        Mon, 17 Aug 2020 09:04:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/xen-front: Fix misused IS_ERR_OR_NULL checks" failed to apply to 4.19-stable tree
To:     oleksandr_andrushchenko@epam.com, dan.carpenter@oracle.com,
        jgross@suse.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 15:04:36 +0200
Message-ID: <1597669476206215@kroah.com>
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

From 14dee058610446aa464254fc5c8e88c7535195e0 Mon Sep 17 00:00:00 2001
From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Date: Thu, 13 Aug 2020 09:21:10 +0300
Subject: [PATCH] drm/xen-front: Fix misused IS_ERR_OR_NULL checks

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

diff --git a/drivers/gpu/drm/xen/xen_drm_front.c b/drivers/gpu/drm/xen/xen_drm_front.c
index 1fd458e877ca..51818e76facd 100644
--- a/drivers/gpu/drm/xen/xen_drm_front.c
+++ b/drivers/gpu/drm/xen/xen_drm_front.c
@@ -400,8 +400,8 @@ static int xen_drm_drv_dumb_create(struct drm_file *filp,
 	args->size = args->pitch * args->height;
 
 	obj = xen_drm_front_gem_create(dev, args->size);
-	if (IS_ERR_OR_NULL(obj)) {
-		ret = PTR_ERR_OR_ZERO(obj);
+	if (IS_ERR(obj)) {
+		ret = PTR_ERR(obj);
 		goto fail;
 	}
 
diff --git a/drivers/gpu/drm/xen/xen_drm_front_gem.c b/drivers/gpu/drm/xen/xen_drm_front_gem.c
index f0b85e094111..4ec8a49241e1 100644
--- a/drivers/gpu/drm/xen/xen_drm_front_gem.c
+++ b/drivers/gpu/drm/xen/xen_drm_front_gem.c
@@ -83,7 +83,7 @@ static struct xen_gem_object *gem_create(struct drm_device *dev, size_t size)
 
 	size = round_up(size, PAGE_SIZE);
 	xen_obj = gem_create_obj(dev, size);
-	if (IS_ERR_OR_NULL(xen_obj))
+	if (IS_ERR(xen_obj))
 		return xen_obj;
 
 	if (drm_info->front_info->cfg.be_alloc) {
@@ -117,7 +117,7 @@ static struct xen_gem_object *gem_create(struct drm_device *dev, size_t size)
 	 */
 	xen_obj->num_pages = DIV_ROUND_UP(size, PAGE_SIZE);
 	xen_obj->pages = drm_gem_get_pages(&xen_obj->base);
-	if (IS_ERR_OR_NULL(xen_obj->pages)) {
+	if (IS_ERR(xen_obj->pages)) {
 		ret = PTR_ERR(xen_obj->pages);
 		xen_obj->pages = NULL;
 		goto fail;
@@ -136,7 +136,7 @@ struct drm_gem_object *xen_drm_front_gem_create(struct drm_device *dev,
 	struct xen_gem_object *xen_obj;
 
 	xen_obj = gem_create(dev, size);
-	if (IS_ERR_OR_NULL(xen_obj))
+	if (IS_ERR(xen_obj))
 		return ERR_CAST(xen_obj);
 
 	return &xen_obj->base;
@@ -194,7 +194,7 @@ xen_drm_front_gem_import_sg_table(struct drm_device *dev,
 
 	size = attach->dmabuf->size;
 	xen_obj = gem_create_obj(dev, size);
-	if (IS_ERR_OR_NULL(xen_obj))
+	if (IS_ERR(xen_obj))
 		return ERR_CAST(xen_obj);
 
 	ret = gem_alloc_pages_array(xen_obj, size);
diff --git a/drivers/gpu/drm/xen/xen_drm_front_kms.c b/drivers/gpu/drm/xen/xen_drm_front_kms.c
index 78096bbcd226..ef11b1e4de39 100644
--- a/drivers/gpu/drm/xen/xen_drm_front_kms.c
+++ b/drivers/gpu/drm/xen/xen_drm_front_kms.c
@@ -60,7 +60,7 @@ fb_create(struct drm_device *dev, struct drm_file *filp,
 	int ret;
 
 	fb = drm_gem_fb_create_with_funcs(dev, filp, mode_cmd, &fb_funcs);
-	if (IS_ERR_OR_NULL(fb))
+	if (IS_ERR(fb))
 		return fb;
 
 	gem_obj = fb->obj[0];

