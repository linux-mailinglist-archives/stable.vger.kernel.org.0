Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4453A39511B
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 15:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhE3Nzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 09:55:46 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:56693 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3Nzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 09:55:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id B5574194051F;
        Sun, 30 May 2021 09:54:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 May 2021 09:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BdTeil
        rKWiKs9qtDFFR+1+fq8fp5a8Fk+wrwlkwhqNg=; b=ITpbtGu7PM9YjNCF2qKGoO
        GdnRfr4eTHeduKg+q/FyV2hGFp6irXz2ogRrTqe0SAIbYqTQ7+hBs2iDEYzFUOWX
        iZSxhCan29+PTzGYE5SzrUVnVDBmof5WMkFPMrdrEIcY0sCxa1awf1w3pYhTzwIR
        hpuK2reR6C/kJD7OvvFek9yBVPqkvBnpcZSfhKjrCb3UaMhTtaUIZrlSwddSvwTl
        GPOtyHBG2ytM0lr/ORNXdlimL43Z8gkTKFlukWTKh4BUGo3e9Xf7a5u0M3aW4rk1
        9sBYjkG4mzaR0s0y8rdO6o7V302eB+LnBalcsF0cFiuPvCwNQc5TR6pGd3zG0clg
        ==
X-ME-Sender: <xms:_pizYKoGBAAdENtI9MlIS7ZEYIYNVr8AVwr1hZEJ9HpxFa60bPb2rA>
    <xme:_pizYIquYXj5-6HtWXqrP-jD-ZE72ZK2FoYW8qJqHGF1JLk1V79bwkuwDCn5V_Uq7
    MWMN5ePYwZzhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_pizYPOk_46i4phMgJQU_pfQG7xXycsJDwl6o_PLgFPTDa03IEpi3g>
    <xmx:_pizYJ758p-WMZawGyhcfmgujdvXDrvkCG4H1maCGer1vrH6If4ARA>
    <xmx:_pizYJ4ApMTj3XVJ76n4kCmJGAol9PVqQhl_ocCI9qbkXWFr04bQnA>
    <xmx:_pizYLRaiNitJH7tfG0b7GR0UA9quKBKGpL_aW6OAa_fWQ8D18k-7w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 09:54:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net/mlx5e: Fix nullptr in mlx5e_tc_add_fdb_flow()" failed to apply to 4.19-stable tree
To:     dchumak@nvidia.com, saeedm@nvidia.com, vladbu@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 15:53:55 +0200
Message-ID: <162238283575122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fe7738eb3ca3631a75844e790f6cb576c0fe7b00 Mon Sep 17 00:00:00 2001
From: Dima Chumak <dchumak@nvidia.com>
Date: Mon, 26 Apr 2021 15:16:26 +0300
Subject: [PATCH] net/mlx5e: Fix nullptr in mlx5e_tc_add_fdb_flow()

The result of __dev_get_by_index() is not checked for NULL, which then
passed to mlx5e_attach_encap() and gets dereferenced.

Also, in case of a successful lookup, the net_device reference count is
not incremented, which may result in net_device pointer becoming invalid
at any time during mlx5e_attach_encap() execution.

Fix by using dev_get_by_index(), which does proper reference counting on
the net_device pointer. Also, handle nullptr return value when mirred
device is not found.

It's safe to call dev_put() on the mirred net_device pointer, right
after mlx5e_attach_encap() call, because it's not being saved/copied
down the call chain.

Fixes: 3c37745ec614 ("net/mlx5e: Properly deal with encap flows add/del under neigh update")
Addresses-Coverity: ("Dereference null return value")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 46945d04b5b8..882bafba43f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1322,10 +1322,10 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 		      struct netlink_ext_ack *extack)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct net_device *out_dev, *encap_dev = NULL;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	bool vf_tun = false, encap_valid = true;
+	struct net_device *encap_dev = NULL;
 	struct mlx5_esw_flow_attr *esw_attr;
 	struct mlx5_fc *counter = NULL;
 	struct mlx5e_rep_priv *rpriv;
@@ -1371,16 +1371,22 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	esw_attr = attr->esw_attr;
 
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
+		struct net_device *out_dev;
 		int mirred_ifindex;
 
 		if (!(esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP))
 			continue;
 
 		mirred_ifindex = parse_attr->mirred_ifindex[out_index];
-		out_dev = __dev_get_by_index(dev_net(priv->netdev),
-					     mirred_ifindex);
+		out_dev = dev_get_by_index(dev_net(priv->netdev), mirred_ifindex);
+		if (!out_dev) {
+			NL_SET_ERR_MSG_MOD(extack, "Requested mirred device not found");
+			err = -ENODEV;
+			goto err_out;
+		}
 		err = mlx5e_attach_encap(priv, flow, out_dev, out_index,
 					 extack, &encap_dev, &encap_valid);
+		dev_put(out_dev);
 		if (err)
 			goto err_out;
 

