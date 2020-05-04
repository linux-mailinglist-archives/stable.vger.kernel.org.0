Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D5D1C3413
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 10:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgEDIIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 04:08:32 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:57179 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727100AbgEDIIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 04:08:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 680335EE;
        Mon,  4 May 2020 04:08:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 04 May 2020 04:08:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aTbCVz
        i8/Rxzuzy9nrEzBX7H5By6tMvLD1bo4oRdN+4=; b=FCF01R69QV914A0rQGMbAo
        /SI20rYKLJErr33qssB3iuKDsKc+eIxuMZEhIet2m5ltS/eSKDyl0PbIhwuATulU
        6bSddjP2lmIl6MIn0Mp+nFoBXwUgzr62rzj8UHrVT+dMN00giXRZ0lxivcfLIB+S
        1nPWX0IP5Ap00l59/zFi41Xfp4HcZR0IpIWiN8b2K28rWuRFcHzzw73rrnEezE6z
        d+RHv6Y1Og2cSyHbnwxU0YQR+uh34I/8s+lrWDNjg0e6vZjDnCtHUa1CGHYkHeV+
        0/s6SIDY7Uj5oX1Qix0mWckoCCOt3Bq63JaKFeEzlbGjMEMJRcJPj79WunZX4NHQ
        ==
X-ME-Sender: <xms:fs2vXjwUgPKvzu6Ce55qPdW2LTsHyW7BdJO3rp-7g_RRmuWMz6gUbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeegucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttddtlfenuc
    fhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecu
    ggftrfgrthhtvghrnhepkefhhfefgfefheeffedugeeuvddvvefggffftdduueejhffhgf
    evuedtvddtjefgnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecukfhp
    peekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:fs2vXh1zLZIMObx6By__SFMPcHPX0l4VPmru2juncLYTMlkweaAvcQ>
    <xmx:fs2vXqGmhUcAuYbuJ6rKiDsE2w7V3QXrjzQX1unqMQOu47TAnKufSQ>
    <xmx:fs2vXmKDa2T1xYbn7On16vQ4NmtfiuJAv1wL-yZv7KVyyFl9MgW7bQ>
    <xmx:f82vXu0r9E3SGgm4uEHwVynTqSUkME2mGB5ARTEBF_JnKfzoQDgxJk0DIqw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 742EF3066010;
        Mon,  4 May 2020 04:08:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/qxl: qxl_release leak in qxl_draw_dirty_fb()" failed to apply to 4.4-stable tree
To:     vvs@virtuozzo.com, kraxel@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 10:08:28 +0200
Message-ID: <158857970889126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 85e9b88af1e6164f19ec71381efd5e2bcfc17620 Mon Sep 17 00:00:00 2001
From: Vasily Averin <vvs@virtuozzo.com>
Date: Mon, 27 Apr 2020 08:32:46 +0300
Subject: [PATCH] drm/qxl: qxl_release leak in qxl_draw_dirty_fb()

ret should be changed to release allocated struct qxl_release

Cc: stable@vger.kernel.org
Fixes: 8002db6336dd ("qxl: convert qxl driver to proper use for reservations")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Link: http://patchwork.freedesktop.org/patch/msgid/22cfd55f-07c8-95d0-a2f7-191b7153c3d4@virtuozzo.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

diff --git a/drivers/gpu/drm/qxl/qxl_draw.c b/drivers/gpu/drm/qxl/qxl_draw.c
index 5bebf1ea1c5d..f8776d60d08e 100644
--- a/drivers/gpu/drm/qxl/qxl_draw.c
+++ b/drivers/gpu/drm/qxl/qxl_draw.c
@@ -209,9 +209,10 @@ void qxl_draw_dirty_fb(struct qxl_device *qdev,
 		goto out_release_backoff;
 
 	rects = drawable_set_clipping(qdev, num_clips, clips_bo);
-	if (!rects)
+	if (!rects) {
+		ret = -EINVAL;
 		goto out_release_backoff;
-
+	}
 	drawable = (struct qxl_drawable *)qxl_release_map(qdev, release);
 
 	drawable->clip.type = SPICE_CLIP_TYPE_RECTS;

