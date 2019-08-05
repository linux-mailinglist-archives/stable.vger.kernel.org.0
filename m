Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FAC811A8
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfHEFfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:35:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56995 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEFfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:35:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B725620F44;
        Mon,  5 Aug 2019 01:35:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=b2isCH
        E3y2o4MWLpjUyEkG0gcSBj8rDTGe2kND/2uMg=; b=KFC6L7GKj1Ixr8tj6d48h4
        SEZiEgkZU7uuwOKEsdh4svYBmGh3H16w5joI2BIQvQGxlzWqXH2TfjVrLf12l3Ip
        yj6POdopvmdbUIy5E0cq4uVar7ZHIsOmtKzsvaTilF4vvA0jPWeuoTdr3nekksSN
        onBadpJenMOaGEfF/+8oGLzYxfCoeqrTAQvlntpkXgZFCseWci7m8WMFwOfNIjbb
        BqWEZ8WIeu2e3/M9NAMUNN+VczsegKH3R3s5EDytoDaSVCBiOfv3jE+/ztp+o1HM
        EnZsG+Ne3zruglLdxe2brts9E7bRtxm5NzgiTkePA70RsFQ+V0speSdTg1YBKwsA
        ==
X-ME-Sender: <xms:L8BHXfgQFY-A5mYt_vJBOc5QNhNaUFLG0xZcLh8pxaApHOi5OrBi3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:L8BHXenpisDZvxnh6J34oL-mmmFR3sg4lGu9JU292FT8BmJOWSJL3g>
    <xmx:L8BHXSvDNgHqFqkWKllrABonDSI2Tv75_WWw2GJRxAIogq2dfJl6wg>
    <xmx:L8BHXcZw2vpexyTD4OgAAH-zaVBILgDs_zYNRciVJf1nell-AHMryQ>
    <xmx:L8BHXYMELhiUP7GVk5APF5BhdLcLQkFMcwNNGHfXL02mVXyHczPn-w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 11B7D380083;
        Mon,  5 Aug 2019 01:35:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/mlx5: Fix unreg_umr to ignore the mkey state" failed to apply to 4.9-stable tree
To:     yishaih@mellanox.com, artemyko@mellanox.com, jgg@mellanox.com,
        leonro@mellanox.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:35:41 +0200
Message-ID: <156498334110788@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 6a053953739d23694474a5f9c81d1a30093da81a Mon Sep 17 00:00:00 2001
From: Yishai Hadas <yishaih@mellanox.com>
Date: Tue, 23 Jul 2019 09:57:25 +0300
Subject: [PATCH] IB/mlx5: Fix unreg_umr to ignore the mkey state

Fix unreg_umr to ignore the mkey state and do not fail if was freed.  This
prevents a case that a user space application already changed the mkey
state to free and then the UMR operation will fail leaving the mkey in an
inappropriate state.

Link: https://lore.kernel.org/r/20190723065733.4899-3-leon@kernel.org
Cc: <stable@vger.kernel.org> # 3.19
Fixes: 968e78dd9644 ("IB/mlx5: Enhance UMR support to allow partial page table update")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index c482f19958b3..f6a53455bf8b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -481,6 +481,7 @@ struct mlx5_umr_wr {
 	u64				length;
 	int				access_flags;
 	u32				mkey;
+	u8				ignore_free_state:1;
 };
 
 static inline const struct mlx5_umr_wr *umr_wr(const struct ib_send_wr *wr)
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 20ece6e0b2fc..266edaf8029d 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1372,10 +1372,10 @@ static int unreg_umr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		return 0;
 
-	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_DISABLE_MR |
-			      MLX5_IB_SEND_UMR_FAIL_IF_FREE;
+	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_DISABLE_MR;
 	umrwr.wr.opcode = MLX5_IB_WR_UMR;
 	umrwr.mkey = mr->mmkey.key;
+	umrwr.ignore_free_state = 1;
 
 	return mlx5_ib_post_send_wait(dev, &umrwr);
 }
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 2a97619ed603..615cc6771516 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4295,10 +4295,14 @@ static int set_reg_umr_segment(struct mlx5_ib_dev *dev,
 
 	memset(umr, 0, sizeof(*umr));
 
-	if (wr->send_flags & MLX5_IB_SEND_UMR_FAIL_IF_FREE)
-		umr->flags = MLX5_UMR_CHECK_FREE; /* fail if free */
-	else
-		umr->flags = MLX5_UMR_CHECK_NOT_FREE; /* fail if not free */
+	if (!umrwr->ignore_free_state) {
+		if (wr->send_flags & MLX5_IB_SEND_UMR_FAIL_IF_FREE)
+			 /* fail if free */
+			umr->flags = MLX5_UMR_CHECK_FREE;
+		else
+			/* fail if not free */
+			umr->flags = MLX5_UMR_CHECK_NOT_FREE;
+	}
 
 	umr->xlt_octowords = cpu_to_be16(get_xlt_octo(umrwr->xlt_size));
 	if (wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_XLT) {

