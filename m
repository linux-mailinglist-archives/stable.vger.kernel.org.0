Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6243E2F0E68
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbhAKInO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:43:14 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:50955 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728141AbhAKInO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:43:14 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 5FE412497;
        Mon, 11 Jan 2021 03:42:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:42:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NxvyNt
        P4pJ3Fwyh+DnUfAUsRcSmfq1lHRhl1NXLHLLo=; b=czsEcr32LtwXIEh9xNIZSL
        Y9V1NqHjJz8B+rlTf2E0qt3hSBxycAPEcX1kKNRooU3rL0bCTAGKIQ5+t0Fd68H1
        Njc/MElmwm4ZaeB2XWFou2xHc70qQ47eSrK9Ak3J230YJqyzh4vthCV2XcVSXqGy
        XQBTbTjw0abtqs0QpjUbOC+GZmq/1xim6to7S0NICZ6+tCw25Xydik8ocIKLLZ8t
        G7rINr1yvsQg9yqyXDsr2OHHnoiZGSD/JXptHEmLMdgfAIN3CvhdeB1O3NWeJdk8
        rl+qzhu6hzr4quexKaQo2ONtLoaxy3a/nBJYgqQjeNMKthYgb2wueC012DoRxbiQ
        ==
X-ME-Sender: <xms:cw_8XwTeY60J42nn026tDNLjZsMgZDIOUNClafBEoMpxAlY1H3JzqQ>
    <xme:cw_8X9w7o_jc1UMf9vWNJnbqGARVGSIASiepgXC9aADaZ_6tDqFaYe_1MyV5KMXvU
    11PICA4xrDEcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:cw_8X918eHM0a6ZEyaOJ7uuDSaR6Ng5y9yNUBiV3C67Tbw1bVfmn9w>
    <xmx:cw_8X0AkG3Hc-Gzt5BIUuVtu1odG3-hJBtSq6_Rsm73j59fJZ0DjBQ>
    <xmx:cw_8X5izY7JSoRkdal0QjkPRWgeiy4qlMvwuHgWrTaGSqRhoi8nBKw>
    <xmx:dA_8X5J4Uy-nNF-1qmdbN4LaCxc4fhRfWezqIPExeJWSqv7in7SKFPgo07k>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id ADF6F240064;
        Mon, 11 Jan 2021 03:42:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: gadget: u_ether: Fix MTU size mismatch with RX packet" failed to apply to 4.9-stable tree
To:     manish.narani@xilinx.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:43:32 +0100
Message-ID: <1610354612227201@kroah.com>
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

