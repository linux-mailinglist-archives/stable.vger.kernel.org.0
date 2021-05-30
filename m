Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFE8395125
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 15:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhE3N5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 09:57:35 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:36705 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3N5f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 09:57:35 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 784DC194051F;
        Sun, 30 May 2021 09:55:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 30 May 2021 09:55:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=86NeZo
        s2Tuxwak+0oj5x/XzxBnlOX7cU5WI4iVF7aLo=; b=r1LuAWUI0hrKBTpbgY4oek
        jG6alsBlTZVabOWOYbWH48T8PDo7KOVZhNERV3tQbq2y8Arzkpsj8i6dmWOcXJ4q
        ZPV7+X7Dsqj/yIKCHDeO2BpXXcm3LAZNYmrjXUWaamkLJH+5lrSWQ/lzYqrTkCKo
        3s7+g1BDAb3UMiRnjyCw9ERziw1kAcCNZQ1obq+abgtF7c+miQe7itSb358Ixsul
        5QCuCYZ8H6wi7LLN491DS/CN1EnljU6ok/M1wiZi5OhKKPC1dkTBfgvxF5l/mX63
        GqQ+L51JDHSzrE7/OqsbNDLtSN8pK5j4U+Q6HspYTXHe9ZW/lhZerR3iadj1AQDw
        ==
X-ME-Sender: <xms:bZmzYLeK7S6rWE884yqc3XfoKnZ3UrLZBjpkvnac0NCXjMRB2s9noA>
    <xme:bZmzYBOWbkDee2cvTagpZ9ev2TTomEukM-5GbcE07r14RJBXIJV2Qy3WTZ2T-5MsO
    LvRpdDif8YXZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:bZmzYEhQz5RlbrcfcO9o1eioRPvndmi67TJkTyokGOJvRDACS3W9GQ>
    <xmx:bZmzYM9KqVWW7njBmOmgzuxK5ZSl1__cdfos8i8qLljFiVzWOZg1Lw>
    <xmx:bZmzYHuYYkdbaoPlm7E0HHXTzfxNJ9EdiccS1zWyIuJZOHHzGUTsPA>
    <xmx:bZmzYAVBi6w0c25J66uUMqRcILoBOAoVIb960hY6wD-ezZ6HHTYh9w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 09:55:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net/mlx5: Fix err prints and return when creating termination" failed to apply to 5.10-stable tree
To:     roid@nvidia.com, maord@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 15:55:53 +0200
Message-ID: <1622382953201246@kroah.com>
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

