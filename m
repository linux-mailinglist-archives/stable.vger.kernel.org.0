Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF77E2F76A5
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 11:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbhAOK0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 05:26:44 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:55865 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725995AbhAOK0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 05:26:44 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 60BA619C3AD2;
        Fri, 15 Jan 2021 05:25:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 15 Jan 2021 05:25:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=e3kZ5I
        JG8rv6TeLVq6UlVzWipoRVIjY7aieE6bsqR+E=; b=OEJkIxIMNg0p2AjZxBk/md
        2vWOPhSRxPUSLgonondfDhNvRK2tV0YL9RW500W8PlEaRUY3HSQdLEPswCCx98Ub
        +rW4U8iwiIQYt15rB3HpzeEC/RWTuVkTyEHyWF71+3SU8J8F8+oJEOq8ef3Drvva
        04u7RsCCUdHrijKippKbhuFUcw37LchyGEufPsdl37K1IRYzrr17iz/9c7+aq59Q
        im/i9Fk265NX4tte81A0A28gqVB0rfj+V34KBsKGFBbQmWm1/+VPRotV6ItWgLAr
        ZHunWV+Uy3RIGk6Q+dqTiQNszgvk2sfCE7vimLEGuF2uN6I2L6NqK9AEb4E6x7Kw
        ==
X-ME-Sender: <xms:tG0BYDwL1-N5uSyHjcpZyrNp51jBUxpOskTkWIKUqjqaudpF-NjrNw>
    <xme:tG0BYLTM7eGXTfZ4SkTmRznit1170IonNhYOSvSEfkKELY_4iw05o0vJVEnAvY53s
    GS2oqSz5BOL8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugddugeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:tG0BYNU4ep0mmSBnoJWAk-EZ-WMffBVHXi4fQditt8SON4mF35DmNg>
    <xmx:tG0BYNj8WDuLr04EQ3ncRjSrkT_8EMNijvvBBZoyuuheaenGp0hDFw>
    <xmx:tG0BYFB8cdvfJeL0eUVjjMqW6lqw6OgtqgU6b1H0RHPJUXvMwCpcsQ>
    <xmx:tW0BYIPDMSrwX1aVgeK1njGyqA5Hp-RePzuA7fWrrgKSLzk7ahH8uQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8729B1080059;
        Fri, 15 Jan 2021 05:25:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] iommu/vt-d: Fix general protection fault in" failed to apply to 5.4-stable tree
To:     yi.l.liu@intel.com, baolu.lu@linux.intel.com, will@kernel.org,
        xin.zeng@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 11:25:55 +0100
Message-ID: <16107063553555@kroah.com>
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

From 18abda7a2d555783d28ea1701f3ec95e96237a86 Mon Sep 17 00:00:00 2001
From: Liu Yi L <yi.l.liu@intel.com>
Date: Thu, 7 Jan 2021 00:03:56 +0800
Subject: [PATCH] iommu/vt-d: Fix general protection fault in
 aux_detach_device()

The aux-domain attach/detach are not tracked, some data structures might
be used after free. This causes general protection faults when multiple
subdevices are created and assigned to a same guest machine:

  | general protection fault, probably for non-canonical address 0xdead000000000100: 0000 [#1] SMP NOPTI
  | RIP: 0010:intel_iommu_aux_detach_device+0x12a/0x1f0
  | [...]
  | Call Trace:
  |  iommu_aux_detach_device+0x24/0x70
  |  vfio_mdev_detach_domain+0x3b/0x60
  |  ? vfio_mdev_set_domain+0x50/0x50
  |  iommu_group_for_each_dev+0x4f/0x80
  |  vfio_iommu_detach_group.isra.0+0x22/0x30
  |  vfio_iommu_type1_detach_group.cold+0x71/0x211
  |  ? find_exported_symbol_in_section+0x4a/0xd0
  |  ? each_symbol_section+0x28/0x50
  |  __vfio_group_unset_container+0x4d/0x150
  |  vfio_group_try_dissolve_container+0x25/0x30
  |  vfio_group_put_external_user+0x13/0x20
  |  kvm_vfio_group_put_external_user+0x27/0x40 [kvm]
  |  kvm_vfio_destroy+0x45/0xb0 [kvm]
  |  kvm_put_kvm+0x1bb/0x2e0 [kvm]
  |  kvm_vm_release+0x22/0x30 [kvm]
  |  __fput+0xcc/0x260
  |  ____fput+0xe/0x10
  |  task_work_run+0x8f/0xb0
  |  do_exit+0x358/0xaf0
  |  ? wake_up_state+0x10/0x20
  |  ? signal_wake_up_state+0x1a/0x30
  |  do_group_exit+0x47/0xb0
  |  __x64_sys_exit_group+0x18/0x20
  |  do_syscall_64+0x57/0x1d0
  |  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix the crash by tracking the subdevices when attaching and detaching
aux-domains.

Fixes: 67b8e02b5e76 ("iommu/vt-d: Aux-domain specific domain attach/detach")
Co-developed-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/1609949037-25291-3-git-send-email-yi.l.liu@intel.com
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 788119c5b021..d7720a836268 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1877,6 +1877,7 @@ static struct dmar_domain *alloc_domain(int flags)
 		domain->flags |= DOMAIN_FLAG_USE_FIRST_LEVEL;
 	domain->has_iotlb_device = false;
 	INIT_LIST_HEAD(&domain->devices);
+	INIT_LIST_HEAD(&domain->subdevices);
 
 	return domain;
 }
