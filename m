Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 861F32F0E4B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbhAKIhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:37:18 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:58279 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727856AbhAKIhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:37:18 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id DC8D22491;
        Mon, 11 Jan 2021 03:36:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:36:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=iNqSbM
        +1vAVW91t83A5FkLkblxRx/IBxqMDu/rT3UzA=; b=lwv946BlYHM2vZojHt5+Cz
        HapI3MvfLKQQDehg6MgXw4tb+vpfV9pLoZDQ8cyRr1DdqwWrl1ZpLqYI6hQ5rMyA
        wXVxVz03Ng5lS7jxjZx6qI7FUCiTEks9GrkOwXDInW1NvanuHyKMk3rWTYhLgwfj
        LYrry2PRkvFXfctOC4cJRGU6G6QXiiv/B74rJ0V0KepwdPrtXDy4GWh99zF0bT7z
        /OwT4Ps6jKpwic04ys/XuqMIYoYuXs1QVK7Hlxrz/h7eVWW2kH6wqgYaSF2Mw7Sk
        e29byFKnWtFADWMUjDwDLmRXwdifuc8aTLP37Vvd4SmWRHQufVneg1nelv0bEArA
        ==
X-ME-Sender: <xms:_A38X-IIgGIJMcEPMEQN4gMK1FtSnQAUvEBRInAKwocTJzBuPgPyWQ>
    <xme:_A38X2LwzGyJpzCwXHMON0xc3TsaZJA7uUWFZJU8ye-kYduyESoSHNeaziQNEMvUM
    Dp51yV6c-Wc9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:_A38X-u98gCt1vhV_zvoPzbKak1uaS2FJ9tSNAu1OU5p7y7EDM-QWQ>
    <xmx:_A38XzZrg6GvfpaxCyXXTT9M5OSOOD3I9BUNfuvCb0cCRvfRzXmd9w>
    <xmx:_A38X1buUr1ttqmQN10bG3lEEET528ax7pPnrLWANo-vD-nrFVFL9g>
    <xmx:_A38X0xnrJUk23Jq0ZPSdnFrh3uX-TPix-WQDW3ZSPM3NDSEyAA2UZqgY_k>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 34E6B108005C;
        Mon, 11 Jan 2021 03:36:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: dwc3: ulpi: Fix USB2.0 HS/FS/LS PHY suspend regression" failed to apply to 5.4-stable tree
To:     Sergey.Semin@baikalelectronics.ru, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:37:23 +0100
Message-ID: <16103542436125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e5f4ca3fce90a37b23a77bfcc86800d484a80514 Mon Sep 17 00:00:00 2001
From: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Date: Thu, 10 Dec 2020 11:50:08 +0300
Subject: [PATCH] usb: dwc3: ulpi: Fix USB2.0 HS/FS/LS PHY suspend regression

First of all the commit e0082698b689 ("usb: dwc3: ulpi: conditionally
resume ULPI PHY") introduced the Suspend USB2.0 HS/FS/LS PHY regression,
as by design of the fix any attempt to read/write from/to the PHY control
registers will completely disable the PHY suspension, which consequently
will increase the USB bus power consumption. Secondly the fix won't work
well for the very first attempt of the ULPI PHY control registers IO,
because after disabling the USB2.0 PHY suspension functionality it will
still take some time for the bus to resume from the sleep state if one has
been reached before it. So the very first PHY register read/write
operation will take more time than the busy-loop provides and the IO
timeout error might be returned anyway.

Here we suggest to fix the denoted problems in the following way. First of
all let's not disable the Suspend USB2.0 HS/FS/LS PHY functionality so to
make the controller and the USB2.0 bus more power efficient. Secondly
instead of that we'll extend the PHY IO op wait procedure with 1 - 1.2 ms
sleep if the PHY suspension is enabled (1ms should be enough as by LPM
specification it is at most how long it takes for the USB2.0 bus to resume
from L1 (Sleep) state). Finally in case if the USB2.0 PHY suspension
functionality has been disabled on the DWC USB3 controller setup procedure
we'll compensate the USB bus resume process latency by extending the
busy-loop attempts counter.

Fixes: e0082698b689 ("usb: dwc3: ulpi: conditionally resume ULPI PHY")
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20201210085008.13264-4-Sergey.Semin@baikalelectronics.ru
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/ulpi.c b/drivers/usb/dwc3/ulpi.c
index 54c877f7b51d..f23f4c9a557e 100644
--- a/drivers/usb/dwc3/ulpi.c
+++ b/drivers/usb/dwc3/ulpi.c
@@ -24,7 +24,7 @@
 static int dwc3_ulpi_busyloop(struct dwc3 *dwc, u8 addr, bool read)
 {
 	unsigned long ns = 5L * DWC3_ULPI_BASE_DELAY;
-	unsigned int count = 1000;
+	unsigned int count = 10000;
 	u32 reg;
 
 	if (addr >= ULPI_EXT_VENDOR_SPECIFIC)
@@ -33,6 +33,10 @@ static int dwc3_ulpi_busyloop(struct dwc3 *dwc, u8 addr, bool read)
 	if (read)
 		ns += DWC3_ULPI_BASE_DELAY;
 
+	reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
+	if (reg & DWC3_GUSB2PHYCFG_SUSPHY)
+		usleep_range(1000, 1200);
+
 	while (count--) {
 		ndelay(ns);
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYACC(0));
@@ -50,12 +54,6 @@ static int dwc3_ulpi_read(struct device *dev, u8 addr)
 	u32 reg;
 	int ret;
 
-	reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
-	if (reg & DWC3_GUSB2PHYCFG_SUSPHY) {
-		reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
-		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
-	}
-
 	reg = DWC3_GUSB2PHYACC_NEWREGREQ | DWC3_ULPI_ADDR(addr);
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
 
@@ -73,12 +71,6 @@ static int dwc3_ulpi_write(struct device *dev, u8 addr, u8 val)
 	struct dwc3 *dwc = dev_get_drvdata(dev);
 	u32 reg;
 
-	reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYCFG(0));
-	if (reg & DWC3_GUSB2PHYCFG_SUSPHY) {
-		reg &= ~DWC3_GUSB2PHYCFG_SUSPHY;
-		dwc3_writel(dwc->regs, DWC3_GUSB2PHYCFG(0), reg);
-	}
-
 	reg = DWC3_GUSB2PHYACC_NEWREGREQ | DWC3_ULPI_ADDR(addr);
 	reg |= DWC3_GUSB2PHYACC_WRITE | val;
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);

