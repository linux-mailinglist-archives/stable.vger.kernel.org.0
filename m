Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3486ECA5D
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 12:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjDXKcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 06:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjDXKc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 06:32:28 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B3818C;
        Mon, 24 Apr 2023 03:32:26 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id D9E7532000D7;
        Mon, 24 Apr 2023 06:32:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 24 Apr 2023 06:32:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1682332345; x=
        1682418745; bh=EPSLnlfkuPGroG+yuKCSOFSwJ5aB9Wh0nx281+ahLCM=; b=O
        BF4z2lAFMtSb37GAWIwTr//OaFyy/pwpaLh5ROUi2VCthMCGRnEBn4jiFuIgR3Gp
        bFXTyajAlwM8UZkj8vSBb/8PqmegusMYWCy7c9OyU2vsF9WUaURPH54bvz88Hhkk
        xbvbdgvUcmmJ431RZ+NDSG+18MkXhSIclomQt+/gjL5W+dgBywMRpPg5Yesn3pZy
        C+n66Od8qCv4t8uhh7qv9Ge+KdW/P4RvnJPk+353AhbT9PlSc1a2lPTupxn0xvXi
        wHaJOntTXI8pSDOGRmXjax3/2ILwfAs8ZBuI/nAUUGeV0vKU1EBAczI/6SwtucB4
        vFPtF9NzdBbpo5f06kwXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1682332345; x=
        1682418745; bh=EPSLnlfkuPGroG+yuKCSOFSwJ5aB9Wh0nx281+ahLCM=; b=A
        iWEEi8zcR7RM4XGa2JJVYQHxnml6vZ2A9h+5ZI9GTp+K0mtNL6eJOSZBIVL8o86G
        BurzmHR4xFNROXkXAh9BXjNuqTwoVcrpjxADMEleYsDIhTz95Klg8nczVmDxx1eP
        lpX56APR9r9eppBGKbdfXJAvuodSMwOSWiUF+UoA1OapV6UtTaRteZPGWHGjBFHp
        d9644qkXKxhTiN3DSfQqpwMeF/UTfAMaqGfS1x3rXuuCgdscrCpH7cngn8rBc8TZ
        R3AHwg6bZa5szESeoVf9HkWjLZHzWZiUbx3cYANjtvOmyhKOj9UPXiCg5+L9YduP
        kKRRytXIGsDdHo80yVM7Q==
X-ME-Sender: <xms:uVpGZAQJ6TPMNVUzQic5fV2b45Kr_wekkjLQI0LdtviDJAWrN9GXQQ>
    <xme:uVpGZNyK-Id4ZD-lokcsIhVy0NTt3LH-iiclJmZBweCk_y-XEwOepARgQn_sG7tK2
    alaOD095B1q7dkxK7Q>
X-ME-Received: <xmr:uVpGZN0fxfM_S24C3yn6iQS4lSAKXBklVFSfzTlb1FyoxQi_3KeVW38YKO5G>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedutddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeflihgrgihunhcujggrnhhguceojhhirgiguhhnrdihrghn
    ghesfhhlhihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepfeeludefheegvdeuvd
    dvgeekgfdvtdettdelieeihfegtedugeekhfdvhfejfedtnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhi
    hgohgrthdrtghomh
X-ME-Proxy: <xmx:uVpGZECLLjCh5_xRPYlmg204wLpphGG4KskV5MQkPZ5jvgrxGhBxJg>
    <xmx:uVpGZJiOMHDo8ZLqp1PUrSScJA6plJ66uRInLJfHm1MEAUSLZVnXZA>
    <xmx:uVpGZArjzylj-lXagiMcHMGscilswGELe_6a0p0GsOMvKD4VfXSU5w>
    <xmx:uVpGZEW3ekGnSJf432qERNErVto5IzKItbaok8xsIXm2LQjHIFqr3A>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Apr 2023 06:32:24 -0400 (EDT)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     maz@kernel.org
Cc:     tsbogend@alpha.franken.de, fancer.lancer@gmail.com,
        tglx@linutronix.de, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] irqchip/mips-gic: Use raw spinlock for gic_lock
Date:   Mon, 24 Apr 2023 11:31:56 +0100
Message-Id: <20230424103156.66753-3-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230424103156.66753-1-jiaxun.yang@flygoat.com>
References: <20230424103156.66753-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since we may hold gic_lock in hardirq context, use raw spinlock
makes more sense given that it is for low-level interrupt handling
routine and the critical section is small.

Fixes BUG:

