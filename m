Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A842363517
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 14:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhDRMT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 08:19:59 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:35637 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhDRMT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 08:19:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E17A41B18;
        Sun, 18 Apr 2021 08:19:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 08:19:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=o25zB4
        ekJW1DMVE3Z+avhamkGP6x8liYl5lyN3AFiGY=; b=aGMoWqTzohyigKAatTdSdT
        1u/Swub/ohPA9tAuKumcErjuRI5suPi5vpffyIymC5QMk80RMxUeW2uKbXMDp0aS
        O7vyAm2j1s34LL2/MLThPi1MauI94IFXtSA1FYEP7FdWJw+GF2ocvXfk3KFwvs5q
        XUB4UvJVg78eckCADp5MX26KRIuH1D9ToPN88BuMpquo0JcGE7hY4NS8Bv1OpNvu
        aPexQ5wY+CSwmKuoeoJQrS8KSLRGrDsg61Y5Vqw5E346TV3UunXeVN95hOBKbcLO
        g49CqBPyOaT9qGokf6sNlPqN6NBPL6NeiBaWawqrN5qW+kRyuFtyutrIG09e8e+Q
        ==
X-ME-Sender: <xms:ziN8YOCa74b67IuAfRaQeBILPYAH-ZxBHG5Hm5BYuLBHsIJvjJNUag>
    <xme:ziN8YIhNoAd_3pqJabGY0v8Mwtb9Z7PGSQ7vi-v4KNpLKuPdcxdBGSRUzrsgjQveC
    hcSmBqGSk0hWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:ziN8YBmLqaV_tqWnIFDwz0XBGGL-0hty3ejTEuufx9KgM_X5mArlig>
    <xmx:ziN8YMwbGArgTa_s4tdGUDFdZrGgmUXGeCPpIQ3cJbsrQj5Dc1jINA>
    <xmx:ziN8YDTikLnv0oq7jUJx9b1AGEtGyUKc6Xrb_VXOltl9Q0BkEbzkMw>
    <xmx:ziN8YE6SKXJuJlOtYz7wxdqJi1LuTF63vte3SaGgcMl3zDDI6-8IjO-27gY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 31CEA1080063;
        Sun, 18 Apr 2021 08:19:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: ip6_tunnel: Unregister catch-all devices" failed to apply to 4.4-stable tree
To:     hristo@venev.name, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 14:19:15 +0200
Message-ID: <161874835521367@kroah.com>
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

