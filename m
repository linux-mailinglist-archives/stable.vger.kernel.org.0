Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E437282A47
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 12:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgJDKz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 06:55:57 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:53017 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbgJDKz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 06:55:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E9ED419417DD;
        Sun,  4 Oct 2020 06:55:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 04 Oct 2020 06:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=eq9SJj
        0LpAG6y7sFfZuhjh8zTbuHccCeI0dGtDzB+io=; b=YiyP6Ct2RMEu7s913NbN4/
        XmcE9Aj0dAg3Lzqh0ftqBObPDCQaC8CM0ytnMjqiqiZNcVs03m+qpMcBMWRR9nsx
        wue3d76s9AJg5tSwF4V+0V+ELqO+hSsM5Aos580Kq3455aRGl5DDGFXIaXWc1aQH
        0kD/aTKKIDkH9bJDZEHYpN1UschG9odH89DNVklSHVtfrhM3zP6X4QK8qdqCgYiP
        mrJ4bE9bX5RbT8iZyDb7UxYa3vKCI3XXPBDcbmsFF338aeJN2QyujYRkB1wPFJfl
        0rOhmh8gniWAWOasE+0EMcDWU445atFAd9DgGdBdp/fPVOdTdtX06ykfSxiuJijw
        ==
X-ME-Sender: <xms:O6p5Xx9J-bSBQMK32O1SUz67z3JFl_5jeuORIuEvpT0omgi-svYA9A>
    <xme:O6p5X1sYYJjl_9mBEbsgtXEnbN2KCKsy-UFlIXAlT6mDJZh3BKRcUn33LpkTdwqIX
    mbgiMRjdslfiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgedtgdefhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:O6p5X_B4EIzeT2whPByKYJq8HRKX9BwmvQd-c5UADiyI4FNnZQn0Vw>
    <xmx:O6p5X1eKzlEnQBq3tZpAmacTNdrNUMlD4g_tYyDu_dWpO9HKTUKWbw>
    <xmx:O6p5X2PVspt1oLIZQJR4_9zd_dGdi1OBSnngQVzWBxuhLKgtxse-lw>
    <xmx:O6p5X43pdfZxFd1zoTqyNOcmqflPoG5qywRqKu3Sf_72H6NmaFPwPA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 846FF328005A;
        Sun,  4 Oct 2020 06:55:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xen/events: don't use chip_data for legacy IRQs" failed to apply to 4.9-stable tree
To:     jgross@suse.com, boris.ostrovsky@oracle.com,
        stefan.bader@canonical.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 04 Oct 2020 12:56:40 +0200
Message-ID: <1601809000145121@kroah.com>
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

From 0891fb39ba67bd7ae023ea0d367297ffff010781 Mon Sep 17 00:00:00 2001
From: Juergen Gross <jgross@suse.com>
Date: Wed, 30 Sep 2020 11:16:14 +0200
Subject: [PATCH] xen/events: don't use chip_data for legacy IRQs

Since commit c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.")
Xen is using the chip_data pointer for storing IRQ specific data. When
running as a HVM domain this can result in problems for legacy IRQs, as
those might use chip_data for their own purposes.

Use a local array for this purpose in case of legacy IRQs, avoiding the
double use.

Cc: stable@vger.kernel.org
Fixes: c330fb1ddc0a ("XEN uses irqdesc::irq_data_common::handler_data to store a per interrupt XEN data pointer which contains XEN specific information.")
Signed-off-by: Juergen Gross <jgross@suse.com>
Tested-by: Stefan Bader <stefan.bader@canonical.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20200930091614.13660-1-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 90b8f56fbadb..6f02c18fa65c 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -92,6 +92,8 @@ static bool (*pirq_needs_eoi)(unsigned irq);
 /* Xen will never allocate port zero for any purpose. */
 #define VALID_EVTCHN(chn)	((chn) != 0)
 
+static struct irq_info *legacy_info_ptrs[NR_IRQS_LEGACY];
+
 static struct irq_chip xen_dynamic_chip;
 static struct irq_chip xen_percpu_chip;
 static struct irq_chip xen_pirq_chip;
@@ -156,7 +158,18 @@ int get_evtchn_to_irq(evtchn_port_t evtchn)
 /* Get info for IRQ */
 struct irq_info *info_for_irq(unsigned irq)
 {
-	return irq_get_chip_data(irq);
+	if (irq < nr_legacy_irqs())
+		return legacy_info_ptrs[irq];
+	else
+		return irq_get_chip_data(irq);
+}
+
+static void set_info_for_irq(unsigned int irq, struct irq_info *info)
+{
+	if (irq < nr_legacy_irqs())
+		legacy_info_ptrs[irq] = info;
+	else
+		irq_set_chip_data(irq, info);
 }
 
 /* Constructors for packed IRQ information. */
@@ -377,7 +390,7 @@ static void xen_irq_init(unsigned irq)
 	info->type = IRQT_UNBOUND;
 	info->refcnt = -1;
 
-	irq_set_chip_data(irq, info);
+	set_info_for_irq(irq, info);
 
 	list_add_tail(&info->list, &xen_irq_list_head);
 }
@@ -426,14 +439,14 @@ static int __must_check xen_allocate_irq_gsi(unsigned gsi)
 
 static void xen_free_irq(unsigned irq)
 {
-	struct irq_info *info = irq_get_chip_data(irq);
+	struct irq_info *info = info_for_irq(irq);
 
 	if (WARN_ON(!info))
 		return;
 
 	list_del(&info->list);
 
-	irq_set_chip_data(irq, NULL);
+	set_info_for_irq(irq, NULL);
 
 	WARN_ON(info->refcnt > 0);
 
@@ -603,7 +616,7 @@ EXPORT_SYMBOL_GPL(xen_irq_from_gsi);
 static void __unbind_from_irq(unsigned int irq)
 {
 	evtchn_port_t evtchn = evtchn_from_irq(irq);
-	struct irq_info *info = irq_get_chip_data(irq);
+	struct irq_info *info = info_for_irq(irq);
 
 	if (info->refcnt > 0) {
 		info->refcnt--;
@@ -1108,7 +1121,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 
 void unbind_from_irqhandler(unsigned int irq, void *dev_id)
 {
-	struct irq_info *info = irq_get_chip_data(irq);
+	struct irq_info *info = info_for_irq(irq);
 
 	if (WARN_ON(!info))
 		return;
@@ -1142,7 +1155,7 @@ int evtchn_make_refcounted(evtchn_port_t evtchn)
 	if (irq == -1)
 		return -ENOENT;
 
-	info = irq_get_chip_data(irq);
+	info = info_for_irq(irq);
 
 	if (!info)
 		return -ENOENT;
@@ -1170,7 +1183,7 @@ int evtchn_get(evtchn_port_t evtchn)
 	if (irq == -1)
 		goto done;
 
-	info = irq_get_chip_data(irq);
+	info = info_for_irq(irq);
 
 	if (!info)
 		goto done;

