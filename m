Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DDD2F0E8C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbhAKIw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:52:59 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:41863 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726611AbhAKIw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:52:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 5BB0C24CB;
        Mon, 11 Jan 2021 03:51:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:51:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mMldDO
        op2e02c/JXlnP++elZuCop0e3zPP0rQA6wOi4=; b=X2c8rR4GNIjbzWGvGLCg1e
        qI1KF46YtWKR8NOKCRYEQXIlzWaUNGH4/MkwbN2o478D2L8NoLFTSHjVPF8Z4Oic
        E+9sJanx86uv8YQISnoDzTBms0hWBnOaPb6NNcuUTdoSCmeIDi5DJ73eS1omGH37
        /kTX/C4Xd0a+PcP156EtaOCKPl5jwKhwoR/dbBXFNkZuusMXALMjTsNOXJ3ZT6HD
        DwBPDHrgrdgGsNyIeNDs+REw245pmgES6fxJ76D2rDjWhZNLl4jufjneynC1T9D9
        YNj/Ko4PcUvcylkBixTyHeoeUzh/fRtRLVF8jqbpuhWU8J4nXT4nx6iQ2+ci8y9w
        ==
X-ME-Sender: <xms:pxH8X6NDxK8pCcUCLZkX-hIHYTqsuTG-at9AyTcHbS2HwSzRACoCyA>
    <xme:pxH8X49ajydDU_WTeIRdMJQr2JArzIo0k9FavkE7gIh342RsoVUg_UugCvF-3eOER
    64mxsBsj11Fqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:pxH8XxRhmhgeKNxKBifoqatF8A_Ny9rqPy5KX6waoI7jrDA9ygp2kA>
    <xmx:pxH8X6u5RkiUtddulQuB-oNlbNMgbaP3b2US-Gad6mw29nrt3_ynig>
    <xmx:pxH8Xyd01AAKzl1fTqSAhtZk61imYyMV8IwvUSscigqZ3IdxPeFU9g>
    <xmx:qBH8X6TXpZpUCoTp34XLmW5kCoKGQNCHaPiLGyaZkgLCaMjWXlm_NnLpM1s>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0209C108005C;
        Mon, 11 Jan 2021 03:51:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] iommu/vt-d: Move intel_iommu info from struct intel_svm to" failed to apply to 5.4-stable tree
To:     yi.l.liu@intel.com, Kaijie.Guo@intel.com, ashok.raj@intel.com,
        baolu.lu@linux.intel.com, dwmw2@infradead.org,
        jacob.jun.pan@linux.intel.com, will@kernel.org, xin.zeng@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:53:03 +0100
Message-ID: <161035518312185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 9ad9f45b3b91162b33abfe175ae75ab65718dbf5 Mon Sep 17 00:00:00 2001
From: Liu Yi L <yi.l.liu@intel.com>
Date: Thu, 7 Jan 2021 00:03:55 +0800
Subject: [PATCH] iommu/vt-d: Move intel_iommu info from struct intel_svm to
 struct intel_svm_dev

'struct intel_svm' is shared by all devices bound to a give process,
but records only a single pointer to a 'struct intel_iommu'. Consequently,
cache invalidations may only be applied to a single DMAR unit, and are
erroneously skipped for the other devices.

In preparation for fixing this, rework the structures so that the iommu
pointer resides in 'struct intel_svm_dev', allowing 'struct intel_svm'
to track them in its device list.

Fixes: 1c4f88b7f1f9 ("iommu/vt-d: Shared virtual address in scalable mode")
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Raj Ashok <ashok.raj@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Reported-by: Guo Kaijie <Kaijie.Guo@intel.com>
Reported-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Guo Kaijie <Kaijie.Guo@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Tested-by: Guo Kaijie <Kaijie.Guo@intel.com>
Cc: stable@vger.kernel.org # v5.0+
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/1609949037-25291-2-git-send-email-yi.l.liu@intel.com
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 9bcedd360235..790ef3497e7e 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -142,7 +142,7 @@ static void intel_flush_svm_range_dev (struct intel_svm *svm, struct intel_svm_d
 	}
 	desc.qw2 = 0;
 	desc.qw3 = 0;
-	qi_submit_sync(svm->iommu, &desc, 1, 0);
+	qi_submit_sync(sdev->iommu, &desc, 1, 0);
 
 	if (sdev->dev_iotlb) {
 		desc.qw0 = QI_DEV_EIOTLB_PASID(svm->pasid) |
@@ -166,7 +166,7 @@ static void intel_flush_svm_range_dev (struct intel_svm *svm, struct intel_svm_d
 		}
 		desc.qw2 = 0;
 		desc.qw3 = 0;
-		qi_submit_sync(svm->iommu, &desc, 1, 0);
+		qi_submit_sync(sdev->iommu, &desc, 1, 0);
 	}
 }
 
@@ -211,7 +211,7 @@ static void intel_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 	 */
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdev, &svm->devs, list)
-		intel_pasid_tear_down_entry(svm->iommu, sdev->dev,
+		intel_pasid_tear_down_entry(sdev->iommu, sdev->dev,
 					    svm->pasid, true);
 	rcu_read_unlock();
 
@@ -364,6 +364,7 @@ int intel_svm_bind_gpasid(struct iommu_domain *domain, struct device *dev,
 	}
 	sdev->dev = dev;
 	sdev->sid = PCI_DEVID(info->bus, info->devfn);
+	sdev->iommu = iommu;
 
 	/* Only count users if device has aux domains */
 	if (iommu_dev_feature_enabled(dev, IOMMU_DEV_FEAT_AUX))
@@ -548,6 +549,7 @@ intel_svm_bind_mm(struct device *dev, unsigned int flags,
 		goto out;
 	}
 	sdev->dev = dev;
+	sdev->iommu = iommu;
 
 	ret = intel_iommu_enable_pasid(iommu, dev);
 	if (ret) {
@@ -577,7 +579,6 @@ intel_svm_bind_mm(struct device *dev, unsigned int flags,
 			kfree(sdev);
 			goto out;
 		}
-		svm->iommu = iommu;
 
 		if (pasid_max > intel_pasid_max_id)
 			pasid_max = intel_pasid_max_id;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index d956987ed032..94522685a0d9 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -758,6 +758,7 @@ struct intel_svm_dev {
 	struct list_head list;
 	struct rcu_head rcu;
 	struct device *dev;
+	struct intel_iommu *iommu;
 	struct svm_dev_ops *ops;
 	struct iommu_sva sva;
 	u32 pasid;
@@ -771,7 +772,6 @@ struct intel_svm {
 	struct mmu_notifier notifier;
 	struct mm_struct *mm;
 
-	struct intel_iommu *iommu;
 	unsigned int flags;
 	u32 pasid;
 	int gpasid; /* In case that guest PASID is different from host PASID */

