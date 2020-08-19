Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81F6249A25
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 12:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgHSKVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 06:21:39 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:50599 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726923AbgHSKVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 06:21:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id EFFAB1941E5D;
        Wed, 19 Aug 2020 06:21:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 06:21:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RENzN+
        zfqehvjTceK6AyqqAZeD0U83yHMvI29BD95l4=; b=tG3Z8SfzoJcPrxfz7zOloB
        VA73siW8b5FwIETE+HLQ11UE7UzwcNOGsRxRcAmWPwGreEW8F0s+QtElKSEXQ85K
        1hdQC61HPUkusZrWL25nN9ht8eVHs98c4Hwqe6UrKKPod0k0bYLs/8VAz5CHxF8A
        brnDV3KFtkRIMCiNgO/oKTat9vTTEiAVTSseg8WW8LtvEj+o+JAnSzw9sUstmUrU
        gx1o6tYR0sRFij9ehBasBRo2Yu5DEEmLp5XXXZXvUNcT4A2I/MbOxHdJjZS//Lpq
        pczZLMpBXudHEvQXOgn07u7PB7xFOXh5evbpQmgKEU7DnZI1Qya98b24P6la2N0g
        ==
X-ME-Sender: <xms:Mf08X0QcoC9Qx9dG6IlH4X7zvHG_1Efql1gIxaAYN_n-wZFd31NYfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Mf08Xxw9N2-sSoMV2amTR0JqnQ5uv4ugbNw9UtzF3GKrjWs2KyPTmg>
    <xmx:Mf08Xx2FnJDA2pQj7W-X5aqzNxPIG0gAApNnKzhQBjvZCONkXI029Q>
    <xmx:Mf08X4An3FM0mf6Qg07qGUeGbW4YLsDC57LA1sfquy8OkXd0pEpqnw>
    <xmx:Mf08X9aiwNwA34pMBy60q7JDAvso_-lJjaJYL6nCVM4vYx4dbTLYmQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F96A3280059;
        Wed, 19 Aug 2020 06:21:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI/ATS: Add pci_pri_supported() to check device or" failed to apply to 4.14-stable tree
To:     ashok.raj@intel.com, baolu.lu@linux.intel.com, bhelgaas@google.com,
        jroedel@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 12:21:59 +0200
Message-ID: <159783251922454@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

