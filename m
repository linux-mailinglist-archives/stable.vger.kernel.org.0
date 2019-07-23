Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579B3717AF
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 14:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387738AbfGWMDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 08:03:42 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48663 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728240AbfGWMDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 08:03:42 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 88D89212BF;
        Tue, 23 Jul 2019 08:03:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 08:03:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=liURrO
        5dG1jqTtqR7amhvryt0jD7Vc7nEmKUvNzHeRI=; b=xXOZrAkBkgnTLzoDEG8DMh
        +BKvmpCuKYfoAHZopU5rvZ54sYrF/uRi2jF16V0oUKHn+5TiBWFUuVScnXOnbKb3
        i3e8bOURzhqe+mMTVQpxKYjkEwmmi6ASumg3rw18QnWOfHGyjR6Lif6c1nihMUAf
        a0B0wA4GYOVvJljF5X3VLZNkxQPOp1tTh4OFE1dMesPa6da1FmE47eR9Dlv8BMwx
        ZQDCFdxACM4dZ7vQfze7viHq5NGTvJMOo5JJOSmKPG1dAh8OB0Ao5uE4TpAnkrST
        RZzoqZZCYDDNwkDnk52Wtsie23mZo/xT2D1oTAA1WcZAW8YCq/HMQCyN+oF7YZFw
        ==
X-ME-Sender: <xms:nfc2XQ1oE8P6Dyt8sTzIVSwrp3DfPGyyrPXhJXSxftsumHW6bOE2hQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:nfc2XfXw31E9G6jn5aO0txoDGWVEt94WRcZ4kG69mznER1Q6mcTYUA>
    <xmx:nfc2XT6jXGh1Ldzgf4eKDuLqpgbQsHkj7_BtdZhkbTk85bfqYiLJmQ>
    <xmx:nfc2XeI-Qvp187EDKKuDiaHG6trAESr5ETBPiXuME6KQFOKFlrlptg>
    <xmx:nfc2XbEuKkGZbp0dnym6Sv7wz-hXFiV0uM_-lPAyWQr9jDpziQlNiQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A374280059;
        Tue, 23 Jul 2019 08:03:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/mlx5: Report correctly tag matching rendezvous capability" failed to apply to 4.14-stable tree
To:     danitg@mellanox.com, artemyko@mellanox.com, jgg@mellanox.com,
        leonro@mellanox.com, stable@vger.kernel.org, yishaih@mellanox.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 14:03:39 +0200
Message-ID: <1563883419210193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 89705e92700170888236555fe91b45e4c1bb0985 Mon Sep 17 00:00:00 2001
From: Danit Goldberg <danitg@mellanox.com>
Date: Fri, 5 Jul 2019 19:21:57 +0300
Subject: [PATCH] IB/mlx5: Report correctly tag matching rendezvous capability

Userspace expects the IB_TM_CAP_RC bit to indicate that the device
supports RC transport tag matching with rendezvous offload. However the
firmware splits this into two capabilities for eager and rendezvous tag
matching.

Only if the FW supports both modes should userspace be told the tag
matching capability is available.

Cc: <stable@vger.kernel.org> # 4.13
Fixes: eb761894351d ("IB/mlx5: Fill XRQ capabilities")
Signed-off-by: Danit Goldberg <danitg@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 7581571bd9cd..56d4b1e9dd23 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1046,15 +1046,19 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	}
 
 	if (MLX5_CAP_GEN(mdev, tag_matching)) {
-		props->tm_caps.max_rndv_hdr_size = MLX5_TM_MAX_RNDV_MSG_SIZE;
 		props->tm_caps.max_num_tags =
 			(1 << MLX5_CAP_GEN(mdev, log_tag_matching_list_sz)) - 1;
-		props->tm_caps.flags = IB_TM_CAP_RC;
 		props->tm_caps.max_ops =
 			1 << MLX5_CAP_GEN(mdev, log_max_qp_sz);
 		props->tm_caps.max_sge = MLX5_TM_MAX_SGE;
 	}
 
+	if (MLX5_CAP_GEN(mdev, tag_matching) &&
+	    MLX5_CAP_GEN(mdev, rndv_offload_rc)) {
+		props->tm_caps.flags = IB_TM_CAP_RNDV_RC;
+		props->tm_caps.max_rndv_hdr_size = MLX5_TM_MAX_RNDV_MSG_SIZE;
+	}
+
 	if (MLX5_CAP_GEN(dev->mdev, cq_moderation)) {
 		props->cq_caps.max_cq_moderation_count =
 						MLX5_MAX_CQ_COUNT;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 50806bef9f20..4053be51b7fa 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -307,8 +307,8 @@ struct ib_rss_caps {
 };
 
 enum ib_tm_cap_flags {
-	/*  Support tag matching on RC transport */
-	IB_TM_CAP_RC		    = 1 << 0,
+	/*  Support tag matching with rendezvous offload for RC transport */
+	IB_TM_CAP_RNDV_RC = 1 << 0,
 };
 
 struct ib_tm_caps {

