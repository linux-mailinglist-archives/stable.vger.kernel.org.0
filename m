Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3E93A588D
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhFMM6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:58:10 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:55279 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231649AbhFMM6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:58:09 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9DF421940992;
        Sun, 13 Jun 2021 08:56:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 13 Jun 2021 08:56:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3ZHELQ
        tD6/Ca2GrY0RTJaBTqAh3OUJOaj4D+3AVU4C0=; b=ph8XrsZwCH6QYpwTd8gA75
        EyOl/Lch517dLZUvjyEscPiSZ0LwwqX/bFDiEAgPttGQ8XzUp4QrGIBTCghFDZtj
        QuT+Wg7g1o3yelraaeuHGzmKS3Unyt4l7p0Wff9c2GIdX7/yOEOECfKpOZY7QHKZ
        YkhRH64vozz1OLSzW9YlVlwOk1hfCX8QEjO66fIOvNOvm6DUc+i5RT6SrABbC+ZQ
        0Jp9m7x1YzKEAMm9LFUJrtW2wMJF6eKPojKZ4a9xoh69eYSVVGBTeMIw9Qafna7b
        jxcH7m/Uz+xuqcMxGZolcMxP4UYip+nslWQKd6ER0cD5tg8t0UDJQEDhlT7YkPHA
        ==
X-ME-Sender: <xms:ZwDGYFiD47oWWz2dzLGlD3eKjIlmeFp_bqjSC8rmi04WCKhSYS9sPg>
    <xme:ZwDGYKAY9qcFCJVi3mrLwq-PezrlHBybQiV25X3cJAJFMELYWoeB9k08qy-lwgMzs
    jMRBLLrxyj9vw>
X-ME-Received: <xmr:ZwDGYFGUyAgXoAWzWpmbuDhRhXrRE5Kl8O1KWJDqmM0YzGGhIIEkIRX4vg0S__iuIjd_mPN8ybRtDU1dUO5418MtuyX0bQZ2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:ZwDGYKRYNzDgs5acoaEj4YkX02NXHn9Gxiu8xkBMdKmB3cnUsGpsaQ>
    <xmx:ZwDGYCzap2x6SDHtElST9zO9mI_1GrK42tvHp2P8RclS9wlf7yfAqg>
    <xmx:ZwDGYA4J8toSoiwuKb0wtfGvikrhwnaTZhMwqpJJEk3CFJy2Jc_FZQ>
    <xmx:ZwDGYG9CgXN8D9lw8O4VwZ0VajLjh3L4QPanABPtkqyv1Y3Mm7CuPQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:56:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA: Verify port when creating flow rule" failed to apply to 4.9-stable tree
To:     maorg@nvidia.com, jgg@nvidia.com, leonro@nvidia.com,
        markb@mellanox.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:56:02 +0200
Message-ID: <1623588962100208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

