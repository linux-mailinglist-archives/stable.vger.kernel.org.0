Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D1F3C3C49
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhGKM2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:28:05 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:35615 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232575AbhGKM2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:28:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 78D6E1AC0D0B;
        Sun, 11 Jul 2021 08:25:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 11 Jul 2021 08:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=AHNpsr
        qNT+K1GR38YESGTik2cnQ3NqNJJeogrk8lT9I=; b=tnOiGRPK01HcY8WJwuFAhK
        QmLF4AOxqG0hF1USKNNxbELbwT84Hq5aHN4h5E/SvvXEfMwlmy8mgCO71oE2NxZn
        Cb5uYOZUm96dww9itjxiNSF80N+BjvgKIiOnktSGtY4BKWf+grfaVVDSeX+MgeLG
        DnK7A8Ut7Gkxg47ZW/GOlp6WrQWiy0Kb8rahZx3I85rp68dupWwW6PPQp9fGwUdK
        VdJaBZgXm5yKLJWyUqOxu8kfmaM1O500IxZwofKdTHYdURBP2a51NV60AAMr1doL
        O7LUlY68F26cebJRVfFgK0RGuA6/4b8SNK8qwbVC8kJyKLm6yOPCv/XAp5EdWO/A
        ==
X-ME-Sender: <xms:LePqYJFsHa5tBjKUKV2PKZmhu47XhLMzn6Pm1azbmdj20JZnUk1_aQ>
    <xme:LePqYOWbs62-mMZc5XhvKQEFxfst6U63gXGHUdhLAfKgCSjY4NDYfcSSYnm6KyJCM
    mG_nHFsrp7yvQ>
X-ME-Received: <xmr:LePqYLJ2BZjODF4YIkbAwoTYYCGT3_pcp26e-JpZevbKlZ6VseCb_4ggINuKYZ8q-8YQ5Z8KF11IL5WpM8DKYAWcuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:LePqYPHh8q_TYw60g_AH0jltfuqRRoNJhGjl4IAergCl-J6vfbbdsQ>
    <xmx:LePqYPV92KXRItpEJ5h1EseCUO42C0juQJOJ_Fck_LZN7LLwEi7BRw>
    <xmx:LePqYKNbGjPwixypdkBP25mb4yWX4B8iaVzBEg9SCtqheXwVsgyI1Q>
    <xmx:LuPqYMh0V_Pe_h-xB8x6InYIV781dBTlW0gwleiOWtilg58hcHZOTAU13Fs>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:25:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] can: gw: synchronize rcu operations before removing gw job" failed to apply to 4.4-stable tree
To:     socketcan@hartkopp.net, mkl@pengutronix.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:25:16 +0200
Message-ID: <162600631611429@kroah.com>
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

From fb8696ab14adadb2e3f6c17c18ed26b3ecd96691 Mon Sep 17 00:00:00 2001
From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Fri, 18 Jun 2021 19:36:45 +0200
Subject: [PATCH] can: gw: synchronize rcu operations before removing gw job
 entry

can_can_gw_rcv() is called under RCU protection, so after calling
can_rx_unregister(), we have to call synchronize_rcu in order to wait
for any RCU read-side critical sections to finish before removing the
kmem_cache entry with the referenced gw job entry.

Link: https://lore.kernel.org/r/20210618173645.2238-1-socketcan@hartkopp.net
Fixes: c1aabdf379bc ("can-gw: add netlink based CAN routing")
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/net/can/gw.c b/net/can/gw.c
index ba4124805602..d8861e862f15 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -596,6 +596,7 @@ static int cgw_notifier(struct notifier_block *nb,
 			if (gwj->src.dev == dev || gwj->dst.dev == dev) {
 				hlist_del(&gwj->list);
 				cgw_unregister_filter(net, gwj);
+				synchronize_rcu();
 				kmem_cache_free(cgw_cache, gwj);
 			}
 		}
@@ -1154,6 +1155,7 @@ static void cgw_remove_all_jobs(struct net *net)
 	hlist_for_each_entry_safe(gwj, nx, &net->can.cgw_list, list) {
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(net, gwj);
+		synchronize_rcu();
 		kmem_cache_free(cgw_cache, gwj);
 	}
 }
@@ -1222,6 +1224,7 @@ static int cgw_remove_job(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(net, gwj);
+		synchronize_rcu();
 		kmem_cache_free(cgw_cache, gwj);
 		err = 0;
 		break;

