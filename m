Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7D42E3692
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgL1Lf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:35:29 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:49087 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727329AbgL1Lf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:35:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 09E68866;
        Mon, 28 Dec 2020 06:33:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:33:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ibigy3
        H+PIrpeIKkgarNFObDoo3LmxzhtC7+TnOprWQ=; b=AvFmzWSy1pWM+rGfcrzFap
        IplUDSfnqs1JfxtkjmvstSH47h/oe5GFrh+Nm1lakNQM4s6PUgMlVVzPnAjZm9s5
        pyqmVSpfHsyFRYdwMSRkKlruyTZV0/veHW1sO4wCMzL8KOH4nPc8GbNlbuSkrapG
        dXgR21N0MWN5xMOW5MNCtvMdKVO/U9A8QR/ibsp1s6esYdK58xs2h6Lh9j9AgfjB
        S/2+bVl0utZHGTAyDK0vmUQ0SgMCcN5mOOvund4ne6/pztopuoxC5swPbMMwn5uB
        2krOkrhg/gnzL7OC4x6MhcYg1eHt4ndTXeo3zB+L3REPSP43NaN+/E3r1NiwzNrA
        ==
X-ME-Sender: <xms:gcLpX1E2mNLylmm_eNrktQ4hA0OSsxeDP5xT--NqiTiZacTTJQrZBg>
    <xme:gcLpX6UCPgTVaW6oX3EEp4PTMhL-fUryv0OfQMAcWqpcMpnsSUZ1e5kDcKSAnXm9C
    6zGOkgyge-a6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:gcLpX3K2QwKSOtI1OQXCSHYNrdnn4WAUQ5PqSmd5v0h7l50n8aGTbQ>
    <xmx:gcLpX7GGuh5b4jmQ1AixdsPhbb_yIg0aV026At0HeLHCT1C0pDwo2w>
    <xmx:gcLpX7Uj3o_Wi1y6xvZN48j0PV-p6cUFqfTedIl-9GcxZ3UnQhT45A>
    <xmx:gcLpX4gSxNQT5iUck2OfADQCYtG9pJEHDIsaJ5WNagtJN20st2zXvyn8Zb4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E75E24005B;
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

