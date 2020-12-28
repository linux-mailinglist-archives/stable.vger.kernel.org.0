Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F6E2E3693
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgL1Lfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:35:30 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60905 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727376AbgL1Lf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:35:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6C597864;
        Mon, 28 Dec 2020 06:33:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:33:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PLe93s
        +fsjWE0oo5tnPmZagVTNNu9G/Hh7CE+VXYn+w=; b=I+dszYIYvmfx0zAbvY5YB5
        a/2J97n3rCp9H5Uf9U206HMqSQ7Ciz0oaj4/RGFCrWBgBc+keFjNGX2GpwFzz4hV
        7D1qsjkXcoB89gGEvxqwBGAUg7M8xhMo+tR1Wd+dBVEFiGcGFOhFKMfx1pR4UQ/6
        DFvEnoEdhActEA+ZgxLjL0j8Od0pnXl3A2bb9WajCcXurWVzJjObNp/MyIwigH5t
        yU+tzFDfO1w80wTT6/ci/ohd5rf52d/er9J03Znt6ieP0L42o4gmnyOodWEFirBp
        H1bs5gh4N4f4xatRxvuTPOrxwKY8NSIYByZnCyXhpiSXgpkk5LIX0U5S/++7obwA
        ==
X-ME-Sender: <xms:hcLpX9V98p9PY0r0KQYE8GIcwtuzofn8sTRuV0BjTLDzeej4KjgT-A>
    <xme:hcLpX9kNn_USbTjpahfXi4fvAsg9FsWhPR2mHI35j0JXu4sf75D3KY9wIT-S6z97y
    0pwlWKT0SrMyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:hcLpX5YzlmQm9T-zNecwwiUNsQTvRfm7MkDhQcRpYXenYHMYQr-ZLA>
    <xmx:hcLpXwUneK31e-KMNAv1lEDnpuG_C-r7XS_85Wo5J2bB4FWZ91v3fg>
    <xmx:hcLpX3nfFlpo9md6X1v59Iu7_KJYYCgzhY7dxI7CpXYVRJI2Y8cl2A>
    <xmx:hsLpX8wCBwJV7QfxeX08TA3o9juvSyH_qYsCAqN8Magi4JyhWTM-SaoEY30>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B04E61080059;
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

