Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7E41891F6
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgCQX1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:50 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53484 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgCQX1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F16T6wNGFJ5djV/xDhXdd3tfSyiNYBaPFrCvnq73EY0=;
        b=riTCNlApdWawzo42Ffnd0T9Fdl10Gsf3wlbERCK/DNpfjsLtsqa7QKMhBTbYkdoHr+DZiQ
        jCp/+CRtSAWGyig3YGG79GhBiLGEk52v2MhqQRxGxYs4z9Ix6sEWDpgbnB+vAoN70JH3zM
        EqkVYw3ZxW/weO+L9R07BHcifAga6E0=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Marek Lindner <mareklindner@neomailbox.ch>,
        Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 07/48] batman-adv: init neigh node last seen field
Date:   Wed, 18 Mar 2020 00:26:53 +0100
Message-Id: <20200317232734.6127-8-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Lindner <mareklindner@neomailbox.ch>

commit e48474ed8a217b7f80f2a42bc05352406a06cb67 upstream.

Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
[sven@narfation.org: fix conflicts with current version]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
---
 net/batman-adv/originator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index 6282f021ddfb..19b4b91b19ff 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -483,6 +483,7 @@ batadv_neigh_node_new(struct batadv_orig_node *orig_node,
 	ether_addr_copy(neigh_node->addr, neigh_addr);
 	neigh_node->if_incoming = hard_iface;
 	neigh_node->orig_node = orig_node;
+	neigh_node->last_seen = jiffies;
 
 	/* extra reference for return */
 	atomic_set(&neigh_node->refcount, 2);
-- 
2.20.1