@@ -2547,7 +2548,7 @@ static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
 	info->iommu = iommu;
 	info->pasid_table = NULL;
 	info->auxd_enabled = 0;
-	INIT_LIST_HEAD(&info->auxiliary_domains);
+	INIT_LIST_HEAD(&info->subdevices);
 
 	if (dev && dev_is_pci(dev)) {
 		struct pci_dev *pdev = to_pci_dev(info->dev);
@@ -4475,33 +4476,61 @@ is_aux_domain(struct device *dev, struct iommu_domain *domain)
 			domain->type == IOMMU_DOMAIN_UNMANAGED;
 }
 
-static void auxiliary_link_device(struct dmar_domain *domain,
-				  struct device *dev)
+static inline struct subdev_domain_info *
+lookup_subdev_info(struct dmar_domain *domain, struct device *dev)
+{
+	struct subdev_domain_info *sinfo;
+
+	if (!list_empty(&domain->subdevices)) {
+		list_for_each_entry(sinfo, &domain->subdevices, link_domain) {
+			if (sinfo->pdev == dev)
+				return sinfo;
+		}
+	}
+
+	return NULL;
+}
+
+static int auxiliary_link_device(struct dmar_domain *domain,
+				 struct device *dev)
 {
 	struct device_domain_info *info = get_domain_info(dev);
+	struct subdev_domain_info *sinfo = lookup_subdev_info(domain, dev);
 
 	assert_spin_locked(&device_domain_lock);
 	if (WARN_ON(!info))
-		return;
+		return -EINVAL;
+
+	if (!sinfo) {
+		sinfo = kzalloc(sizeof(*sinfo), GFP_ATOMIC);
+		sinfo->domain = domain;
+		sinfo->pdev = dev;
+		list_add(&sinfo->link_phys, &info->subdevices);
+		list_add(&sinfo->link_domain, &domain->subdevices);
+	}
 
-	domain->auxd_refcnt++;
-	list_add(&domain->auxd, &info->auxiliary_domains);
+	return ++sinfo->users;
 }
 
