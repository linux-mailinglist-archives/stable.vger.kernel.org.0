Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589022B0B4B
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 18:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgKLRbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 12:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgKLRbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 12:31:04 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BD0C0613D1
        for <stable@vger.kernel.org>; Thu, 12 Nov 2020 09:31:04 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id r17so6908913wrw.1
        for <stable@vger.kernel.org>; Thu, 12 Nov 2020 09:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=raaKEFv9hSNpaMciIIHYuZtWNQXHTpjXgjTyMn1nIKE=;
        b=o6uyMPstj8xB511TQcgMpEAkqfYI9QZuvE7BlfFhEmZ4g4TgFSCuQbAHcx/cvslUSB
         UXEg+F8H+o8ozN4eHidO0fgjhc0VNOqqvH7rSkyC9vXnWndysOdrkE6bAncFGiOScgBQ
         kdoZQ/66d3rynM6Jl1jaOVLmBNYX6TdNl2Qf/eW+YyZIEzo+UwOo9xXr7IJE0fovysUh
         QEUqtwpRlpclayZoN+I7SPG6M/xupIiOyWKeOEZOQRwLS9MkviL4aBR1A8Yb1FJqV8UN
         XluvMTnzEaPtNYk6+lBikViz4wDiLjCm7EMqdwMRuhHOvbQMNRdapVgyYK/H/oezoCGm
         Y2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=raaKEFv9hSNpaMciIIHYuZtWNQXHTpjXgjTyMn1nIKE=;
        b=DJYZNGQZ80ucypiS8ARTyOZqlorMOrepXw2RD6yM67HIzRI4RdZl6evcQ6QNVUAjiZ
         rLrlwXtPgdBQIlbAlZ9q6peKVXoQeSx1a5keVQ6OHG+WxfoZuoVnEA2aa26kH0CxlPbo
         ifgNNuyxk+u54cBiN4s+ZTWXSpWjk8I58RvKfu42vLGS3a2gDuUq73OYJR4DiFcFsPG6
         rCs7y+cJ+V0bGQ1dr8rzd2hIP179ofwsGxrY1VBw13pv8klk2lbkxBzwj78YRCKKmqHT
         H4OnM74t6P6QToI1f+jkgfBHmKJyYMrDJgm85Ot+rGjxBNCF9hHE2ALI3KL3jNERxGnY
         p+1g==
X-Gm-Message-State: AOAM533BJ2tjfoQ6d40huu6CvLWwUQGgHuoQSKVcMly+FpEtydY8H3kp
        skRk3pZR0jWC5b5i2eRcAdWrqOMFIMYksg==
X-Google-Smtp-Source: ABdhPJzq8ZbYRKMhmOsXWYzq2zEAKMSnMC3np5beLyr30+g+5hF/zBbfQrJlJ1TVxGi28+y7MHC99g==
X-Received: by 2002:adf:f24b:: with SMTP id b11mr724382wrp.342.1605202262746;
        Thu, 12 Nov 2020 09:31:02 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id f16sm7865476wrp.66.2020.11.12.09.31.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 Nov 2020 09:31:02 -0800 (PST)
