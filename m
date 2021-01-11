Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6412F0E42
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbhAKIgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:36:35 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:37317 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbhAKIgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:36:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6006424EA;
        Mon, 11 Jan 2021 03:35:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:35:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=BXI5yP
        RcrsrrduV5E/AdGiNh3udGDkmknW9BzxhQXgw=; b=fUloGJzzIKsTom88uXDuxH
        engOyawTYFZRwAwhDB3h0anUo+c4/p5H1uF9E0zTf0xKnCLZ1kccrqP/Td8T2bvd
        vQNdFudrxSwTE8n8kSqdprLTJ+9hHvRj+wLRoFFNR1suu67gvnTzAjWWkBSvgBda
        4R93r/6rO9Pv0rTDUVvopNLhllHVC5f6JeFiP7WE5FjBEKzrBPI36hS07LE6iq5/
        YQi6T/5ltW2Kaqus01fgO54iSWzUEgATI5cVLZbyVDlBMZOLBhB91Q3HtsSLVxN+
        tRiQw234bps7eqB931Y5pd7FyxSVcnyuWF6tkfp/r+qIwP0pOzr7lsQgQU/Fh2Pw
        ==
X-ME-Sender: <xms:5A38XwzXJiXNoayZK8yua0rc01MiPJ-FtpZXYLiDn-q-5ZdxZsuXgw>
    <xme:5A38X0R0xKUqZuJ_Pwy9SLzs0iLYtnnII5MWnyIgeYquXsLJBwyfM2SJulfbhqwNN
    gXdkapJsjcC7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:5A38XyXxKjOKWFoSGBckvXVQ-hYZ33X5IjhnzNfsaxQE0Yz5xsX7ag>
    <xmx:5A38X-hW7wb690iiq4QvYoxqLphcM2zKPFOeT5WXAG_rxZJNc1IvHw>
    <xmx:5A38XyA1IIZRCaK4JGL7QhAkLZTvSNBWklytGwlPHC8VZ9poEB1vFg>
    <xmx:5Q38Xz5Xs062qQPRMcZJkBPV9e5GzKUG5F1V-9-PTcNuuN2KS69B06Y1nXs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A70E2108005C;
        Mon, 11 Jan 2021 03:35:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: dwc3: ulpi: Replace CPU-based busyloop with" failed to apply to 4.9-stable tree
To:     Sergey.Semin@baikalelectronics.ru, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:37:00 +0100
Message-ID: <1610354220102122@kroah.com>
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

From fca3f138105727c3a22edda32d02f91ce1bf11c9 Mon Sep 17 00:00:00 2001
From: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Date: Thu, 10 Dec 2020 11:50:07 +0300
Subject: [PATCH] usb: dwc3: ulpi: Replace CPU-based busyloop with
 Protocol-based one

Originally the procedure of the ULPI transaction finish detection has been
developed as a simple busy-loop with just decrementing counter and no
delays. It's wrong since on different systems the loop will take a
different time to complete. So if the system bus and CPU are fast enough
to overtake the ULPI bus and the companion PHY reaction, then we'll get to
take a false timeout error. Fix this by converting the busy-loop procedure
to take the standard bus speed, address value and the registers access
mode into account for the busy-loop delay calculation.

Here is the way the fix works. It's known that the ULPI bus is clocked
with 60MHz signal. In accordance with [1] the ULPI bus protocol is created
so to spend 5 and 6 clock periods for immediate register write and read
operations respectively, and 6 and 7 clock periods - for the extended
register writes and reads. Based on that we can easily pre-calculate the
time which will be needed for the controller to perform a requested IO
operation. Note we'll still preserve the attempts counter in case if the
DWC USB3 controller has got some internals delays.

[1] UTMI+ Low Pin Interface (ULPI) Specification, Revision 1.1,
    October 20, 2004, pp. 30 - 36.

Fixes: 88bc9d194ff6 ("usb: dwc3: add ULPI interface support")
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20201210085008.13264-3-Sergey.Semin@baikalelectronics.ru
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/ulpi.c b/drivers/usb/dwc3/ulpi.c
index 3cc4f4970c05..54c877f7b51d 100644
--- a/drivers/usb/dwc3/ulpi.c
+++ b/drivers/usb/dwc3/ulpi.c
@@ -7,6 +7,8 @@
  * Author: Heikki Krogerus <heikki.krogerus@linux.intel.com>
  */
 
+#include <linux/delay.h>
+#include <linux/time64.h>
 #include <linux/ulpi/regs.h>
 
 #include "core.h"
@@ -17,12 +19,22 @@
 		DWC3_GUSB2PHYACC_ADDR(ULPI_ACCESS_EXTENDED) | \
 		DWC3_GUSB2PHYACC_EXTEND_ADDR(a) : DWC3_GUSB2PHYACC_ADDR(a))
 
-static int dwc3_ulpi_busyloop(struct dwc3 *dwc)
+#define DWC3_ULPI_BASE_DELAY	DIV_ROUND_UP(NSEC_PER_SEC, 60000000L)
+
+static int dwc3_ulpi_busyloop(struct dwc3 *dwc, u8 addr, bool read)
 {
+	unsigned long ns = 5L * DWC3_ULPI_BASE_DELAY;
 	unsigned int count = 1000;
 	u32 reg;
 
+	if (addr >= ULPI_EXT_VENDOR_SPECIFIC)
+		ns += DWC3_ULPI_BASE_DELAY;
+
+	if (read)
+		ns += DWC3_ULPI_BASE_DELAY;
+
 	while (count--) {
+		ndelay(ns);
 		reg = dwc3_readl(dwc->regs, DWC3_GUSB2PHYACC(0));
 		if (reg & DWC3_GUSB2PHYACC_DONE)
 			return 0;
@@ -47,7 +59,7 @@ static int dwc3_ulpi_read(struct device *dev, u8 addr)
 	reg = DWC3_GUSB2PHYACC_NEWREGREQ | DWC3_ULPI_ADDR(addr);
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
 
-	ret = dwc3_ulpi_busyloop(dwc);
+	ret = dwc3_ulpi_busyloop(dwc, addr, true);
 	if (ret)
 		return ret;
 
@@ -71,7 +83,7 @@ static int dwc3_ulpi_write(struct device *dev, u8 addr, u8 val)
 	reg |= DWC3_GUSB2PHYACC_WRITE | val;
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
 
-	return dwc3_ulpi_busyloop(dwc);
+	return dwc3_ulpi_busyloop(dwc, addr, false);
 }
 
 static const struct ulpi_ops dwc3_ulpi_ops = {

