Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0CD3A588A
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhFMM5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:57:31 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:37235 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231649AbhFMM5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:57:31 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id B046D1940A0F;
        Sun, 13 Jun 2021 08:55:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 13 Jun 2021 08:55:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=sozmLl
        Cr41ZyYOVM3l5ZItYKqHDrf0vXLnA/OP0KNlE=; b=k1iuN2zfpMuwXx1cMHf9R5
        1cHcB0aUt2yHGi1JpzC1LqYaA3N08/r2bheNoir/YrnKggOrzZuo2wkyxlYljoKT
        DwbQt0yj6S+QXh1I88W8LYjWvyLx3tazyvdnskGy3uU3u1orcB/Yq20dVuqRFJ2c
        IJ6boCBziod9sKPCXLi3/jlNJ6sX2pDUAaMm1Ukwl0plEjVlHFrd96gVQVnTXm1b
        e/lVlvKxZPSmRFR5RqOjIPknzmIr7ynw2GchvVwvNMWpz3KMU2/6KJRWgucmqiA8
        exgdlblEuDBlbeDejXaTHPceDK9qoDf3AspnkrewQiIe0osN5zU24pXJJsNMo9oQ
        ==
X-ME-Sender: <xms:QQDGYCqHSAxDI5w5ritZunh89l5jAmsPJCpy6U93_qTTEfEiUphTjg>
    <xme:QQDGYApl_7LSVJiPs-ToeRfKudsnhBuPl2or5ctT3Vhpl0O4xbpNfFQLo2uruKheL
    Zkf1IZAZsUyQQ>
X-ME-Received: <xmr:QQDGYHNZHXTTUrXx8KW__p1dyjKaLY02QMZVOIG4_oDQQgzhv53d2Iw2OIlrJz8VzaqG5JtbjYSnwR2OJp3RevtDYmLdfs8W>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:QQDGYB7Uw0Mz2heOQL_y2VAJ-LGnFhjdEyDUOO6XlD1wICPCiG4J4A>
    <xmx:QQDGYB4J4JZXnWF62Zdfezx7agcAZWLkBj7bKAl1nNe1z7tH0sRgjA>
    <xmx:QQDGYBhyI3KSmdOk8t85gGysCx9cbzQ_0Ld2ySjIMqiDWAHIktkTdA>
    <xmx:QQDGYBHcq0jDyDsMLUf92nViH7RFS7TAN2OzC3aVUwS7VIUbe1Jjsg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:55:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/mlx4: Do not map the core_clock page to user space" failed to apply to 4.14-stable tree
To:     shayd@nvidia.com, jgg@nvidia.com, leonro@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:55:17 +0200
Message-ID: <1623588917100168@kroah.com>
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

From 404e5a12691fe797486475fe28cc0b80cb8bef2c Mon Sep 17 00:00:00 2001
From: Shay Drory <shayd@nvidia.com>
Date: Thu, 3 Jun 2021 16:19:39 +0300
Subject: [PATCH] RDMA/mlx4: Do not map the core_clock page to user space
 unless enabled

Currently when mlx4 maps the hca_core_clock page to the user space there
are read-modifiable registers, one of which is semaphore, on this page as
well as the clock counter. If user reads the wrong offset, it can modify
the semaphore and hang the device.

Do not map the hca_core_clock page to the user space unless the device has
been put in a backwards compatibility mode to support this feature.

After this patch, mlx4 core_clock won't be mapped to user space on the
majority of existing devices and the uverbs device time feature in
ibv_query_rt_values_ex() will be disabled.

Fixes: 52033cfb5aab ("IB/mlx4: Add mmap call to map the hardware clock")
Link: https://lore.kernel.org/r/9632304e0d6790af84b3b706d8c18732bc0d5e27.1622726305.git.leonro@nvidia.com
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 22898d97ecbd..16704262fc3a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -581,12 +581,9 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	props->cq_caps.max_cq_moderation_count = MLX4_MAX_CQ_COUNT;
 	props->cq_caps.max_cq_moderation_period = MLX4_MAX_CQ_PERIOD;
 
-	if (!mlx4_is_slave(dev->dev))
-		err = mlx4_get_internal_clock_params(dev->dev, &clock_params);
-
 	if (uhw->outlen >= resp.response_length + sizeof(resp.hca_core_clock_offset)) {
 		resp.response_length += sizeof(resp.hca_core_clock_offset);
-		if (!err && !mlx4_is_slave(dev->dev)) {
+		if (!mlx4_get_internal_clock_params(dev->dev, &clock_params)) {
 			resp.comp_mask |= MLX4_IB_QUERY_DEV_RESP_MASK_CORE_CLOCK_OFFSET;
 			resp.hca_core_clock_offset = clock_params.offset % PAGE_SIZE;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index f6cfec81ccc3..dc4ac1a2b6b6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -823,6 +823,7 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 #define QUERY_DEV_CAP_MAD_DEMUX_OFFSET		0xb0
 #define QUERY_DEV_CAP_DMFS_HIGH_RATE_QPN_BASE_OFFSET	0xa8
 #define QUERY_DEV_CAP_DMFS_HIGH_RATE_QPN_RANGE_OFFSET	0xac
+#define QUERY_DEV_CAP_MAP_CLOCK_TO_USER 0xc1
 #define QUERY_DEV_CAP_QP_RATE_LIMIT_NUM_OFFSET	0xcc
 #define QUERY_DEV_CAP_QP_RATE_LIMIT_MAX_OFFSET	0xd0
 #define QUERY_DEV_CAP_QP_RATE_LIMIT_MIN_OFFSET	0xd2
@@ -841,6 +842,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 
 	if (mlx4_is_mfunc(dev))
 		disable_unsupported_roce_caps(outbox);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAP_CLOCK_TO_USER);
+	dev_cap->map_clock_to_user = field & 0x80;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_QP_OFFSET);
 	dev_cap->reserved_qps = 1 << (field & 0xf);
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_QP_OFFSET);
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.h b/drivers/net/ethernet/mellanox/mlx4/fw.h
index 8f020f26ebf5..cf64e54eecb0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.h
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.h
@@ -131,6 +131,7 @@ struct mlx4_dev_cap {
 	u32 health_buffer_addrs;
 	struct mlx4_port_cap port_cap[MLX4_MAX_PORTS + 1];
 	bool wol_port[MLX4_MAX_PORTS + 1];
+	bool map_clock_to_user;
 };
 
 struct mlx4_func_cap {
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index c326b434734e..00c84656b2e7 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -498,6 +498,7 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		}
 	}
 
+	dev->caps.map_clock_to_user  = dev_cap->map_clock_to_user;
 	dev->caps.uar_page_size	     = PAGE_SIZE;
 	dev->caps.num_uars	     = dev_cap->uar_size / PAGE_SIZE;
 	dev->caps.local_ca_ack_delay = dev_cap->local_ca_ack_delay;
@@ -1948,6 +1949,11 @@ int mlx4_get_internal_clock_params(struct mlx4_dev *dev,
 	if (mlx4_is_slave(dev))
 		return -EOPNOTSUPP;
 
+	if (!dev->caps.map_clock_to_user) {
+		mlx4_dbg(dev, "Map clock to user is not supported.\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (!params)
 		return -EINVAL;
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 236a7d04f891..30bb59fe970c 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -630,6 +630,7 @@ struct mlx4_caps {
 	bool			wol_port[MLX4_MAX_PORTS + 1];
 	struct mlx4_rate_limit_caps rl_caps;
 	u32			health_buffer_addrs;
+	bool			map_clock_to_user;
 };
 
 struct mlx4_buf_list {

