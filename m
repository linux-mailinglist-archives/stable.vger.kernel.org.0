Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD1D327FA4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbhCANhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:37:11 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:33875 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235852AbhCANhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:37:03 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7E9601940F48;
        Mon,  1 Mar 2021 08:36:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:36:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wlgIAY
        pyPWSVpJnl2W1ZluZ9UMgUw1BWwqrFKqO8Weg=; b=iFml1KBX4z9tgl2qvHvBwO
        DmRpNMrmjH0r7yP/tcP4i2pOEDUqxpRngMUBkmwbnqsp2pr6C2MOV9ZTWcKuRGC1
        0lqsUhmgjdu3tIsvnhs1LvnQlQhG3uui1/Wvrv6qIVwH9S/X5l/p7SF7xlaaCo3V
        oLWE5J/78gdhZOAdnc+2HpLQeJihzo4DVx5eUzrtpQovg0LLEFNU3EpsHf6EbvIo
        9BCDZzDkUcPR4sGXtGe9QEug9uT0Cdpw2V4TIsDQBHyRTcDjy8xa4qvuC5O6PVVq
        jZAs0ms2d3JqteGZhC5RgDOwTDhk56Gj8AoZ2LOrIRYXqvjXPxUCD7l5ROANoCRA
        ==
X-ME-Sender: <xms:zu08YEXL51McsPcrQWhb7Y2g3I-6UnZ6SXaQHWjHKTVLX1LwgbYlmQ>
    <xme:zu08YImm43vBem3cFhkSByT_muNHCHRBPrsviSmJNnAVuv4yPcGUAqWDliJJkqz5d
    LJfPyHxXoekfQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:zu08YIZWOZMfY37JQSLK0nzCAhQFfsRPqiRSz2K61Di7UIoltYKHDQ>
    <xmx:zu08YDWnkW_OG-jJ9CXTpXBsQyZGihV40NC2LCjrIGeonp19tJMtXw>
    <xmx:zu08YOmTXbT5vuATeJgksagK7i0L5MSZBEVOguFjuSqwzzR7g2E6Iw>
    <xmx:zu08YCuEoAkDkeHTnpNiK_H15X2KYqUvFNoOzEC67vc5HabDhIxw8Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2A97E24005A;
        Mon,  1 Mar 2021 08:36:14 -0500 (EST)
Subject: FAILED: patch "[PATCH] virtio/s390: implement virtio-ccw revision 2 correctly" failed to apply to 4.19-stable tree
To:     cohuck@redhat.com, gor@linux.ibm.com, pasic@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:36:04 +0100
Message-ID: <1614605764184255@kroah.com>
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

From 182f709c5cff683e6732d04c78e328de0532284f Mon Sep 17 00:00:00 2001
From: Cornelia Huck <cohuck@redhat.com>
Date: Tue, 16 Feb 2021 12:06:45 +0100
Subject: [PATCH] virtio/s390: implement virtio-ccw revision 2 correctly

CCW_CMD_READ_STATUS was introduced with revision 2 of virtio-ccw,
and drivers should only rely on it being implemented when they
negotiated at least that revision with the device.

However, virtio_ccw_get_status() issued READ_STATUS for any
device operating at least at revision 1. If the device accepts
READ_STATUS regardless of the negotiated revision (which some
implementations like QEMU do, even though the spec currently does
not allow it), everything works as intended. While a device
rejecting the command should also be handled gracefully, we will
not be able to see any changes the device makes to the status,
such as setting NEEDS_RESET or setting the status to zero after
a completed reset.

We negotiated the revision to at most 1, as we never bumped the
maximum revision; let's do that now and properly send READ_STATUS
only if we are operating at least at revision 2.

Cc: stable@vger.kernel.org
Fixes: 7d3ce5ab9430 ("virtio/s390: support READ_STATUS command for virtio-ccw")
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20210216110645.1087321-1-cohuck@redhat.com
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 5730572b52cd..54e686dca6de 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -117,7 +117,7 @@ struct virtio_rev_info {
 };
 
 /* the highest virtio-ccw revision we support */
-#define VIRTIO_CCW_REV_MAX 1
+#define VIRTIO_CCW_REV_MAX 2
 
 struct virtio_ccw_vq_info {
 	struct virtqueue *vq;
@@ -952,7 +952,7 @@ static u8 virtio_ccw_get_status(struct virtio_device *vdev)
 	u8 old_status = vcdev->dma_area->status;
 	struct ccw1 *ccw;
 
-	if (vcdev->revision < 1)
+	if (vcdev->revision < 2)
 		return vcdev->dma_area->status;
 
 	ccw = ccw_device_dma_zalloc(vcdev->cdev, sizeof(*ccw));

