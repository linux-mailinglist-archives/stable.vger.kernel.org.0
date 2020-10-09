Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A95528837D
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 09:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732009AbgJIH33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 03:29:29 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:36041 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725908AbgJIH32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 03:29:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B26EA1940A6F;
        Fri,  9 Oct 2020 03:29:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 09 Oct 2020 03:29:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uOciA6
        juQFJ9BTii45o7VCoeDK1ImcmZgxhRQ17oduA=; b=dcwCh2EHkXBE6woqJlJEML
        BmLRTxJtQHwudSHQAB48jBJi85TV8MFHP3cw3s9otQO236F4xVs3mvueuAhUpDET
        aCU6P9CP48oLBoBjn2BBhxriXDOIKvZoAPQucpdJVKSncpDVNm5Jouz11eCCuibv
        0pzNyoGe6uEiWVv+nha4sQLfNsRSFjVXxDbH+adPWyd06hRRcFQ1SOgqvlQGDaD+
        A3zC8vYfXPzxbkvsA3Qz/eeN10u7vWxM7R61YEeNqi8U9Es9uHzzr98yWXVCmngC
        5j+8k/RFW98AroDAlViq4PLE91KjgxjESrgPUAnOnkpLxdFFZhP3T65/ranVrCpQ
        ==
X-ME-Sender: <xms:VhGAXw0iqPnfo6ubad6AS6UpHS0H0yMqwT_3Wn12clqnaNjn8MpDjw>
    <xme:VhGAX7FJIE2muTytTZFTjit8FlM9AANUlOvpQ5EjhmA9CMi5sFkJzN3oYmBU65hNC
    nYBO5jj9dBKFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrhedtgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepfeegtdefleeguddufeekvdefgeevkeeujefgieehfe
    euudegvdffveekleetkeetnecuffhomhgrihhnpehrvgguhhgrthdrtghomhdpkhgvrhhn
    vghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:VhGAX46-gD1kNXzsfn9RE0V9qfx1r7Ru3S8bSGcUlLuSNyLcTJTdhQ>
    <xmx:VhGAX50i0O4GXMuqHZKJC8nPISpV2tW7t45XJHdIByNP6q69LMQFaw>
    <xmx:VhGAXzGPt_ghWnGEXb84Ork8fgZv9DE220eL3jRChJoh0ohEN5B8eg>
    <xmx:VhGAX5MEXK03YyNBQelyyYBQ-zakHHJuWS5VQyf8q8vbSjToi_EMPA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 204E7306467E;
        Fri,  9 Oct 2020 03:29:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] vhost: Don't call access_ok() when using IOTLB" failed to apply to 4.9-stable tree
To:     groug@kaod.org, jasowang@redhat.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Oct 2020 09:30:13 +0200
Message-ID: <160222861319240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0210a8db2aeca393fb3067e234967877e3146266 Mon Sep 17 00:00:00 2001
From: Greg Kurz <groug@kaod.org>
Date: Sat, 3 Oct 2020 12:01:52 +0200
Subject: [PATCH] vhost: Don't call access_ok() when using IOTLB

When the IOTLB device is enabled, the vring addresses we get
from userspace are GIOVAs. It is thus wrong to pass them down
to access_ok() which only takes HVAs.

Access validation is done at prefetch time with IOTLB. Teach
vq_access_ok() about that by moving the (vq->iotlb) check
from vhost_vq_access_ok() to vq_access_ok(). This prevents
vhost_vring_set_addr() to fail when verifying the accesses.
No behavior change for vhost_vq_access_ok().

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1883084
Fixes: 6b1e6cc7855b ("vhost: new device IOTLB API")
Cc: jasowang@redhat.com
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Greg Kurz <groug@kaod.org>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/160171931213.284610.2052489816407219136.stgit@bahia.lan
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b45519ca66a7..c3b49975dc28 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1290,6 +1290,11 @@ static bool vq_access_ok(struct vhost_virtqueue *vq, unsigned int num,
 			 vring_used_t __user *used)
 
 {
+	/* If an IOTLB device is present, the vring addresses are
+	 * GIOVAs. Access validation occurs at prefetch time. */
+	if (vq->iotlb)
+		return true;
+
 	return access_ok(desc, vhost_get_desc_size(vq, num)) &&
 	       access_ok(avail, vhost_get_avail_size(vq, num)) &&
 	       access_ok(used, vhost_get_used_size(vq, num));
@@ -1383,10 +1388,6 @@ bool vhost_vq_access_ok(struct vhost_virtqueue *vq)
 	if (!vq_log_access_ok(vq, vq->log_base))
 		return false;
 
-	/* Access validation occurs at prefetch time with IOTLB */
-	if (vq->iotlb)
-		return true;
-
 	return vq_access_ok(vq, vq->num, vq->desc, vq->avail, vq->used);
 }
 EXPORT_SYMBOL_GPL(vhost_vq_access_ok);

