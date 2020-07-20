Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1037225E96
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgGTMcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:32:20 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:47557 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728290AbgGTMcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:32:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8F74719404CD;
        Mon, 20 Jul 2020 08:32:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZP1bWd
        oJMKdsc1UJQB6K/QSOleIGlz6GP3dA3bIW0vQ=; b=UqKCInesqsq8TmJlbGu/Je
        U3+qJSthSidliArDc/cJdR8ZCweEdclnI96qSvP4GWPOBmRYz8KCr9Iua2tcj/Xe
        zuhz0vZpZDwSC8r0DhnmtMJdZ5z5V8euQzO71smOEsiuKJb9K1SoLEKE6GKt1OZx
        BT/q6KqfOEZUW4XMTF6RDeVEOAOVdcQa+Gyazr1mvPXilZBMFpV3a9ot2CAlt1Y/
        JySBC0xq6D2NYBbHWzFbSnMvQi6DCQ09PC5C4Q+OcJCk6ynsUHz3wzRmmvzkwDGc
        y7ZF/V+1sw9EViXU5E2HrtFMGhZuOMclnf6QjT/G4FIvvCO3J67d+bAU19hii+jA
        ==
X-ME-Sender: <xms:0Y4VX6C6hAqg28jIv0KOJHN6pGQvVVZWSGnVMws5VfUwtKUeSQiw1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0Y4VX0hSpc0JA0O4LIXDo3KVCHwyWJNDdb7jP8ZsJHaz-nqbKUMu8Q>
    <xmx:0Y4VX9kQEVmJB5myoBBM26YOsxlP3GVs4jIWnHlFPxKEMVra2ivTpw>
    <xmx:0Y4VX4yOVjyhtaO_AY9oRugB_LZeJ9MI2BZx9gIDJ_G-zu9Ou0E9zQ>
    <xmx:0o4VX2JfRDNHC8C5oURSImgaAfmE74BL_RUthSk1FJ3Pl9a_Q1QSTA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 877AE30600A9;
        Mon, 20 Jul 2020 08:32:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] irqdomain/treewide: Keep firmware node unconditionally" failed to apply to 5.7-stable tree
To:     tglx@linutronix.de, andriy.shevchenko@linux.intel.com,
        bhelgaas@google.com, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:32:27 +0200
Message-ID: <159524834772169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e3beca48a45b5e0e6e6a4e0124276b8248dcc9bb Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 9 Jul 2020 11:53:06 +0200
Subject: [PATCH] irqdomain/treewide: Keep firmware node unconditionally
 allocated

Quite some non OF/ACPI users of irqdomains allocate firmware nodes of type
IRQCHIP_FWNODE_NAMED or IRQCHIP_FWNODE_NAMED_ID and free them right after
creating the irqdomain. The only purpose of these FW nodes is to convey
name information. When this was introduced the core code did not store the
pointer to the node in the irqdomain. A recent change stored the firmware
node pointer in irqdomain for other reasons and missed to notice that the
usage sites which do the alloc_fwnode/create_domain/free_fwnode sequence
are broken by this. Storing a dangling pointer is dangerous itself, but in
case that the domain is destroyed later on this leads to a double free.

Remove the freeing of the firmware node after creating the irqdomain from
all affected call sites to cure this.

Fixes: 711419e504eb ("irqdomain: Add the missing assignment of domain->fwnode for named fwnode")
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/873661qakd.fsf@nanos.tec.linutronix.de

diff --git a/arch/mips/pci/pci-xtalk-bridge.c b/arch/mips/pci/pci-xtalk-bridge.c
index 3b2552fb7735..5958217861b8 100644
--- a/arch/mips/pci/pci-xtalk-bridge.c
+++ b/arch/mips/pci/pci-xtalk-bridge.c
@@ -627,9 +627,10 @@ static int bridge_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	domain = irq_domain_create_hierarchy(parent, 0, 8, fn,
 					     &bridge_domain_ops, NULL);
-	irq_domain_free_fwnode(fn);
-	if (!domain)
+	if (!domain) {
+		irq_domain_free_fwnode(fn);
 		return -ENOMEM;
+	}
 
 	pci_set_flags(PCI_PROBE_ONLY);
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ce61e3e7d399..81ffcfbfaef2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2316,12 +2316,12 @@ static int mp_irqdomain_create(int ioapic)
 	ip->irqdomain = irq_domain_create_linear(fn, hwirqs, cfg->ops,
 						 (void *)(long)ioapic);
 
-	/* Release fw handle if it was allocated above */
-	if (!cfg->dev)
-		irq_domain_free_fwnode(fn);
-
-	if (!ip->irqdomain)
+	if (!ip->irqdomain) {
+		/* Release fw handle if it was allocated above */
+		if (!cfg->dev)
+			irq_domain_free_fwnode(fn);
 		return -ENOMEM;
+	}
 
 	ip->irqdomain->parent = parent;
 
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 5cbaca58af95..c2b2911feeef 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -263,12 +263,13 @@ void __init arch_init_msi_domain(struct irq_domain *parent)
 		msi_default_domain =
 			pci_msi_create_irq_domain(fn, &pci_msi_domain_info,
 						  parent);
-		irq_domain_free_fwnode(fn);
 	}
-	if (!msi_default_domain)
+	if (!msi_default_domain) {
+		irq_domain_free_fwnode(fn);
 		pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
-	else
+	} else {
 		msi_default_domain->flags |= IRQ_DOMAIN_MSI_NOMASK_QUIRK;
+	}
 }
 
 #ifdef CONFIG_IRQ_REMAP
