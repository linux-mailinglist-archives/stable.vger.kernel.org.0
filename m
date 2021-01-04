Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EF32E9691
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 15:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbhADOBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 09:01:47 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:52967 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbhADOBr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 09:01:47 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3D9501C5A;
        Mon,  4 Jan 2021 09:00:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 04 Jan 2021 09:00:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=S4942b
        5UhouCbdKbktcZhPAUmyC+M5KsSjYDcmjzdZg=; b=NTsOA9ppWYD0Q7dk8dR4r3
        6PkpIOeYPUYRVWsNeqD4axuv4mfJkJMqN+vhUjNzjYDs7pF5q1ulfHhHw4CBG3uu
        P0dY3sy7hWHHk1KteCrkAiYdTbyJRGduF0fA8dcnXlGRY/yF28HrHnhpo32eQ/os
        YE4LSSMs/BCSbQHx8PMVtNF0febhukbKBAtvUpn3moRrIYQbRXSJvPKbaQ+rme3Z
        HnTygOXnX5XsuSFHIIDv7FLhzy74uwObCZnoPTJzssdCrv5OHAMheLVDmGwGLU/Z
        WDWO2Ps2RG/8FHAD7mSdMESvbpXKmH32ql+RW6fbwOTPCmLDSEfk468uSYIuv1kQ
        ==
X-ME-Sender: <xms:iB_zX-oXB2a-ImeiozHLlcDO6482Dx9gMCKeHWTpBT5bBbvUcZJBGA>
    <xme:iB_zX8qGLxAEspZXJhqZcVM0HUz_FiEsGZ7tozaVoFztBUez0NKcsx-FET2mWdWEE
    h1DEF3ZJEbvvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeffedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:iB_zXzM47vzX6PpRm-sMWlUBsJshKV_sJq4W7Xl1EkcwbfzsySq0Zg>
    <xmx:iB_zX94r0wVgUAxUW7vcX-jiznvRTAE1IG8R5tiEHVAvYXRnRgs9_w>
    <xmx:iB_zX97lPmUrpdXZmcoGuqVhmwttkJXDZxhz3WYo7ZrKoSVG_bAOkw>
    <xmx:iB_zX-UIzvsDfIOGi0b3j8eu9oOKkb-ZWXD6snfIMh47D-6d_MkrrY9Ucfo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 755C9240068;
        Mon,  4 Jan 2021 09:00:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] RDMA/siw,rxe: Make emulated devices virtual in the device" failed to apply to 5.10-stable tree
To:     jgg@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jan 2021 15:02:07 +0100
Message-ID: <1609768927196196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a9d2e9ae953f0ddd0327479c81a085adaa76d903 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgg@nvidia.com>
Date: Fri, 6 Nov 2020 10:00:49 -0400
Subject: [PATCH] RDMA/siw,rxe: Make emulated devices virtual in the device
 tree

This moves siw and rxe to be virtual devices in the device tree:

lrwxrwxrwx 1 root root 0 Nov  6 13:55 /sys/class/infiniband/rxe0 -> ../../devices/virtual/infiniband/rxe0/

Previously they were trying to parent themselves to the physical device of
their attached netdev, which doesn't make alot of sense.

My hope is this will solve some weird syzkaller hits related to sysfs as
it could be possible that the parent of a netdev is another netdev, eg
under bonding or some other syzkaller found netdev configuration.

Nesting a ib_device under anything but a physical device is going to cause
inconsistencies in sysfs during destructions.

Link: https://lore.kernel.org/r/0-v1-dcbfc68c4b4a+d6-virtual_dev_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index ee3cf3af7cab..c4b06ced30a7 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -19,15 +19,6 @@
 
 static struct rxe_recv_sockets recv_sockets;
 
-struct device *rxe_dma_device(struct rxe_dev *rxe)
-{
-	struct net_device *ndev;
-
-	ndev = rxe->ndev;
-
-	return ndev->dev.parent;
-}
-
 int rxe_mcast_add(struct rxe_dev *rxe, union ib_gid *mgid)
 {
 	int err;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index a2bd91aaa5de..2fbea2b2d72a 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -1134,7 +1134,6 @@ int rxe_register_device(struct rxe_dev *rxe, const char *ibdev_name)
 	dev->node_type = RDMA_NODE_IB_CA;
 	dev->phys_port_cnt = 1;
 	dev->num_comp_vectors = num_possible_cpus();
-	dev->dev.parent = rxe_dma_device(rxe);
 	dev->local_dma_lkey = 0;
 	addrconf_addr_eui48((unsigned char *)&dev->node_guid,
 			    rxe->ndev->dev_addr);
diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index d9de062852c4..ee95cf29179d 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -305,24 +305,8 @@ static struct siw_device *siw_device_create(struct net_device *netdev)
 {
 	struct siw_device *sdev = NULL;
 	struct ib_device *base_dev;
-	struct device *parent = netdev->dev.parent;
 	int rv;
 
-	if (!parent) {
-		/*
-		 * The loopback device has no parent device,
-		 * so it appears as a top-level device. To support
-		 * loopback device connectivity, take this device
-		 * as the parent device. Skip all other devices
-		 * w/o parent device.
-		 */
-		if (netdev->type != ARPHRD_LOOPBACK) {
-			pr_warn("siw: device %s error: no parent device\n",
-				netdev->name);
-			return NULL;
-		}
-		parent = &netdev->dev;
-	}
 	sdev = ib_alloc_device(siw_device, base_dev);
 	if (!sdev)
 		return NULL;
@@ -359,7 +343,6 @@ static struct siw_device *siw_device_create(struct net_device *netdev)
 	 * per physical port.
 	 */
 	base_dev->phys_port_cnt = 1;
-	base_dev->dev.parent = parent;
 	base_dev->num_comp_vectors = num_possible_cpus();
 
 	xa_init_flags(&sdev->qp_xa, XA_FLAGS_ALLOC1);
@@ -401,7 +384,7 @@ static struct siw_device *siw_device_create(struct net_device *netdev)
 	atomic_set(&sdev->num_mr, 0);
 	atomic_set(&sdev->num_pd, 0);
 
-	sdev->numa_node = dev_to_node(parent);
+	sdev->numa_node = dev_to_node(&netdev->dev);
 	spin_lock_init(&sdev->lock);
 
 	return sdev;

