Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5064B395126
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 15:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhE3N5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 09:57:37 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:34263 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3N5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 09:57:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 311AB194051F;
        Sun, 30 May 2021 09:55:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 30 May 2021 09:55:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ReM+TN
        7f/StpA8FyRw2enJ40m/aMvhmE4+iX8Rq0+YI=; b=kIUfcGB/IbU3npNzFxD5Qp
        i3UZ+6jXvnxthLMPZ2r+0cj8ARmrz3JECSDLXt/+84qw6wtJllzClOEB6v5G7J/U
        muCH6ZiNnKid72NqjXeKDqPrXX0suude51NrjopLlRWxrztOgAy7GV/3sEbAsJda
        2G7tmQTavKiBItRQYUn4KYH0Rq5nPo3ow3Fa0fDqcwxqa8KCZJxs/LMYwDjW5lOo
        tcxErIJPIYwCQV3/T9njxMjbyeo2tyWYB6hWvu9LJ3EnbMRo9FFvhrJ/jiwGTFtA
        CX+s0/us1kMjTfuYBkn73nbE+bf9ZZxN3VT6YxU+Rxm+GoCMC6edYWIHmLY/bAAQ
        ==
X-ME-Sender: <xms:b5mzYEcuIUNovfKVX2pAnVa-70ulNY2n9_U63nPHcSntELrQJfD_sg>
    <xme:b5mzYGOaHuimYOUaRq6t7eyEuaKmEtp1qobj8SMB3t6ycIeTYUT1HqmPW9rcW3wA2
    3QJ5oRyH1Cihg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:b5mzYFgGYXhZFVCZAZwN0_yGqYW5-Sksp5YcOszwrgb614SJ9xPGrg>
    <xmx:b5mzYJ8vBtuM7iUAPHdvjTcjtiQe9aOaZAfYeB3LK6aZx88WMQGWJg>
    <xmx:b5mzYAvlQtWYziwvo-HNUTxd5NBV39ge9emWhSuvRZN0rnJE1CyhfA>
    <xmx:b5mzYNXvsdEJ5IHrOsDfl7GY0PwbTzNucC2CNmUs_PUyZkC_bPRplQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 09:55:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net/mlx5: Fix err prints and return when creating termination" failed to apply to 5.12-stable tree
To:     roid@nvidia.com, maord@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 15:55:53 +0200
Message-ID: <16223829539485@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fca086617af864efd20289774901221b2df06b39 Mon Sep 17 00:00:00 2001
From: Roi Dayan <roid@nvidia.com>
Date: Thu, 13 May 2021 15:00:53 +0300
Subject: [PATCH] net/mlx5: Fix err prints and return when creating termination
 table

Fix print to print correct error code and not using IS_ERR() which
will just result in always printing 1.
Also return real err instead of always -EOPNOTSUPP.

Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push actions")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index e3e7fdd396ad..d61bee2d35fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -65,7 +65,7 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 {
 	struct mlx5_flow_table_attr ft_attr = {};
 	struct mlx5_flow_namespace *root_ns;
-	int err;
+	int err, err2;
 
 	root_ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_FDB);
 	if (!root_ns) {
@@ -83,26 +83,26 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
 	ft_attr.autogroup.max_num_groups = 1;
 	tt->termtbl = mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
 	if (IS_ERR(tt->termtbl)) {
-		esw_warn(dev, "Failed to create termination table (error %d)\n",
-			 IS_ERR(tt->termtbl));
-		return -EOPNOTSUPP;
+		err = PTR_ERR(tt->termtbl);
+		esw_warn(dev, "Failed to create termination table, err %pe\n", tt->termtbl);
+		return err;
 	}
 
 	tt->rule = mlx5_add_flow_rules(tt->termtbl, NULL, flow_act,
 				       &tt->dest, 1);
 	if (IS_ERR(tt->rule)) {
-		esw_warn(dev, "Failed to create termination table rule (error %d)\n",
-			 IS_ERR(tt->rule));
+		err = PTR_ERR(tt->rule);
+		esw_warn(dev, "Failed to create termination table rule, err %pe\n", tt->rule);
 		goto add_flow_err;
 	}
 	return 0;
 
 add_flow_err:
-	err = mlx5_destroy_flow_table(tt->termtbl);
-	if (err)
-		esw_warn(dev, "Failed to destroy termination table\n");
+	err2 = mlx5_destroy_flow_table(tt->termtbl);
+	if (err2)
+		esw_warn(dev, "Failed to destroy termination table, err %d\n", err2);
 
-	return -EOPNOTSUPP;
+	return err;
 }
 
 static struct mlx5_termtbl_handle *
@@ -270,8 +270,7 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 		tt = mlx5_eswitch_termtbl_get_create(esw, &term_tbl_act,
 						     &dest[i], attr);
 		if (IS_ERR(tt)) {
-			esw_warn(esw->dev, "Failed to get termination table (error %d)\n",
-				 IS_ERR(tt));
+			esw_warn(esw->dev, "Failed to get termination table, err %pe\n", tt);
 			goto revert_changes;
 		}
 		attr->dests[num_vport_dests].termtbl = tt;

