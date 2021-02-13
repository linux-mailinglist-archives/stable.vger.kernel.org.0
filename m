Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299C331A887
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 01:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhBMACV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 19:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhBMACU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 19:02:20 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936CCC061574
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 16:01:39 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id j11so1145898wmi.3
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 16:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xVCQMi5Rey+AZZ+t8UZNvWNm3o+cNUVc8nqRGcYe8Xs=;
        b=Xj8whxCz832NJO1GTtRiQCT2/dL4FTaEJt1R0F21MiJOG+tsOiRUE4mzaxVnPsr6UJ
         TKXjTsa9z5p+Fy1MzQNmBCInh8cG5ueQo3n3f+GohV1ltZAIyC3GhfzG2qp3Cymj8Mnq
         H+v+bC8TvJU3Oga0o87lwE2x0tH/vecCbDz/HQJfB73fgj5whmns7AbVTsUs3NGg9zE1
         IsORjY7mX/7AD5bulUPgW29YaQVRrSqQdDcMqk+gFaJWoAHn6JihaKXrif0Y26ZLRjJM
         vc1PqhD7qSwviHmK9rpxaYDUmqLHeH7Y199T5xndct91LuMLFXzuZ9ea9JQ/6wEy2cCf
         rDwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xVCQMi5Rey+AZZ+t8UZNvWNm3o+cNUVc8nqRGcYe8Xs=;
        b=OY4C8yeuYdRDy1p/HgSr69cJWaI8oUXbzpQCGYGq7p4c2ofJRAsQSb/gc2cPtMYTIn
         qirsamnfXj4dewfTosyExGloYOl4dftCKmx1wurps47ic02UNf7e+uxJXjpTrGP1MMAL
         LMx44+SO/gKJU2HZ1Id5nh2G6DAULIlyTz8ADcZvdmwcZ7qh0KAQB05V5ak2TMGcsDVr
         JjtNA6JaTpL8MVIkFLc5gKSTnAXNnpgmAZiKBy5PjAW7K+BoXT/e093E9Ie9bwNOl3yU
         XzSGPsyrzfxEDmcqzPSa4/jRspc8+gg9WsDV1Gt8KsO90bE7yKbBef6D2eV8aYQCcG56
         5qzQ==
X-Gm-Message-State: AOAM531rI7WMdtiLB5KcYoi65LBgoAPd68XsYpeljCNs6NXK+zojMSo4
        xYX8c/BDmAr8GeyVDyktNas=
X-Google-Smtp-Source: ABdhPJzj9O59lJUKojCL/wB1cS5F98NwIimTxOn9nUtnL7hsRlxb4kzXOAt5i6fb7qpMM7/SK6hWFA==
X-Received: by 2002:a05:600c:4f46:: with SMTP id m6mr4625500wmq.160.1613174498153;
        Fri, 12 Feb 2021 16:01:38 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id e16sm14919061wrt.36.2021.02.12.16.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:01:37 -0800 (PST)
Date:   Sat, 13 Feb 2021 00:01:35 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Sergey.Semin@baikalelectronics.ru, heikki.krogerus@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: dwc3: ulpi: Replace CPU-based
 busyloop with" failed to apply to 5.4-stable tree
Message-ID: <YCcW3zX1JGnQeZhI@debian>
References: <161035422430194@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fKUPKjpbpTG4nPyH"
Content-Disposition: inline
In-Reply-To: <161035422430194@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fKUPKjpbpTG4nPyH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 11, 2021 at 09:37:04AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, along with 2a499b452952 ("usb: dwc3: ulpi: fix checkpatch warning")
which makes backporting easy. Will also apply to 4.19-stable.

--
Regards
Sudip

--fKUPKjpbpTG4nPyH
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-usb-dwc3-ulpi-fix-checkpatch-warning.patch"

From ac6ba1ce363799ff9259ceaee08dceb431f44291 Mon Sep 17 00:00:00 2001
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
index bb8271531da7..a462ef54678a 100644
--- a/drivers/usb/dwc3/ulpi.c
+++ b/drivers/usb/dwc3/ulpi.c
@@ -19,7 +19,7 @@
 
 static int dwc3_ulpi_busyloop(struct dwc3 *dwc)
 {
-	unsigned count = 1000;
+	unsigned int count = 1000;
 	u32 reg;
 
 	while (count--) {
-- 
2.30.0


--fKUPKjpbpTG4nPyH
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-usb-dwc3-ulpi-Replace-CPU-based-busyloop-with-Protoc.patch"

From 25f8c4577e254f235fc445b9d62b8d201d69c63e Mon Sep 17 00:00:00 2001
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
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/usb/dwc3/ulpi.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/ulpi.c b/drivers/usb/dwc3/ulpi.c
index a462ef54678a..ffe3440abb74 100644
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
-- 
2.30.0


--fKUPKjpbpTG4nPyH--
