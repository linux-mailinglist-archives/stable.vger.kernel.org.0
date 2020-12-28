Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1BA72E356A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgL1JVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:21:23 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:44423 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbgL1JVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:21:23 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id A02487A3;
        Mon, 28 Dec 2020 04:20:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:20:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=I/BXK+
        +E1G9q4IXfgKCljgWi6UWozA5sT5d3jfD1uyw=; b=oU/9/blH1jSJuZLL8eJVfz
        Nj00ZIZCcIC9IYuMVBmcaZ+Yfru9EVyeGMVrKcYU1OH+xhbBFid/kB4HYEk4d+yk
        VKWSbElVQDdrJMIXiuF+IPhhnrICwvuMfMVccHtqV+XnTx6Ql4udcLMPcH/znVge
        JzqYPC98XHEKK1Y1sEpZ3B9S3s3pVAYXIMP/obzALJebZtc99Pzu+3d7gn6n6jEh
        godk6HXFmBkq5kdwP1WgxgGKYAvX8UMnUKsQ4eP4tA9UBcFpxGAP0UoehXJE7XZl
        gahwxFKLnpuAi55J91HXYgSSyrEnXYHBR0w5lVK0OiqvNldHxbMBR+Mq9F6Xtztw
        ==
X-ME-Sender: <xms:YKPpXz5GTMm1K_TlpTu7E6hyaYi771OomyPMVzeANRwX4TuSCeoiHw>
    <xme:YKPpX464swkM4ChZ10IWqiMhfhGAnlh9WmcYCXFGeVoojZj10tjzfs3UrruLCP5w4
    Ga9d3_SLIl-XQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:YKPpX6eAnde4wdgLEKxSq4OLaYWKstXGO5HkgMEiAPJBfLwkr3rDFA>
    <xmx:YKPpX0I9fQD9cBGlFe0hJ2B3WvkNg3kOHSwlKMAugMDkgUXCaO1KfQ>
    <xmx:YKPpX3IleKvNdHeTNeQdIB0iJgrTIz8FTQfuHz_xuLAq5zOH9MeELw>
    <xmx:YKPpX9juEc2NHxdGgxUUwPo-ANSlhEtBZnT7I1eRJA5LtPxAxUGOkxWutaM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CC49F240057;
        Mon, 28 Dec 2020 04:20:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] RDMA/mlx5: Assign dev to DM MR" failed to apply to 4.19-stable tree
To:     maorg@nvidia.com, jgg@nvidia.com, leonro@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:21:46 +0100
Message-ID: <16091473061799@kroah.com>
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

From ca991a7d14d4835b302bcd182fdbf54470f45520 Mon Sep 17 00:00:00 2001
From: Maor Gottlieb <maorg@nvidia.com>
Date: Thu, 3 Dec 2020 21:08:07 +0200
Subject: [PATCH] RDMA/mlx5: Assign dev to DM MR

Currently, DM MR registration flow doesn't set the mlx5_ib_dev pointer and
can cause a NULL pointer dereference if userspace dumps the MR via rdma
tool.

Assign the IB device together with the other fields and remove the
redundant reference of mlx5_ib_dev from mlx5_ib_mr.

Cc: stable@vger.kernel.org
Fixes: 6c29f57ea475 ("IB/mlx5: Device memory mr registration support")
Link: https://lore.kernel.org/r/20201203190807.127189-1-leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index fac495e7834e..c33d6fd64fb6 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -669,7 +669,6 @@ struct mlx5_ib_mr {
 	struct mlx5_shared_mr_info	*smr_info;
 	struct list_head	list;
 	struct mlx5_cache_ent  *cache_ent;
-	struct mlx5_ib_dev     *dev;
 	u32 out[MLX5_ST_SZ_DW(create_mkey_out)];
 	struct mlx5_core_sig_ctx    *sig;
 	void			*descs_alloc;
@@ -1107,6 +1106,11 @@ static inline struct mlx5_ib_dev *to_mdev(struct ib_device *ibdev)
 	return container_of(ibdev, struct mlx5_ib_dev, ib_dev);
 }
 
