Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D678B27B0C
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 12:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfEWKtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 06:49:08 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53329 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbfEWKtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 06:49:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BA4C2376D3;
        Thu, 23 May 2019 06:49:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 23 May 2019 06:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=APoy7K
        qlUqvI9Yqt0eqOFijNrY7ZWc8J8wHBov85+ho=; b=5c5TCp3v7B9gWR7uSi/HOQ
        SrqAApqNPs+SqZy7rwwnxDROfHk8DLPJJeBm1Uzq6JtcDA20SrTj4J1wkte1LUzs
        4ek3pGj28R1CSO4YJmnGhiTay3lbWEpsZOHa4MrjURfKuOqLJZD6kO5xCWScjudD
        xdORcJNzVavA9ka/gOsD/etKxpGWKnH12ScKe5zOekGSzvboIp55UTX5lv0Xyc7a
        dR9OxIypJ+YdDT54IKFoZjS8l1/3FKOxzBLFepJNVpBIgCkxiJZ+hKGQJfgPciKk
        vNZ9eQk4fS8ii6Th+aaaqo4IMmE1njLL6U1kREkSkt6L5l3pYyQNVT+LZEEt5xrA
        ==
X-ME-Sender: <xms:onrmXN5NeQC96Q8m_Q2sd3eY0fp2uH-52O5c0mHp2cLR2NLW3x7GEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:onrmXDL2p0__YMBRCYUPXgIP7HMRWcMW4eW6Hj4gEPMqrIYmkorvgg>
    <xmx:onrmXCQiN6sTFPhUHLwdH8d1O9c9ehIQHXrLODU9DCgx8B9jz9Eelw>
    <xmx:onrmXLElL3V_uROq-d4iT4F-x263AVAVBDDmyMmg2nnrX7ZVJnC36g>
    <xmx:onrmXI7xtgJFSZ_JhGUtTlIjTbFq4xbHl_Og5lq4dDvdbq2dXMAmng>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E0F680061;
        Thu, 23 May 2019 06:49:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: dwc: Use devm_pci_alloc_host_bridge() to simplify code" failed to apply to 4.14-stable tree
To:     Jisheng.Zhang@synaptics.com, bhelgaas@google.com,
        gustavo.pimentel@synopsys.com, lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 12:48:55 +0200
Message-ID: <1558608535246217@kroah.com>
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

From e6fdd3bf5aecd8615f31a5128775b9abcf3e0d86 Mon Sep 17 00:00:00 2001
From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Fri, 29 Mar 2019 11:58:53 +0000
Subject: [PATCH] PCI: dwc: Use devm_pci_alloc_host_bridge() to simplify code

Use devm_pci_alloc_host_bridge() to simplify the error code path.  This
also fixes a leak in the dw_pcie_host_init() error path.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Gustavo Pimentel <gustavo.pimentel@synopsys.com>
CC: stable@vger.kernel.org	# v4.13+

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index acc9be5cf34a..dcc7405aff9a 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -358,7 +358,7 @@ int dw_pcie_host_init(struct pcie_port *pp)
 		dev_err(dev, "Missing *config* reg space\n");
 	}
 
-	bridge = pci_alloc_host_bridge(0);
+	bridge = devm_pci_alloc_host_bridge(dev, 0);
 	if (!bridge)
 		return -ENOMEM;
 
@@ -369,7 +369,7 @@ int dw_pcie_host_init(struct pcie_port *pp)
 
 	ret = devm_request_pci_bus_resources(dev, &bridge->windows);
 	if (ret)
-		goto error;
+		return ret;
 
 	/* Get the I/O and memory ranges from DT */
 	resource_list_for_each_entry_safe(win, tmp, &bridge->windows) {
@@ -413,8 +413,7 @@ int dw_pcie_host_init(struct pcie_port *pp)
 						resource_size(pp->cfg));
 		if (!pci->dbi_base) {
 			dev_err(dev, "Error with ioremap\n");
-			ret = -ENOMEM;
-			goto error;
+			return -ENOMEM;
 		}
 	}
 
@@ -425,8 +424,7 @@ int dw_pcie_host_init(struct pcie_port *pp)
 					pp->cfg0_base, pp->cfg0_size);
 		if (!pp->va_cfg0_base) {
 			dev_err(dev, "Error with ioremap in function\n");
-			ret = -ENOMEM;
-			goto error;
+			return -ENOMEM;
 		}
 	}
 
@@ -436,8 +434,7 @@ int dw_pcie_host_init(struct pcie_port *pp)
 						pp->cfg1_size);
 		if (!pp->va_cfg1_base) {
 			dev_err(dev, "Error with ioremap\n");
-			ret = -ENOMEM;
-			goto error;
+			return -ENOMEM;
 		}
 	}
 
@@ -460,14 +457,14 @@ int dw_pcie_host_init(struct pcie_port *pp)
 			    pp->num_vectors == 0) {
 				dev_err(dev,
 					"Invalid number of vectors\n");
-				goto error;
+				return -EINVAL;
 			}
 		}
 
 		if (!pp->ops->msi_host_init) {
 			ret = dw_pcie_allocate_domains(pp);
 			if (ret)
-				goto error;
+				return ret;
 
 			if (pp->msi_irq)
 				irq_set_chained_handler_and_data(pp->msi_irq,
@@ -476,7 +473,7 @@ int dw_pcie_host_init(struct pcie_port *pp)
 		} else {
 			ret = pp->ops->msi_host_init(pp);
 			if (ret < 0)
-				goto error;
+				return ret;
 		}
 	}
 
@@ -516,8 +513,6 @@ int dw_pcie_host_init(struct pcie_port *pp)
 err_free_msi:
 	if (pci_msi_enabled() && !pp->ops->msi_host_init)
 		dw_pcie_free_msi(pp);
-error:
-	pci_free_host_bridge(bridge);
 	return ret;
 }
 

