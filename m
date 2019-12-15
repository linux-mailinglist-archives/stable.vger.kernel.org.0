Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E9111F6F2
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 10:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfLOJYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 04:24:15 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:54767 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726050AbfLOJYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 04:24:15 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F20BA6A2;
        Sun, 15 Dec 2019 04:24:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 04:24:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hP5iih
        3v2kWauO5QeJF1OHdI8dvrLpwGPfiC2YsqvhQ=; b=yWcNDSQ+toX2uy/cYW8uyX
        2dQHSKxcuSrSld7IVH+6KQQEsHX35sgEOzT9+UEZM7J3tD7nwZICrhNA/A9feQ/2
        T/uZDECwzsjJI9j7xbUwLfekUeApuSAiMBkeMwC8vsXsuB9X5BB9njuQVI+IwBoC
        6KM5K/Sw6JT2N0OBgTZsCT7OCru1JpLo4j2Bq/MMdNWhjxLBFJPD1KE0ndGTG+0d
        kXxtE8AZVy6K81xn28p5N2NC0rO2qXMoejXb85PNDCC4UuTu5jCVdIej6Q5jgV/F
        tTNs13LuXk6kVTXuAWKfsGhdm4V1nI7wMKCN35MrUou7ba4nkRARn40wsk9uEg4g
        ==
X-ME-Sender: <xms:vfv1XeFLS1yBt8Q6l7bGilDF9Mw3w2WoIiu6fNPlcHfyslXG3mGTAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:vfv1XfBJLzq91DLieRgGd7XKAw4EKEjEn-KZ3f2raZm0zwpffnAOqg>
    <xmx:vfv1XS9hqt5TCLPJkUZEz3OQUMuHMMkiY0iFUrYtbqDG_2xnC8Dsig>
    <xmx:vfv1XahWgFlaail7AwceDSNadxllNq7RqzXnWKQj_QGFjUMlWSeF5A>
    <xmx:vfv1XfUvRVQEx3nnekKGsdYCB6BVBK_zD3d4bS2876cZpuCUbMKz3Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ECA268005A;
        Sun, 15 Dec 2019 04:24:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: xhci: only set D3hot for pci device" failed to apply to 4.9-stable tree
To:     henryl@nvidia.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 10:24:11 +0100
Message-ID: <157640185110204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From f2c710f7dca8457e88b4ac9de2060f011254f9dd Mon Sep 17 00:00:00 2001
From: Henry Lin <henryl@nvidia.com>
Date: Wed, 11 Dec 2019 16:20:04 +0200
Subject: [PATCH] usb: xhci: only set D3hot for pci device

Xhci driver cannot call pci_set_power_state() on non-pci xhci host
controllers. For example, NVIDIA Tegra XHCI host controller which acts
as platform device with XHCI_SPURIOUS_WAKEUP quirk set in some platform
hits this issue during shutdown.

Cc: <stable@vger.kernel.org>
Fixes: 638298dc66ea ("xhci: Fix spurious wakeups after S5 on Haswell")
Signed-off-by: Henry Lin <henryl@nvidia.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20191211142007.8847-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index a0025d23b257..2907fe4d78dd 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -521,6 +521,18 @@ static int xhci_pci_resume(struct usb_hcd *hcd, bool hibernated)
 }
 #endif /* CONFIG_PM */
 
+static void xhci_pci_shutdown(struct usb_hcd *hcd)
+{
+	struct xhci_hcd		*xhci = hcd_to_xhci(hcd);
+	struct pci_dev		*pdev = to_pci_dev(hcd->self.controller);
+
+	xhci_shutdown(hcd);
+
+	/* Yet another workaround for spurious wakeups at shutdown with HSW */
+	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
+		pci_set_power_state(pdev, PCI_D3hot);
+}
+
 /*-------------------------------------------------------------------------*/
 
 /* PCI driver selection metadata; PCI hotplugging uses this */
@@ -556,6 +568,7 @@ static int __init xhci_pci_init(void)
 #ifdef CONFIG_PM
 	xhci_pci_hc_driver.pci_suspend = xhci_pci_suspend;
 	xhci_pci_hc_driver.pci_resume = xhci_pci_resume;
+	xhci_pci_hc_driver.shutdown = xhci_pci_shutdown;
 #endif
 	return pci_register_driver(&xhci_pci_driver);
 }
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6721d059f58a..c5ee562c4c74 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -770,7 +770,7 @@ static void xhci_stop(struct usb_hcd *hcd)
  *
  * This will only ever be called with the main usb_hcd (the USB3 roothub).
  */
-static void xhci_shutdown(struct usb_hcd *hcd)
+void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 
@@ -789,11 +789,8 @@ static void xhci_shutdown(struct usb_hcd *hcd)
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"xhci_shutdown completed - status = %x",
 			readl(&xhci->op_regs->status));
-
-	/* Yet another workaround for spurious wakeups at shutdown with HSW */
-	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
-		pci_set_power_state(to_pci_dev(hcd->self.sysdev), PCI_D3hot);
 }
+EXPORT_SYMBOL_GPL(xhci_shutdown);
 
 #ifdef CONFIG_PM
 static void xhci_save_registers(struct xhci_hcd *xhci)
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index dc6f62a4b197..13d8838cd552 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2050,6 +2050,7 @@ int xhci_start(struct xhci_hcd *xhci);
 int xhci_reset(struct xhci_hcd *xhci);
 int xhci_run(struct usb_hcd *hcd);
 int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
+void xhci_shutdown(struct usb_hcd *hcd);
 void xhci_init_driver(struct hc_driver *drv,
 		      const struct xhci_driver_overrides *over);
 int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id);

