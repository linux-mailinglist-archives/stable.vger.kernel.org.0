Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193512F0E4A
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 09:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbhAKIhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:37:16 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:53833 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727856AbhAKIhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:37:16 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 9070824DE;
        Mon, 11 Jan 2021 03:35:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 11 Jan 2021 03:35:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dkel7I
        VOw+FwEifRhbBbb8eZGbCOpZW8BLTqwcdhXnM=; b=O3qo1kfQBTpDzwCsn41jU6
        v2Z/DcKXYGFgP3nFIH+wuRnbvFfMF+FtdYJhvSxBXnrBgRPKISdTAik6eILr9bqM
        8/SD8/Mm2KEEH1xnD3eAlkHTZ+a7THXyvgJ13pBwTOqk8hTPSVUtcWMB1gMkWef9
        V78YwsX2golusRvfROsRdeHwYei9IO8PIfpBbs2j16vkRFmzxQPXbYCYvy8XrQWj
        xCqoLi3Dl7VBAqpq+6C4xzFHsf9B85utuhzqFo66ks3h7lFQxdMKXsVvXS/hWCZj
        1YOqtnlROnH8/WIfYfltl5Zw9Jdqbdx46+46mYA01oc7+C1c6huPByUqeYba1krA
        ==
X-ME-Sender: <xms:6w38X350CT-AkF31Tey-VkefkEJ7ZUKTr5mT7ryoUYAgRll9_CQOKA>
    <xme:6w38X81OTWbF93S9YhhROAIGRe-5kgIgxO6Gn2Jj0ZwOUznk6__71s7T7TeS4wO24
    QHJ_rMst72tzw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:6w38X7Ww1w_Y6Rq3tDOlgzhKkHIbcXNkvdq1T35ZI6yOaaqK_Q8pKA>
    <xmx:6w38X_7HHyahLsvDsgKj5yOok6PS2LIXmFtnjo4MDO_7Hoj-HN23IA>
    <xmx:6w38X6JkXXqLsEDpYmeyWv3SlnZylfd2BzGFwfz2Hca3trBs92MXlA>
    <xmx:7A38X3m7rdhB-j3fXbxdsLp-PfwB_YCY4nTuFLbBDfHQuPqMxRi1T4GLkZM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 66340108005B;
        Mon, 11 Jan 2021 03:35:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: dwc3: ulpi: Replace CPU-based busyloop with" failed to apply to 4.19-stable tree
To:     Sergey.Semin@baikalelectronics.ru, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:37:02 +0100
Message-ID: <1610354222183137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

