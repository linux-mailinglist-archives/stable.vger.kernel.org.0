Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956F036429E
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239664AbhDSNKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239523AbhDSNKI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:10:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEF8961288;
        Mon, 19 Apr 2021 13:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837777;
        bh=oObnfVcrrOuvmowWFddpwKRb/CnoYWfUEUohX8mOOjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K571faFgfmT8WsF1cY1P2/UkGTYudNyfLyq4ID2av8QBKA+lpXXP6VNeeFr7kMAM3
         1jXHWRTuqjQp2MnkPJYgwOZvgNxXnmgGXCBs5uh0aZzMfltx3bp5IP+n56x0Zbom6u
         mm8/VcQ/BqWvWGI52SH0/uue7jjyryThdsPe2SAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 050/122] net: tipc: Fix spelling errors in net/tipc module
Date:   Mon, 19 Apr 2021 15:05:30 +0200
Message-Id: <20210419130531.886812663@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit a79ace4b312953c5835fafb12adc3cb6878b26bd ]

These patches fix a series of spelling errors in net/tipc module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.h | 6 +++---
 net/tipc/net.c    | 2 +-
 net/tipc/node.c   | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index 6bf4550aa1ac..57c6a1a719e2 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -154,9 +154,9 @@ struct tipc_media {
  * care of initializing all other fields.
  */
 struct tipc_bearer {
-	void __rcu *media_ptr;			/* initalized by media */
-	u32 mtu;				/* initalized by media */
-	struct tipc_media_addr addr;		/* initalized by media */
+	void __rcu *media_ptr;			/* initialized by media */
+	u32 mtu;				/* initialized by media */
+	struct tipc_media_addr addr;		/* initialized by media */
 	char name[TIPC_MAX_BEARER_NAME];
 	struct tipc_media *media;
 	struct tipc_media_addr bcast_addr;
diff --git a/net/tipc/net.c b/net/tipc/net.c
index a129f661bee3..faf6bf554514 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -89,7 +89,7 @@
  *     - A spin lock to protect the registry of kernel/driver users (reg.c)
  *     - A global spin_lock (tipc_port_lock), which only task is to ensure
  *       consistency where more than one port is involved in an operation,
- *       i.e., whe a port is part of a linked list of ports.
+ *       i.e., when a port is part of a linked list of ports.
  *       There are two such lists; 'port_list', which is used for management,
  *       and 'wait_list', which is used to queue ports during congestion.
  *
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 136338b85504..e0ee83263a39 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1734,7 +1734,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 }
 
 /* tipc_node_xmit_skb(): send single buffer to destination
- * Buffers sent via this functon are generally TIPC_SYSTEM_IMPORTANCE
+ * Buffers sent via this function are generally TIPC_SYSTEM_IMPORTANCE
  * messages, which will not be rejected
  * The only exception is datagram messages rerouted after secondary
  * lookup, which are rare and safe to dispose of anyway.
-- 
2.30.2



