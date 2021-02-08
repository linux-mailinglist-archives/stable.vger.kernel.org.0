Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8369312ED3
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhBHKVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:21:37 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:37885 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231463AbhBHKT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:19:26 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 01DF8A2E;
        Mon,  8 Feb 2021 05:18:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:18:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=psJTlP
        NhPDub1JYwuRjMhwLZ+ni/Ki7CdSWcKQCMyXU=; b=j7+y5KsZ8Y0dl6MKjIFb+3
        OcamJc0YSy7QmO5f6MFqZscDqtLZ0XOvqgSSjayfGpESR+9V4BiyB+ANFLYl9BZR
        LLl/cPn9539S00FZZtZ6zrkZ27b0MhTADQTXSaZVE5nylfjq6hu47tGJhcNkmdqX
        5CfZnfA2Rl3CRvBdfS1ICxpR1enJL49ZMQeKnRcNQ1E7L+3xl1RRogSnoqRVfcH4
        JyiovSdPZGyUMpl3XC+oNY+uhkpqadyu2k5Qd32vmALnw6TwXftwYbVZmZCi8ROo
        wwsd/3jGzoNeY+xns4EjP8WJQIYs8a0qfsVKEHBnxN0RYR8TIt4f5E4rg6mlTZtQ
        ==
X-ME-Sender: <xms:-g8hYJ6ggKLibvBNMvyVyTrwQNj_slpZbXucLh2qyJCwtmHD7eSAHA>
    <xme:-g8hYG5zsB5D24kpanHfU6Bz-WYvw4EChanpTYhdYlkSaafLsteCysiBB1McLXnC8
    p8bjcXOr-3H2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:-g8hYAdSnl0ywZR6lQwc2QDmt_2AD7rz32a1TrHvMkrWtMw49KK3bg>
    <xmx:-g8hYCKjcg9I_RJzp1I1dmmR8l5KU4MxFdUyVrHVWo8I42UFO6-RnQ>
    <xmx:-g8hYNLF-60oQdRZlX0G-IxPR-MS2DvBWfylWR3S9AzBqiLEOTf78w>
    <xmx:-w8hYLgwWv5M42se244IivdGrqPpTNOTkgnAeYsX0XjqKXOA37ILw8O8VqA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 79C6024005C;
        Mon,  8 Feb 2021 05:18:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] genirq/msi: Activate Multi-MSI early when" failed to apply to 4.14-stable tree
To:     maz@kernel.org, shameerali.kolothum.thodi@huawei.com,
        tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:18:32 +0100
Message-ID: <16127795123211@kroah.com>
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

From 4c457e8cb75eda91906a4f89fc39bde3f9a43922 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Sat, 23 Jan 2021 12:27:59 +0000
Subject: [PATCH] genirq/msi: Activate Multi-MSI early when
 MSI_FLAG_ACTIVATE_EARLY is set

When MSI_FLAG_ACTIVATE_EARLY is set (which is the case for PCI),
__msi_domain_alloc_irqs() performs the activation of the interrupt (which
in the case of PCI results in the endpoint being programmed) as soon as the
interrupt is allocated.

But it appears that this is only done for the first vector, introducing an
inconsistent behaviour for PCI Multi-MSI.

Fix it by iterating over the number of vectors allocated to each MSI
descriptor. This is easily achieved by introducing a new
"for_each_msi_vector" iterator, together with a tiny bit of refactoring.

Fixes: f3b0946d629c ("genirq/msi: Make sure PCI MSIs are activated early")
Reported-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210123122759.1781359-1-maz@kernel.org

diff --git a/include/linux/msi.h b/include/linux/msi.h
index 360a0a7e7341..aef35fd1cf11 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -178,6 +178,12 @@ struct msi_desc {
 	list_for_each_entry((desc), dev_to_msi_list((dev)), list)
 #define for_each_msi_entry_safe(desc, tmp, dev)	\
 	list_for_each_entry_safe((desc), (tmp), dev_to_msi_list((dev)), list)
+#define for_each_msi_vector(desc, __irq, dev)				\
+	for_each_msi_entry((desc), (dev))				\
+		if ((desc)->irq)					\
+			for (__irq = (desc)->irq;			\
+			     __irq < ((desc)->irq + (desc)->nvec_used);	\
+			     __irq++)
 
 #ifdef CONFIG_IRQ_MSI_IOMMU
 static inline const void *msi_desc_get_iommu_cookie(struct msi_desc *desc)
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index dc0e2d7fbdfd..b338d622f26e 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -436,22 +436,22 @@ int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 
 	can_reserve = msi_check_reservation_mode(domain, info, dev);
 
-	for_each_msi_entry(desc, dev) {
-		virq = desc->irq;
-		if (desc->nvec_used == 1)
-			dev_dbg(dev, "irq %d for MSI\n", virq);
-		else
+	/*
+	 * This flag is set by the PCI layer as we need to activate
+	 * the MSI entries before the PCI layer enables MSI in the
+	 * card. Otherwise the card latches a random msi message.
+	 */
+	if (!(info->flags & MSI_FLAG_ACTIVATE_EARLY))
+		goto skip_activate;
+
+	for_each_msi_vector(desc, i, dev) {
+		if (desc->irq == i) {
+			virq = desc->irq;
 			dev_dbg(dev, "irq [%d-%d] for MSI\n",
 				virq, virq + desc->nvec_used - 1);
-		/*
-		 * This flag is set by the PCI layer as we need to activate
-		 * the MSI entries before the PCI layer enables MSI in the
-		 * card. Otherwise the card latches a random msi message.
-		 */
-		if (!(info->flags & MSI_FLAG_ACTIVATE_EARLY))
-			continue;
+		}
 
-		irq_data = irq_domain_get_irq_data(domain, desc->irq);
+		irq_data = irq_domain_get_irq_data(domain, i);
 		if (!can_reserve) {
 			irqd_clr_can_reserve(irq_data);
 			if (domain->flags & IRQ_DOMAIN_MSI_NOMASK_QUIRK)
@@ -462,28 +462,24 @@ int __msi_domain_alloc_irqs(struct irq_domain *domain, struct device *dev,
 			goto cleanup;
 	}
 
+skip_activate:
 	/*
 	 * If these interrupts use reservation mode, clear the activated bit
 	 * so request_irq() will assign the final vector.
 	 */
 	if (can_reserve) {
-		for_each_msi_entry(desc, dev) {
-			irq_data = irq_domain_get_irq_data(domain, desc->irq);
+		for_each_msi_vector(desc, i, dev) {
+			irq_data = irq_domain_get_irq_data(domain, i);
 			irqd_clr_activated(irq_data);
 		}
 	}
 	return 0;
 
 cleanup:
-	for_each_msi_entry(desc, dev) {
-		struct irq_data *irqd;
-
-		if (desc->irq == virq)
-			break;
-
-		irqd = irq_domain_get_irq_data(domain, desc->irq);
-		if (irqd_is_activated(irqd))
-			irq_domain_deactivate_irq(irqd);
+	for_each_msi_vector(desc, i, dev) {
+		irq_data = irq_domain_get_irq_data(domain, i);
+		if (irqd_is_activated(irq_data))
+			irq_domain_deactivate_irq(irq_data);
 	}
 	msi_domain_free_irqs(domain, dev);
 	return ret;

