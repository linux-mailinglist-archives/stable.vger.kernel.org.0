Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C52336350B
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 14:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhDRMO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 08:14:26 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:57163 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230413AbhDRMO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 08:14:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id DDA8A1AD9;
        Sun, 18 Apr 2021 08:13:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 08:13:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oBwxyf
        THzgxRym/nJZhdSKt6IIf81vy0fCpvXyzwo2o=; b=kxpa4y5x++tMmB2EK/xBj6
        IcbRsPhQqk6YIcT5SSIz5dFU9D7PG7LDEfwBNi1EOsmpbcG7tTkYW5wt6ENeF0no
        qdK8oYzoY02M2RY3Bhfs7IX1o4KV6y8FvnomSVWUP06Fnnl2I9F/1A0uTcxxvb+V
        ThKmOO7fGE/rGJT4B7sfjyBBdwyaPrear44DYC5B7epMSCIMW8xBshtj0VEfYpCI
        PPTM+/e8/YGmwWlDqqNhkSl9PwQLwaAeS8M349O6JizyQXvsz+ncIuKhX524NQPv
        5l6jwz3sqqRLgnbBtENsCHJpHIHb6YwjoXCZMi2q8ta25Al0rkMyXWehSFQ1V0Sw
        ==
X-ME-Sender: <xms:hCJ8YB7shRWSrE6clN8QXRBa1ThzucSlmKp4FrK_kMlSRMYZZ9n7Ew>
    <xme:hCJ8YO6YxnOJaaZya9WUUjxGMCvPhE8Le-w7oFs_P87X2H03Rjcr_Fk_71V1CwNtU
    Y-kRoC0nSRSVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:hCJ8YIdJvQ-fMYJVpWnnrdAVyuM5zbYDf3_putkEI5-sK7UnIXEH-g>
    <xmx:hCJ8YKIE_-JNZ4HkM0gimVsWrZRnfEjvVNzfmKAPtPPx9gWj_t_ktA>
    <xmx:hCJ8YFJJWsJJOwEY7ZDFXP9STUAOGFhY2hiQmA9yB3bvH0xCnQfnYg>
    <xmx:hSJ8YHxw4TlRGNdSkw4VuJj23S-qU1hFXUJ61kKRW0vkOjgnD7TAFwbn4Yk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B73781080057;
        Sun, 18 Apr 2021 08:13:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] netfilter: nftables: clone set element expression template" failed to apply to 5.10-stable tree
To:     pablo@netfilter.org, nevola@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 14:13:55 +0200
Message-ID: <1618748035133237@kroah.com>
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

From 4d8f9065830e526c83199186c5f56a6514f457d2 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 10 Apr 2021 21:29:38 +0200
Subject: [PATCH] netfilter: nftables: clone set element expression template

memcpy() breaks when using connlimit in set elements. Use
nft_expr_clone() to initialize the connlimit expression list, otherwise
connlimit garbage collector crashes when walking on the list head copy.

[  493.064656] Workqueue: events_power_efficient nft_rhash_gc [nf_tables]
[  493.064685] RIP: 0010:find_or_evict+0x5a/0x90 [nf_conncount]
[  493.064694] Code: 2b 43 40 83 f8 01 77 0d 48 c7 c0 f5 ff ff ff 44 39 63 3c 75 df 83 6d 18 01 48 8b 43 08 48 89 de 48 8b 13 48 8b 3d ee 2f 00 00 <48> 89 42 08 48 89 10 48 b8 00 01 00 00 00 00 ad de 48 89 03 48 83
[  493.064699] RSP: 0018:ffffc90000417dc0 EFLAGS: 00010297
[  493.064704] RAX: 0000000000000000 RBX: ffff888134f38410 RCX: 0000000000000000
[  493.064708] RDX: 0000000000000000 RSI: ffff888134f38410 RDI: ffff888100060cc0
[  493.064711] RBP: ffff88812ce594a8 R08: ffff888134f38438 R09: 00000000ebb9025c
[  493.064714] R10: ffffffff8219f838 R11: 0000000000000017 R12: 0000000000000001
[  493.064718] R13: ffffffff82146740 R14: ffff888134f38410 R15: 0000000000000000
[  493.064721] FS:  0000000000000000(0000) GS:ffff88840e440000(0000) knlGS:0000000000000000
[  493.064725] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  493.064729] CR2: 0000000000000008 CR3: 00000001330aa002 CR4: 00000000001706e0
[  493.064733] Call Trace:
[  493.064737]  nf_conncount_gc_list+0x8f/0x150 [nf_conncount]
[  493.064746]  nft_rhash_gc+0x106/0x390 [nf_tables]

Reported-by: Laura Garcia Liebana <nevola@gmail.com>
Fixes: 409444522976 ("netfilter: nf_tables: add elements with stateful expressions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f57f1a6ba96f..589d2f6978d3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5295,16 +5295,35 @@ int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 	return -ENOMEM;
 }
 
-static void nft_set_elem_expr_setup(const struct nft_set_ext *ext, int i,
-				    struct nft_expr *expr_array[])
+static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
+				   const struct nft_set_ext *ext,
+				   struct nft_expr *expr_array[],
+				   u32 num_exprs)
 {
 	struct nft_set_elem_expr *elem_expr = nft_set_ext_expr(ext);
-	struct nft_expr *expr = nft_setelem_expr_at(elem_expr, elem_expr->size);
+	struct nft_expr *expr;
+	int i, err;
+
+	for (i = 0; i < num_exprs; i++) {
+		expr = nft_setelem_expr_at(elem_expr, elem_expr->size);
+		err = nft_expr_clone(expr, expr_array[i]);
+		if (err < 0)
+			goto err_elem_expr_setup;
+
+		elem_expr->size += expr_array[i]->ops->size;
+		nft_expr_destroy(ctx, expr_array[i]);
+		expr_array[i] = NULL;
+	}
+
+	return 0;
+
+err_elem_expr_setup:
+	for (; i < num_exprs; i++) {
+		nft_expr_destroy(ctx, expr_array[i]);
+		expr_array[i] = NULL;
+	}
 
-	memcpy(expr, expr_array[i], expr_array[i]->ops->size);
-	elem_expr->size += expr_array[i]->ops->size;
-	kfree(expr_array[i]);
-	expr_array[i] = NULL;
+	return -ENOMEM;
 }
 
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
@@ -5556,12 +5575,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		*nft_set_ext_obj(ext) = obj;
 		obj->use++;
 	}
-	for (i = 0; i < num_exprs; i++)
-		nft_set_elem_expr_setup(ext, i, expr_array);
+	err = nft_set_elem_expr_setup(ctx, ext, expr_array, num_exprs);
+	if (err < 0)
+		goto err_elem_expr;
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
-	if (trans == NULL)
-		goto err_trans;
+	if (trans == NULL) {
+		err = -ENOMEM;
+		goto err_elem_expr;
+	}
 
 	ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
 	err = set->ops->insert(ctx->net, set, &elem, &ext2);
@@ -5605,7 +5627,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	set->ops->remove(ctx->net, set, &elem);
 err_element_clash:
 	kfree(trans);
-err_trans:
+err_elem_expr:
 	if (obj)
 		obj->use--;
 

