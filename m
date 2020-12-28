Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF612E3696
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgL1Lfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:35:31 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56471 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727377AbgL1Lfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:35:31 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 1299A847;
        Mon, 28 Dec 2020 06:33:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:33:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PLe93s
        +fsjWE0oo5tnPmZagVTNNu9G/Hh7CE+VXYn+w=; b=qw600ivx1vdced5BV8+bgK
        Fk1tApgPruTYcP8oSNPIz1hai4kIuYp8XWOWN0e78gB/jKo5l2Y9emabOvak3rgw
        tVXbFZV77SXHJmeo0nPaPsmpk9KFouh5ZpCMWU12UM/B9wgPl8Im2hIS3URLXhAK
        Vu0Xi7EG+r8ru9861fF3ZBrORVsNawS6JopQWs5YmQYxPKJjquvs9t4y1E6/DvUi
        q7ynrJqHwdWJ08TKGonWtGXcXhlIh4fivH1VrlPcIHtfYdwx6fjn+I3BLKW9VBKq
        t1WTEysReg94777skLJ1Zf391F7axmLbvibjeaGRici6Mhy6CunWnYf0w3BS0ugA
        ==
X-ME-Sender: <xms:hcLpX1jUPuoXM0IeLkouoUhGKS98K34DTnZHa1DjRKFvJG7AA4WIyg>
    <xme:hcLpX6CVnYimwe8Q9EbOYk93Fc70pl8OsjMYnqXCAxy8BLKgRuyU5XcCEO-Kxld-S
    a8PoulfAIGngQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:hcLpX1HNZmZXINLODGC9ols90UPuasM76wyJv6gyX373r8lEnD1Gag>
    <xmx:hcLpX6Sdy7-HfBCBpkIzso7ttkxSkOKZhcs8AUj0qDWqUk25LuXjiw>
    <xmx:hcLpXyw7x2CrZktDvRGThUedcKQE3NBNumKv4DlHdKl1OA5F_ySlNw>
    <xmx:hcLpX98BltX-Fo2biHqWUnOgmgnoVz3j8CvqqY0T94tk1st3Rb-6hIXGAfo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 55F9C24005C;
        Mon, 28 Dec 2020 06:33:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] xenbus/xenbus_backend: Disallow pending watch messages" failed to apply to 4.9-stable tree
To:     sjpark@amazon.de, jgross@suse.com, mku@amazon.de, wipawel@amazon.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:28:39 +0100
Message-ID: <160915491940246@kroah.com>
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

From 9996bd494794a2fe393e97e7a982388c6249aa76 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sjpark@amazon.de>
Date: Mon, 14 Dec 2020 10:08:40 +0100
Subject: [PATCH] xenbus/xenbus_backend: Disallow pending watch messages

'xenbus_backend' watches 'state' of devices, which is writable by
guests.  Hence, if guests intensively updates it, dom0 will have lots of
pending events that exhausting memory of dom0.  In other words, guests
can trigger dom0 memory pressure.  This is known as XSA-349.  However,
the watch callback of it, 'frontend_changed()', reads only 'state', so
doesn't need to have the pending events.

To avoid the problem, this commit disallows pending watch messages for
'xenbus_backend' using the 'will_handle()' watch callback.

This is part of XSA-349

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/drivers/xen/xenbus/xenbus_probe_backend.c b/drivers/xen/xenbus/xenbus_probe_backend.c
index 2ba699897e6d..5abded97e1a7 100644
--- a/drivers/xen/xenbus/xenbus_probe_backend.c
+++ b/drivers/xen/xenbus/xenbus_probe_backend.c
@@ -180,6 +180,12 @@ static int xenbus_probe_backend(struct xen_bus_type *bus, const char *type,
 	return err;
 }
 
+static bool frontend_will_handle(struct xenbus_watch *watch,
+				 const char *path, const char *token)
+{
+	return watch->nr_pending == 0;
+}
+
 static void frontend_changed(struct xenbus_watch *watch,
 			     const char *path, const char *token)
 {
@@ -191,6 +197,7 @@ static struct xen_bus_type xenbus_backend = {
 	.levels = 3,		/* backend/type/<frontend>/<id> */
 	.get_bus_id = backend_bus_id,
 	.probe = xenbus_probe_backend,
+	.otherend_will_handle = frontend_will_handle,
 	.otherend_changed = frontend_changed,
 	.bus = {
 		.name		= "xen-backend",

