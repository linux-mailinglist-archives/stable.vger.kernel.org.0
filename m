Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D4E2D45D2
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730647AbgLIPwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:52:09 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:36965 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729711AbgLIPwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:52:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4BB121943AF2;
        Wed,  9 Dec 2020 04:10:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 04:10:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=EC/O9C
        YfpzJtQQu1t35wYI3qAIQIolbkQ/4dDXp8Pm8=; b=N6aaXGV1ypCdInB17aI1vY
        c6DhpYYN63t1qlNI2MgkY2fjwkvRNsHixKJYipIWPnXs691hI1fww0XpcF9htt2i
        I46AMIizO4d3SMOyV9rvGDVvOvY9Gw18X5DSsgWxwBHvmH9abglNHy0UXNMqXJfk
        26PqYqM3JW0Scosf1tIUzMcqp/QyyrXtMylSOtgZ/NKDGktNYuwJEiUHD9CgvE73
        ZcbNCw3FSbmw+UIVOsgON976IRdgq0dwhSk2W88HdKm6p5ijho14WM3cw79NR/5Q
        Zg9qG0toJxOWxNSGfCnEuq7Vhp6P0UVBAjv5T8KcCzVsr1MooCQqiT0Jgb4Ml6bg
        ==
X-ME-Sender: <xms:gJTQX7Wh-VRQ_vMs5ObuzwZ7Zyi9tgkuR2DtYOcR-IY-ieC_4PwugQ>
    <xme:gJTQXzmUZMbMdHeWIbr39n987q7CrhLF3168JaBZNsnN103787b0kRcjhyozGUaAB
    _N4TjUmLspY1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejkedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:gJTQX3aq6t-w0fKPNwCOdiPT-CGswOoNHPkpvJCCUIoynJnc8NLlAA>
    <xmx:gJTQX2UEvOnDxWUz0l5daQQjLGxCes4YEUhu5J1tV0VL2P7NyLm3sw>
    <xmx:gJTQX1lhYFDm7iE7ZbAKVKRhL_NIknjyRTSDTHXmzA3I9krtEkb_2Q>
    <xmx:gpTQX6zgik6GWt1md-dLSURSNA8SVLA8R3W38pjuhYJlWHR_UgvqaA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 307F5108005F;
        Wed,  9 Dec 2020 04:10:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] genirq/irqdomain: Add an irq_create_mapping_affinity()" failed to apply to 4.9-stable tree
To:     lvivier@redhat.com, groug@kaod.org, mpe@ellerman.id.au,
        tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 10:11:42 +0100
Message-ID: <16075051025557@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From bb4c6910c8b41623104c2e64a30615682689a54d Mon Sep 17 00:00:00 2001
From: Laurent Vivier <lvivier@redhat.com>
Date: Thu, 26 Nov 2020 09:28:51 +0100
Subject: [PATCH] genirq/irqdomain: Add an irq_create_mapping_affinity()
 function

There is currently no way to convey the affinity of an interrupt
via irq_create_mapping(), which creates issues for devices that
expect that affinity to be managed by the kernel.

In order to sort this out, rename irq_create_mapping() to
irq_create_mapping_affinity() with an additional affinity parameter that
can be passed down to irq_domain_alloc_descs().

irq_create_mapping() is re-implemented as a wrapper around
irq_create_mapping_affinity().

No functional change.

Fixes: e75eafb9b039 ("genirq/msi: Switch to new irq spreading infrastructure")
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Greg Kurz <groug@kaod.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201126082852.1178497-2-lvivier@redhat.com

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 71535e87109f..ea5a337e0f8b 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -384,11 +384,19 @@ extern void irq_domain_associate_many(struct irq_domain *domain,
 extern void irq_domain_disassociate(struct irq_domain *domain,
 				    unsigned int irq);
 
-extern unsigned int irq_create_mapping(struct irq_domain *host,
-				       irq_hw_number_t hwirq);
+extern unsigned int irq_create_mapping_affinity(struct irq_domain *host,
+				      irq_hw_number_t hwirq,
+				      const struct irq_affinity_desc *affinity);
 extern unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec);
 extern void irq_dispose_mapping(unsigned int virq);
 
+static inline unsigned int irq_create_mapping(struct irq_domain *host,
+					      irq_hw_number_t hwirq)
+{
+	return irq_create_mapping_affinity(host, hwirq, NULL);
+}
+
+
 /**
  * irq_linear_revmap() - Find a linux irq from a hw irq number.
  * @domain: domain owning this hardware interrupt
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index cf8b374b892d..e4ca69608f3b 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -624,17 +624,19 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
 
 /**
- * irq_create_mapping() - Map a hardware interrupt into linux irq space
+ * irq_create_mapping_affinity() - Map a hardware interrupt into linux irq space
  * @domain: domain owning this hardware interrupt or NULL for default domain
  * @hwirq: hardware irq number in that domain space
+ * @affinity: irq affinity
  *
  * Only one mapping per hardware interrupt is permitted. Returns a linux
  * irq number.
  * If the sense/trigger is to be specified, set_irq_type() should be called
  * on the number returned from that call.
  */
-unsigned int irq_create_mapping(struct irq_domain *domain,
-				irq_hw_number_t hwirq)
+unsigned int irq_create_mapping_affinity(struct irq_domain *domain,
+				       irq_hw_number_t hwirq,
+				       const struct irq_affinity_desc *affinity)
 {
 	struct device_node *of_node;
 	int virq;
@@ -660,7 +662,8 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 	}
 
 	/* Allocate a virtual interrupt number */
-	virq = irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node), NULL);
+	virq = irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node),
+				      affinity);
 	if (virq <= 0) {
 		pr_debug("-> virq allocation failed\n");
 		return 0;
@@ -676,7 +679,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 
 	return virq;
 }
-EXPORT_SYMBOL_GPL(irq_create_mapping);
+EXPORT_SYMBOL_GPL(irq_create_mapping_affinity);
 
 /**
  * irq_create_strict_mappings() - Map a range of hw irqs to fixed linux irqs

