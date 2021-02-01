Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C6A30ABEA
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 16:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhBAPvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 10:51:05 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:52091 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231301AbhBAPu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 10:50:58 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 07F75B71;
        Mon,  1 Feb 2021 10:50:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 01 Feb 2021 10:50:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=68XEts
        vSvJE3GRwffo+zLBMI76rj2W3VLEdm7brxnbc=; b=U/Tqgun46HGmYKaf9xuR9N
        ushd50LaY08A3QelUhmvLLcHYa8uvDYEJprGt0aJs/G9umFMWKvJJgtc/4IlUDlg
        sO1Ng8wVRY23aeIHXvAIPsKhkdrftG25iTGtcAG1yUTel5BL4OM4xOvb8ho6EYiT
        EVh6hyBgeSjzrgSR6f5wqokmN0A/pMQQPRc/J+UsRAo/5A1vogyKzxzgoRt3athf
        H9sDIbVI+D6O6y2RBlSildhL+KKdCRN1vDnioZ1DPrIJrLi+oaLGlNnBdpVMrAgN
        0p5PB84coV7S/u6seBTtxYDGuskwsSYrT91iaWs8OSsLYaz9xx4AZQxKVWv3s7lw
        ==
X-ME-Sender: <xms:LCMYYGrX1hIzWQxK0nZ56NmH4mu2VFhTHdJ568IjQ8gvikLEQW_lZg>
    <xme:LCMYYNlNt5CSGpG_IW5Ns5tjrEW2wDoU489ZWzji48dxcG8l8SOxH650s1Np72iMH
    cFpY3oOGvteOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:LCMYYGxjQpZDmzI6QaRlpr7XBslEtzKCRU7_0dgWoxhfiHVMtdqVoA>
    <xmx:LCMYYF-emObgA4KRwSgffNYUxh_FPmWg5dqbKf7Dg1cMudDK_t7ZMw>
    <xmx:LCMYYCIjnPeFAGcD90BYA6HOD7-0uMoJp6OOa1vSFeg91i159J5xpw>
    <xmx:LCMYYCxDgnYYvW4xDyhIZJjKwYS_ixNtUt1_0KPxpTWXdOIXdLvy_-MuwCo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0CAD41080066;
        Mon,  1 Feb 2021 10:50:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] netfilter: nft_dynset: dump expressions when set definition" failed to apply to 5.10-stable tree
To:     pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 16:50:01 +0100
Message-ID: <161219460114930@kroah.com>
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

From ce5379963b2884e9d23bea0c5674a7251414c84b Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 16 Jan 2021 19:50:34 +0100
Subject: [PATCH] netfilter: nft_dynset: dump expressions when set definition
 contains no expressions

If the set definition provides no stateful expressions, then include the
stateful expression in the ruleset listing. Without this fix, the dynset
rule listing shows the stateful expressions provided by the set
definition.

Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 218c09e4fddd..d164ef9e6843 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -384,22 +384,25 @@ static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
 			 nf_jiffies64_to_msecs(priv->timeout),
 			 NFTA_DYNSET_PAD))
 		goto nla_put_failure;
-	if (priv->num_exprs == 1) {
-		if (nft_expr_dump(skb, NFTA_DYNSET_EXPR, priv->expr_array[0]))
-			goto nla_put_failure;
-	} else if (priv->num_exprs > 1) {
-		struct nlattr *nest;
-
-		nest = nla_nest_start_noflag(skb, NFTA_DYNSET_EXPRESSIONS);
-		if (!nest)
-			goto nla_put_failure;
-
-		for (i = 0; i < priv->num_exprs; i++) {
-			if (nft_expr_dump(skb, NFTA_LIST_ELEM,
-					  priv->expr_array[i]))
+	if (priv->set->num_exprs == 0) {
+		if (priv->num_exprs == 1) {
+			if (nft_expr_dump(skb, NFTA_DYNSET_EXPR,
+					  priv->expr_array[0]))
 				goto nla_put_failure;
+		} else if (priv->num_exprs > 1) {
+			struct nlattr *nest;
+
+			nest = nla_nest_start_noflag(skb, NFTA_DYNSET_EXPRESSIONS);
+			if (!nest)
+				goto nla_put_failure;
+
+			for (i = 0; i < priv->num_exprs; i++) {
+				if (nft_expr_dump(skb, NFTA_LIST_ELEM,
+						  priv->expr_array[i]))
+					goto nla_put_failure;
+			}
+			nla_nest_end(skb, nest);
 		}
-		nla_nest_end(skb, nest);
 	}
 	if (nla_put_be32(skb, NFTA_DYNSET_FLAGS, htonl(flags)))
 		goto nla_put_failure;

