Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5B7327FA6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbhCANhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:37:18 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:34663 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235851AbhCANhO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:37:14 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6B6A51941FB4;
        Mon,  1 Mar 2021 08:36:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:36:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=tHTPHG
        uRq1ZMR0CghscirmE3c6r+baIrPCSU/Ru6SOg=; b=Lq2rtwHa8k7fF/VMJrlPu7
        cs0PGxqZ/04BAjH+uebhPXg+SpQCnZKQqSPj60SB17S9AjqCIsMq165S00vG9DDI
        Crx+HmqKPo8LV1U/KZQ9PCNt2ZtpMYGYrIALfgNXPJONJkIhX7bZzIzljGkfVoUU
        1gCaYQSZjA0RW5mcEhnH93gGzGMpSFyxSTVP41VYI+dfGJxgkJCp8HQmXl5FjNwq
        FCf8Y0srA2RwwAXaPnUCZZ02iWepPxB0sMgSuoE1bN00ZxdqLwNxpahehzlGvTPL
        wDV8OI3zx4p/gWKWPCLM+/QO9tLnlWRPPKCdS3jp6cfn+JNAEkhJVNWc1wGtt73g
        ==
X-ME-Sender: <xms:xe08YNhmy-vdMc8-auUdX_mllvQtIpsUrski_Ilha9P0hqAd_BZ3pA>
    <xme:xe08YCD2FotLEhCN0QIV-fRxu0vXk3m9Gu9zmVbQuwh852Xf2cyKoJNSkUp_555-S
    Z9MHj1BXi8Plg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:xe08YNHjx3ZUmjSibBqu65D7vyoeLmoicPWCMcTemNBNUNDCson63Q>
    <xmx:xe08YCQyWbGp5mIYvwPNLiFMm2oflzaBRH_HORxZPDNg1SGbidtpWA>
    <xmx:xe08YKx1elPRYDi3IBuefJp6vj811jrvC_0cRWNBl47o2rZDkRQMeQ>
    <xmx:xu08YPrdLvmec8JpenLRnt8FAsawoWTjwXjsHpq4oBoYkmq-TOLEKg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 80DEB24005B;
        Mon,  1 Mar 2021 08:36:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] virtio/s390: implement virtio-ccw revision 2 correctly" failed to apply to 4.14-stable tree
To:     cohuck@redhat.com, gor@linux.ibm.com, pasic@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:36:03 +0100
Message-ID: <161460576321113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

