Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24832D4624
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731689AbgLIPzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:55:21 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:33371 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731532AbgLIPzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:55:12 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id ADE131940F75;
        Wed,  9 Dec 2020 04:11:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 09 Dec 2020 04:11:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4VJkuc
        XLiGuRONfRqSwoeFpy6M3MH18FCJgM2VgV8xs=; b=U6GdIe03+dS46rWff8BxKo
        U0djGw5XPe7Spl5dLS1oxfQbV1JHrX/GIcsIWYne5xGLkpecuRJkdZ9d8kL9ADNh
        0x/uC62Obd1DYuEPKZaOWwVHxQF7y9J6NBaCZjcjnpkwb8mMpNWUlJdGdhmN1bj+
        TND801v3K18NJlXM0keURoAWwGNME1+NHqvKJGKN+3YUYMXU/QARSDGGnU56AYIq
        pZZmX1hAVkTVPi5b39xxlesjN+W22dITXchZvikNfrEoGzwjKMY9L09VcYonsCxA
        qh1jsUOJDhFU70sGEKdpsv2SL6QClKhfo5AWA6A+iYeFvEW6kE3WCB04tMZyVKhg
        ==
X-ME-Sender: <xms:rZTQXwp7StG92uoQZ7z_7VwE8OLnS-g0lZEB2zozuTPQRuQ5mtTdaQ>
    <xme:rZTQX0M7vQvMe8g0BgLUPU9jvgPnaNu6oMWoMRGqpJ1O737zlxVKrbOvB7jrNFtSC
    8h-Uj7x-83UXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejkedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:rZTQX7rbQ03gvmiH_RgO-tC88MQkpJOUDA3ajgLat6f9aA_YeQF08A>
    <xmx:rZTQX5d-egDC4L723MXmkBSX_Ks8AXMrmEuGvngduVtYGyuUlgvMww>
    <xmx:rZTQXxTwZDm1OZ_ABxpLwNQn3niUXHqZsNz77bKPJLLkc_uBRPnoEw>
    <xmx:rZTQX6YDsQ5KwbBKIQ7Tz-zH7m-klgRQQ9CBtHkZ-yF6cqkPG8tcxw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5AD151080057;
        Wed,  9 Dec 2020 04:11:09 -0500 (EST)
Subject: FAILED: patch "[PATCH] genirq/irqdomain: Add an irq_create_mapping_affinity()" failed to apply to 4.14-stable tree
To:     lvivier@redhat.com, groug@kaod.org, mpe@ellerman.id.au,
        tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 10:12:27 +0100
Message-ID: <160750514712173@kroah.com>
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

