Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115D539511E
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 15:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhE3N5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 09:57:11 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:39755 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3N5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 09:57:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2B5D2194070E;
        Sun, 30 May 2021 09:55:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 30 May 2021 09:55:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Tu4M7l
        0EZKY8nC91odcjVab59aakLRNeneTE17pFoE0=; b=Ej4zWC7Ct2R1TMKW+NPvnO
        CPjmyGE3Fwm3EEB0g43FS0NrO3buOLw74Oi8FEYtkzLQhk9bGr8qfcPesqwedTuz
        Es0ZZuW+M0QrvSnU023PPFe3hjG2EMHd1VGDw8kiLakq6L5h0LPdU6eKo4Vz/ukE
        wZVIDbjMwN8l9dHjyZ30HwDuuuB+gkusfBJNDMevl/Ksi4PW4WpLGq9cpZq5JzO9
        fvUBAQZM8B/IT18jRo5hx+nNUYx2qtRoCxKHmVSBdDri2t8g1qalfet/dxhnhjFp
        p/9fXfxwT8xTT66i5Xi4oa1nMWrRIrRD0k7me/8xa9P/utNGtjdfQd6KNc/xgocw
        ==
X-ME-Sender: <xms:VZmzYKhSnZmNEUTGA8nXMc_7aJNmz24N8uoiopz4aw0o7d1jx5n7ZQ>
    <xme:VZmzYLA9FetiInpfkIm69cmHP8L1mqKMU_dw7XujrY0zY1mYy5_khAwdB_vqhLH-T
    H3rN-1ZVV403Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:VZmzYCG8F6Mp8FyCcVH_sM7TF2JpgQF2eaVeUMqBqCaRGekGlR0yvw>
    <xmx:VZmzYDQscBXD5u-O7a-VCdcAD2bamLBdFnn4i5PNV3SpCUd2zb6YWQ>
    <xmx:VZmzYHxOrfxrDyFWXNgD_Sk2hpNt20-5F0fJi7woPchx5F-5aTApgA>
    <xmx:VZmzYAoKxTkTFQ_r0JR4e3CKoUCB1BP6sr7zb5xLHlZvYb_jaOwgCA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 09:55:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] {net, RDMA}/mlx5: Fix override of log_max_qp by other device" failed to apply to 4.4-stable tree
To:     maorg@nvidia.com, mbloch@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 15:55:30 +0200
Message-ID: <1622382930198237@kroah.com>
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

From 3410fbcd47dc6479af4309febf760ccaa5efb472 Mon Sep 17 00:00:00 2001
From: Maor Gottlieb <maorg@nvidia.com>
Date: Wed, 12 May 2021 13:52:27 +0300
Subject: [PATCH] {net, RDMA}/mlx5: Fix override of log_max_qp by other device

mlx5_core_dev holds pointer to static profile, hence when the
log_max_qp of the profile is override by some device, then it
effect all other mlx5 devices that share the same profile.
Fix it by having a profile instance for every mlx5 device.

Fixes: 883371c453b9 ("net/mlx5: Check FW limitations on log_max_qp before setting it")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 4388afeff251..9662cd39c7ff 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -743,10 +743,10 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 		ent->xlt = (1 << ent->order) * sizeof(struct mlx5_mtt) /
 			   MLX5_IB_UMR_OCTOWORD;
 		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
