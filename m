Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529F32F76AA
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 11:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbhAOK1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 05:27:18 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:55119 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726652AbhAOK1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 05:27:18 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2DAD019C3E4A;
        Fri, 15 Jan 2021 05:26:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 15 Jan 2021 05:26:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TngPgU
        Ut+a902GQCm+/7fts43p6Bjz7zAAtRIxCUb1c=; b=Wn9p5bVyLTzI0x+aVWz1Vy
        uXuIHsTFFcdTFdy+Aeu9ZOfZetciLxPXlDJDIyNkC1Zeiy1CrVXp8rn6iYy9dwBO
        CjFeW5UQe2BpNLOwuV8NzuJsk2J9TwAKnmSQCdz5972Q1sbmmvjuKeruRXBPRjTn
        cS9vlVHDLVYCrXChZbsjIiXl249/BDAH3Gurk7CxB8v9FPvuV21zsfbBGCcJqKK9
        n20g3EG9TxLmGVg9jttlQ1zju6PhWd+vZQbexiknfj9yUe6e2VsMdATK6XP+s1On
        SmSVStCoUNPvSWQrQNcAlldyP5QrRhIsWxzqPG8K+N9asO2kvcf5klZtbmA6GOxA
        ==
X-ME-Sender: <xms:xG0BYFtuSORmFHhR4Nvl00LQVx_w8rI5Cb7nFUElzsIeUQJ3ZNUatA>
    <xme:xG0BYOfa1jNr8bs-w-Yk2UZmIaB1rs7z7Lak0kNOviljmk9RUDdAUeFrM8VICZKJj
    XGH8Goh6OmqlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugddugeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:xG0BYIwWezEcXmP8_5oAwPMfOp5Y4C_pztVR_8tXqrWFVrKliAvWZA>
    <xmx:xG0BYMPNnR3Bk57q7zZEm7_zmXdAd-jQQectUm4tFfHLIjWGCA1AeA>
    <xmx:xG0BYF-SFWnnLoXYU2fa3_Zav7JpjuxoSrTYOZTg14RZ-f33oDMQoA>
    <xmx:xG0BYHmuqclx1gsf538IhtOsYLEzPQAy1HcF0Fruh98vhNnps34UOw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CDA1B24005C;
        Fri, 15 Jan 2021 05:26:11 -0500 (EST)
Subject: FAILED: patch "[PATCH] iommu/vt-d: Fix ineffective devTLB invalidation for" failed to apply to 5.10-stable tree
To:     yi.l.liu@intel.com, baolu.lu@linux.intel.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 11:26:02 +0100
Message-ID: <161070636285136@kroah.com>
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

From 7c29ada5e70083805bc3a68daa23441df421fbee Mon Sep 17 00:00:00 2001
From: Liu Yi L <yi.l.liu@intel.com>
Date: Thu, 7 Jan 2021 00:03:57 +0800
Subject: [PATCH] iommu/vt-d: Fix ineffective devTLB invalidation for
 subdevices

iommu_flush_dev_iotlb() is called to invalidate caches on a device but
only loops over the devices which are fully-attached to the domain. For
sub-devices, this is ineffective and can result in invalid caching
entries left on the device.

Fix the missing invalidation by adding a loop over the subdevices and
ensuring that 'domain->has_iotlb_device' is updated when attaching to
subdevices.

Fixes: 67b8e02b5e76 ("iommu/vt-d: Aux-domain specific domain attach/detach")
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/1609949037-25291-4-git-send-email-yi.l.liu@intel.com
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index d7720a836268..65cf06d70bf4 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -719,6 +719,8 @@ static int domain_update_device_node(struct dmar_domain *domain)
 	return nid;
 }
 
+static void domain_update_iotlb(struct dmar_domain *domain);
+
 /* Some capabilities may be different across iommus */
 static void domain_update_iommu_cap(struct dmar_domain *domain)
 {
@@ -744,6 +746,8 @@ static void domain_update_iommu_cap(struct dmar_domain *domain)
 		domain->domain.geometry.aperture_end = __DOMAIN_MAX_ADDR(domain->gaw - 1);
 	else
 		domain->domain.geometry.aperture_end = __DOMAIN_MAX_ADDR(domain->gaw);
+
+	domain_update_iotlb(domain);
 }
 
 struct context_entry *iommu_context_addr(struct intel_iommu *iommu, u8 bus,
@@ -1464,17 +1468,22 @@ static void domain_update_iotlb(struct dmar_domain *domain)
 
 	assert_spin_locked(&device_domain_lock);
 
-	list_for_each_entry(info, &domain->devices, link) {
-		struct pci_dev *pdev;
-
-		if (!info->dev || !dev_is_pci(info->dev))
-			continue;
-
-		pdev = to_pci_dev(info->dev);
-		if (pdev->ats_enabled) {
+	list_for_each_entry(info, &domain->devices, link)
+		if (info->ats_enabled) {
 			has_iotlb_device = true;
 			break;
 		}
+
+	if (!has_iotlb_device) {
+		struct subdev_domain_info *sinfo;
+
+		list_for_each_entry(sinfo, &domain->subdevices, link_domain) {
+			info = get_domain_info(sinfo->pdev);
+			if (info && info->ats_enabled) {
+				has_iotlb_device = true;
+				break;
+			}
+		}
 	}
 
 	domain->has_iotlb_device = has_iotlb_device;
@@ -1555,25 +1564,37 @@ static void iommu_disable_dev_iotlb(struct device_domain_info *info)
 #endif
 }
 
+static void __iommu_flush_dev_iotlb(struct device_domain_info *info,
+				    u64 addr, unsigned int mask)
+{
+	u16 sid, qdep;
+
+	if (!info || !info->ats_enabled)
+		return;
+
+	sid = info->bus << 8 | info->devfn;
+	qdep = info->ats_qdep;
+	qi_flush_dev_iotlb(info->iommu, sid, info->pfsid,
+			   qdep, addr, mask);
+}
+
 static void iommu_flush_dev_iotlb(struct dmar_domain *domain,
 				  u64 addr, unsigned mask)
 {
-	u16 sid, qdep;
 	unsigned long flags;
 	struct device_domain_info *info;
+	struct subdev_domain_info *sinfo;
 
 	if (!domain->has_iotlb_device)
 		return;
 
 	spin_lock_irqsave(&device_domain_lock, flags);
-	list_for_each_entry(info, &domain->devices, link) {
-		if (!info->ats_enabled)
-			continue;
+	list_for_each_entry(info, &domain->devices, link)
+		__iommu_flush_dev_iotlb(info, addr, mask);
 
-		sid = info->bus << 8 | info->devfn;
-		qdep = info->ats_qdep;
-		qi_flush_dev_iotlb(info->iommu, sid, info->pfsid,
-				qdep, addr, mask);
+	list_for_each_entry(sinfo, &domain->subdevices, link_domain) {
+		info = get_domain_info(sinfo->pdev);
+		__iommu_flush_dev_iotlb(info, addr, mask);
 	}
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 }

