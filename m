Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5043A589F
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 15:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhFMNHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 09:07:23 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:59719 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231286AbhFMNHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 09:07:23 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7273A1940B2C;
        Sun, 13 Jun 2021 09:05:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 13 Jun 2021 09:05:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=26sepj
        sw9A6mbZVeCT8JHNlF9IHknZOtakB8KSUt4Z4=; b=WdouCIvtgJFj7qDsdp7RIr
        LyIj04T8JG+AsRSnKKg/db1iF6q1yru5boktJsGsxCsvesVbo/ujGAPnKY2ga2Pz
        rBparSwVQiK9bZtmeALS26wgsPCNlYXnRVMky8YTrw7qowI8qS9PadjAGj4uliA5
        NOcyxLaYMnEdFWOx0mqSC8PdTIzkaIc8Ysbf1d7VELd0KMZYC+aIoCox8AkaA1eF
        uvcNvldRrqOHDoe2js6RYXTTbIy5YxJj6eEr9ElW+aztkuFyYwwf//O//mVXPfLV
        +0NTMR+Waw0SNURlzVRNEnxTV0EoWqd4pW5S36bhXXMDgvcQ8eE0RnxYqGtlHGIg
        ==
X-ME-Sender: <xms:kQLGYAZXLRj-ijhPSZdi4PwP9taCyyrTyyRdhFRkfqevXnJXnxw0jg>
    <xme:kQLGYLaN-7yJf1rsMw4tEgK1e3btVZdp4mi5fji5eMWPZ8Wj8L-VGQj7BLYwiVWP2
    guymYsUzMgQng>
X-ME-Received: <xmr:kQLGYK8ylecDNSf88qzy6sn2MwxQnb2ob3xtnVT5kIjsQ4A6s-VtPpEgcrHXRl_vEqVqdC0jOqPTU2UwLNnY82czvdRDWDRl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:kQLGYKo6R2a--oIYYcv0sI8gPSHfCsTpSeCE3MqN6612IX9PTh2LDQ>
    <xmx:kQLGYLp6BEjf0ezruFzcW4DoLqvOTm63iG6W2KexkVKuBjKseb4p5A>
    <xmx:kQLGYIT5iaCE5oQ4tbAFw5bU957nXP5_iUoerfCuAeEtBiB_BYdCLQ>
    <xmx:kQLGYC1lehATuLKbRzXm-AXFgQpNvL1Ey_RGb-d8YMwlgWY8MFLC6w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 09:05:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/mlx5: Use different doorbell memory for different" failed to apply to 5.4-stable tree
To:     markzhang@nvidia.com, jgg@nvidia.com, leonro@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 15:05:19 +0200
Message-ID: <162358951918531@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

