Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106F6312ED6
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhBHKVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:21:41 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51893 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232056AbhBHKTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:19:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 608DFA17;
        Mon,  8 Feb 2021 05:18:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:18:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=A3gB1u
        6ut5CWrqV5Awt2yedhXsenGVUWrGtdTdyZsrI=; b=HYTZdGclY6AtB77kumHntL
        Ot8dxB9mVJuXXTRRYOMeOzVlnbh4SAPPW5aR/o8fpFn2R9ul3XvFD2nDK+PfXroZ
        PhqWV/XUrURbhhD/u0yWHp6ZKrDk6ADBkMRDr7ShfDdHPuTabOXuZyPVcahm5Ibz
        PDcV7XZytcBUMGpfVj2R6s8dfV+Oxgl6KOdDxT5MyslmOcKk7TSDAJoeR0X0dxzq
        8gaYikBZEK3bYlGzcwhM2VehxtWWvhEcMHrib6zTFbNpKdx+1ZWCFh4uuZwLOW1I
        R/jbAFAhv6nn+0lO2E9uvCdZg465+4NeOssbzhwrqQlJXJKq83tdvBi2ah+gyqgg
        ==
X-ME-Sender: <xms:BBAhYB1zQUIzUyxCkBv7uXdSUkXC56UJxPHGAOuoJtOZv4TCHBF0vw>
    <xme:BBAhYIEt_I-R2BJivQqYtllqkHvVy8W8uFEGIKWk4Dd5dU1DEOt0jd-4FImFPoHkJ
    RxGT57WV7ig1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:BBAhYB6ejadiqQqrd0ptLDSgvTknsDa7FJ_LeRh9_kFQKrUt9uipiQ>
    <xmx:BBAhYO2y5p9rGfXTJdiDWWuSQlcbCnqE5W1zNlrtARvsNeYZCAdsNQ>
    <xmx:BBAhYEHhug7IqTinoJMU4YUUScZImZSgww7jLUeDZwOiWbeuD3a95w>
    <xmx:BRAhYONOdhCDAAxwYEn6JrhAtP42pvX-DWcwobsFLDPvVJsTZoPixSUJWME>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C53024005D;
        Mon,  8 Feb 2021 05:18:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] genirq/msi: Activate Multi-MSI early when" failed to apply to 4.4-stable tree
To:     maz@kernel.org, shameerali.kolothum.thodi@huawei.com,
        tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:18:34 +0100
Message-ID: <161277951429100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

