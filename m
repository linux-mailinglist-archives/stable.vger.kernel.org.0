Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE47F3A5896
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 15:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhFMNFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 09:05:46 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:51431 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231286AbhFMNFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 09:05:45 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id E794A19401DE;
        Sun, 13 Jun 2021 09:03:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 13 Jun 2021 09:03:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UziDN6
        Y8kDouTZso4SwlFyQF0QohOLg+KfyU4yJau1Y=; b=VxklZ9U1C4g/9ShbHm6OIe
        KMx7DyT0m1xA53vD4eMgJ4rxlOghrtBz/OOVI9u8VYaLViEiznNYz72cmMjXu58q
        49vgkwIa6LNJCCRBPEvwJLDyQosmsO0R6He3leucfAY3n80RjpQK9KPRP9ADy2CK
        4W7+g+CryXoTCYY1Mj25DOUpw0snQ/bbBeA7vCEWQjxFXtoHqkNtNj6Pz3MqqQxP
        NypaGkPsxecj5/uUhRI4/MfvbG6JfBhTmOUCE9JOt+tK8U4E/2u/lV4ha57CwLbg
        12aUwfm4cI8+Z9VdRC8S7vPahfiK5LapswiP9AmlAn5cZKD3UfTuecpbKimk/V6A
        ==
X-ME-Sender: <xms:LwLGYLC8tQGqeYK20b7behEZgwHSAdT43BqTl0K6fmqL7wPo6TogdA>
    <xme:LwLGYBiTHdxdW7DleFQ4IqlmGyzJ22jbzugt1Ob-NerBZM_XGFSTohRwiytYFSGwq
    GWaK-_YyaYEtA>
X-ME-Received: <xmr:LwLGYGmJP6xJ8FG_69VKV-0mmcanA0Fs9ROFAgvaecThr0b9FYyk2D_QRz-6XTGZ4BTyCe0TmRISuqXO8bZu7XcbKOwq_ZCL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:LwLGYNxDMWzfw5_KrmNmlY0dlw90pSVrH8yX1j8w3vmS0XRJel-m-w>
    <xmx:LwLGYARRBeeocc_F5yka7kCn1uVnj2coruV4yyKrsTspRZmkOU2f9w>
    <xmx:LwLGYAazo8zDIpqDZ7KZy5jYMTdx8McSDrpoGI3xp_SpwT-gPbe7qw>
    <xmx:LwLGYLf6XwOJ1hyDFauHG9Hj0285h1hBaRNe9ZJR1TKhC7_91HWBeg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 09:03:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/mlx5: Use different doorbell memory for different" failed to apply to 4.9-stable tree
To:     markzhang@nvidia.com, jgg@nvidia.com, leonro@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 15:03:33 +0200
Message-ID: <16235894133360@kroah.com>
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

From a0ffb4c12f7fa89163e228e6f27df09b46631db1 Mon Sep 17 00:00:00 2001
From: Mark Zhang <markzhang@nvidia.com>
Date: Thu, 3 Jun 2021 16:18:03 +0300
Subject: [PATCH] RDMA/mlx5: Use different doorbell memory for different
 processes

In a fork scenario, the parent and child can have same virtual address and
also share the uverbs fd.  That causes to the list_for_each_entry search
return same doorbell physical page for all processes, even though that
page has been COW' or copied.

This patch takes the mm_struct into consideration during search, to make
sure that VA's belonging to different processes are not intermixed.

Resolves the malfunction of uverbs after fork in some specific cases.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Link: https://lore.kernel.org/r/feacc23fe0bc6e1088c6824d5583798745e72405.1622726212.git.leonro@nvidia.com
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/mlx5/doorbell.c b/drivers/infiniband/hw/mlx5/doorbell.c
index 61475b571531..7af4df7a6823 100644
--- a/drivers/infiniband/hw/mlx5/doorbell.c
+++ b/drivers/infiniband/hw/mlx5/doorbell.c
@@ -41,6 +41,7 @@ struct mlx5_ib_user_db_page {
 	struct ib_umem	       *umem;
 	unsigned long		user_virt;
 	int			refcnt;
+	struct mm_struct	*mm;
 };
 
 int mlx5_ib_db_map_user(struct mlx5_ib_ucontext *context,
@@ -53,7 +54,8 @@ int mlx5_ib_db_map_user(struct mlx5_ib_ucontext *context,
 	mutex_lock(&context->db_page_mutex);
 
 	list_for_each_entry(page, &context->db_page_list, list)
-		if (page->user_virt == (virt & PAGE_MASK))
+		if ((current->mm == page->mm) &&
+		    (page->user_virt == (virt & PAGE_MASK)))
 			goto found;
 
 	page = kmalloc(sizeof(*page), GFP_KERNEL);
@@ -71,6 +73,8 @@ int mlx5_ib_db_map_user(struct mlx5_ib_ucontext *context,
 		kfree(page);
 		goto out;
 	}
+	mmgrab(current->mm);
+	page->mm = current->mm;
 
 	list_add(&page->list, &context->db_page_list);
 
@@ -91,6 +95,7 @@ void mlx5_ib_db_unmap_user(struct mlx5_ib_ucontext *context, struct mlx5_db *db)
 
 	if (!--db->u.user_page->refcnt) {
 		list_del(&db->u.user_page->list);
+		mmdrop(db->u.user_page->mm);
 		ib_umem_release(db->u.user_page->umem);
 		kfree(db->u.user_page);
 	}