-static void auxiliary_unlink_device(struct dmar_domain *domain,
-				    struct device *dev)
+static int auxiliary_unlink_device(struct dmar_domain *domain,
+				   struct device *dev)
 {
 	struct device_domain_info *info = get_domain_info(dev);
+	struct subdev_domain_info *sinfo = lookup_subdev_info(domain, dev);
+	int ret;
 
 	assert_spin_locked(&device_domain_lock);
-	if (WARN_ON(!info))
-		return;
+	if (WARN_ON(!info || !sinfo || sinfo->users <= 0))
+		return -EINVAL;
 
-	list_del(&domain->auxd);
-	domain->auxd_refcnt--;
+	ret = --sinfo->users;
+	if (!ret) {
+		list_del(&sinfo->link_phys);
+		list_del(&sinfo->link_domain);
+		kfree(sinfo);
+	}
 
-	if (!domain->auxd_refcnt && domain->default_pasid > 0)
-		ioasid_put(domain->default_pasid);
+	return ret;
 }
 
 static int aux_domain_add_dev(struct dmar_domain *domain,
@@ -4530,6 +4559,19 @@ static int aux_domain_add_dev(struct dmar_domain *domain,
 	}
 
 	spin_lock_irqsave(&device_domain_lock, flags);
+	ret = auxiliary_link_device(domain, dev);
+	if (ret <= 0)
+		goto link_failed;
+
+	/*
+	 * Subdevices from the same physical device can be attached to the
+	 * same domain. For such cases, only the first subdevice attachment
+	 * needs to go through the full steps in this function. So if ret >
+	 * 1, just goto out.
+	 */
+	if (ret > 1)
+		goto out;
+
 	/*
 	 * iommu->lock must be held to attach domain to iommu and setup the
 	 * pasid entry for second level translation.
@@ -4548,10 +4590,9 @@ static int aux_domain_add_dev(struct dmar_domain *domain,
 						     domain->default_pasid);
 	if (ret)
 		goto table_failed;
-	spin_unlock(&iommu->lock);
-
-	auxiliary_link_device(domain, dev);
 
+	spin_unlock(&iommu->lock);
+out:
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 
 	return 0;
@@ -4560,8 +4601,10 @@ static int aux_domain_add_dev(struct dmar_domain *domain,
 	domain_detach_iommu(domain, iommu);
 attach_failed:
 	spin_unlock(&iommu->lock);
+	auxiliary_unlink_device(domain, dev);
+link_failed:
 	spin_unlock_irqrestore(&device_domain_lock, flags);
-	if (!domain->auxd_refcnt && domain->default_pasid > 0)
+	if (list_empty(&domain->subdevices) && domain->default_pasid > 0)
 		ioasid_put(domain->default_pasid);
 
 	return ret;
@@ -4581,14 +4624,18 @@ static void aux_domain_remove_dev(struct dmar_domain *domain,
 	info = get_domain_info(dev);
 	iommu = info->iommu;
 
-	auxiliary_unlink_device(domain, dev);
-
-	spin_lock(&iommu->lock);
-	intel_pasid_tear_down_entry(iommu, dev, domain->default_pasid, false);
-	domain_detach_iommu(domain, iommu);
-	spin_unlock(&iommu->lock);
+	if (!auxiliary_unlink_device(domain, dev)) {
+		spin_lock(&iommu->lock);
+		intel_pasid_tear_down_entry(iommu, dev,
+					    domain->default_pasid, false);
+		domain_detach_iommu(domain, iommu);
+		spin_unlock(&iommu->lock);
+	}
 
 	spin_unlock_irqrestore(&device_domain_lock, flags);
+
+	if (list_empty(&domain->subdevices) && domain->default_pasid > 0)
+		ioasid_put(domain->default_pasid);
 }
 
 static int prepare_domain_attach_device(struct iommu_domain *domain,
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 94522685a0d9..09c6a0bf3892 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -533,11 +533,10 @@ struct dmar_domain {
 					/* Domain ids per IOMMU. Use u16 since
 					 * domain ids are 16 bit wide according
 					 * to VT-d spec, section 9.3 */
-	unsigned int	auxd_refcnt;	/* Refcount of auxiliary attaching */
 
 	bool has_iotlb_device;
 	struct list_head devices;	/* all devices' list */
-	struct list_head auxd;		/* link to device's auxiliary list */
+	struct list_head subdevices;	/* all subdevices' list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
 
 	struct dma_pte	*pgd;		/* virtual address */
@@ -610,14 +609,21 @@ struct intel_iommu {
 	struct dmar_drhd_unit *drhd;
 };
 
+/* Per subdevice private data */
+struct subdev_domain_info {
+	struct list_head link_phys;	/* link to phys device siblings */
+	struct list_head link_domain;	/* link to domain siblings */
+	struct device *pdev;		/* physical device derived from */
+	struct dmar_domain *domain;	/* aux-domain */
+	int users;			/* user count */
+};
+
 /* PCI domain-device relationship */
 struct device_domain_info {
 	struct list_head link;	/* link to domain siblings */
 	struct list_head global; /* link to global list */
 	struct list_head table;	/* link to pasid table */
-	struct list_head auxiliary_domains; /* auxiliary domains
-					     * attached to this device
-					     */
+	struct list_head subdevices; /* subdevices sibling */
 	u32 segment;		/* PCI segment number */
 	u8 bus;			/* PCI bus number */
 	u8 devfn;		/* PCI devfn number */

