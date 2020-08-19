Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5D8249A28
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 12:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgHSKVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 06:21:48 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:44529 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726923AbgHSKVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 06:21:45 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8165E1941ED5;
        Wed, 19 Aug 2020 06:21:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 06:21:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=33ezEW
        /0nkkJqA+vJcsZ7vfa4EXcSg0VFc8z52r2HTY=; b=EP5oRClQFcvKxZ+AXw11Je
        YmaHNQr0zuCkBEoJ5dDzIw9rGX8CE0RWfYrgEeDUOKP9ZhQ8NSIY+69fx/9ydpME
        pTEm7nk8i0MPgl6uRoVGU/3DLVtmY9HRB+uHBxDTUOT+RS/156ZvZJBYbm5QANVy
        EbIDU10rzjuvU8sSPKGb1AvOYNEgaq5TrpKUA3+/mkLtaO4mPNobb4LvbTgC2wIQ
        McxnW9p/SLpkynEP5TcTAKcJGE7RKldfAeqXghwRSVw1nTozSQhi7wtyCHBe/XsG
        DCX9PpxNd47uWNO+UxGVDf4cqYAk6+zS7fByy3BvAcc+z24kn5Ojchsvsm+brchg
        ==
X-ME-Sender: <xms:OP08Xwgq47fdoS7H85U1BF30FvYGMblyAwjYYHvgTVQ39OpZIkVIfQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:OP08X5Ax0lq4tIhMbknT1-UiiC6P1iHYc5qqDINZBsPsOwoylzRirA>
    <xmx:OP08X4HSJgwO0KCsEdQ7Uyhz_iNlFSqGijhj9wfPQ0jE82fb-hL1Tw>
    <xmx:OP08XxTzdj8MPhT8vrErBhUwPihnXpmrGWNwHdOF5mYUfKrSydCxew>
    <xmx:OP08X-rMibgEVyXenVRXM9-Y_eEqPG-KW-L8GnfCxJaLAf5gNhucqg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22600328005A;
        Wed, 19 Aug 2020 06:21:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI/ATS: Add pci_pri_supported() to check device or" failed to apply to 4.4-stable tree
To:     ashok.raj@intel.com, baolu.lu@linux.intel.com, bhelgaas@google.com,
        jroedel@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 12:22:01 +0200
Message-ID: <15978325219771@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

