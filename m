Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C92C3A5888
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhFMM5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:57:21 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:45185 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231667AbhFMM5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:57:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0D7491940A0C;
        Sun, 13 Jun 2021 08:55:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 13 Jun 2021 08:55:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BqgnfS
        1Ii6QXr+cNsJOs7q9eefbD11kPGqMfxFxpbII=; b=O4bcyHBcU6e0ZZHtiAgB9v
        FHWlStTVHaJaFINH7k3cnKrI1l9AK0NGZpLjYqVplXpWPihV7VSuBR+PryX/B5qk
        GXlDafrlAoxE7iuanm5DfmgogJF9uXYUiSsRGKvjOhS5cT8dxh6Vgiokzlif/KsZ
        v6Gm1KiGqZD5NXpJFZBvxFZvU4XV7KSEDyeNYO4z4pHLapDhyuXweGGTMN3gTk1q
        ZuiHPVPJ5AsDQzzIE9DggfVgMi3Borv7rJd7JgcuzSkJJ226t8cDQKDAkryeah41
        Jf4JhiFU1jdMGl57xiu/Gtct2qdsx+ovIiAoZ7gmVEGFBjV/nTnPA1nVFr5yESHA
        ==
X-ME-Sender: <xms:NgDGYF54vab7TGYptzhoOHBydxdBAp1EPyFLBmzEzXMW1NHBGCEuUA>
    <xme:NgDGYC7QbvtMuLwqyQpsH63_5dVFQlXhO2ZTKDTWNkHaNCxZTrwnM_hqghMr-8EkB
    sOXHZMdTMci5w>
X-ME-Received: <xmr:NgDGYMdPAGNtZ5wrnjPuIh9D0TXisQ09ARBcp6U_4EqMcZj8rcr-ZrBcEX6TBhZh87vMj-SKlNwvbBoNaYVowI_wgEOz1DuN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:NgDGYOItJtHcXBfgo2elXHVB2v3gi91CaTFdpeyaU8vqVw8yaja72w>
    <xmx:NgDGYJJZFt8ZbqrSBsnuCOth2Jp5MCWvT6H_sTvFnGb_IRwuWD2D9w>
    <xmx:NgDGYHzre8Dh8fHFqwa4Xrn7KveR9TOnOBwkAXM64Ws6LFm7O5dOaw>
    <xmx:NgDGYAVHaAB_oTKDZ9E8QJCK0b1HlAc_IAdYpp8FHiZm2Iv7HKh-tA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:55:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/mlx4: Do not map the core_clock page to user space" failed to apply to 4.4-stable tree
To:     shayd@nvidia.com, jgg@nvidia.com, leonro@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:55:15 +0200
Message-ID: <1623588915240146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

