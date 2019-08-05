Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59D40811AA
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfHEFfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:35:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49337 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEFfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:35:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D24B221ACF;
        Mon,  5 Aug 2019 01:35:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:35:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DONOd6
        0pYvdqVzOMzc4zgWi67UbCU94uBv/bRDAXLSw=; b=OkBlwCAAiGDTfcIQlvSrjZ
        eGBgRawN4KJ4i/zsp5asZ+ZKEhlJBPLj3BMgcuGmJ6DIv+DKGNMX/jMygP7OGN6y
        EPLnExzMByKrgf5PPzRLHaZc0yp15EjQztVoAgmB1turt1J2ENoYYU6jbOp2Sl6/
        zC2WfYdi8sehIHMhplJYlnyONxM+jAlqkkH0F0KXK2LeLRDVvLPsE7pRDB3uxKfP
        DAsr2ZwweCygQjR42+YXq5u2ppd+dEY5YYddgM+HHMEozbrhNiFv0I/w+8tyzNsw
        YdJMHPCwowttqtnqqNw7i2cO9gOocSlbZXl+VetdQWFXmJBaB0Hh1EcG5/5j2OfQ
        ==
X-ME-Sender: <xms:N8BHXYbg-feXqXY6KIXj4jf6zfZJAP2f9RRXQy0OoOaeu6V8VFuwdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:N8BHXc0y5vHzR0vmZR2zabYDjd--ErF-UUAHki_UHHYF7t6RGk5ERw>
    <xmx:N8BHXSgdOrqVDEKG7T3aB6MWMFfjheZoa-cq_h-wey8sh1ja4orWIQ>
    <xmx:N8BHXYZtu5l0wfmSBeLwwPT7Bk961CXo8chcTUkk8SYOTB7BKmUj9Q>
    <xmx:N8BHXQZKcKopuPQED84ahkKlStya70n8cuTwS0AZ9qEO9yoARtriqg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52B5C380086;
        Mon,  5 Aug 2019 01:35:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/mlx5: Fix unreg_umr to ignore the mkey state" failed to apply to 4.4-stable tree
To:     yishaih@mellanox.com, artemyko@mellanox.com, jgg@mellanox.com,
        leonro@mellanox.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:35:42 +0200
Message-ID: <156498334217081@kroah.com>
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