+static inline struct mlx5_ib_dev *mr_to_mdev(struct mlx5_ib_mr *mr)
+{
+	return to_mdev(mr->ibmr.device);
+}
+
 static inline struct mlx5_ib_dev *mlx5_udata_to_mdev(struct ib_udata *udata)
 {
 	struct mlx5_ib_ucontext *context = rdma_udata_to_drv_context(
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 281032d2827f..6fa869c30e3f 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -137,8 +137,8 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 {
 	struct mlx5_ib_mr *mr =
 		container_of(context, struct mlx5_ib_mr, cb_work);
-	struct mlx5_ib_dev *dev = mr->dev;
 	struct mlx5_cache_ent *ent = mr->cache_ent;
+	struct mlx5_ib_dev *dev = ent->dev;
 	unsigned long flags;
 
 	if (status) {
@@ -176,7 +176,6 @@ static struct mlx5_ib_mr *alloc_cache_mr(struct mlx5_cache_ent *ent, void *mkc)
 	if (!mr)
 		return NULL;
 	mr->cache_ent = ent;
-	mr->dev = ent->dev;
 
 	set_mkc_access_pd_addr_fields(mkc, 0, 0, ent->dev->umrc.pd);
 	MLX5_SET(mkc, mkc, free, 1);
@@ -931,6 +930,7 @@ static void set_mr_fields(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
 	mr->ibmr.lkey = mr->mmkey.key;
 	mr->ibmr.rkey = mr->mmkey.key;
 	mr->ibmr.length = length;
+	mr->ibmr.device = &dev->ib_dev;
 	mr->access_flags = access_flags;
 }
 
@@ -1062,7 +1062,7 @@ static void *mlx5_ib_create_xlt_wr(struct mlx5_ib_mr *mr,
 				   size_t nents, size_t ent_size,
 				   unsigned int flags)
 {
-	struct mlx5_ib_dev *dev = mr->dev;
+	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
 	struct device *ddev = &dev->mdev->pdev->dev;
 	dma_addr_t dma;
 	void *xlt;
@@ -1124,7 +1124,7 @@ static unsigned int xlt_wr_final_send_flags(unsigned int flags)
 int mlx5_ib_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 		       int page_shift, int flags)
 {
-	struct mlx5_ib_dev *dev = mr->dev;
+	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
 	struct device *ddev = &dev->mdev->pdev->dev;
 	void *xlt;
 	struct mlx5_umr_wr wr;
@@ -1203,7 +1203,7 @@ int mlx5_ib_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
  */
 static int mlx5_ib_update_mr_pas(struct mlx5_ib_mr *mr, unsigned int flags)
 {
-	struct mlx5_ib_dev *dev = mr->dev;
+	struct mlx5_ib_dev *dev = mr_to_mdev(mr);
 	struct device *ddev = &dev->mdev->pdev->dev;
 	struct ib_block_iter biter;
 	struct mlx5_mtt *cur_mtt;
@@ -1335,7 +1335,6 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 	}
 	mr->mmkey.type = MLX5_MKEY_MR;
 	mr->desc_size = sizeof(struct mlx5_mtt);
-	mr->dev = dev;
 	mr->umem = umem;
 	set_mr_fields(dev, mr, umem->length, access_flags);
 	kvfree(in);
@@ -1579,17 +1578,17 @@ int mlx5_mr_cache_invalidate(struct mlx5_ib_mr *mr)
 {
 	struct mlx5_umr_wr umrwr = {};
 
-	if (mr->dev->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+	if (mr_to_mdev(mr)->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		return 0;
 
 	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_DISABLE_MR |
 			      MLX5_IB_SEND_UMR_UPDATE_PD_ACCESS;
 	umrwr.wr.opcode = MLX5_IB_WR_UMR;
-	umrwr.pd = mr->dev->umrc.pd;
+	umrwr.pd = mr_to_mdev(mr)->umrc.pd;
 	umrwr.mkey = mr->mmkey.key;
 	umrwr.ignore_free_state = 1;
 
-	return mlx5_ib_post_send_wait(mr->dev, &umrwr);
+	return mlx5_ib_post_send_wait(mr_to_mdev(mr), &umrwr);
 }
 
 /*
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index f4a28a012187..aa2413b50adc 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -102,7 +102,7 @@ static void populate_klm(struct mlx5_klm *pklm, size_t idx, size_t nentries,
 	if (flags & MLX5_IB_UPD_XLT_ZAP) {
 		for (; pklm != end; pklm++, idx++) {
 			pklm->bcount = cpu_to_be32(MLX5_IMR_MTT_SIZE);
-			pklm->key = cpu_to_be32(imr->dev->null_mkey);
+			pklm->key = cpu_to_be32(mr_to_mdev(imr)->null_mkey);
 			pklm->va = 0;
 		}
 		return;
@@ -129,7 +129,7 @@ static void populate_klm(struct mlx5_klm *pklm, size_t idx, size_t nentries,
 	 * locking around the xarray.
 	 */
 	lockdep_assert_held(&to_ib_umem_odp(imr->umem)->umem_mutex);
-	lockdep_assert_held(&imr->dev->odp_srcu);
+	lockdep_assert_held(&mr_to_mdev(imr)->odp_srcu);
 
 	for (; pklm != end; pklm++, idx++) {
 		struct mlx5_ib_mr *mtt = xa_load(&imr->implicit_children, idx);
@@ -139,7 +139,7 @@ static void populate_klm(struct mlx5_klm *pklm, size_t idx, size_t nentries,
 			pklm->key = cpu_to_be32(mtt->ibmr.lkey);
 			pklm->va = cpu_to_be64(idx * MLX5_IMR_MTT_SIZE);
 		} else {
-			pklm->key = cpu_to_be32(imr->dev->null_mkey);
+			pklm->key = cpu_to_be32(mr_to_mdev(imr)->null_mkey);
 			pklm->va = 0;
 		}
 	}
@@ -199,7 +199,7 @@ static void dma_fence_odp_mr(struct mlx5_ib_mr *mr)
 	mutex_unlock(&odp->umem_mutex);
 
 	if (!mr->cache_ent) {
-		mlx5_core_destroy_mkey(mr->dev->mdev, &mr->mmkey);
+		mlx5_core_destroy_mkey(mr_to_mdev(mr)->mdev, &mr->mmkey);
 		WARN_ON(mr->descs);
 	}
 }
@@ -222,19 +222,19 @@ static void free_implicit_child_mr(struct mlx5_ib_mr *mr, bool need_imr_xlt)
 	WARN_ON(atomic_read(&mr->num_deferred_work));
 
 	if (need_imr_xlt) {
-		srcu_key = srcu_read_lock(&mr->dev->odp_srcu);
+		srcu_key = srcu_read_lock(&mr_to_mdev(mr)->odp_srcu);
 		mutex_lock(&odp_imr->umem_mutex);
 		mlx5_ib_update_xlt(mr->parent, idx, 1, 0,
 				   MLX5_IB_UPD_XLT_INDIRECT |
 				   MLX5_IB_UPD_XLT_ATOMIC);
 		mutex_unlock(&odp_imr->umem_mutex);
-		srcu_read_unlock(&mr->dev->odp_srcu, srcu_key);
+		srcu_read_unlock(&mr_to_mdev(mr)->odp_srcu, srcu_key);
 	}
 
 	dma_fence_odp_mr(mr);
 
 	mr->parent = NULL;
-	mlx5_mr_cache_free(mr->dev, mr);
+	mlx5_mr_cache_free(mr_to_mdev(mr), mr);
 	ib_umem_odp_release(odp);
 	if (atomic_dec_and_test(&imr->num_deferred_work))
 		wake_up(&imr->q_deferred_work);
@@ -274,7 +274,7 @@ static void destroy_unused_implicit_child_mr(struct mlx5_ib_mr *mr)
 		goto out_unlock;
 
 	atomic_inc(&imr->num_deferred_work);
-	call_srcu(&mr->dev->odp_srcu, &mr->odp_destroy.rcu,
+	call_srcu(&mr_to_mdev(mr)->odp_srcu, &mr->odp_destroy.rcu,
 		  free_implicit_child_mr_rcu);
 
 out_unlock:
@@ -476,12 +476,13 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 	if (IS_ERR(odp))
 		return ERR_CAST(odp);
 
-	ret = mr = mlx5_mr_cache_alloc(imr->dev, MLX5_IMR_MTT_CACHE_ENTRY,
-				       imr->access_flags);
+	ret = mr = mlx5_mr_cache_alloc(
+		mr_to_mdev(imr), MLX5_IMR_MTT_CACHE_ENTRY, imr->access_flags);
 	if (IS_ERR(mr))
 		goto out_umem;
 
 	mr->ibmr.pd = imr->ibmr.pd;
+	mr->ibmr.device = &mr_to_mdev(imr)->ib_dev;
 	mr->umem = &odp->umem;
 	mr->ibmr.lkey = mr->mmkey.key;
 	mr->ibmr.rkey = mr->mmkey.key;
@@ -517,11 +518,11 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 		goto out_mr;
 	}
 
-	mlx5_ib_dbg(imr->dev, "key %x mr %p\n", mr->mmkey.key, mr);
+	mlx5_ib_dbg(mr_to_mdev(imr), "key %x mr %p\n", mr->mmkey.key, mr);
 	return mr;
 
 out_mr:
-	mlx5_mr_cache_free(imr->dev, mr);
+	mlx5_mr_cache_free(mr_to_mdev(imr), mr);
 out_umem:
 	ib_umem_odp_release(odp);
 	return ret;
@@ -555,6 +556,7 @@ struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
 	imr->umem = &umem_odp->umem;
 	imr->ibmr.lkey = imr->mmkey.key;
 	imr->ibmr.rkey = imr->mmkey.key;
+	imr->ibmr.device = &dev->ib_dev;
 	imr->umem = &umem_odp->umem;
 	imr->is_odp_implicit = true;
 	atomic_set(&imr->num_deferred_work, 0);
@@ -588,7 +590,7 @@ struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
 void mlx5_ib_free_implicit_mr(struct mlx5_ib_mr *imr)
 {
 	struct ib_umem_odp *odp_imr = to_ib_umem_odp(imr->umem);
-	struct mlx5_ib_dev *dev = imr->dev;
+	struct mlx5_ib_dev *dev = mr_to_mdev(imr);
 	struct list_head destroy_list;
 	struct mlx5_ib_mr *mtt;
 	struct mlx5_ib_mr *tmp;
@@ -658,10 +660,10 @@ void mlx5_ib_free_implicit_mr(struct mlx5_ib_mr *imr)
 void mlx5_ib_fence_odp_mr(struct mlx5_ib_mr *mr)
 {
 	/* Prevent new page faults and prefetch requests from succeeding */
-	xa_erase(&mr->dev->odp_mkeys, mlx5_base_mkey(mr->mmkey.key));
+	xa_erase(&mr_to_mdev(mr)->odp_mkeys, mlx5_base_mkey(mr->mmkey.key));
 
 	/* Wait for all running page-fault handlers to finish. */
-	synchronize_srcu(&mr->dev->odp_srcu);
+	synchronize_srcu(&mr_to_mdev(mr)->odp_srcu);
 
 	wait_event(mr->q_deferred_work, !atomic_read(&mr->num_deferred_work));
 
@@ -705,7 +707,7 @@ static int pagefault_real_mr(struct mlx5_ib_mr *mr, struct ib_umem_odp *odp,
 
 	if (ret < 0) {
 		if (ret != -EAGAIN)
-			mlx5_ib_err(mr->dev,
+			mlx5_ib_err(mr_to_mdev(mr),
 				    "Failed to update mkey page tables\n");
 		goto out;
 	}
@@ -795,7 +797,7 @@ static int pagefault_implicit_mr(struct mlx5_ib_mr *imr,
 					 MLX5_IB_UPD_XLT_ATOMIC);
 	mutex_unlock(&odp_imr->umem_mutex);
 	if (err) {
-		mlx5_ib_err(imr->dev, "Failed to update PAS\n");
+		mlx5_ib_err(mr_to_mdev(imr), "Failed to update PAS\n");
 		return err;
 	}
 	return ret;
@@ -815,7 +817,7 @@ static int pagefault_mr(struct mlx5_ib_mr *mr, u64 io_virt, size_t bcnt,
 {
 	struct ib_umem_odp *odp = to_ib_umem_odp(mr->umem);
 
-	lockdep_assert_held(&mr->dev->odp_srcu);
+	lockdep_assert_held(&mr_to_mdev(mr)->odp_srcu);
 	if (unlikely(io_virt < mr->mmkey.iova))
 		return -EFAULT;
 
@@ -1783,7 +1785,7 @@ static void mlx5_ib_prefetch_mr_work(struct work_struct *w)
 
 	/* We rely on IB/core that work is executed if we have num_sge != 0 only. */
 	WARN_ON(!work->num_sge);
-	dev = work->frags[0].mr->dev;
+	dev = mr_to_mdev(work->frags[0].mr);
 	/* SRCU should be held when calling to mlx5_odp_populate_xlt() */
 	srcu_key = srcu_read_lock(&dev->odp_srcu);
 	for (i = 0; i < work->num_sge; ++i) {
diff --git a/drivers/infiniband/hw/mlx5/restrack.c b/drivers/infiniband/hw/mlx5/restrack.c
index 887270dd3ce2..4ac429e72004 100644
--- a/drivers/infiniband/hw/mlx5/restrack.c
+++ b/drivers/infiniband/hw/mlx5/restrack.c
@@ -116,7 +116,7 @@ static int fill_res_mr_entry_raw(struct sk_buff *msg, struct ib_mr *ibmr)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
 
-	return fill_res_raw(msg, mr->dev, MLX5_SGMT_TYPE_PRM_QUERY_MKEY,
+	return fill_res_raw(msg, mr_to_mdev(mr), MLX5_SGMT_TYPE_PRM_QUERY_MKEY,
 			    mlx5_mkey_to_idx(mr->mmkey.key));
 }
 

