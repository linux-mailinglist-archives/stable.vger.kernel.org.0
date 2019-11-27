Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5AA010B70E
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 20:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfK0TxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 14:53:06 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47293 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726729AbfK0TxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 14:53:05 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 85BFF22819;
        Wed, 27 Nov 2019 14:53:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 27 Nov 2019 14:53:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Q93Gcl
        LHlN+8SFJ7/7MUXUMhwd7X/JQ7HurQGy1MqUg=; b=sJJuSTwTzdjbgQO5KhVtyL
        uCORSVGfGNzkSTFQvN8X1xhdXPIIsY7amstD903f6B+ptEnRMiELhCJweuyJsuri
        RsKZ+Ka9+Qmt22V46SCE/XD0HbWDVz9bsbPaZckjenBRnDvaqlG38sLvL5KFBghn
        GHFVAO5SYIWrzqkWht1gUa18RkxfyvagqE7LbiYn4NShXJMDZktUp9CCY+3T5UAn
        x2CSdCvl+mYyx/aK26BKRv/eXp0Fh0YvBbCP4Geg82EPriVaUGiaeEV6wo+nVqxM
        Gr0T3UKbn6LpBfG6LwqVs5QQceaxy8hzzVyMPWrf+R+NeYGbtqAFiGd/pkWNzwOg
        ==
X-ME-Sender: <xms:H9TeXZmpbo0bN3QdEQfE0Th-YM1qJySIubQZE5828Q4CpA2FvHspRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeihedguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:INTeXZGhrkwPvpxameJzy5GOfZZR32zNK1Md2r8G3-NUnqRdIzcq5A>
    <xmx:INTeXar92fy2SRh-3reDUwHqCqyzrUhT-g2tD4nmbcytWO_EYgqoRA>
    <xmx:INTeXd7GbtaKajsXqDK6UEi2CO1j5B_EUZK40SMq9CUl3f_qbcT8eA>
    <xmx:INTeXX16gxgwwj-Ah7uMST99PDTgmlSl4kvQ6ZIM7F-wmYXI5r4ZDg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F5098005A;
        Wed, 27 Nov 2019 14:53:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] usbip: Fix uninitialized symbol 'nents' in" failed to apply to 4.9-stable tree
To:     suwan.kim027@gmail.com, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, lkp@intel.com,
        skhan@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 27 Nov 2019 20:53:01 +0100
Message-ID: <1574884381220214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 2a9125317b247f2cf35c196f968906dcf062ae2d Mon Sep 17 00:00:00 2001
From: Suwan Kim <suwan.kim027@gmail.com>
Date: Mon, 11 Nov 2019 23:10:35 +0900
Subject: [PATCH] usbip: Fix uninitialized symbol 'nents' in
 stub_recv_cmd_submit()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Smatch reported that nents is not initialized and used in
stub_recv_cmd_submit(). nents is currently initialized by sgl_alloc()
and used to allocate multiple URBs when host controller doesn't
support scatter-gather DMA. The use of uninitialized nents means that
buf_len is zero and use_sg is true. But buffer length should not be
zero when an URB uses scatter-gather DMA.

To prevent this situation, add the conditional that checks buf_len
and use_sg. And move the use of nents right after the sgl_alloc() to
avoid the use of uninitialized nents.

If the error occurs, it adds SDEV_EVENT_ERROR_MALLOC and stub_priv
will be released by stub event handler and connection will be shut
down.

Fixes: ea44d190764b ("usbip: Implement SG support to vhci-hcd and stub driver")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191111141035.27788-1-suwan.kim027@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/usbip/stub_rx.c b/drivers/usb/usbip/stub_rx.c
index 66edfeea68fe..e2b019532234 100644
--- a/drivers/usb/usbip/stub_rx.c
+++ b/drivers/usb/usbip/stub_rx.c
@@ -470,18 +470,50 @@ static void stub_recv_cmd_submit(struct stub_device *sdev,
 	if (pipe == -1)
 		return;
 
+	/*
+	 * Smatch reported the error case where use_sg is true and buf_len is 0.
+	 * In this case, It adds SDEV_EVENT_ERROR_MALLOC and stub_priv will be
+	 * released by stub event handler and connection will be shut down.
+	 */
 	priv = stub_priv_alloc(sdev, pdu);
 	if (!priv)
 		return;
 
 	buf_len = (unsigned long long)pdu->u.cmd_submit.transfer_buffer_length;
 
+	if (use_sg && !buf_len) {
+		dev_err(&udev->dev, "sg buffer with zero length\n");
+		goto err_malloc;
+	}
+
 	/* allocate urb transfer buffer, if needed */
 	if (buf_len) {
 		if (use_sg) {
 			sgl = sgl_alloc(buf_len, GFP_KERNEL, &nents);
 			if (!sgl)
 				goto err_malloc;
+
+			/* Check if the server's HCD supports SG */
+			if (!udev->bus->sg_tablesize) {
+				/*
+				 * If the server's HCD doesn't support SG, break
+				 * a single SG request into several URBs and map
+				 * each SG list entry to corresponding URB
+				 * buffer. The previously allocated SG list is
+				 * stored in priv->sgl (If the server's HCD
+				 * support SG, SG list is stored only in
+				 * urb->sg) and it is used as an indicator that
+				 * the server split single SG request into
+				 * several URBs. Later, priv->sgl is used by
+				 * stub_complete() and stub_send_ret_submit() to
+				 * reassemble the divied URBs.
+				 */
+				support_sg = 0;
+				num_urbs = nents;
+				priv->completed_urbs = 0;
+				pdu->u.cmd_submit.transfer_flags &=
+								~URB_DMA_MAP_SG;
+			}
 		} else {
 			buffer = kzalloc(buf_len, GFP_KERNEL);
 			if (!buffer)
@@ -489,24 +521,6 @@ static void stub_recv_cmd_submit(struct stub_device *sdev,
 		}
 	}
 
-	/* Check if the server's HCD supports SG */
-	if (use_sg && !udev->bus->sg_tablesize) {
-		/*
-		 * If the server's HCD doesn't support SG, break a single SG
-		 * request into several URBs and map each SG list entry to
-		 * corresponding URB buffer. The previously allocated SG
-		 * list is stored in priv->sgl (If the server's HCD support SG,
-		 * SG list is stored only in urb->sg) and it is used as an
-		 * indicator that the server split single SG request into
-		 * several URBs. Later, priv->sgl is used by stub_complete() and
-		 * stub_send_ret_submit() to reassemble the divied URBs.
-		 */
-		support_sg = 0;
-		num_urbs = nents;
-		priv->completed_urbs = 0;
-		pdu->u.cmd_submit.transfer_flags &= ~URB_DMA_MAP_SG;
-	}
-
 	/* allocate urb array */
 	priv->num_urbs = num_urbs;
 	priv->urbs = kmalloc_array(num_urbs, sizeof(*priv->urbs), GFP_KERNEL);

