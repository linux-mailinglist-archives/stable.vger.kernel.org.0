Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4778A2F0E6A
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbhAKIn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:43:26 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:36595 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727962AbhAKInZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:43:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C42A724C2;
        Mon, 11 Jan 2021 03:42:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:42:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=fGbz94
        Ih+gpNwEn5Sc9Lg1eK5uMiHipdfeY0NTubT9s=; b=RFt39FJGo1qphX8Mt6XnDF
        uxnQHO8nSVFN/Pr7Zztp0hH5yxehDr9g/FLEQ05rJZuv9pllpisbG+zCd6oJg842
        DSna7WoD8djrYvsoYPUfa2yhEPe603zr2/82G2sAYeyjkspVD4haJhmyxhLMT49d
        2PTRVy+gAchXL+41bpOleeu3eF+tAum/8nk+Rhx+B8BO8mT3eBKebRhiuxNVuU3t
        Wzw+yjmcK1NqDNg+engKcpmv14fnFDPAUdEWG/dvlUilCvsSZCs15xF4wTB+ihSW
        KQvbg+tczpwDMQUJKuLkpSMJo0qKuM9qDGNjJae+Q+DUf1L17D7dZSpSxDwv6Cfw
        ==
X-ME-Sender: <xms:aw_8X8Fl3lRYmCle6t-THtCH6JR1kj5YgnBeER3raSdIyqI0jPRHmA>
    <xme:aw_8X1XV_mUe1DODNa7HPI_kjQ9R8vhVDy2kdkDrf3eDHu00QTChG_CwiCfvrm_dP
    UHlqO5JbbuY8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:aw_8X2KL57h5KdwXCZwC73Bb_HjXlhYWAC31oS9T8v-8jb13u9q27w>
    <xmx:aw_8X-HQC4Elj4i4eszGcMF-7U7lOYhZUlLcrlYD7nPrXEQgh-TARg>
    <xmx:aw_8XyXaYXkEU47QKXtUuBjpXj5FuhtQbMOOUTq69oJYTwiLD3vLiw>
    <xmx:aw_8X7fy4dAX2pATioF3VaCTd7AtzcUvvavp5__puZtZ68O5o4O-B-V-uMw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F30BD108005C;
        Mon, 11 Jan 2021 03:42:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: gadget: u_ether: Fix MTU size mismatch with RX packet" failed to apply to 4.4-stable tree
To:     manish.narani@xilinx.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:43:31 +0100
Message-ID: <16103546112228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

