Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28892E3695
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgL1Lfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:35:30 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33263 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727386AbgL1Lfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:35:30 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id AF6F883B;
        Mon, 28 Dec 2020 06:33:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:33:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DavpXx
        Wwe/9CL+y930afJ5uercbRig2cIVGH+AIVA1I=; b=WtIvY5zXWsXbvyGAzHrj3+
        hoo+ffRxd8fbL6JR9S0RqXdwcIMKLWANPD+xhzTGYt8/jPmwqLAZAWzM1k6nyyoV
        +PZMyjIioe9c0FvjbtHrUpc4xX//f/GxKdDcMGDmxym7gHx7/R7BvgkOj8gYbnQj
        Gw9FG6JK3Hb+r7GttwtoExxa0UZ8WJCCK4Uh/qPgLOekDiK0tjDrtpfO5Wcvxm7c
        cQ1QouQIyMiY27svELFvcBolUgYDn4GiXac6y55gfbk81EzIfSWgVfaG6hqE+1rZ
        MfXRCv8iN0mqZZL15Wk4VdXGrvkYsMzVXUK2zx+PTkXmO9nSd6ed6W3PYFIvJZ4Q
        ==
X-ME-Sender: <xms:hMLpX75lQosXQ0s0Kc8ale0pcvD6DCoBeWdLIAXMQmZAWmA8lw0tSg>
    <xme:hMLpXw4izMl_Bnm47VrqfE7uww47iWVcBSHZfy8kE9vIe3-IlBB6JIU155k8uYWR0
    GC2tPgKNon-dw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:hMLpXydsy9LKkIjWleIgPkG_lydzl3-b5ijL4XAhjV4dWsd91a5dmA>
    <xmx:hMLpX8KCn07_aCuDBHnn0_H65Owb_7V8S3WA5Dy5-Rk68THlLRnuEw>
    <xmx:hMLpX_K8gMwP-OE4vG11rt6MOUGlwbRJQCp5ktVQKijDUTBNdSUutQ>
    <xmx:hMLpX2W2t6ur_2xu7xsST3-yLghcFym0MNSPhNfk7eT1fZnEabJ6g1SDoz0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 053FF240057;
        Mon, 28 Dec 2020 06:33:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] xen/xenbus: Count pending messages for each watch" failed to apply to 4.9-stable tree
To:     sjpark@amazon.de, jgross@suse.com, mku@amazon.de, wipawel@amazon.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:27:14 +0100
Message-ID: <1609154834239118@kroah.com>
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

From 3dc86ca6b4c8cfcba9da7996189d1b5a358a94fc Mon Sep 17 00:00:00 2001
From: SeongJae Park <sjpark@amazon.de>
Date: Mon, 14 Dec 2020 10:07:13 +0100
Subject: [PATCH] xen/xenbus: Count pending messages for each watch

This commit adds a counter of pending messages for each watch in the
struct.  It is used to skip unnecessary pending messages lookup in
'unregister_xenbus_watch()'.  It could also be used in 'will_handle'
callback.

This is part of XSA-349

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index e8bdbd0a1e26..12e02eb01f59 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -711,6 +711,7 @@ int xs_watch_msg(struct xs_watch_event *event)
 				 event->path, event->token))) {
 		spin_lock(&watch_events_lock);
 		list_add_tail(&event->list, &watch_events);
+		event->handle->nr_pending++;
 		wake_up(&watch_events_waitq);
 		spin_unlock(&watch_events_lock);
 	} else
@@ -768,6 +769,8 @@ int register_xenbus_watch(struct xenbus_watch *watch)
 
 	sprintf(token, "%lX", (long)watch);
 
+	watch->nr_pending = 0;
+
 	down_read(&xs_watch_rwsem);
 
 	spin_lock(&watches_lock);
@@ -817,11 +820,14 @@ void unregister_xenbus_watch(struct xenbus_watch *watch)
 
 	/* Cancel pending watch events. */
 	spin_lock(&watch_events_lock);
-	list_for_each_entry_safe(event, tmp, &watch_events, list) {
-		if (event->handle != watch)
-			continue;
-		list_del(&event->list);
-		kfree(event);
+	if (watch->nr_pending) {
+		list_for_each_entry_safe(event, tmp, &watch_events, list) {
+			if (event->handle != watch)
+				continue;
+			list_del(&event->list);
+			kfree(event);
+		}
+		watch->nr_pending = 0;
 	}
 	spin_unlock(&watch_events_lock);
 
@@ -868,7 +874,6 @@ void xs_suspend_cancel(void)
 
 static int xenwatch_thread(void *unused)
 {
-	struct list_head *ent;
 	struct xs_watch_event *event;
 
 	xenwatch_pid = current->pid;
@@ -883,13 +888,15 @@ static int xenwatch_thread(void *unused)
 		mutex_lock(&xenwatch_mutex);
 
 		spin_lock(&watch_events_lock);
-		ent = watch_events.next;
-		if (ent != &watch_events)
-			list_del(ent);
+		event = list_first_entry_or_null(&watch_events,
+				struct xs_watch_event, list);
+		if (event) {
+			list_del(&event->list);
+			event->handle->nr_pending--;
+		}
 		spin_unlock(&watch_events_lock);
 
-		if (ent != &watch_events) {
-			event = list_entry(ent, struct xs_watch_event, list);
+		if (event) {
 			event->handle->callback(event->handle, event->path,
 						event->token);
 			kfree(event);
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index c8574d1b814c..00c7235ae93e 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -61,6 +61,8 @@ struct xenbus_watch
 	/* Path being watched. */
 	const char *node;
 
+	unsigned int nr_pending;
+
 	/*
 	 * Called just before enqueing new event while a spinlock is held.
 	 * The event will be discarded if this callback returns false.