-		if ((dev->mdev->profile->mask & MLX5_PROF_MASK_MR_CACHE) &&
+		if ((dev->mdev->profile.mask & MLX5_PROF_MASK_MR_CACHE) &&
 		    !dev->is_rep && mlx5_core_is_pf(dev->mdev) &&
 		    mlx5_ib_can_load_pas_with_umr(dev, 0))
-			ent->limit = dev->mdev->profile->mr_cache[i].limit;
+			ent->limit = dev->mdev->profile.mr_cache[i].limit;
 		else
 			ent->limit = 0;
 		spin_lock_irq(&ent->lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c114365eb126..a1d67bd7fb43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -503,7 +503,7 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev, void *set_ctx)
 
 static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 {
-	struct mlx5_profile *prof = dev->profile;
+	struct mlx5_profile *prof = &dev->profile;
 	void *set_hca_cap;
 	int err;
 
@@ -524,11 +524,11 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 		 to_fw_pkey_sz(dev, 128));
 
 	/* Check log_max_qp from HCA caps to set in current profile */
-	if (MLX5_CAP_GEN_MAX(dev, log_max_qp) < profile[prof_sel].log_max_qp) {
+	if (MLX5_CAP_GEN_MAX(dev, log_max_qp) < prof->log_max_qp) {
 		mlx5_core_warn(dev, "log_max_qp value in current profile is %d, changing it to HCA capability limit (%d)\n",
-			       profile[prof_sel].log_max_qp,
+			       prof->log_max_qp,
 			       MLX5_CAP_GEN_MAX(dev, log_max_qp));
-		profile[prof_sel].log_max_qp = MLX5_CAP_GEN_MAX(dev, log_max_qp);
+		prof->log_max_qp = MLX5_CAP_GEN_MAX(dev, log_max_qp);
 	}
 	if (prof->mask & MLX5_PROF_MASK_QP_SIZE)
 		MLX5_SET(cmd_hca_cap, set_hca_cap, log_max_qp,
@@ -1381,8 +1381,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	struct mlx5_priv *priv = &dev->priv;
 	int err;
 
-	dev->profile = &profile[profile_idx];
-
+	memcpy(&dev->profile, &profile[profile_idx], sizeof(dev->profile));
 	INIT_LIST_HEAD(&priv->ctx_list);
 	spin_lock_init(&priv->ctx_lock);
 	mutex_init(&dev->intf_state_mutex);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f8e8d7e90616..020a8f7fdbdd 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -703,6 +703,27 @@ struct mlx5_hv_vhca;
 #define MLX5_LOG_SW_ICM_BLOCK_SIZE(dev) (MLX5_CAP_DEV_MEM(dev, log_sw_icm_alloc_granularity))
 #define MLX5_SW_ICM_BLOCK_SIZE(dev) (1 << MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))
 
+enum {
+	MLX5_PROF_MASK_QP_SIZE		= (u64)1 << 0,
+	MLX5_PROF_MASK_MR_CACHE		= (u64)1 << 1,
+};
+
+enum {
+	MR_CACHE_LAST_STD_ENTRY = 20,
+	MLX5_IMR_MTT_CACHE_ENTRY,
+	MLX5_IMR_KSM_CACHE_ENTRY,
+	MAX_MR_CACHE_ENTRIES
+};
+
+struct mlx5_profile {
+	u64	mask;
+	u8	log_max_qp;
+	struct {
+		int	size;
+		int	limit;
+	} mr_cache[MAX_MR_CACHE_ENTRIES];
+};
+
 struct mlx5_core_dev {
 	struct device *device;
 	enum mlx5_coredev_type coredev_type;
@@ -731,7 +752,7 @@ struct mlx5_core_dev {
 	struct mutex		intf_state_mutex;
 	unsigned long		intf_state;
 	struct mlx5_priv	priv;
-	struct mlx5_profile	*profile;
+	struct mlx5_profile	profile;
 	u32			issi;
 	struct mlx5e_resources  mlx5e_res;
 	struct mlx5_dm          *dm;
@@ -1083,18 +1104,6 @@ static inline u8 mlx5_mkey_variant(u32 mkey)
 	return mkey & 0xff;
 }
 
-enum {
-	MLX5_PROF_MASK_QP_SIZE		= (u64)1 << 0,
-	MLX5_PROF_MASK_MR_CACHE		= (u64)1 << 1,
-};
-
-enum {
-	MR_CACHE_LAST_STD_ENTRY = 20,
-	MLX5_IMR_MTT_CACHE_ENTRY,
-	MLX5_IMR_KSM_CACHE_ENTRY,
-	MAX_MR_CACHE_ENTRIES
-};
-
 /* Async-atomic event notifier used by mlx5 core to forward FW
  * evetns recived from event queue to mlx5 consumers.
  * Optimise event queue dipatching.
@@ -1148,15 +1157,6 @@ int mlx5_rdma_rn_get_params(struct mlx5_core_dev *mdev,
 			    struct ib_device *device,
 			    struct rdma_netdev_alloc_params *params);
 
-struct mlx5_profile {
-	u64	mask;
-	u8	log_max_qp;
-	struct {
-		int	size;
-		int	limit;
-	} mr_cache[MAX_MR_CACHE_ENTRIES];
-};
-
 enum {
 	MLX5_PCI_DEV_IS_VF		= 1 << 0,
 };

