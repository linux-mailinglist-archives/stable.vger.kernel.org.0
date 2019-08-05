Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCA6811AB
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfHEFgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:36:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48203 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEFgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:36:22 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9F2FE20C86;
        Mon,  5 Aug 2019 01:36:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:36:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=iLGOh5
        LuNdtWDkzn1sofjUa4pPuOnrc3AdUd/gjOORE=; b=pYl6Ksqe+HZqScvLw9i8w9
        j5yYuYxWXWvyLMJhcU3rgN3AVhY+BdrPkvSftAzt4ZPrHbfaC+Lm73kzdgYOpmFa
        SDC7z7+YYR9LeRjcpKZN9Q1RYoNq9ihQk9r6S8w7kHm/OAslL69/cQdOaw680qTj
        Gt34h6R/wJU12dk4agIPOvxDMxliqhYAsD6/Lqmp8sXHDTCCKCjEmqHHvYYCtrMT
        TfifxEv4CBCRZopjG6PhrNvjkQRHf6DisDO664M6/dVCz1v+uMeKqyPaSKwIDvqn
        WfpJymJxT6q63VTr8Lg+aZhJ+phWWgCY1zN0/OhtL9lJt3fvSKyEDE2a3a4S/dSQ
        ==
X-ME-Sender: <xms:VcBHXTCR_SgnCQlD-TAmXO68MirzSLGToUOzUQr8lE5m9bos7v2QVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:VcBHXUH_kSoKMP788gbR4L-UITB2LSsvQh3kf3od42b7BbT7JjldBg>
    <xmx:VcBHXbIiitJZEWg8fiqcGFF5IcgG-hSC493LEZq779p9xNYX7rHjMg>
    <xmx:VcBHXYnnVcWWuvd4u5dCDKMGsiyf8Q7PAsryUsj9Jmqt_nV8awMu5Q>
    <xmx:VcBHXexeYbdcXqKFX9rbx3KptMFIgCEPEQRpSEnePDVG6pLn52-6uw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1AD008005B;
        Mon,  5 Aug 2019 01:36:21 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/mlx5: Move MRs to a kernel PD when freeing them to the MR" failed to apply to 4.4-stable tree
To:     yishaih@mellanox.com, artemyko@mellanox.com, jgg@mellanox.com,
        leonro@mellanox.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:36:19 +0200
Message-ID: <1564983379222253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9ec4483a3f0f71a228a5933bc040441322bfb090 Mon Sep 17 00:00:00 2001
From: Yishai Hadas <yishaih@mellanox.com>
Date: Tue, 23 Jul 2019 09:57:27 +0300
Subject: [PATCH] IB/mlx5: Move MRs to a kernel PD when freeing them to the MR
 cache

Fix unreg_umr to move the MR to a kernel owned PD (i.e. the UMR PD) which
can't be accessed by userspace.

This ensures that nothing can continue to access the MR once it has been
placed in the kernels cache for reuse.

MRs in the cache continue to have their HW state, including DMA tables,
present. Even though the MR has been invalidated, changing the PD provides
an additional layer of protection against use of the MR.

Link: https://lore.kernel.org/r/20190723065733.4899-5-leon@kernel.org
Cc: <stable@vger.kernel.org> # 3.10
Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index b83361aebf28..7274a9b9df58 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1375,8 +1375,10 @@ static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		return 0;
 
-	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_DISABLE_MR;
+	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_DISABLE_MR |
+			      MLX5_IB_SEND_UMR_UPDATE_PD_ACCESS;
 	umrwr.wr.opcode = MLX5_IB_WR_UMR;
+	umrwr.pd = dev->umrc.pd;
 	umrwr.mkey = mr->mmkey.key;
 	umrwr.ignore_free_state = 1;
 

