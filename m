Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77856200A8F
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732611AbgFSNpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:45:55 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:55991 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732029AbgFSNpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:45:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B12A91945747;
        Fri, 19 Jun 2020 09:45:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:45:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yzaxEu
        t7BIZ+SaMiVPbBq7l5F+yEApXKREGTDlsCFms=; b=S/ba6qEpCd0XNyP6lrb4sD
        /oMcMfznwWmaAhjQqxYht8/FOz4PWpvUo+sobkM8S6hYfCekIUXjraFUtfJT87t9
        CtHjM/yHickOb9+xDmjY6LTpzb4EiJnKCL/u6k9mFU+oJg1yz4CAri2PkMkWN6lS
        lwESSqfC8uEMdQx+mzBYhibJdT7UPkfB1Vo/e4Ui3/3QG+UwDSxYepx/e5b83KUy
        YmDcLbAK6ZhkBK2CdS7JH5i84l/bwRfUtKEPVo9H7ADYIM1sbUA3hlAulQN6qSne
        AyYkK7zyuk9cHsqR23RPhssXLqunV/cgx4pzZpL1Wt0sTlef+E3wJqnsIN6adLmg
        ==
X-ME-Sender: <xms:kcHsXsuH5UGO-_ETFmbuJlh7McfVuPULIDZlkxO3ueUGflfust_1gg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:kcHsXpdP1ccqqa-amBqJPulUak9uKq3HbWpyP5mWonKsUwt8MdsnLg>
    <xmx:kcHsXnzl6AO-zIH6g0fbgJfWqRIsqKVTfz_c-m0SgSm1VXuA3LG5EQ>
    <xmx:kcHsXvOJikP8jF-5qUoJzIKBRJMbwM9JrdK2035osEcra5yLyEdNjQ>
    <xmx:kcHsXlI-hfjo7AJSl24QludbMKAWQBtOexzRM4G_Yp5VvwwAg77Jkw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5036F328006B;
        Fri, 19 Jun 2020 09:45:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net/mlx5: DR, Fix freeing in dr_create_rc_qp()" failed to apply to 5.4-stable tree
To:     efremov@linux.com, saeedm@mellanox.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:45:43 +0200
Message-ID: <1592574343164106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 47a357de2b6b706af3c9471d5042f9ba8907031e Mon Sep 17 00:00:00 2001
From: Denis Efremov <efremov@linux.com>
Date: Mon, 1 Jun 2020 19:45:26 +0300
Subject: [PATCH] net/mlx5: DR, Fix freeing in dr_create_rc_qp()

Variable "in" in dr_create_rc_qp() is allocated with kvzalloc() and
should be freed with kvfree().

Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA operations")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index f421013b0b54..2ca79b9bde1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -179,7 +179,7 @@ static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 	MLX5_SET(create_qp_in, in, opcode, MLX5_CMD_OP_CREATE_QP);
 	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
 	dr_qp->qpn = MLX5_GET(create_qp_out, out, qpn);
-	kfree(in);
+	kvfree(in);
 	if (err)
 		goto err_in;
 	dr_qp->uar = attr->uar;

