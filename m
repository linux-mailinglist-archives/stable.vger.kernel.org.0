Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C514731A897
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 01:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhBMAFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 19:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbhBMAFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 19:05:10 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3639CC061574
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 16:04:30 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id t15so1281082wrx.13
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 16:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IUe82wqjVQudpxbY+6CHon19CMI4iCumj6blGPsUmBs=;
        b=GqHPtLxBRgh2wUOepchyEhqYjr5f8ZVaftQszh/ZbDCdQEJKcGM5dBA1TzavWxFDSI
         EH0jc5QSakCcSZRymymeTFnBGMRRErHu3jZzM/XjH2AX4ypARxs9MUvsu/oy7OGL7arv
         9oOt+ETvpDtBZOp/tNKo338Qwtrg7dMsZeDdQ2tFd58nNXwZ5E+4JEBfYy9duIP7rkgk
         QeO/yrv+u+zjK6cHvCKGsWfXyMoQOuc7mM+7HPCaVbdPtTW4nllOqmMapSUZk6xSYbY7
         SCzHyenmYpJY6kSZxV+CiMogIJoHXuIORB/FbF6D6vLY0UvqcjYOLliU4dYWENmpZpJ6
         33ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IUe82wqjVQudpxbY+6CHon19CMI4iCumj6blGPsUmBs=;
        b=i08xpqCLtYG55xYfqJktrKu5lceckxxI/aKKnkONcCACHabIZtsHBkEC4Svb9K7pOv
         sBdFJTYi3XUdZQqRRxcsegEoY2ryKOPjCSHn+aIvH57EQHoNXssRRoVdBsE7LjIjSvJt
         9/kaE0RGsdX0oyopsr0LwuGn4aJgsRLysHJsrfL0gzWmQDgY+oeeKJyXfTNfFRkgACK4
         uqhU34hGVI357TdTp0uDEU710NNKsqPuGueIsw4gdeLhN5ulmZPuS+b1ZUSnQCbrf017
         O8mQ34T+paCtQ2Qh0/8IE+qG3VOhFS1zbNRhMHpe3QBopXPI+xLhZzcPWUJuBcA/RpDS
         SRgA==
X-Gm-Message-State: AOAM531vPlPeSJVbQr4IsjEeznq6pp1azVlFs5HBjrbmkIhKbD16YAZ5
        6A0jqptsHDz9LoN02EevFZQ=
X-Google-Smtp-Source: ABdhPJydKmiEA66nU/l1NQ1hoRK2hM9M1HDyvZd//tKbaSbP/4tk7hwgCR/wdzYNmQFniJNb1bw5HQ==
X-Received: by 2002:a5d:4b8e:: with SMTP id b14mr5943581wrt.130.1613174668982;
        Fri, 12 Feb 2021 16:04:28 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id l1sm13577456wmq.17.2021.02.12.16.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:04:28 -0800 (PST)
Date:   Sat, 13 Feb 2021 00:04:26 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Sergey.Semin@baikalelectronics.ru, heikki.krogerus@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: dwc3: ulpi: Replace CPU-based
 busyloop with" failed to apply to 4.4-stable tree
Message-ID: <YCcXikcgdTJxbelw@debian>
References: <1610354218200130@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="onhq6PIxxiwkMoEA"
Content-Disposition: inline
In-Reply-To: <1610354218200130@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--onhq6PIxxiwkMoEA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 11, 2021 at 09:36:58AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, along with 2a499b452952 ("usb: dwc3: ulpi: fix checkpatch warning")
which makes backporting easy.

--
Regards
Sudip

--onhq6PIxxiwkMoEA
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-usb-dwc3-ulpi-fix-checkpatch-warning.patch"

From 3445398b1ddd749dbf1fc3cac2eaad781aafea53 Mon Sep 17 00:00:00 2001
From: Felipe Balbi <balbi@kernel.org>
Date: Thu, 13 Aug 2020 08:30:38 +0300
Subject: [PATCH 1/2] usb: dwc3: ulpi: fix checkpatch warning

commit 2a499b45295206e7f3dc76edadde891c06cc4447 upstream

no functional changes.

Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/usb/dwc3/ulpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/ulpi.c b/drivers/usb/dwc3/ulpi.c
index ec004c6d76f2..1f8f6163d47d 100644
--- a/drivers/usb/dwc3/ulpi.c
+++ b/drivers/usb/dwc3/ulpi.c
@@ -22,7 +22,7 @@
 
 static int dwc3_ulpi_busyloop(struct dwc3 *dwc)
 {
-	unsigned count = 1000;
+	unsigned int count = 1000;
 	u32 reg;
 
 	while (count--) {
-- 
2.30.0


--onhq6PIxxiwkMoEA
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-usb-dwc3-ulpi-Replace-CPU-based-busyloop-with-Protoc.patch"

From 8157753de640fabd49e0f13764b2f663542f1a4a Mon Sep 17 00:00:00 2001
From: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Date: Thu, 10 Dec 2020 11:50:07 +0300
Subject: [PATCH 2/2] usb: dwc3: ulpi: Replace CPU-based busyloop with
 Protocol-based one

commit fca3f138105727c3a22edda32d02f91ce1bf11c9 upstream

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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/usb/dwc3/ulpi.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/ulpi.c b/drivers/usb/dwc3/ulpi.c
index 1f8f6163d47d..44f1a496633c 100644
--- a/drivers/usb/dwc3/ulpi.c
+++ b/drivers/usb/dwc3/ulpi.c
@@ -10,6 +10,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/delay.h>
+#include <linux/time64.h>
 #include <linux/ulpi/regs.h>
 
 #include "core.h"
@@ -20,12 +22,22 @@
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
 		if (!(reg & DWC3_GUSB2PHYACC_BUSY))
 			return 0;
@@ -44,7 +56,7 @@ static int dwc3_ulpi_read(struct ulpi_ops *ops, u8 addr)
 	reg = DWC3_GUSB2PHYACC_NEWREGREQ | DWC3_ULPI_ADDR(addr);
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
 
-	ret = dwc3_ulpi_busyloop(dwc);
+	ret = dwc3_ulpi_busyloop(dwc, addr, true);
 	if (ret)
 		return ret;
 
@@ -62,7 +74,7 @@ static int dwc3_ulpi_write(struct ulpi_ops *ops, u8 addr, u8 val)
 	reg |= DWC3_GUSB2PHYACC_WRITE | val;
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
 
-	return dwc3_ulpi_busyloop(dwc);
+	return dwc3_ulpi_busyloop(dwc, addr, false);
 }
 
 static struct ulpi_ops dwc3_ulpi_ops = {
-- 
2.30.0


--onhq6PIxxiwkMoEA--
