Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9C72E368E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgL1LfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:35:10 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:47623 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727347AbgL1LfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:35:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 64DD586E;
        Mon, 28 Dec 2020 06:33:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:33:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ibigy3
        H+PIrpeIKkgarNFObDoo3LmxzhtC7+TnOprWQ=; b=Yad/+qN4TBHD2A0khtdv3k
        PZnzy3vVNYroMTTvNgje6wJqeWmcjZicTBDRyQl5i9t0/Z1lc4vd3/GLCnZwB8R7
        ZboBjx72wVzFQHVLolw1j36VxRNMN2uoszCKcH/y289Qws+nwDIeQONpMuknesCL
        Ldg3TwGuYL8HyVql9fhQvG5hmdLhesjMIPcu5hr+ZCMYliFZzJUH92pVWQEEJSz9
        FFFOCZARGocQO3SykvzGA8WDXe0N81TThjuLG0HIymvJbIYo2SFtXkXEOBGd9Tb0
        KKVruMYjVeWqke2NNLg9nrLd3qC6+N+KhAuUCZR1Ew2afrtxSaDYVlmZDGcjayxA
        ==
X-ME-Sender: <xms:gcLpX8u8rljRAt325EM_fNfRZz29lm7mW01RQOGfM5O1Jy8VLhDkCQ>
    <xme:gcLpX5fgHh1AhICGWrYMf7iMwtIetaP_9pKIZoJuKHGJHKG-gZIPfzvU_XGjAg7gj
    so8clq8TedtRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:gcLpX3yigRj1NymtPNohNpy_dbVvU2yss1YoynC6aDes0yIZ9n6VBA>
    <xmx:gcLpX_MCYX6f3lTImtnBblMfuW99FmUdiqtERREOvHl9FL_nPPko8Q>
    <xmx:gcLpX89XPKbxXSMSImNuimdcDUX4nZ98zWffcydUV9VZ4JnxwnVo_Q>
    <xmx:gsLpX-LvBufCxj3MFZTo2MSuKNBKQZkR0U8JZvtb-I4Fwvu6RGl9cn93KIM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AFF321080059;
        Mon, 28 Dec 2020 06:33:21 -0500 (EST)
Subject: FAILED: patch "[PATCH] xen/xenbus: Add 'will_handle' callback support in" failed to apply to 4.9-stable tree
To:     sjpark@amazon.de, jgross@suse.com, mku@amazon.de, wipawel@amazon.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:25:22 +0100
Message-ID: <1609154722117251@kroah.com>
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

From 2e85d32b1c865bec703ce0c962221a5e955c52c2 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sjpark@amazon.de>
Date: Mon, 14 Dec 2020 10:04:18 +0100
Subject: [PATCH] xen/xenbus: Add 'will_handle' callback support in
 xenbus_watch_path()

Some code does not directly make 'xenbus_watch' object and call
'register_xenbus_watch()' but use 'xenbus_watch_path()' instead.  This
commit adds support of 'will_handle' callback in the
'xenbus_watch_path()' and it's wrapper, 'xenbus_watch_pathfmt()'.

This is part of XSA-349

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 76912c584a76..1d8b8d24496c 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -675,7 +675,8 @@ static int xen_blkbk_probe(struct xenbus_device *dev,
 	/* setup back pointer */
 	be->blkif->be = be;
 
-	err = xenbus_watch_pathfmt(dev, &be->backend_watch, backend_changed,
+	err = xenbus_watch_pathfmt(dev, &be->backend_watch, NULL,
+				   backend_changed,
 				   "%s/%s", dev->nodename, "physical-device");
 	if (err)
 		goto fail;
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 00f6f8dc56c8..6f10e0998f1c 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -824,7 +824,7 @@ static void connect(struct backend_info *be)
 	xenvif_carrier_on(be->vif);
 
 	unregister_hotplug_status_watch(be);
-	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch,
+	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch, NULL,
 				   hotplug_status_changed,
 				   "%s/%s", dev->nodename, "hotplug-status");
 	if (!err)
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index 4b99ec3dec58..e7c692cfb2cf 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -689,7 +689,7 @@ static int xen_pcibk_xenbus_probe(struct xenbus_device *dev,
 
 	/* watch the backend node for backend configuration information */
 	err = xenbus_watch_path(dev, dev->nodename, &pdev->be_watch,
-				xen_pcibk_be_watch);
+				NULL, xen_pcibk_be_watch);
 	if (err)
 		goto out;
 
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 0a21a12d9c34..0cd728961fce 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -127,19 +127,22 @@ EXPORT_SYMBOL_GPL(xenbus_strstate);
  */
 int xenbus_watch_path(struct xenbus_device *dev, const char *path,
 		      struct xenbus_watch *watch,
+		      bool (*will_handle)(struct xenbus_watch *,
+					  const char *, const char *),
 		      void (*callback)(struct xenbus_watch *,
 				       const char *, const char *))
 {
 	int err;
 
 	watch->node = path;
-	watch->will_handle = NULL;
+	watch->will_handle = will_handle;
 	watch->callback = callback;
 
 	err = register_xenbus_watch(watch);
 
 	if (err) {
 		watch->node = NULL;
+		watch->will_handle = NULL;
 		watch->callback = NULL;
 		xenbus_dev_fatal(dev, err, "adding watch on %s", path);
 	}
@@ -166,6 +169,8 @@ EXPORT_SYMBOL_GPL(xenbus_watch_path);
  */
 int xenbus_watch_pathfmt(struct xenbus_device *dev,
 			 struct xenbus_watch *watch,
+			 bool (*will_handle)(struct xenbus_watch *,
+					const char *, const char *),
 			 void (*callback)(struct xenbus_watch *,
 					  const char *, const char *),
 			 const char *pathfmt, ...)
@@ -182,7 +187,7 @@ int xenbus_watch_pathfmt(struct xenbus_device *dev,
 		xenbus_dev_fatal(dev, -ENOMEM, "allocating path for watch");
 		return -ENOMEM;
 	}
-	err = xenbus_watch_path(dev, path, watch, callback);
+	err = xenbus_watch_path(dev, path, watch, will_handle, callback);
 
 	if (err)
 		kfree(path);
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 38725d97d909..4c3d1b84aa0a 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -136,7 +136,7 @@ static int watch_otherend(struct xenbus_device *dev)
 		container_of(dev->dev.bus, struct xen_bus_type, bus);
 
 	return xenbus_watch_pathfmt(dev, &dev->otherend_watch,
-				    bus->otherend_changed,
+				    NULL, bus->otherend_changed,
 				    "%s/%s", dev->otherend, "state");
 }
 
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index baa88bf0b9bc..c8574d1b814c 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -204,10 +204,14 @@ void xenbus_probe(struct work_struct *);
 
 int xenbus_watch_path(struct xenbus_device *dev, const char *path,
 		      struct xenbus_watch *watch,
+		      bool (*will_handle)(struct xenbus_watch *,
+					  const char *, const char *),
 		      void (*callback)(struct xenbus_watch *,
 				       const char *, const char *));
-__printf(4, 5)
+__printf(5, 6)
 int xenbus_watch_pathfmt(struct xenbus_device *dev, struct xenbus_watch *watch,
+			 bool (*will_handle)(struct xenbus_watch *,
+					     const char *, const char *),
 			 void (*callback)(struct xenbus_watch *,
 					  const char *, const char *),
 			 const char *pathfmt, ...);

