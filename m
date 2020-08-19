Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B3F249A27
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 12:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHSKVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 06:21:45 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:55527 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727042AbgHSKVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 06:21:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3CE0619421F4;
        Wed, 19 Aug 2020 06:21:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 06:21:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6o8qqI
        qrCpznq+WY62e7ogRPZT69MiWI6CJce2V2xLc=; b=Ve1Uk0YcOAUXYlHP1YXXf4
        +c9UWHQrIpmrEyL1crWAHwhRlboVSm8xVTuPnZdgQdfNJ9f8XMz+NPUnU9KiEJDV
        MqzUoaXImzIzgB/mb9WJxjbG45ynWkF0QQh8aQskYXqH/xoasLue9zA3pHhbcs72
        i1aALPqnEFC4PHkXTvAGQ3BXpe3Z673zvG9Kr62dHOLKOJifnPbSpV/ZFqXtb04u
        eBdzdYRzv9W+m087ORqvgobM5An4gnXSdeDyyohVOx5pxlOiLWhmfu87FOOwOeH4
        XgjyLNOwwJ1luhSQc5C/+co2XfAN1Mq/xqBMQHcS/jv0PJ5u/wcda+aOtztmwjzA
        ==
X-ME-Sender: <xms:Nv08X1sNrgIlFErTENGS1XFcEySzFMTuLmxImMjU02fknMokobM16w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Nv08X-eN9QUP95wwwJPj18i1ufRtTdEmOx_mdR1sls1ybEJCsDwx7w>
    <xmx:Nv08X4xNX0FxlJV_7fS6RwhEaZJz5mjeuiNkTrg3r_gmDkuLYvNC6Q>
    <xmx:Nv08X8M4M5_4kGD_iQkq4AlUmIPslakBpNX1KeZYs2KYB_QrW3Q__Q>
    <xmx:Nv08X3l5YcI8oTjSpi-DqfkfK27Dzs3s1XRdMF6HyNVfzkfBZd_kJQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D18DB3280059;
        Wed, 19 Aug 2020 06:21:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI/ATS: Add pci_pri_supported() to check device or" failed to apply to 4.9-stable tree
To:     ashok.raj@intel.com, baolu.lu@linux.intel.com, bhelgaas@google.com,
        jroedel@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 12:22:00 +0200
Message-ID: <159783252096210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 3f9a7a13fe4cb6e119e4e4745fbf975d30bfac9b Mon Sep 17 00:00:00 2001
From: Ashok Raj <ashok.raj@intel.com>
Date: Thu, 23 Jul 2020 15:37:29 -0700
Subject: [PATCH] PCI/ATS: Add pci_pri_supported() to check device or
 associated PF

For SR-IOV, the PF PRI is shared between the PF and any associated VFs, and
the PRI Capability is allowed for PFs but not for VFs.  Searching for the
PRI Capability on a VF always fails, even if its associated PF supports
PRI.

Add pci_pri_supported() to check whether device or its associated PF
supports PRI.

[bhelgaas: commit log, avoid "!!"]
Fixes: b16d0cb9e2fc ("iommu/vt-d: Always enable PASID/PRI PCI capabilities before ATS")
Link: https://lore.kernel.org/r/1595543849-19692-1-git-send-email-ashok.raj@intel.com
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Acked-by: Joerg Roedel <jroedel@suse.de>
Cc: stable@vger.kernel.org	# v4.4+

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 9129663a7406..5552e7d5d2b1 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2554,7 +2554,7 @@ static struct dmar_domain *dmar_insert_one_dev_info(struct intel_iommu *iommu,
 			}
 
 			if (info->ats_supported && ecap_prs(iommu->ecap) &&
-			    pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI))
+			    pci_pri_supported(pdev))
 				info->pri_supported = 1;
 		}
 	}
diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index b761c1f72f67..647e097530a8 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -325,6 +325,21 @@ int pci_prg_resp_pasid_required(struct pci_dev *pdev)
 
 	return pdev->pasid_required;
 }
+
+/**
+ * pci_pri_supported - Check if PRI is supported.
+ * @pdev: PCI device structure
+ *
+ * Returns true if PRI capability is present, false otherwise.
+ */
+bool pci_pri_supported(struct pci_dev *pdev)
+{
+	/* VFs share the PF PRI */
+	if (pci_physfn(pdev)->pri_cap)
+		return true;
+	return false;
+}
+EXPORT_SYMBOL_GPL(pci_pri_supported);
 #endif /* CONFIG_PCI_PRI */
 
 #ifdef CONFIG_PCI_PASID
diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
index f75c307f346d..df54cd5b15db 100644
--- a/include/linux/pci-ats.h
+++ b/include/linux/pci-ats.h
@@ -28,6 +28,10 @@ int pci_enable_pri(struct pci_dev *pdev, u32 reqs);
 void pci_disable_pri(struct pci_dev *pdev);
 int pci_reset_pri(struct pci_dev *pdev);
 int pci_prg_resp_pasid_required(struct pci_dev *pdev);
+bool pci_pri_supported(struct pci_dev *pdev);
+#else
+static inline bool pci_pri_supported(struct pci_dev *pdev)
+{ return false; }
 #endif /* CONFIG_PCI_PRI */
 
 #ifdef CONFIG_PCI_PASID

