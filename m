Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEBD2F0E69
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbhAKInQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:43:16 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:56813 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728025AbhAKInP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:43:15 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B4BA6255F;
        Mon, 11 Jan 2021 03:42:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:42:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=a4O02K
        AaqLH5GcymscK/+3RM8I1xnsv9Su23dvLoV1A=; b=HrCIxUt8cyYGm3l7VW3WN2
        9SMav6nM0LLjVPx507JDdVYFF2xnCIVX2x2HGI5CVqh6bhq4WlhXK2nq0Z9H2QQq
        AswDXc2jTRai/uzAASaq1IZbAOnDX9jGx78Q2irHzOlRPJihplKa/Kwd2jvhUzKz
        GlWyV/igoTRBall8S+5Idm5LcHno88rDnFPt6Ade7TLamzuIStxxKz1cqgwX1ZTQ
        qhV+iWdq5/vW7WUH5tVs22w+FlEp5fWeKGqTI2f6Pb30dANVDB54Bpp0yeiVlcnk
        tRexMzdxdOgR4FZgSi/2zQYczoBrC1V8Au5MGagmaoHJ6LN7ZELaIDHk3BJzZh6w
        ==
X-ME-Sender: <xms:dQ_8X9tTnno86uf2ZNcpXjAvBM7v_0bcdv3t8Aji_tmCbQHf0crutw>
    <xme:dQ_8X2eSmvQC0fw9Ty69ON6HUuqDUMdpC00Os2euSWR0sMIZdMerEEWnyUJwT9VZi
    hDMYuHs1HL0oQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:dQ_8Xww4rUU2IN1PiqRolzUX5Ys4wwXgPEZtWRNNDDkBNy4yDYzTCA>
    <xmx:dQ_8X0MRD6Mzz9TOkO1uUlsY6WZ-XB_LwCXJts9QWDw0YIW1C5XFcg>
    <xmx:dQ_8X99P9DY_ZyozZOVezihIahQ8AF85uo-zFFf6V4OKATqcWoAIHQ>
    <xmx:dQ_8X6HKLEfudfxjgp6FANCLlRmZY9vI3jDA_15SCjAmkUMKA7QsKtKGEvk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A4DB1080069;
        Mon, 11 Jan 2021 03:42:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: gadget: u_ether: Fix MTU size mismatch with RX packet" failed to apply to 4.14-stable tree
To:     manish.narani@xilinx.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:43:33 +0100
Message-ID: <1610354613231213@kroah.com>
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

From 0a88fa221ce911c331bf700d2214c5b2f77414d3 Mon Sep 17 00:00:00 2001
From: Manish Narani <manish.narani@xilinx.com>
Date: Tue, 17 Nov 2020 12:43:35 +0530
Subject: [PATCH] usb: gadget: u_ether: Fix MTU size mismatch with RX packet
 size

Fix the MTU size issue with RX packet size as the host sends the packet
with extra bytes containing ethernet header. This causes failure when
user sets the MTU size to the maximum i.e. 15412. In this case the
ethernet packet received will be of length 15412 plus the ethernet header
length. This patch fixes the issue where there is a check that RX packet
length must not be more than max packet length.

Fixes: bba787a860fa ("usb: gadget: ether: Allow jumbo frames")
Signed-off-by: Manish Narani <manish.narani@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1605597215-122027-1-git-send-email-manish.narani@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 31ea76adcc0d..c019f2b0c0af 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -45,9 +45,10 @@
 #define UETH__VERSION	"29-May-2008"
 
 /* Experiments show that both Linux and Windows hosts allow up to 16k
- * frame sizes. Set the max size to 15k+52 to prevent allocating 32k
+ * frame sizes. Set the max MTU size to 15k+52 to prevent allocating 32k
  * blocks and still have efficient handling. */
-#define GETHER_MAX_ETH_FRAME_LEN 15412
+#define GETHER_MAX_MTU_SIZE 15412
+#define GETHER_MAX_ETH_FRAME_LEN (GETHER_MAX_MTU_SIZE + ETH_HLEN)
 
 struct eth_dev {
 	/* lock is held while accessing port_usb
@@ -786,7 +787,7 @@ struct eth_dev *gether_setup_name(struct usb_gadget *g,
 
 	/* MTU range: 14 - 15412 */
 	net->min_mtu = ETH_HLEN;
-	net->max_mtu = GETHER_MAX_ETH_FRAME_LEN;
+	net->max_mtu = GETHER_MAX_MTU_SIZE;
 
 	dev->gadget = g;
 	SET_NETDEV_DEV(net, &g->dev);
@@ -848,7 +849,7 @@ struct net_device *gether_setup_name_default(const char *netname)
 
 	/* MTU range: 14 - 15412 */
 	net->min_mtu = ETH_HLEN;
-	net->max_mtu = GETHER_MAX_ETH_FRAME_LEN;
+	net->max_mtu = GETHER_MAX_MTU_SIZE;
 
 	return net;
 }

