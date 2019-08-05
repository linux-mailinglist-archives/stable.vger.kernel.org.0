Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC9E811AF
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfHEFgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:36:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47885 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEFgx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:36:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5D667206FC;
        Mon,  5 Aug 2019 01:36:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:36:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Go1zVr
        w+HnugJAdChOJ/bmyEG7vZxW+ynTY94+Q9dR4=; b=kgycqQG8z8okD58Pn/VpaH
        NxrwmCA0+QFgCoTGazUxK863vV3UmIBDotGdufmQI0lbEgeQjU2GJP8Qj8FtCi8s
        hHpL+3ovL5jPVPGLGZ4W66CWdFs7ZNFaBb4a8WqmVdapoUSt+rMrU+vpi8mpcCMP
        QGOiASelicvayVj60tVNGNI8UrHnNwzTIfgxwS+OGoRg9tA9CH00MMLCPkiFIY+h
        xaQSL0uY993m0O0wjRgHNGqNgRb6sx+8H3YuEpquRC/Wr13ef4Ym5Mxh7rnIGG40
        OK0SfHqUmsKD1QpTvRJYqDWuaxyKfSGEYjJ4QVL6hD9N99vJLEbwvuXccVtC6zgw
        ==
X-ME-Sender: <xms:dMBHXT28UjmqX9xmSChZo_aI-76z68i4cx6eSxY-_HtEqzdmCTtXPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeeh
X-ME-Proxy: <xmx:dMBHXeM-czasd9uVhDfi7uoGQx6yEEAR_40TCNqI-iMSAYiW7_44-Q>
    <xmx:dMBHXdLUKkrtG3wyqlnoZDqA-o9qSV7Rfz9NNdGHeSjw6DYj3Qa-PA>
    <xmx:dMBHXX6u7LDIhJmfso1g8GbC9lGgb1UuyR-Iz-EI_XqfCYYiTHuJeA>
    <xmx:dMBHXbP79oBonHgXX17TUVRpiyInsMuFlyCFsz-7FdkdXIVIcau8bQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CBE2A380083;
        Mon,  5 Aug 2019 01:36:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/mlx5: Fix clean_mr() to work in the expected order" failed to apply to 4.4-stable tree
To:     yishaih@mellanox.com, artemyko@mellanox.com, jgg@mellanox.com,
        leonro@mellanox.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:36:42 +0200
Message-ID: <1564983402148137@kroah.com>
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

From b9332dad987018745a0c0bb718d12dacfa760489 Mon Sep 17 00:00:00 2001
From: Yishai Hadas <yishaih@mellanox.com>
Date: Tue, 23 Jul 2019 09:57:28 +0300
Subject: [PATCH] IB/mlx5: Fix clean_mr() to work in the expected order

Any dma map underlying the MR should only be freed once the MR is fenced
at the hardware.

As of the above we first destroy the MKEY and just after that can safely
call to dma_unmap_single().

Link: https://lore.kernel.org/r/20190723065733.4899-6-leon@kernel.org
Cc: <stable@vger.kernel.org> # 4.3
Fixes: 8a187ee52b04 ("IB/mlx5: Support the new memory registration API")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 7274a9b9df58..2c77456f359f 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1582,10 +1582,10 @@ static void clean_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 		mr->sig = NULL;
 	}
 
-	mlx5_free_priv_descs(mr);
-
-	if (!allocated_from_cache)
+	if (!allocated_from_cache) {
 		destroy_mkey(dev, mr);
+		mlx5_free_priv_descs(mr);
+	}
 }
 
 static void dereg_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)

