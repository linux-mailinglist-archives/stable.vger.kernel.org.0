Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF8928837F
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 09:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732021AbgJIH3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 03:29:38 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:60003 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732006AbgJIH3h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Oct 2020 03:29:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id D7DAA1940A8D;
        Fri,  9 Oct 2020 03:29:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 09 Oct 2020 03:29:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mv2bNO
        LNC4sQtEOzWgKMEfKDxUVTpemYw+YnAGd7vUY=; b=KfxpzRyiGq+36J7ZuR6qu6
        VTc9/bVW4FfXo8UIR//6gc5qIzIHz3SYM1GmX5zRnlPFvj5Yleg44BO1Mj7K4arh
        96g2esHOYaza5Pg3v/ayWjOFkZmUywjdlkTFAbggPNTG0Bp6oDh5ImySgMdZw2cx
        RgOwl1K8O9kCkenyqZyaCsjuzJZ5IY4Lquf/83SaqOLSVwrbvRsLNSq7AU3ft4o4
        wgJsaOmEFH2jKEtZjtafE6Bbcu9CAQjho4zL+Lb+DMyybeJKjvhOmHAahbKM/BE6
        62WEPVlHeXenI9kMUktWxd4ALK7nf+GKqchADm2D66/DlPInQKdwF6DZ5HQ9mFmA
        ==
X-ME-Sender: <xms:YBGAX4zWG6pA3RCrB6UmLczrD7W_JQEVD3ujH50GvCW14gbURAMxKQ>
    <xme:YBGAX8Q9oumjKJgbPn48cpajcXiKAnW3l6DNL7IQu2h4Z3wIsSV9w4xfoWPRwvzex
    rd514bcYzpJNQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrhedtgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepfeegtdefleeguddufeekvdefgeevkeeujefgieehfe
    euudegvdffveekleetkeetnecuffhomhgrihhnpehrvgguhhgrthdrtghomhdpkhgvrhhn
    vghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivg
    epudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:YBGAX6W8oh2Hn_gE_wL7DKW1W2vIoiZgMD_R8qI1cJ0iyJ7ddbmwOA>
    <xmx:YBGAX2j8xRaj0uy-KLF_dcAF_zK_LDjEhFsyVPNcPtQ3Ti0TftZ_Pg>
    <xmx:YBGAX6CsNa9fEegQhrTxSsqtoNzV_Iv0Uv1W_-MUAL2hbU3IbSKrfQ>
    <xmx:YBGAX74sqRUZVXz3M2e-N840607rGTTo84-8YFgAHtq9hKBjl8-g_Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 72F293064680;
        Fri,  9 Oct 2020 03:29:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] vhost: Don't call access_ok() when using IOTLB" failed to apply to 4.19-stable tree
To:     groug@kaod.org, jasowang@redhat.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Oct 2020 09:30:15 +0200
Message-ID: <1602228615251214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

