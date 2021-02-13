Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDFB31A88B
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 01:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhBMADm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 19:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbhBMADg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 19:03:36 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9483C061574
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 16:02:55 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id m1so1367237wml.2
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 16:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vMh6EGGvTJYwrXGUrFUBzMOC53RMRoX94LvlMeiKhuw=;
        b=c14nayi7HL892+Uol7qIFGwqtD660yql+KJtuH+vALcORZ8qebkrexulN6p2NoJQIa
         j6OS/pLYHBXK4CiqUNE9isJs89gz5G79Q3eeb/ZwAL8ucve51dI8fqDz61uiYGXc01Bw
         in7aAWU7gh9A1F0UbB5EBLhpec3EU38ISCA8rARhil5amyR+vC1uNfG+6tnAF1xH/mGE
         eRaa9SqHt/RaHTUbc0ne1PkjaiUxIDwwCGAxXBRN9Rem5O/NCzOKps9d7EB8cPDDgTIN
         zdQLDitgi9aJTZhEsgRTSTSuIAd0KJyJ1tj3eNFJxKUjAXg36Cl+iFBhnJFXSs+Ux/uA
         UQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vMh6EGGvTJYwrXGUrFUBzMOC53RMRoX94LvlMeiKhuw=;
        b=CItw0G1Q6hTATdaVyu9jEy6bTkSQwUE5C5qtT3AHn3IMw4HPs9CP61Lw89foNaf0ZX
         KTJBj9Q9o0V01CzTFKEDXSEI3+bemomsPeI5kt3LS1plvkdLPybzkKUaXtirQAbC6c1d
         2s4IJBauwxs5Wxz2BYL7S/gHdjyGJo2KXjW+0ms5z6ZiXBB6Yy2hLulZKhTaZw/fn6P3
         px2Ysm9LiwFlWYE6WbwAMy+Mpcq/nUXprNdlOY4jlHE+5PxshX0CYhQ50tZDk2DIld3N
         shjvdzYHu45WgBPZT67YTJbKw14+0Vg6vvksgIYw5fL40rs1UkQ4MxA2v7g2y69rEdC6
         xtxg==
X-Gm-Message-State: AOAM532AI4aXetHDxfT/RIwcSg16WjxDLXvSjv0jQaTI4HhmaVKpc/Ov
        jgyHU7pnJBPC6KCv7f92z0g=
X-Google-Smtp-Source: ABdhPJzh0NQljVw9q+rxkap9Btj0DUR4iEu5qT8bHB73K+cr+gGISiJ43jApZZmHf77AwUQ/fObZ+A==
X-Received: by 2002:a05:600c:2210:: with SMTP id z16mr4679784wml.50.1613174574492;
        Fri, 12 Feb 2021 16:02:54 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id j40sm14807915wmp.47.2021.02.12.16.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:02:53 -0800 (PST)
Date:   Sat, 13 Feb 2021 00:02:52 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Sergey.Semin@baikalelectronics.ru, heikki.krogerus@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: dwc3: ulpi: Replace CPU-based
 busyloop with" failed to apply to 4.14-stable tree
Message-ID: <YCcXLGkHVYfmO8Pj@debian>
References: <161035422122542@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="K7RLa8IsMSqGv4Iz"
Content-Disposition: inline
In-Reply-To: <161035422122542@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--K7RLa8IsMSqGv4Iz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 11, 2021 at 09:37:01AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, along with 2a499b452952 ("usb: dwc3: ulpi: fix checkpatch warning")
which makes backporting easy.

--
Regards
Sudip

--K7RLa8IsMSqGv4Iz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-usb-dwc3-ulpi-fix-checkpatch-warning.patch"

From dcdc76aadec9417bc4be087aa2a6374b168ee1f3 Mon Sep 17 00:00:00 2001
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
index d3b68e97096e..231f7cf5c7b2 100644
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


--K7RLa8IsMSqGv4Iz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-usb-dwc3-ulpi-Replace-CPU-based-busyloop-with-Protoc.patch"

From 46a78fd7786a27206e2f67550fc6f6adabfed603 Mon Sep 17 00:00:00 2001
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
index 231f7cf5c7b2..bc2dd9499ea0 100644
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
 		if (reg & DWC3_GUSB2PHYACC_DONE)
 			return 0;
@@ -50,7 +62,7 @@ static int dwc3_ulpi_read(struct device *dev, u8 addr)
 	reg = DWC3_GUSB2PHYACC_NEWREGREQ | DWC3_ULPI_ADDR(addr);
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
 
-	ret = dwc3_ulpi_busyloop(dwc);
+	ret = dwc3_ulpi_busyloop(dwc, addr, true);
 	if (ret)
 		return ret;
 
@@ -74,7 +86,7 @@ static int dwc3_ulpi_write(struct device *dev, u8 addr, u8 val)
 	reg |= DWC3_GUSB2PHYACC_WRITE | val;
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
 
-	return dwc3_ulpi_busyloop(dwc);
+	return dwc3_ulpi_busyloop(dwc, addr, false);
 }
 
 static const struct ulpi_ops dwc3_ulpi_ops = {
-- 
2.30.0


--K7RLa8IsMSqGv4Iz--
