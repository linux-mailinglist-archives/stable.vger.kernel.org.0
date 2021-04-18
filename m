Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7B2363515
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 14:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhDRMTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 08:19:46 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:46901 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhDRMTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 08:19:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 8DA1A1B0D;
        Sun, 18 Apr 2021 08:19:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 08:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Lvv4ek
        oRxcQyFA4Wx0BdWG2LT07ScbWFuX2HpAiK4zk=; b=QmfVvo2s/uoDdDyI1g5F2U
        lgNifLZsH3qJMNhvnyNo3RD0dHDSVhB3MJ5HTw9vtTJ+Kyj3FCPM6LI+BMlLPbDc
        twL9TiBUiHDasBYWAAWvzRqhe6D2gBvg6LhJdd02N9deDTYKez1LbG4tWo5wTTN9
        XqIcRr9+JoZsaGbY+lId7Xg7l8oPyWwFqYH1P90ydQXWEOAqt/N9qyOxW9rIszmK
        09/ykIGh7L8uTmUWDyFr8Uh31CqDhWkbhqE0dQlhpzbgwzReamcfYa82n7Dfg561
        /FMkyopmuJp53MCB4ZHDPXLHGOZoukAYhZ+VvRJ/cIS2+sr8Ra9MieZay6FQ3DJw
        ==
X-ME-Sender: <xms:xCN8YBgr57qGEX3kBMULE47Rq_R3d0IenBr_DnzDcOilGFp02ZIqkQ>
    <xme:xCN8YGAFOxfJsWmvJvwxXolLvwEZH1hBHZVvAsfIGtH5FPE3NWjcJOTSCKMasgv-h
    jDLzdKoBOKOMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:xCN8YBHi1RZ7PgCnI-3EwIpbOqyqYUvr0pJUGZzSVOWoYLLEKcCdVA>
    <xmx:xCN8YGTzu0xgVvwjofQF_LV8qWNy67Z6YMfYLTCoxuBnukM6S0kfrQ>
    <xmx:xCN8YOw9Jt326JHxtHqEIXdUeq1krUevmotqLi28FK2se5poekm9Yg>
    <xmx:xSN8YEbQvCxPwy-Xu3_Q8CQYh2QXTOvsAai0I79EdQsgidXWIC9W7fTUWMc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 903D81080063;
        Sun, 18 Apr 2021 08:19:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: ip6_tunnel: Unregister catch-all devices" failed to apply to 4.14-stable tree
To:     hristo@venev.name, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 14:19:14 +0200
Message-ID: <1618748354170235@kroah.com>
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

From 941ea91e87a6e879ed82dad4949f6234f2702bec Mon Sep 17 00:00:00 2001
From: Hristo Venev <hristo@venev.name>
Date: Mon, 12 Apr 2021 20:41:17 +0300
Subject: [PATCH] net: ip6_tunnel: Unregister catch-all devices

Similarly to the sit case, we need to remove the tunnels with no
addresses that have been moved to another network namespace.

Fixes: 0bd8762824e73 ("ip6tnl: add x-netns support")
Signed-off-by: Hristo Venev <hristo@venev.name>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 3fa0eca5a06f..42fe7db6bbb3 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -2244,6 +2244,16 @@ static void __net_exit ip6_tnl_destroy_tunnels(struct net *net, struct list_head
 			t = rtnl_dereference(t->next);
 		}
 	}
+
+	t = rtnl_dereference(ip6n->tnls_wc[0]);
+	while (t) {
+		/* If dev is in the same netns, it has already
+		 * been added to the list by the previous loop.
+		 */
+		if (!net_eq(dev_net(t->dev), net))
+			unregister_netdevice_queue(t->dev, list);
+		t = rtnl_dereference(t->next);
+	}
 }
 
 static int __net_init ip6_tnl_init_net(struct net *net)

