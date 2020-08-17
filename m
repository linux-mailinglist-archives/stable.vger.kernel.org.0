Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA252466E6
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgHQNES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:04:18 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:42675 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726194AbgHQNER (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:04:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 999211941155;
        Mon, 17 Aug 2020 09:04:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 09:04:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ESFGYX
        wK4d0/Mgyp5/amx046cjo7ctiHJ23XmThVANs=; b=L3rwAmtHVHuXTTdA8IdzLK
        PgCS8DVYaEUe23vcsWGp52td1rmxDl/ULqhflxS/Y3H/pn4pWCwH/iRkuKfPk/8y
        FZ2cjP9PZQMjjBlCQ33OM0yq57texqxWbWmCwIBKFQoR1AGn+SJ75CP+d2EFEbkN
        90rIXYP9zu99Kc2sc9Djp9QmpakcDjzP18hICY3Xtt5AvnlRoL1JMNaJqy5Pbh6s
        RyRzJSj/pjuX0NmCKq8Cxl4HKn8rIjD3JeoWogtYJp5KSFRxfsNJRamJgGF73IKF
        aEDhUSKYSAirE4dPK+d518S7i/zQV95tD6/NwoQNV+OigXOINudffNWMt/xr0Avg
        ==
X-ME-Sender: <xms:UIA6Xz_r0sHxWpmxZIYUoOL9S6e8_i2MAFJDNFEx6Ehrog1Kkfc7ZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:UIA6X_vfMs6xFQCerQQOSk4s5zevLcWuL4VNLzGjVytbWkDPl0UgDA>
    <xmx:UIA6XxA4qZ2dTuxG1iA4HjCLn8CGyifV5aJD5ZejmG7ECYZnTqpZ7Q>
    <xmx:UIA6X_eqDv3EuI9BzIxo1duMskozJEbgj3QOpfBavkidQPqdkvXGYw>
    <xmx:UIA6XyVHP59ufA2ti6b3D5mH9nFZ1i_aG7kHDL9TljREkhyBVoEtLQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 05EE53280065;
        Mon, 17 Aug 2020 09:04:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/xen-front: Fix misused IS_ERR_OR_NULL checks" failed to apply to 5.4-stable tree
To:     oleksandr_andrushchenko@epam.com, dan.carpenter@oracle.com,
        jgross@suse.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 15:04:36 +0200
Message-ID: <15976694767059@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

