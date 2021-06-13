Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B7D3A5898
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 15:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbhFMNGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 09:06:31 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:47779 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231286AbhFMNGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 09:06:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id F01061940AF5;
        Sun, 13 Jun 2021 09:04:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 13 Jun 2021 09:04:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uKGG0e
        Y26bJhLPQBCIUv3m2agqANUbRoXdsE4ZLcVLo=; b=JTwzabwmmLDQrSGH7exYC9
        fsKLTXAnp8rxfOvop7M5ZG197r0ICc++hO3U5KxBMtjpWYYqDdnIVnJYt4pLFd0i
        n/9ANtP9Azq/yRp0g5vB9uWEm1DRqoDgABq3CKUGZ7EhqgmUyyZyvKPOObh6SaLq
        swE79q/tmzDv/h+ZdJiugb8M2tLpIKtQF5cZpyTHhORm26/o0AJkZ4lr+eZcd5Ss
        GpznEZg4tb7V+hDOxTr8e6emSLDG3kkvy8upuD/NIzHp5YrOqPxHvT6/kLdcuRwf
        6UNLGIARUydxAqE/0/joUJ1LEKnwUUOkTNRGhE7BVPmwxQn6D6Qv+fPjHZ2cDTcQ
        ==
X-ME-Sender: <xms:XQLGYCIv0D9QMOTJJ19wWgoV2IWe2tkYsNWGrk3yTsJNMwoiEhWeIQ>
    <xme:XQLGYKK5Sm229XP7mCuO4FjrKghJtgJON8ixAlPcCgzJ2V8jsYp1eSCUJzLPnozCT
    W7MOjba1WjfFA>
X-ME-Received: <xmr:XQLGYCvuUEBJXVoiSBP5bk_JqB2x-cDvD6c0rOR6Q8MjlEpGF56iXRPhP1XvmuSV2NUCvWfKPub_rKh6zX74Z6BNH_ZFfSvd>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:XQLGYHZ29zbUUgEaCYEg6VVnKOxb6aRKj2Pb63MOHc6deUaAhTR0gA>
    <xmx:XQLGYJY414AFZ2Qn-9zRhiINv4G37bL3e2Zgh-IbCnrjVUBnsmBv3g>
    <xmx:XQLGYDB4qPeFo4yw39zni4MmfhR43J-yJqOdora_hAtnW-YTVRZaAA>
    <xmx:XQLGYImCXFzj5arhSHHh7OtxD3sgI4AuEi2dyYg0TSVwcKi-Gz0iRw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 09:04:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/mlx5: Use different doorbell memory for different" failed to apply to 4.19-stable tree
To:     markzhang@nvidia.com, jgg@nvidia.com, leonro@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 15:04:19 +0200
Message-ID: <1623589459162136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

