Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3DE30ABEC
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhBAPvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:51:11 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:34109 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231236AbhBAPvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:51:04 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id C773EB57;
        Mon,  1 Feb 2021 10:49:57 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 01 Feb 2021 10:49:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2ntFQa
        HfQ6TkN1G9tdTzuf+IgF6eCbooLBTbuLRNQRM=; b=naq8uwLB/V6XghAr3vS4C7
        WLABlQPdCbUAmz/UlHWd6VLY9BLvjGF7zBE4tOiMCmyF7PSEPLCMQZ0311VlEPBg
        If40ND9WI/xO0+6Q7cthoQqINzJWyicEhdVrPw2Jpo/EJeeTx31XUGA/3zI6Btna
        9hTXS+5o2hmcVgT8RYlz/ct7jDpkn9w0MSElVJyTzPYFSNKG2fEqiIzhhz7L4MsS
        gQlRWMtKEYWhd0oUhP+Z5uc+iOw/idAitmGpde2VK6ogwLOF8o0AnsmtefV5qNMx
        FjdtT20YEEEFsLOEtprM+BRcIvZricLXfoDM6PIxYNMPGebv0+iMpa2eRIoeF/Tg
        ==
X-ME-Sender: <xms:JSMYYBd95zguwBVgNoydNHovP5_ds26NpEtvtZkD1_2uiS-RmXxRAA>
    <xme:JSMYYPJtnODSeafZe2QyBtJt0Ms7P9Ma2vznpofM5iMhcNVK6srKix9TJ5udfkIil
    nn1JWcOhFeL3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:JSMYYHYxnwVqbBl9GT4qBG9tmFjd_k8BbG1RNE0v0r9RE4Z1ziW6pA>
    <xmx:JSMYYCsAqxmhzUEUk3qXjY9zGUSXlpzOCuSTC3M6RTFpGV1uoJALow>
    <xmx:JSMYYMu9mBCX0CVKgdtDG-ZTxiYdP3CodcZpOoF0RDShgNzBhNrvPQ>
    <xmx:JSMYYAWYEjBm-ks70GE7cIrtcgjV0udgIJaCwbA3JdoKTf9ngbKXA4ayz9Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D6FE4240057;
        Mon,  1 Feb 2021 10:49:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] netfilter: nft_dynset: honor stateful expressions in set" failed to apply to 5.10-stable tree
To:     pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 16:49:55 +0100
Message-ID: <16121945956990@kroah.com>
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

From fca05d4d61e65fa573a3768f9019a42143c03349 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 16 Jan 2021 12:26:46 +0100
Subject: [PATCH] netfilter: nft_dynset: honor stateful expressions in set
 definition

If the set definition contains stateful expressions, allocate them for
the newly added entries from the packet path.

Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f4af8362d234..4b6ecf532623 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -721,6 +721,8 @@ void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *key_end, const u32 *data,
 			u64 timeout, u64 expiration, gfp_t gfp);
+int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
+			    struct nft_expr *expr_array[]);
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 15c467f1a9dd..8d3aa97b52e7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5235,9 +5235,8 @@ static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 	kfree(elem);
 }
 
-static int nft_set_elem_expr_clone(const struct nft_ctx *ctx,
-				   struct nft_set *set,
-				   struct nft_expr *expr_array[])
+int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
+			    struct nft_expr *expr_array[])
 {
 	struct nft_expr *expr;
 	int err, i, k;
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 0b053f75cd60..86204740f6c7 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -295,6 +295,12 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			err = -EOPNOTSUPP;
 			goto err_expr_free;
 		}
+	} else if (set->num_exprs > 0) {
+		err = nft_set_elem_expr_clone(ctx, set, priv->expr_array);
+		if (err < 0)
+			return err;
+
+		priv->num_exprs = set->num_exprs;
 	}
 
 	nft_set_ext_prepare(&priv->tmpl);