Date:   Thu, 12 Nov 2020 17:31:00 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Wei Liu <wl@xen.org>
Subject: backport of 073d0552ead5 ("xen/events: avoid removing an event
Message-ID: <20201112173100.6rbaklb74ofkltl5@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rmznzdybnrm3fww3"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rmznzdybnrm3fww3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

This was missing from v4.4.y, v4.9.y and v4.14.y. Please consider
the attached backported patch.
Missed adding stable in the previous mail.

--
Regards
Sudip

--rmznzdybnrm3fww3
Content-Type: text/x-diff; charset=iso-8859-1
Content-Disposition: attachment; filename="0001-xen-events-avoid-removing-an-event-channel-while-han.patch"
Content-Transfer-Encoding: 8bit

From 94ca21c0ecd8352c6f15ef17c81e7ac7ccfb0d93 Mon Sep 17 00:00:00 2001
From: Juergen Gross <jgross@suse.com>
Date: Mon, 7 Sep 2020 15:47:27 +0200
Subject: [PATCH] xen/events: avoid removing an event channel while handling it
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit 073d0552ead5bfc7a3a9c01de590e924f11b5dd2 upstream

Today it can happen that an event channel is being removed from the
system while the event handling loop is active. This can lead to a
race resulting in crashes or WARN() splats when trying to access the
irq_info structure related to the event channel.

Fix this problem by using a rwlock taken as reader in the event
handling loop and as writer when deallocating the irq_info structure.

As the observed problem was a NULL dereference in evtchn_from_irq()
make this function more robust against races by testing the irq_info
pointer to be not NULL before dereferencing it.

And finally make all accesses to evtchn_to_irq[row][col] atomic ones
in order to avoid seeing partial updates of an array element in irq
handling. Note that irq handling can be entered only for event channels
which have been valid before, so any not populated row isn't a problem
in this regard, as rows are only ever added and never removed.

This is XSA-331.

Cc: stable@vger.kernel.org
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reported-by: Jinoh Kang <luke1337@theori.io>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Wei Liu <wl@xen.org>
[sudip: Backported by adjusting context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/xen/events/events_base.c | 41 ++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index fdeeef2b9947..6ef1b491e6d6 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/irqnr.h>
 #include <linux/pci.h>
+#include <linux/spinlock.h>
 
 #ifdef CONFIG_X86
 #include <asm/desc.h>
@@ -69,6 +70,23 @@ const struct evtchn_ops *evtchn_ops;
  */
 static DEFINE_MUTEX(irq_mapping_update_lock);
 
+/*
+ * Lock protecting event handling loop against removing event channels.
+ * Adding of event channels is no issue as the associated IRQ becomes active
+ * only after everything is setup (before request_[threaded_]irq() the handler
+ * can't be entered for an event, as the event channel will be unmasked only
+ * then).
+ */
+static DEFINE_RWLOCK(evtchn_rwlock);
+
+/*
+ * Lock hierarchy:
+ *
+ * irq_mapping_update_lock
+ *   evtchn_rwlock
+ *     IRQ-desc lock
+ */
+
 static LIST_HEAD(xen_irq_list_head);
 
 /* IRQ <-> VIRQ mapping. */
@@ -103,7 +121,7 @@ static void clear_evtchn_to_irq_row(unsigned row)
 	unsigned col;
 
 	for (col = 0; col < EVTCHN_PER_ROW; col++)
-		evtchn_to_irq[row][col] = -1;
+		WRITE_ONCE(evtchn_to_irq[row][col], -1);
 }
 
 static void clear_evtchn_to_irq_all(void)
@@ -140,7 +158,7 @@ static int set_evtchn_to_irq(unsigned evtchn, unsigned irq)
 		clear_evtchn_to_irq_row(row);
 	}
 
-	evtchn_to_irq[row][col] = irq;
+	WRITE_ONCE(evtchn_to_irq[row][col], irq);
 	return 0;
 }
 
@@ -150,7 +168,7 @@ int get_evtchn_to_irq(unsigned evtchn)
 		return -1;
 	if (evtchn_to_irq[EVTCHN_ROW(evtchn)] == NULL)
 		return -1;
-	return evtchn_to_irq[EVTCHN_ROW(evtchn)][EVTCHN_COL(evtchn)];
+	return READ_ONCE(evtchn_to_irq[EVTCHN_ROW(evtchn)][EVTCHN_COL(evtchn)]);
 }
 
 /* Get info for IRQ */
@@ -259,10 +277,14 @@ static void xen_irq_info_cleanup(struct irq_info *info)
  */
 unsigned int evtchn_from_irq(unsigned irq)
 {
-	if (unlikely(WARN(irq >= nr_irqs, "Invalid irq %d!\n", irq)))
+	const struct irq_info *info = NULL;
+
+	if (likely(irq < nr_irqs))
+		info = info_for_irq(irq);
+	if (!info)
 		return 0;
 
-	return info_for_irq(irq)->evtchn;
+	return info->evtchn;
 }
 
 unsigned irq_from_evtchn(unsigned int evtchn)
@@ -438,16 +460,21 @@ static int __must_check xen_allocate_irq_gsi(unsigned gsi)
 static void xen_free_irq(unsigned irq)
 {
 	struct irq_info *info = info_for_irq(irq);
+	unsigned long flags;
 
 	if (WARN_ON(!info))
 		return;
 
+	write_lock_irqsave(&evtchn_rwlock, flags);
+
 	list_del(&info->list);
 
 	set_info_for_irq(irq, NULL);
 
 	WARN_ON(info->refcnt > 0);
 
+	write_unlock_irqrestore(&evtchn_rwlock, flags);
+
 	kfree(info);
 
 	/* Legacy IRQ descriptors are managed by the arch. */
@@ -1233,6 +1260,8 @@ static void __xen_evtchn_do_upcall(void)
 	int cpu = get_cpu();
 	unsigned count;
 
+	read_lock(&evtchn_rwlock);
+
 	do {
 		vcpu_info->evtchn_upcall_pending = 0;
 
@@ -1248,7 +1277,7 @@ static void __xen_evtchn_do_upcall(void)
 	} while (count != 1 || vcpu_info->evtchn_upcall_pending);
 
 out:
-
+	read_unlock(&evtchn_rwlock);
 	put_cpu();
 }
 
-- 
2.11.0


--rmznzdybnrm3fww3--
