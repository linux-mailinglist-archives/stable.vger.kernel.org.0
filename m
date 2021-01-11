Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9EC2F0E40
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbhAKIgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:36:17 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:43613 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727819AbhAKIgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:36:17 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 82F3324D3;
        Mon, 11 Jan 2021 03:35:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:35:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7CALAU
        5Oz5VDXyaU+KOlzx0YYNSI67Bn0TEgbPiyQCU=; b=O4nZ86iTrRcdUjAignjo9Q
        vvcaCMNfT3hz3kEdxhK38IiBf6jEh3Bn8o49ZFnjbKZN8cyYgOlcT0l+MJowDNEB
        coLym4aLnsI1ctwFCh1IZZnw+OVMxYHDEV9pQ1XajLme2F/UF0tlnj7UOZ5jBXtD
        A8IwpNoJSJ7R4w0HFL9i4T+oxiwB7tn4ondqzXHh018pBu583FHlBdN2wVoezeQO
        oyEkz5jKR0Oo74/hmlGkH7Y1Rf7KeIeA8IOq3l8V5ubwF/BAAamAT96gjAr0J5qq
        liZj2rJHD5S3bRVVKQtjWiO+oT1VPCm4VONaA2xdqL6+cbGVnIVQwRhpLVF5Zsew
        ==
X-ME-Sender: <xms:vw38X0T1tQHPHdtCacHRb9JDHIheHOM2v1S55_sOhXzK3TC2aeobIQ>
    <xme:vw38Xxyieo-5Y-A8xRIdE0Q-vCFokRVyhRDQFAE4ahvriwfGqS0zpqrvPTrNCs9Ng
    FjhqtxawGMAaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vw38Xx2GDPZKmu7cF_W1SIh9jE5qDq-J84dX5TxY1KXv1ZoUn2ixOw>
    <xmx:vw38X4CUchGDVLyj9Eu6ULrFXaEr9tiW2WJlKGmlRFjcNNUcI7J3BQ>
    <xmx:vw38X9j-d4H0e3LbrGa54PCV4tsXyz3IVBPlZJprH9-LGIrBBXGLEw>
    <xmx:vw38X9av13s5lloMc-ZBsQcHkXASsIU1hcjVk_LvSbis43EJFbKG-7PHtSw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C84FC1080066;
        Mon, 11 Jan 2021 03:35:10 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: dwc3: ulpi: Use VStsDone to detect PHY regs access" failed to apply to 4.9-stable tree
To:     Sergey.Semin@baikalelectronics.ru, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:36:15 +0100
Message-ID: <1610354175237251@kroah.com>
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

From ce722da66d3e9384aa2de9d33d584ee154e5e157 Mon Sep 17 00:00:00 2001
From: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Date: Thu, 10 Dec 2020 11:50:06 +0300
Subject: [PATCH] usb: dwc3: ulpi: Use VStsDone to detect PHY regs access
 completion

In accordance with [1] the DWC_usb3 core sets the GUSB2PHYACCn.VStsDone
bit when the PHY vendor control access is done and clears it when the
application initiates a new transaction. The doc doesn't say anything
about the GUSB2PHYACCn.VStsBsy flag serving for the same purpose. Moreover
we've discovered that the VStsBsy flag can be cleared before the VStsDone
bit. So using the former as a signal of the PHY control registers
completion might be dangerous. Let's have the VStsDone flag utilized
instead then.

[1] Synopsys DesignWare Cores SuperSpeed USB 3.0 xHCI Host Controller
    Databook, 2.70a, December 2013, p.388

Fixes: 88bc9d194ff6 ("usb: dwc3: add ULPI interface support")
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20201210085008.13264-2-Sergey.Semin@baikalelectronics.ru
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 2f95f08ca511..1b241f937d8f 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -285,6 +285,7 @@
 
 /* Global USB2 PHY Vendor Control Register */
 #define DWC3_GUSB2PHYACC_NEWREGREQ	BIT(25)
+#define DWC3_GUSB2PHYACC_DONE		BIT(24)
 #define DWC3_GUSB2PHYACC_BUSY		BIT(23)
 #define DWC3_GUSB2PHYACC_WRITE		BIT(22)
 #define DWC3_GUSB2PHYACC_ADDR(n)	(n << 16)
diff --git a/drivers/usb/dwc3/ulpi.c b/drivers/usb/dwc3/ulpi.c
index aa213c9815f6..3cc4f4970c05 100644
--- a/drivers/usb/dwc3/ulpi.c
+++ b/drivers/usb/dwc3/ulpi.c
@@ -24,7 +24,7 @@ static int dwc3_ulpi_busyloop(struct dwc3 *dwc)
 
 	while (count--) {
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYACC(0));
-		if (!(reg & DWC3_GUSB2PHYACC_BUSY))
+		if (reg & DWC3_GUSB2PHYACC_DONE)
 			return 0;
 		cpu_relax();
 	}

