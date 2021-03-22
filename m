Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D0E343C39
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 10:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhCVJBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 05:01:41 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:53649 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229897AbhCVJBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 05:01:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 148A0D6A;
        Mon, 22 Mar 2021 05:01:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 22 Mar 2021 05:01:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UYC/jS
        DCsGODGQr4Sde4IPxKsfVQCRLTQ3ST+xH+z0w=; b=p4OZ84mJdbVHEoNfjIetIQ
        9PpSXl8r6usSjE6wbKvWMbJUjX6FV1l/9iNczDnmxI6SAG7AOe5beuzoBYerInSZ
        fL3v1k7s3ueVVpxJ++RFLIhMIqnfx12vD1TXfO9KJZG5o1mU+smSWx3+kxw0SKdK
        VQ8hAOoUp6ArMCHf1UkahB31Zkt486u9d/hw3MCBsy+1e6sN7qLuqRKX//Kt84KB
        xfR3p1RtEIF9kTBMyIJHZlaq1Obs4ie7HiGSvjY1qoZAbHwWgZjUM/zOYS05HL+B
        IB0bYrMXzTb6DanX6upe3hu/tbIaZRtLgW3D1SS7IKC/kcjzPShEPqSoU2KTi4Pw
        ==
X-ME-Sender: <xms:2VxYYEatqAJksuO6KwTEcFaX2jq_fTgEWARRVTc6z41AQ7i1cLDuNQ>
    <xme:2VxYYPbG_GX6Nor0KoR-Bk_tNKPSjTb4XEPGyN1rHDGuANG4lE0WcCAwxY5MNVGbQ
    lyJ8W_eH3Ih7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegfedguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:2VxYYO8Sij2U8UI6XE58DeXRwcTjlg_nMBVFL7Wq0iP6l4J4qIM4sA>
    <xmx:2VxYYOo1BDwMBVoJw2Syww7UPz3VDUYDsm6U0JzmRN90YHkbQJT6RA>
    <xmx:2VxYYPr0NjJp5DX_ZObmqcqJQXOaGE28ZJ204fw5Ti0eOEkIW_yAbQ>
    <xmx:2VxYYOT-ZgbWMF_2WkSCnzkRAh3giQOx1k3aEDrEBBC2o8vdZF824KsjW08>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E8ED81080054;
        Mon, 22 Mar 2021 05:01:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] thunderbolt: Initialize HopID IDAs in tb_switch_alloc()" failed to apply to 5.4-stable tree
To:     mika.westerberg@linux.intel.com, chiranjeevi.rapolu@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Mar 2021 10:01:11 +0100
Message-ID: <161640367124312@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 781e14eaa7d168dc07d2a2eea5c55831a5bb46f3 Mon Sep 17 00:00:00 2001
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Wed, 10 Feb 2021 16:06:33 +0200
Subject: [PATCH] thunderbolt: Initialize HopID IDAs in tb_switch_alloc()

If there is a failure before the tb_switch_add() is called the switch
object is released by tb_switch_release() but at that point HopID IDAs
have not yet been initialized. So we see splat like this:

BUG: spinlock bad magic on CPU#2, kworker/u8:5/115
...
Workqueue: thunderbolt0 tb_handle_hotplug
Call Trace:
 dump_stack+0x97/0xdc
 ? spin_bug+0x9a/0xa7
 do_raw_spin_lock+0x68/0x98
 _raw_spin_lock_irqsave+0x3f/0x5d
 ida_destroy+0x4f/0x127
 tb_switch_release+0x6d/0xfd
 device_release+0x2c/0x7d
 kobject_put+0x9b/0xbc
 tb_handle_hotplug+0x278/0x452
 process_one_work+0x1db/0x396
 worker_thread+0x216/0x375
 kthread+0x14d/0x155
 ? pr_cont_work+0x58/0x58
 ? kthread_blkcg+0x2e/0x2e
 ret_from_fork+0x1f/0x40

Fix this by always initializing HopID IDAs in tb_switch_alloc().

Fixes: 0b2863ac3cfd ("thunderbolt: Add functions for allocating and releasing HopIDs")
Cc: stable@vger.kernel.org
Reported-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index b63fecca6c2a..2a95b4ce06c0 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -768,12 +768,6 @@ static int tb_init_port(struct tb_port *port)
 
 	tb_dump_port(port->sw->tb, &port->config);
 
-	/* Control port does not need HopID allocation */
-	if (port->port) {
-		ida_init(&port->in_hopids);
-		ida_init(&port->out_hopids);
-	}
-
 	INIT_LIST_HEAD(&port->list);
 	return 0;
 
@@ -1842,10 +1836,8 @@ static void tb_switch_release(struct device *dev)
 	dma_port_free(sw->dma_port);
 
 	tb_switch_for_each_port(sw, port) {
-		if (!port->disabled) {
-			ida_destroy(&port->in_hopids);
-			ida_destroy(&port->out_hopids);
-		}
+		ida_destroy(&port->in_hopids);
+		ida_destroy(&port->out_hopids);
 	}
 
 	kfree(sw->uuid);
@@ -2025,6 +2017,12 @@ struct tb_switch *tb_switch_alloc(struct tb *tb, struct device *parent,
 		/* minimum setup for tb_find_cap and tb_drom_read to work */
 		sw->ports[i].sw = sw;
 		sw->ports[i].port = i;
+
+		/* Control port does not need HopID allocation */
+		if (i) {
+			ida_init(&sw->ports[i].in_hopids);
+			ida_init(&sw->ports[i].out_hopids);
+		}
 	}
 
 	ret = tb_switch_find_vse_cap(sw, TB_VSE_CAP_PLUG_EVENTS);

