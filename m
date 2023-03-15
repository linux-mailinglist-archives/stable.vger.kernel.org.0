Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852606BB0EF
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbjCOMXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbjCOMWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:22:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82CB97FF6;
        Wed, 15 Mar 2023 05:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07065B81E02;
        Wed, 15 Mar 2023 12:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B70C433EF;
        Wed, 15 Mar 2023 12:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882898;
        bh=OYvFb206puK8rZA/fcMkpfco5uf6yFXDZzVU7DdC0BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFSP8PRDrWRgk4b1aBdGDXagvD0PM0WstQe5p8UlZnBWm4AXNkaDd6I53hZsrbivQ
         gKo7k/fQIHB9LZFY5nB+WYCDUb0Qg83LjTUcGdHQCg1/Qc3R9/zDTZ5xhYFCNF+CFq
         +jrIGXjyF2Q9/b2W+Za2UIyaE8hWbIyJLI3IUxVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 014/104] irq: Fix typos in comments
Date:   Wed, 15 Mar 2023 13:11:45 +0100
Message-Id: <20230315115732.633991365@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit a359f757965aafd0f58570de95dc6bc06cf12a9c ]

Fix ~36 single-word typos in the IRQ, irqchip and irqdomain code comments.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Stable-dep-of: 6e6f75c9c98d ("irqdomain: Look for existing mapping only once")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-aspeed-vic.c       |  4 ++--
 drivers/irqchip/irq-bcm7120-l2.c       |  2 +-
 drivers/irqchip/irq-csky-apb-intc.c    |  2 +-
 drivers/irqchip/irq-gic-v2m.c          |  2 +-
 drivers/irqchip/irq-gic-v3-its.c       | 10 +++++-----
 drivers/irqchip/irq-gic-v3.c           |  2 +-
 drivers/irqchip/irq-loongson-pch-pic.c |  2 +-
 drivers/irqchip/irq-meson-gpio.c       |  2 +-
 drivers/irqchip/irq-mtk-cirq.c         |  2 +-
 drivers/irqchip/irq-mxs.c              |  4 ++--
 drivers/irqchip/irq-sun4i.c            |  2 +-
 drivers/irqchip/irq-ti-sci-inta.c      |  2 +-
 drivers/irqchip/irq-vic.c              |  4 ++--
 drivers/irqchip/irq-xilinx-intc.c      |  2 +-
 include/linux/irq.h                    |  4 ++--
 include/linux/irqdesc.h                |  2 +-
 kernel/irq/chip.c                      |  2 +-
 kernel/irq/dummychip.c                 |  2 +-
 kernel/irq/irqdesc.c                   |  2 +-
 kernel/irq/irqdomain.c                 |  8 ++++----
 kernel/irq/manage.c                    |  6 +++---
 kernel/irq/msi.c                       |  2 +-
 kernel/irq/timings.c                   |  2 +-
 23 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/irqchip/irq-aspeed-vic.c b/drivers/irqchip/irq-aspeed-vic.c
index 6567ed782f82c..58717cd44f99f 100644
--- a/drivers/irqchip/irq-aspeed-vic.c
+++ b/drivers/irqchip/irq-aspeed-vic.c
@@ -71,7 +71,7 @@ static void vic_init_hw(struct aspeed_vic *vic)
 	writel(0, vic->base + AVIC_INT_SELECT);
 	writel(0, vic->base + AVIC_INT_SELECT + 4);
 
-	/* Some interrupts have a programable high/low level trigger
+	/* Some interrupts have a programmable high/low level trigger
 	 * (4 GPIO direct inputs), for now we assume this was configured
 	 * by firmware. We read which ones are edge now.
 	 */
@@ -203,7 +203,7 @@ static int __init avic_of_init(struct device_node *node,
 	}
 	vic->base = regs;
 
-	/* Initialize soures, all masked */
+	/* Initialize sources, all masked */
 	vic_init_hw(vic);
 
 	/* Ready to receive interrupts */
diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index 7d776c905b7d2..1c2c5bd5a9fc1 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -310,7 +310,7 @@ static int __init bcm7120_l2_intc_probe(struct device_node *dn,
 
 		if (data->can_wake) {
 			/* This IRQ chip can wake the system, set all
-			 * relevant child interupts in wake_enabled mask
+			 * relevant child interrupts in wake_enabled mask
 			 */
 			gc->wake_enabled = 0xffffffff;
 			gc->wake_enabled &= ~gc->unused;
diff --git a/drivers/irqchip/irq-csky-apb-intc.c b/drivers/irqchip/irq-csky-apb-intc.c
index 5a2ec43b7ddd4..ab91afa867557 100644
--- a/drivers/irqchip/irq-csky-apb-intc.c
+++ b/drivers/irqchip/irq-csky-apb-intc.c
@@ -176,7 +176,7 @@ gx_intc_init(struct device_node *node, struct device_node *parent)
 	writel(0x0, reg_base + GX_INTC_NEN63_32);
 
 	/*
-	 * Initial mask reg with all unmasked, because we only use enalbe reg
+	 * Initial mask reg with all unmasked, because we only use enable reg
 	 */
 	writel(0x0, reg_base + GX_INTC_NMASK31_00);
 	writel(0x0, reg_base + GX_INTC_NMASK63_32);
diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index fbec07d634ad2..4116b48e60aff 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -371,7 +371,7 @@ static int __init gicv2m_init_one(struct fwnode_handle *fwnode,
 	 * the MSI data is the absolute value within the range from
 	 * spi_start to (spi_start + num_spis).
 	 *
-	 * Broadom NS2 GICv2m implementation has an erratum where the MSI data
+	 * Broadcom NS2 GICv2m implementation has an erratum where the MSI data
 	 * is 'spi_number - 32'
 	 *
 	 * Reading that register fails on the Graviton implementation
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index d8cb5bcd6b10e..5ec091c64d47f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -1492,7 +1492,7 @@ static void its_vlpi_set_doorbell(struct irq_data *d, bool enable)
 	 *
 	 * Ideally, we'd issue a VMAPTI to set the doorbell to its LPI
 	 * value or to 1023, depending on the enable bit. But that
-	 * would be issueing a mapping for an /existing/ DevID+EventID
+	 * would be issuing a mapping for an /existing/ DevID+EventID
 	 * pair, which is UNPREDICTABLE. Instead, let's issue a VMOVI
 	 * to the /same/ vPE, using this opportunity to adjust the
 	 * doorbell. Mouahahahaha. We loves it, Precious.
@@ -3122,7 +3122,7 @@ static void its_cpu_init_lpis(void)
 
 		/*
 		 * It's possible for CPU to receive VLPIs before it is
-		 * sheduled as a vPE, especially for the first CPU, and the
+		 * scheduled as a vPE, especially for the first CPU, and the
 		 * VLPI with INTID larger than 2^(IDbits+1) will be considered
 		 * as out of range and dropped by GIC.
 		 * So we initialize IDbits to known value to avoid VLPI drop.
@@ -3613,7 +3613,7 @@ static void its_irq_domain_free(struct irq_domain *domain, unsigned int virq,
 
 	/*
 	 * If all interrupts have been freed, start mopping the
-	 * floor. This is conditionned on the device not being shared.
+	 * floor. This is conditioned on the device not being shared.
 	 */
 	if (!its_dev->shared &&
 	    bitmap_empty(its_dev->event_map.lpi_map,
@@ -4187,7 +4187,7 @@ static int its_sgi_set_affinity(struct irq_data *d,
 {
 	/*
 	 * There is no notion of affinity for virtual SGIs, at least
-	 * not on the host (since they can only be targetting a vPE).
+	 * not on the host (since they can only be targeting a vPE).
 	 * Tell the kernel we've done whatever it asked for.
 	 */
 	irq_data_update_effective_affinity(d, mask_val);
@@ -4232,7 +4232,7 @@ static int its_sgi_get_irqchip_state(struct irq_data *d,
 	/*
 	 * Locking galore! We can race against two different events:
 	 *
-	 * - Concurent vPE affinity change: we must make sure it cannot
+	 * - Concurrent vPE affinity change: we must make sure it cannot
 	 *   happen, or we'll talk to the wrong redistributor. This is
 	 *   identical to what happens with vLPIs.
 	 *
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 4c8f18f0cecf8..2805969e4f15a 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1456,7 +1456,7 @@ static int gic_irq_domain_translate(struct irq_domain *d,
 
 		/*
 		 * Make it clear that broken DTs are... broken.
-		 * Partitionned PPIs are an unfortunate exception.
+		 * Partitioned PPIs are an unfortunate exception.
 		 */
 		WARN_ON(*type == IRQ_TYPE_NONE &&
 			fwspec->param[0] != GIC_IRQ_TYPE_PARTITION);
diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
index 90e1ad6e36120..a4eb8a2181c7f 100644
--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -180,7 +180,7 @@ static void pch_pic_reset(struct pch_pic *priv)
 	int i;
 
 	for (i = 0; i < PIC_COUNT; i++) {
-		/* Write vectore ID */
+		/* Write vectored ID */
 		writeb(priv->ht_vec_base + i, priv->base + PCH_INT_HTVEC(i));
 		/* Hardcode route to HT0 Lo */
 		writeb(1, priv->base + PCH_INT_ROUTE(i));
diff --git a/drivers/irqchip/irq-meson-gpio.c b/drivers/irqchip/irq-meson-gpio.c
index bc7aebcc96e9c..e50676ce2ec84 100644
--- a/drivers/irqchip/irq-meson-gpio.c
+++ b/drivers/irqchip/irq-meson-gpio.c
@@ -227,7 +227,7 @@ meson_gpio_irq_request_channel(struct meson_gpio_irq_controller *ctl,
 
 	/*
 	 * Get the hwirq number assigned to this channel through
-	 * a pointer the channel_irq table. The added benifit of this
+	 * a pointer the channel_irq table. The added benefit of this
 	 * method is that we can also retrieve the channel index with
 	 * it, using the table base.
 	 */
diff --git a/drivers/irqchip/irq-mtk-cirq.c b/drivers/irqchip/irq-mtk-cirq.c
index 69ba8ce3c1785..9bca0918078e8 100644
--- a/drivers/irqchip/irq-mtk-cirq.c
+++ b/drivers/irqchip/irq-mtk-cirq.c
@@ -217,7 +217,7 @@ static void mtk_cirq_resume(void)
 {
 	u32 value;
 
-	/* flush recored interrupts, will send signals to parent controller */
+	/* flush recorded interrupts, will send signals to parent controller */
 	value = readl_relaxed(cirq_data->base + CIRQ_CONTROL);
 	writel_relaxed(value | CIRQ_FLUSH, cirq_data->base + CIRQ_CONTROL);
 
diff --git a/drivers/irqchip/irq-mxs.c b/drivers/irqchip/irq-mxs.c
index a671938fd97f6..d1f5740cd5755 100644
--- a/drivers/irqchip/irq-mxs.c
+++ b/drivers/irqchip/irq-mxs.c
@@ -58,7 +58,7 @@ struct icoll_priv {
 static struct icoll_priv icoll_priv;
 static struct irq_domain *icoll_domain;
 
-/* calculate bit offset depending on number of intterupt per register */
+/* calculate bit offset depending on number of interrupt per register */
 static u32 icoll_intr_bitshift(struct irq_data *d, u32 bit)
 {
 	/*
@@ -68,7 +68,7 @@ static u32 icoll_intr_bitshift(struct irq_data *d, u32 bit)
 	return bit << ((d->hwirq & 3) << 3);
 }
 
-/* calculate mem offset depending on number of intterupt per register */
+/* calculate mem offset depending on number of interrupt per register */
 static void __iomem *icoll_intr_reg(struct irq_data *d)
 {
 	/* offset = hwirq / intr_per_reg * 0x10 */
diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index fb78d6623556c..9ea94456b178c 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -189,7 +189,7 @@ static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
 	 * 3) spurious irq
 	 * So if we immediately get a reading of 0, check the irq-pending reg
 	 * to differentiate between 2 and 3. We only do this once to avoid
-	 * the extra check in the common case of 1 hapening after having
+	 * the extra check in the common case of 1 happening after having
 	 * read the vector-reg once.
 	 */
 	hwirq = readl(irq_ic_data->irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
diff --git a/drivers/irqchip/irq-ti-sci-inta.c b/drivers/irqchip/irq-ti-sci-inta.c
index 532d0ae172d9f..ca1f593f4d13a 100644
--- a/drivers/irqchip/irq-ti-sci-inta.c
+++ b/drivers/irqchip/irq-ti-sci-inta.c
@@ -78,7 +78,7 @@ struct ti_sci_inta_vint_desc {
  * struct ti_sci_inta_irq_domain - Structure representing a TISCI based
  *				   Interrupt Aggregator IRQ domain.
  * @sci:		Pointer to TISCI handle
- * @vint:		TISCI resource pointer representing IA inerrupts.
+ * @vint:		TISCI resource pointer representing IA interrupts.
  * @global_event:	TISCI resource pointer representing global events.
  * @vint_list:		List of the vints active in the system
  * @vint_mutex:		Mutex to protect vint_list
diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
index e460363742272..62f3d29f90420 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -163,7 +163,7 @@ static struct syscore_ops vic_syscore_ops = {
 };
 
 /**
- * vic_pm_init - initicall to register VIC pm
+ * vic_pm_init - initcall to register VIC pm
  *
  * This is called via late_initcall() to register
  * the resources for the VICs due to the early
@@ -397,7 +397,7 @@ static void __init vic_clear_interrupts(void __iomem *base)
 /*
  * The PL190 cell from ARM has been modified by ST to handle 64 interrupts.
  * The original cell has 32 interrupts, while the modified one has 64,
- * replocating two blocks 0x00..0x1f in 0x20..0x3f. In that case
+ * replicating two blocks 0x00..0x1f in 0x20..0x3f. In that case
  * the probe function is called twice, with base set to offset 000
  *  and 020 within the page. We call this "second block".
  */
diff --git a/drivers/irqchip/irq-xilinx-intc.c b/drivers/irqchip/irq-xilinx-intc.c
index 1d3d273309bd3..8cd1bfc730572 100644
--- a/drivers/irqchip/irq-xilinx-intc.c
+++ b/drivers/irqchip/irq-xilinx-intc.c
@@ -210,7 +210,7 @@ static int __init xilinx_intc_of_init(struct device_node *intc,
 
 	/*
 	 * Disable all external interrupts until they are
-	 * explicity requested.
+	 * explicitly requested.
 	 */
 	xintc_write(irqc, IER, 0);
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 607bee9271bd7..b89a8ac83d1bc 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -116,7 +116,7 @@ enum {
  * IRQ_SET_MASK_NOCPY	- OK, chip did update irq_common_data.affinity
  * IRQ_SET_MASK_OK_DONE	- Same as IRQ_SET_MASK_OK for core. Special code to
  *			  support stacked irqchips, which indicates skipping
- *			  all descendent irqchips.
+ *			  all descendant irqchips.
  */
 enum {
 	IRQ_SET_MASK_OK = 0,
@@ -302,7 +302,7 @@ static inline bool irqd_is_level_type(struct irq_data *d)
 
 /*
  * Must only be called of irqchip.irq_set_affinity() or low level
- * hieararchy domain allocation functions.
+ * hierarchy domain allocation functions.
  */
 static inline void irqd_set_single_target(struct irq_data *d)
 {
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 5745491303e03..fdb22e0f9a91e 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -32,7 +32,7 @@ struct pt_regs;
  * @last_unhandled:	aging timer for unhandled count
  * @irqs_unhandled:	stats field for spurious unhandled interrupts
  * @threads_handled:	stats field for deferred spurious detection of threaded handlers
- * @threads_handled_last: comparator field for deferred spurious detection of theraded handlers
+ * @threads_handled_last: comparator field for deferred spurious detection of threaded handlers
  * @lock:		locking for SMP
  * @affinity_hint:	hint to user space for preferred irq affinity
  * @affinity_notify:	context for notification of affinity changes
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 621d8dd157bc1..e7d284261d450 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -811,7 +811,7 @@ void handle_edge_irq(struct irq_desc *desc)
 		/*
 		 * When another irq arrived while we were handling
 		 * one, we could have masked the irq.
-		 * Renable it, if it was not disabled in meantime.
+		 * Reenable it, if it was not disabled in meantime.
 		 */
 		if (unlikely(desc->istate & IRQS_PENDING)) {
 			if (!irqd_irq_disabled(&desc->irq_data) &&
diff --git a/kernel/irq/dummychip.c b/kernel/irq/dummychip.c
index 0b0cdf206dc44..7fe6cffe7d0df 100644
--- a/kernel/irq/dummychip.c
+++ b/kernel/irq/dummychip.c
@@ -13,7 +13,7 @@
 
 /*
  * What should we do if we get a hw irq event on an illegal vector?
- * Each architecture has to answer this themself.
+ * Each architecture has to answer this themselves.
  */
 static void ack_bad(struct irq_data *data)
 {
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 9b0914a063f90..6c009a033c73f 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -31,7 +31,7 @@ static int __init irq_affinity_setup(char *str)
 	cpulist_parse(str, irq_default_affinity);
 	/*
 	 * Set at least the boot cpu. We don't want to end up with
-	 * bugreports caused by random comandline masks
+	 * bugreports caused by random commandline masks
 	 */
 	cpumask_set_cpu(smp_processor_id(), irq_default_affinity);
 	return 1;
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 1720998933f8d..fe07888a7d96a 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -53,7 +53,7 @@ EXPORT_SYMBOL_GPL(irqchip_fwnode_ops);
  * @name:	Optional user provided domain name
  * @pa:		Optional user-provided physical address
  *
- * Allocate a struct irqchip_fwid, and return a poiner to the embedded
+ * Allocate a struct irqchip_fwid, and return a pointer to the embedded
  * fwnode_handle (or NULL on failure).
  *
  * Note: The types IRQCHIP_FWNODE_NAMED and IRQCHIP_FWNODE_NAMED_ID are
@@ -657,7 +657,7 @@ unsigned int irq_create_mapping_affinity(struct irq_domain *domain,
 
 	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
 
-	/* Look for default domain if nececssary */
+	/* Look for default domain if necessary */
 	if (domain == NULL)
 		domain = irq_default_domain;
 	if (domain == NULL) {
@@ -893,7 +893,7 @@ unsigned int irq_find_mapping(struct irq_domain *domain,
 {
 	struct irq_data *data;
 
-	/* Look for default domain if nececssary */
+	/* Look for default domain if necessary */
 	if (domain == NULL)
 		domain = irq_default_domain;
 	if (domain == NULL)
@@ -1423,7 +1423,7 @@ int irq_domain_alloc_irqs_hierarchy(struct irq_domain *domain,
  * The whole process to setup an IRQ has been split into two steps.
  * The first step, __irq_domain_alloc_irqs(), is to allocate IRQ
  * descriptor and required hardware resources. The second step,
- * irq_domain_activate_irq(), is to program hardwares with preallocated
+ * irq_domain_activate_irq(), is to program the hardware with preallocated
  * resources. In this way, it's easier to rollback when failing to
  * allocate resources.
  */
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 437b073dc487e..0159925054faa 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -341,7 +341,7 @@ static bool irq_set_affinity_deactivated(struct irq_data *data,
 	 * If the interrupt is not yet activated, just store the affinity
 	 * mask and do not call the chip driver at all. On activation the
 	 * driver has to make sure anyway that the interrupt is in a
-	 * useable state so startup works.
+	 * usable state so startup works.
 	 */
 	if (!IS_ENABLED(CONFIG_IRQ_DOMAIN_HIERARCHY) ||
 	    irqd_is_activated(data) || !irqd_affinity_on_activate(data))
@@ -999,7 +999,7 @@ static void irq_finalize_oneshot(struct irq_desc *desc,
 	 * to IRQS_INPROGRESS and the irq line is masked forever.
 	 *
 	 * This also serializes the state of shared oneshot handlers
-	 * versus "desc->threads_onehsot |= action->thread_mask;" in
+	 * versus "desc->threads_oneshot |= action->thread_mask;" in
 	 * irq_wake_thread(). See the comment there which explains the
 	 * serialization.
 	 */
@@ -1877,7 +1877,7 @@ static struct irqaction *__free_irq(struct irq_desc *desc, void *dev_id)
 	/* Last action releases resources */
 	if (!desc->action) {
 		/*
-		 * Reaquire bus lock as irq_release_resources() might
+		 * Reacquire bus lock as irq_release_resources() might
 		 * require it to deallocate resources over the slow bus.
 		 */
 		chip_bus_lock(desc);
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index b47d95b68ac1a..4457f3e966d0e 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -5,7 +5,7 @@
  *
  * This file is licensed under GPLv2.
  *
- * This file contains common code to support Message Signalled Interrupt for
+ * This file contains common code to support Message Signaled Interrupts for
  * PCI compatible and non PCI compatible devices.
  */
 #include <linux/types.h>
diff --git a/kernel/irq/timings.c b/kernel/irq/timings.c
index 1f981162648a3..00d45b6bd8f89 100644
--- a/kernel/irq/timings.c
+++ b/kernel/irq/timings.c
@@ -490,7 +490,7 @@ static inline void irq_timings_store(int irq, struct irqt_stat *irqs, u64 ts)
 
 	/*
 	 * The interrupt triggered more than one second apart, that
-	 * ends the sequence as predictible for our purpose. In this
+	 * ends the sequence as predictable for our purpose. In this
 	 * case, assume we have the beginning of a sequence and the
 	 * timestamp is the first value. As it is impossible to
 	 * predict anything at this point, return.
-- 
2.39.2



