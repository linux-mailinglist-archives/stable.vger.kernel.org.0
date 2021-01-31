Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0F1309D2B
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 15:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhAaOsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 09:48:23 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:59189 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231542AbhAaOpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 09:45:15 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4B5751949A6F;
        Sun, 31 Jan 2021 09:41:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 31 Jan 2021 09:41:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=v2EtaN
        qlFfxg6IbXswg5T7MXqaiC73CElLMSUQRRifc=; b=Apx6rKq4FXYcP6i+81W59W
        1Q40juEbC0g1xyANl9ZW2oNL1FkWOLlRKmoOS213kPi+i0wOqsvXhrTpER8KPxcc
        DrBeyX3faZSLhvj2Wfmtlx4ho6dl8EAHJR51Ng45bsIKT7Q0cLcIMDHNi08UAPnm
        nanPTDonNHk1RfTtAn60aoSrOyyKL4345DHPsbowTiuCPnCXz7srao58j+Qx6vnb
        7AK9emIcSnqn8S9RvrVmSDwCHHwTahyBlx/iIZvfp6hJB+cxqY7+fHleBofM3piG
        cqx9WnAP0o0mkOEvHWRH0v8jh0J9rrHxqKJb0bM9dyPtUCi/FVPxxeDQ6Lgb359g
        ==
X-ME-Sender: <xms:msEWYIhvA3OrKsCG0aAk_aOjmE-TDuH5nGVv5BBRut2NwHBky3-VRQ>
    <xme:msEWYBDJABiAayww7haXGMzNVAvYeFZDczZ7imXjd0A_XFcWCLSF62x8fq6MBoXW1
    fn47fRBwagfoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeigdeivdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:msEWYAFUGh8xAl9aj85y0lZmCUczSWg4P0wqcLJOZ4jUfStqT3FAVw>
    <xmx:msEWYJQWfnnv9BJ_6wmc5_jWuMyJQTE6buVCM-gkNNWn8D1Mo1_oxQ>
    <xmx:msEWYFxZrGfsoG1UolGG0xs2Pm18yUd5CIYJl04S2Iqi7t-SRnOHug>
    <xmx:msEWYHtThchKWYM8MRTNI7M8679i9ZaOdIYRhrgzqjtxIzl-3JvLrg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EDA5B24005A;
        Sun, 31 Jan 2021 09:41:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] iommu/vt-d: Do not use flush-queue when caching-mode is on" failed to apply to 5.10-stable tree
To:     namit@vmware.com, baolu.lu@linux.intel.com, dwmw2@infradead.org,
        joro@8bytes.org, jroedel@suse.de, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Jan 2021 15:41:28 +0100
Message-ID: <1612104088214157@kroah.com>
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

From 29b32839725f8c89a41cb6ee054c85f3116ea8b5 Mon Sep 17 00:00:00 2001
From: Nadav Amit <namit@vmware.com>
Date: Wed, 27 Jan 2021 09:53:17 -0800
Subject: [PATCH] iommu/vt-d: Do not use flush-queue when caching-mode is on

When an Intel IOMMU is virtualized, and a physical device is
passed-through to the VM, changes of the virtual IOMMU need to be
propagated to the physical IOMMU. The hypervisor therefore needs to
monitor PTE mappings in the IOMMU page-tables. Intel specifications
provide "caching-mode" capability that a virtual IOMMU uses to report
that the IOMMU is virtualized and a TLB flush is needed after mapping to
allow the hypervisor to propagate virtual IOMMU mappings to the physical
IOMMU. To the best of my knowledge no real physical IOMMU reports
"caching-mode" as turned on.

Synchronizing the virtual and the physical IOMMU tables is expensive if
the hypervisor is unaware which PTEs have changed, as the hypervisor is
required to walk all the virtualized tables and look for changes.
Consequently, domain flushes are much more expensive than page-specific
flushes on virtualized IOMMUs with passthrough devices. The kernel
therefore exploited the "caching-mode" indication to avoid domain
flushing and use page-specific flushing in virtualized environments. See
commit 78d5f0f500e6 ("intel-iommu: Avoid global flushes with caching
mode.")

This behavior changed after commit 13cf01744608 ("iommu/vt-d: Make use
of iova deferred flushing"). Now, when batched TLB flushing is used (the
default), full TLB domain flushes are performed frequently, requiring
the hypervisor to perform expensive synchronization between the virtual
TLB and the physical one.

Getting batched TLB flushes to use page-specific invalidations again in
such circumstances is not easy, since the TLB invalidation scheme
assumes that "full" domain TLB flushes are performed for scalability.

Disable batched TLB flushes when caching-mode is on, as the performance
benefit from using batched TLB invalidations is likely to be much
smaller than the overhead of the virtual-to-physical IOMMU page-tables
synchronization.

Fixes: 13cf01744608 ("iommu/vt-d: Make use of iova deferred flushing")
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org

Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210127175317.1600473-1-namit@vmware.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index f665322a0991..06b00b5363d8 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5440,6 +5440,36 @@ intel_iommu_domain_set_attr(struct iommu_domain *domain,
 	return ret;
 }
 
+static bool domain_use_flush_queue(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	bool r = true;
+
+	if (intel_iommu_strict)
+		return false;
+
+	/*
+	 * The flush queue implementation does not perform page-selective
+	 * invalidations that are required for efficient TLB flushes in virtual
+	 * environments. The benefit of batching is likely to be much lower than
+	 * the overhead of synchronizing the virtual and physical IOMMU
+	 * page-tables.
+	 */
+	rcu_read_lock();
+	for_each_active_iommu(iommu, drhd) {
+		if (!cap_caching_mode(iommu->cap))
+			continue;
+
+		pr_warn_once("IOMMU batching is disabled due to virtualization");
+		r = false;
+		break;
+	}
+	rcu_read_unlock();
+
+	return r;
+}
+
 static int
 intel_iommu_domain_get_attr(struct iommu_domain *domain,
 			    enum iommu_attr attr, void *data)
@@ -5450,7 +5480,7 @@ intel_iommu_domain_get_attr(struct iommu_domain *domain,
 	case IOMMU_DOMAIN_DMA:
 		switch (attr) {
 		case DOMAIN_ATTR_DMA_USE_FLUSH_QUEUE:
-			*(int *)data = !intel_iommu_strict;
+			*(int *)data = domain_use_flush_queue();
 			return 0;
 		default:
 			return -ENODEV;

