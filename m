Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFC43A588E
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhFMM6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:58:11 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:43747 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231761AbhFMM6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:58:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id A05151940909;
        Sun, 13 Jun 2021 08:56:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 13 Jun 2021 08:56:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=L6esxJ
        2e10b6q3xdxz3/IbVIvlQXVZvq9Vi3s2MYNe0=; b=HzORxc/VGvAqMWFD1T+uuJ
        b4ztXArg5hxglk8wxJLuR2y967LIisiCq17IvsDiu9vGVy5heYiOLy2xpleVNxKq
        hAGDzj+pt7dWet2CcDrnYfGrLkulXhJNCk4UEXgwo9ar/+cMHnRsDjznXqpk0AZP
        eVOf3iIbqj/IWVjNSfnk8B9dCKAZxI2m6TDLIFO7XN2zoI3G0iexVdoOufwRVYWu
        47E+RVRDoo+L22Ufc7X/CB7yHoY/OOEE9ZdqnkJ4czw1x2BdGRizIr8+11ItYFDt
        lY6kyIQKKd6cHVOJrAvDLi5nSs4l1BDhlYO6A2bn62E562SYr0Tn5//WhVOGd34w
        ==
X-ME-Sender: <xms:aQDGYICh143i56U8Tn-NrA1gUMHNDsrkfzIQ7m12emO3bHRYLF7leQ>
    <xme:aQDGYKjf3kks5uJ0MIlCdt2QqviLSRBIYrL1gXTqHnDfuvhdyOyg5Marru4Aqmv4H
    nnJB2guKGBu6A>
X-ME-Received: <xmr:aQDGYLmCFoeiEpGoo0iQIbdFEyv1K_42hAJ73JTgbesxLQg8c30rFvKJQYXlZX3bFu2hEtt6CwynkhPa5YpMseTwPFiiiCt2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:aQDGYOxKd_Mb5eglouDpxdM-N8pFdEKfJTTO1MY3w5vKmI-HFRyVyA>
    <xmx:aQDGYNSy7syTgjl10qJEfCeWXgz7u70YpMnu-C5ZR4oeduX6JugVjQ>
    <xmx:aQDGYJY4o-qXg8EIUxRdQpe9xnGNdlg8A2K3OJoQymGy9el-ECLhKg>
    <xmx:aQDGYPfahdwRwFt3ZPXLLiiwBc06anBKHu4EbArispIGfOgN6RJ4UQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:56:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA: Verify port when creating flow rule" failed to apply to 4.14-stable tree
To:     maorg@nvidia.com, jgg@nvidia.com, leonro@nvidia.com,
        markb@mellanox.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:56:03 +0200
Message-ID: <16235889632183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 2adcb4c5a52a2623cd2b43efa7041e74d19f3a5e Mon Sep 17 00:00:00 2001
From: Maor Gottlieb <maorg@nvidia.com>
Date: Thu, 10 Jun 2021 10:34:25 +0300
Subject: [PATCH] RDMA: Verify port when creating flow rule

Validate port value provided by the user and with that remove no longer
needed validation by the driver.  The missing check in the mlx5_ib driver
could cause to the below oops.

Call trace:
  _create_flow_rule+0x2d4/0xf28 [mlx5_ib]
  mlx5_ib_create_flow+0x2d0/0x5b0 [mlx5_ib]
  ib_uverbs_ex_create_flow+0x4cc/0x624 [ib_uverbs]
  ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0xd4/0x150 [ib_uverbs]
  ib_uverbs_cmd_verbs.isra.7+0xb28/0xc50 [ib_uverbs]
  ib_uverbs_ioctl+0x158/0x1d0 [ib_uverbs]
  do_vfs_ioctl+0xd0/0xaf0
  ksys_ioctl+0x84/0xb4
  __arm64_sys_ioctl+0x28/0xc4
  el0_svc_common.constprop.3+0xa4/0x254
  el0_svc_handler+0x84/0xa0
  el0_svc+0x10/0x26c
 Code: b9401260 f9615681 51000400 8b001c20 (f9403c1a)

Fixes: 436f2ad05a0b ("IB/core: Export ib_create/destroy_flow through uverbs")
Link: https://lore.kernel.org/r/faad30dc5219a01727f47db3dc2f029d07c82c00.1623309971.git.leonro@nvidia.com
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index d5e15a8c870d..64e4be1cbec7 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3248,6 +3248,11 @@ static int ib_uverbs_ex_create_flow(struct uverbs_attr_bundle *attrs)
 		goto err_free_attr;
 	}
 
+	if (!rdma_is_port_valid(uobj->context->device, cmd.flow_attr.port)) {
+		err = -EINVAL;
+		goto err_uobj;
+	}
+
 	qp = uobj_get_obj_read(qp, UVERBS_OBJECT_QP, cmd.qp_handle, attrs);
 	if (!qp) {
 		err = -EINVAL;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 16704262fc3a..230a6ae0ab5a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1699,9 +1699,6 @@ static struct ib_flow *mlx4_ib_create_flow(struct ib_qp *qp,
 	struct mlx4_dev *dev = (to_mdev(qp->device))->dev;
 	int is_bonded = mlx4_is_bonded(dev);
 
-	if (!rdma_is_port_valid(qp->device, flow_attr->port))
-		return ERR_PTR(-EINVAL);
-
 	if (flow_attr->flags & ~IB_FLOW_ATTR_FLAGS_DONT_TRAP)
 		return ERR_PTR(-EOPNOTSUPP);
 
diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index f84441ff0c81..18ee2f293825 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -1194,9 +1194,8 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 		goto free_ucmd;
 	}
 
-	if (flow_attr->port > dev->num_ports ||
-	    (flow_attr->flags &
-	     ~(IB_FLOW_ATTR_FLAGS_DONT_TRAP | IB_FLOW_ATTR_FLAGS_EGRESS))) {
+	if (flow_attr->flags &
+	    ~(IB_FLOW_ATTR_FLAGS_DONT_TRAP | IB_FLOW_ATTR_FLAGS_EGRESS)) {
 		err = -EINVAL;
 		goto free_ucmd;
 	}

