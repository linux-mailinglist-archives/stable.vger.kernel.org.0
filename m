Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F2E363516
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 14:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhDRMTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 08:19:54 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:49357 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhDRMTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 08:19:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 5164E1B0D;
        Sun, 18 Apr 2021 08:19:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 08:19:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZWwZzr
        sY4f3hXP/Y11UOx5+OLMrUym0jQxUi4G0XljQ=; b=CCzzQmyLXX8Op/T340P6s5
        WOlLi+SQGMjNBm5eIlWypzhsfX6/C3QvM2ejDr9zMnZbjjaNLCR7+A2c/Es5skCL
        PG5CylxDoZFzaI8zJIZJ8lPhG6NI63kyzP580ec9K1dGeh+6JOGEYDoMf+IChtEF
        U2HBMYHakK6iiSCVTVtm5Y7w8LqSWdtzRoujBIVVdgama0CCE1uztjiEqDMYtIDl
        RYtg9IEznabpuc59/ZhaJRlISLkDNWNsaHbTjOM1pdQsb1BMfGzSHdpAZ1OTb0t4
        qsYXx0Q+Mha7qz+KxZobrRh4Hu2Uo7BMPhdnkBVPFxlvozwiqYa9Xu+/u3+Zh2mQ
        ==
X-ME-Sender: <xms:zCN8YJ7zfHh9hlwvW7Bahig7FlBi-kgvktwO5s12AvGnOdoxi79bgg>
    <xme:zCN8YG7KsXHrttDwDIk8IL_cOCAavqaX371QQjn0i_NmMUek8OE_z7ibXY9mmxNTT
    KdYnMaSBfWB5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:zCN8YAddWh15_3hFoWNF9FKnFIeFajoCkoGDsl6p_WoMesHSUKOlwQ>
    <xmx:zCN8YCJSZcgmdOx8IjI0OCyHCfc6mn5UJaBoZDh8kk-zi8m7Zh1dmw>
    <xmx:zCN8YNJIisrdgE2W-sg1tgl4NAZBpkXXsJPyXOpLMKaeg-3Jsermwg>
    <xmx:zCN8YPxzvdvi7HOAdTenazNxgNmica74E3_cza6w2lLKyXUMVrAaaO9aLJc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D79924005B;
        Sun, 18 Apr 2021 08:19:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: ip6_tunnel: Unregister catch-all devices" failed to apply to 4.9-stable tree
To:     hristo@venev.name, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 14:19:14 +0200
Message-ID: <16187483542532@kroah.com>
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