[    0.426106] =============================
[    0.426257] [ BUG: Invalid wait context ]
[    0.426422] 6.3.0-rc7-next-20230421-dirty #54 Not tainted
[    0.426638] -----------------------------
[    0.426766] swapper/0/1 is trying to lock:
[    0.426954] ffffffff8104e7b8 (gic_lock){....}-{3:3}, at: gic_set_type+0x30/08

Fixes: 95150ae8b330 ("irqchip: mips-gic: Implement irq_set_type callback")
Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 drivers/irqchip/irq-mips-gic.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index b568d55ef7c5..6d5ecc10a870 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -50,7 +50,7 @@ void __iomem *mips_gic_base;
 
 static DEFINE_PER_CPU_READ_MOSTLY(unsigned long[GIC_MAX_LONGS], pcpu_masks);
 
-static DEFINE_SPINLOCK(gic_lock);
+static DEFINE_RAW_SPINLOCK(gic_lock);
 static struct irq_domain *gic_irq_domain;
 static int gic_shared_intrs;
 static unsigned int gic_cpu_pin;
@@ -210,7 +210,7 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 
 	irq = GIC_HWIRQ_TO_SHARED(d->hwirq);
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 	switch (type & IRQ_TYPE_SENSE_MASK) {
 	case IRQ_TYPE_EDGE_FALLING:
 		pol = GIC_POL_FALLING_EDGE;
@@ -250,7 +250,7 @@ static int gic_set_type(struct irq_data *d, unsigned int type)
 	else
 		irq_set_chip_handler_name_locked(d, &gic_level_irq_controller,
 						 handle_level_irq, NULL);
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 
 	return 0;
 }
@@ -268,7 +268,7 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 		return -EINVAL;
 
 	/* Assumption : cpumask refers to a single CPU */
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 
 	/* Re-route this IRQ */
 	write_gic_map_vp(irq, BIT(mips_cm_vp_id(cpu)));
@@ -279,7 +279,7 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *cpumask,
 		set_bit(irq, per_cpu_ptr(pcpu_masks, cpu));
 
 	irq_data_update_effective_affinity(d, cpumask_of(cpu));
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 
 	return IRQ_SET_MASK_OK;
 }
@@ -357,12 +357,12 @@ static void gic_mask_local_irq_all_vpes(struct irq_data *d)
 	cd = irq_data_get_irq_chip_data(d);
 	cd->mask = false;
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 	for_each_online_cpu(cpu) {
 		write_gic_vl_other(mips_cm_vp_id(cpu));
 		write_gic_vo_rmask(BIT(intr));
 	}
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 }
 
 static void gic_unmask_local_irq_all_vpes(struct irq_data *d)
@@ -375,12 +375,12 @@ static void gic_unmask_local_irq_all_vpes(struct irq_data *d)
 	cd = irq_data_get_irq_chip_data(d);
 	cd->mask = true;
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 	for_each_online_cpu(cpu) {
 		write_gic_vl_other(mips_cm_vp_id(cpu));
 		write_gic_vo_smask(BIT(intr));
 	}
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 }
 
 static void gic_all_vpes_irq_cpu_online(void)
@@ -393,7 +393,7 @@ static void gic_all_vpes_irq_cpu_online(void)
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 
 	for (i = 0; i < ARRAY_SIZE(local_intrs); i++) {
 		unsigned int intr = local_intrs[i];
@@ -407,7 +407,7 @@ static void gic_all_vpes_irq_cpu_online(void)
 			write_gic_vl_smask(BIT(intr));
 	}
 
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 }
 
 static struct irq_chip gic_all_vpes_local_irq_controller = {
@@ -437,11 +437,11 @@ static int gic_shared_irq_domain_map(struct irq_domain *d, unsigned int virq,
 
 	data = irq_get_irq_data(virq);
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 	write_gic_map_pin(intr, GIC_MAP_PIN_MAP_TO_PIN | gic_cpu_pin);
 	write_gic_map_vp(intr, BIT(mips_cm_vp_id(cpu)));
 	irq_data_update_effective_affinity(data, cpumask_of(cpu));
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 
 	return 0;
 }
@@ -533,12 +533,12 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int virq,
 	if (!gic_local_irq_is_routable(intr))
 		return -EPERM;
 
-	spin_lock_irqsave(&gic_lock, flags);
+	raw_spin_lock_irqsave(&gic_lock, flags);
 	for_each_online_cpu(cpu) {
 		write_gic_vl_other(mips_cm_vp_id(cpu));
 		write_gic_vo_map(mips_gic_vx_map_reg(intr), map);
 	}
-	spin_unlock_irqrestore(&gic_lock, flags);
+	raw_spin_unlock_irqrestore(&gic_lock, flags);
 
 	return 0;
 }
-- 
2.34.1

