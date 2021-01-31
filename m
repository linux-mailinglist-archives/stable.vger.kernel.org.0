Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADED7309D2F
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 15:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhAaOuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 09:50:13 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:37347 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231963AbhAaOmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 09:42:38 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 17810194590B;
        Sun, 31 Jan 2021 09:41:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 31 Jan 2021 09:41:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9PUnhn
        whd70mQrwaOltnVl1SHuq7OkLUiHwjTNsCYOU=; b=LVy+M0dX6OXtw27fiiMW3G
        TAx9eMDlysMT4x9+/wMU6a2Ff12HvCMu+PVYMCFQEM03J+ym90TlRky2Nkf7WMnY
        F55pqx+Ro3An8JiTGUVe5DCXcE/Y/g2uHP59lXLLfJRj2GMa+g7A0e7IWlUn65Q4
        CmSUQNln0f3L3xAl8byni44LhK+nXlqEqFQDtEXYH2sTWRE5mTBhwyhGLDDDXHOF
        c90HCLtb2662nPejGskDywruLT7RgE078oVZ8fOlGKvktuV807oGC0mXmWDLUTmp
        JppdoYX9zbY7dqsdOk2Aju8P+7yFb7U94kRYo0KmEJX9sNZIl4CeEOZpIVWWte2Q
        ==
X-ME-Sender: <xms:lcEWYEzvPT-dLf0HFnK7LjpP_9J-aV3S336t5DIP7HxYaYNbSiJP0Q>
    <xme:lcEWYIRHY1yNPsscOpni6aJ7R-RQZhyNsj4QYwfH1D6G3DVCpO8OKnLHVwr6TB5Ts
    mpUmpwGzKB5xw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeigdeivdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:lcEWYGVjluXKSa6k17fUCEXmdavhoKIWs9QdVFoXWme1fRORd4WKGA>
    <xmx:lcEWYCh8VFrpHA4Yz7bkLGOGWR5tn82Tkqo0jWWAKfNniUZQP-3hFg>
    <xmx:lcEWYGCRqL4WMsLz6vlFl-tiXDXyCPMY6SE1tS-zM2NDqvWU9-hXtg>
    <xmx:lsEWYJ-FpdB0aJkQ3lQ1uiSsFwRmtNlR36quSTPk4sHJRR4nsQLhQA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DB841080059;
        Sun, 31 Jan 2021 09:41:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] iommu/vt-d: Do not use flush-queue when caching-mode is on" failed to apply to 4.14-stable tree
To:     namit@vmware.com, baolu.lu@linux.intel.com, dwmw2@infradead.org,
        joro@8bytes.org, jroedel@suse.de, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Jan 2021 15:41:23 +0100
Message-ID: <161210408319221@kroah.com>
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

