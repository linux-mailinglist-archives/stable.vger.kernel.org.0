Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3608C3A58A1
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 15:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhFMNIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 09:08:21 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:40371 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231286AbhFMNIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 09:08:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id E76951940A0F;
        Sun, 13 Jun 2021 09:06:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 13 Jun 2021 09:06:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rYppUT
        G96kh5Vq2OCS3C2eas6rMrslB6i+V3SMvdu0w=; b=Jj2xbxhkM4ZgH2ZpTE8QI8
        y1sWVR43HMbdb4C1zacHDpHp2zsiG7HLxTfbUGcXoYOz52nso3LzvrSHJNKagcr9
        n9qyFtPKktUT+Av8yccug3FCoMzsLeCtJZIr8EhtGHalAhZyJ7y0GkNQvy0tJg8F
        okBEt9F21Htfj81UoPHhzlb6A+c0aF6wa+uLtmKSUBsiNcUadsHc8klM+p6VnMSL
        6ukp4roRfdPugkYT1tqqRzpQEb6Uk09vf7XyncAAl5RbOvlP71Ix34vDaXcNpGWF
        zLDxUOcTopjsvgTdk8ey+DI46ETuTKqz0gqAPpnjrTZKFm4tUBYK2UznDPQwPGAQ
        ==
X-ME-Sender: <xms:ywLGYHXvxyFWFWPic5kNbx_nK84EcnV5BH1xugZFmIBctQB58EEAtQ>
    <xme:ywLGYPkuFoGLJ-8__acrDgek6dLZVDXeWAqhSpzGPXVarZmT1asF6iqMCXbrFXatX
    SNXiuRJ_uw94g>
X-ME-Received: <xmr:ywLGYDYOkhctp0uoCEsU0peOL6dXeLCi2rEpc3pH7cadsWF9wo6XtMl5RxHS2Q_S0RwxAq_BpoNV0WOrqN3vONpA2YqUtx4C>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:ywLGYCX9n3SE7z918Tbsr4Bt6p_4wlpx-tq6p79-fi2k4KHYW0HdLA>
    <xmx:ywLGYBnL7RVxW-nRcfeHM807AA7w7K20jfcaw0w6vNtSH5uveewGeA>
    <xmx:ywLGYPeLqmRW3PrhgXeVYJy4jmwbmWwROQnttKUwRx9tb7AvCnjeKw>
    <xmx:ywLGYGzCMyNH5R6Pwr0zrTp71mZR_Z08LdjTecpl8d6FXH1pZ_GEDw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 09:06:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/mlx5: Use different doorbell memory for different" failed to apply to 5.10-stable tree
To:     markzhang@nvidia.com, jgg@nvidia.com, leonro@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 15:06:17 +0200
Message-ID: <1623589577251246@kroah.com>
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

