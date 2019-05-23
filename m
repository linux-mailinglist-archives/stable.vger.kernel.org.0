Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA2927B0B
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 12:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfEWKtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 06:49:06 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43423 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbfEWKtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 06:49:06 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1837537531;
        Thu, 23 May 2019 06:49:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 23 May 2019 06:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ufVWph
        7qoohbSmNuEiI8CBtU9F14O5V7/W+ue6LmTVM=; b=dSslBjHu06PkGcJUQoG0PL
        izwPt4nPub2bD7HJ9WCzXu4lCA/oxU/PA2PmeThk1XUkl1/nVXiRtKl8MnA2iylH
        KkJx662LsqONh1HCr7pQf3Zqu3mLRI2vH2NodMhDmG3roWpuMUU2zIcSxDSPANLf
        HMdTGsPkH6w5JMeIAPz+hOWHfSFGkXybXo0VqMJsc7ddi96wQweLMAXKzMnHWEbO
        ISYa/a+BAiSr5fObimu/AXZkFEj1P9eQwyZxXE4OpBmVNpr3pdAwzw0ItLkmQ8Gs
        /RKwoZmGrCINSwDABvo0D8c/VuGP3xv3i2VzgtNy/JJiJ+eG6k/pFj0kOuFQAvNg
        ==
X-ME-Sender: <xms:oHrmXPRER6B8E4MPBChSTcmb9zMEZ3LTPMk6J6Ylr1CeoGkrQ7o3mg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:oHrmXG5wDg0usxLI1KVaIl_Wztzcrbxq3qVr73ONl3AnbwnXFzOiTg>
    <xmx:oHrmXBli3nY_RAmgg4Jn529wdKDfmUBJnYcVe8_TI2v4JD5nbSkN6A>
    <xmx:oHrmXE7gaPUCRNrumKtFySAk8NhYVNcjnTnU0ZbbG2b0NTC9Z2EF2w>
    <xmx:oXrmXDqHXWrZgYo_X9FupAa97M4FVnc05hXmPTAgh2UgD_P6qyZBqQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C5B3380088;
        Thu, 23 May 2019 06:49:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: dwc: Use devm_pci_alloc_host_bridge() to simplify code" failed to apply to 4.19-stable tree
To:     Jisheng.Zhang@synaptics.com, bhelgaas@google.com,
        gustavo.pimentel@synopsys.com, lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 12:48:55 +0200
Message-ID: <155860853518214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
 