@@ -301,7 +302,8 @@ struct irq_domain *arch_create_remap_msi_irq_domain(struct irq_domain *parent,
 	if (!fn)
 		return NULL;
 	d = pci_msi_create_irq_domain(fn, &pci_msi_ir_domain_info, parent);
-	irq_domain_free_fwnode(fn);
+	if (!d)
+		irq_domain_free_fwnode(fn);
 	return d;
 }
 #endif
@@ -364,7 +366,8 @@ static struct irq_domain *dmar_get_irq_domain(void)
 	if (fn) {
 		dmar_domain = msi_create_irq_domain(fn, &dmar_msi_domain_info,
 						    x86_vector_domain);
-		irq_domain_free_fwnode(fn);
+		if (!dmar_domain)
+			irq_domain_free_fwnode(fn);
 	}
 out:
 	mutex_unlock(&dmar_lock);
@@ -489,7 +492,10 @@ struct irq_domain *hpet_create_irq_domain(int hpet_id)
 	}
 
 	d = msi_create_irq_domain(fn, domain_info, parent);
-	irq_domain_free_fwnode(fn);
+	if (!d) {
+		irq_domain_free_fwnode(fn);
+		kfree(domain_info);
+	}
 	return d;
 }
 
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index c48be6e1f676..cc8b16f89dd4 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -709,7 +709,6 @@ int __init arch_early_irq_init(void)
 	x86_vector_domain = irq_domain_create_tree(fn, &x86_vector_domain_ops,
 						   NULL);
 	BUG_ON(x86_vector_domain == NULL);
-	irq_domain_free_fwnode(fn);
 	irq_set_default_host(x86_vector_domain);
 
 	arch_init_msi_domain(x86_vector_domain);
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index fc13cbbb2dce..abb6075397f0 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -167,9 +167,10 @@ static struct irq_domain *uv_get_irq_domain(void)
 		goto out;
 
 	uv_domain = irq_domain_create_tree(fn, &uv_domain_ops, NULL);
-	irq_domain_free_fwnode(fn);
 	if (uv_domain)
 		uv_domain->parent = x86_vector_domain;
+	else
+		irq_domain_free_fwnode(fn);
 out:
 	mutex_unlock(&uv_lock);
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 74cca1757172..2f22326ee4df 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3985,9 +3985,10 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
 	if (!fn)
 		return -ENOMEM;
 	iommu->ir_domain = irq_domain_create_tree(fn, &amd_ir_domain_ops, iommu);
-	irq_domain_free_fwnode(fn);
-	if (!iommu->ir_domain)
+	if (!iommu->ir_domain) {
+		irq_domain_free_fwnode(fn);
 		return -ENOMEM;
+	}
 
 	iommu->ir_domain->parent = arch_get_ir_parent_domain();
 	iommu->msi_domain = arch_create_remap_msi_irq_domain(iommu->ir_domain,
diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index 3c0c67a99c7b..8919c1c70b68 100644
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -155,7 +155,10 @@ static int __init hyperv_prepare_irq_remapping(void)
 				0, IOAPIC_REMAPPING_ENTRY, fn,
 				&hyperv_ir_domain_ops, NULL);
 
-	irq_domain_free_fwnode(fn);
+	if (!ioapic_ir_domain) {
+		irq_domain_free_fwnode(fn);
+		return -ENOMEM;
+	}
 
 	/*
 	 * Hyper-V doesn't provide irq remapping function for
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 7f8769800815..9564d23d094f 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -563,8 +563,8 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 					    0, INTR_REMAP_TABLE_ENTRIES,
 					    fn, &intel_ir_domain_ops,
 					    iommu);
-	irq_domain_free_fwnode(fn);
 	if (!iommu->ir_domain) {
+		irq_domain_free_fwnode(fn);
 		pr_err("IR%d: failed to allocate irqdomain\n", iommu->seq_id);
 		goto out_free_bitmap;
 	}
diff --git a/drivers/mfd/ioc3.c b/drivers/mfd/ioc3.c
index 02998d4eb74b..74cee7cb0afc 100644
--- a/drivers/mfd/ioc3.c
+++ b/drivers/mfd/ioc3.c
@@ -142,10 +142,11 @@ static int ioc3_irq_domain_setup(struct ioc3_priv_data *ipd, int irq)
 		goto err;
 
 	domain = irq_domain_create_linear(fn, 24, &ioc3_irq_domain_ops, ipd);
-	if (!domain)
+	if (!domain) {
+		irq_domain_free_fwnode(fn);
 		goto err;
+	}
 
-	irq_domain_free_fwnode(fn);
 	ipd->domain = domain;
 
 	irq_set_chained_handler_and_data(irq, ioc3_irq_handler, domain);
diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index e386d4eac407..9a64cf90c291 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -546,9 +546,10 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 
 	vmd->irq_domain = pci_msi_create_irq_domain(fn, &vmd_msi_domain_info,
 						    x86_vector_domain);
-	irq_domain_free_fwnode(fn);
-	if (!vmd->irq_domain)
+	if (!vmd->irq_domain) {
+		irq_domain_free_fwnode(fn);
 		return -ENODEV;
+	}
 
 	pci_add_resource(&resources, &vmd->resources[0]);
 	pci_add_resource_offset(&resources, &vmd->resources[1], offset[0]);

