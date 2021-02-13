Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89A931A893
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 01:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbhBMAEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 19:04:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhBMAE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 19:04:26 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173E7C061574
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 16:03:46 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r21so1307372wrr.9
        for <stable@vger.kernel.org>; Fri, 12 Feb 2021 16:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Um9PhsyBd9Bs+88noZN0PnApfZgcLF0N2YhndOSlCds=;
        b=C5X5qVyPMx3DLjYQMqsYL3cUyelht4L6owYn8D+knvW8ek/zT79yAFA6zVVuuCGld0
         3CjOI5Ucf2x0vkaNSzr6/xFK434F098hAtyZyAKIuoCq1NKrJxlGwkwxBfIX8zCVXUbJ
         9IGvvzho0Xc6h7ni9gYrtunhkXSI0cCcAHa2XBS9N4W8AGB4Wnp7He5t4U+TAo9ol0Ry
         SpRFZehtfr9Ze0WmguqNUYrk6xzmn6JY0Aucw44frzoAbXooL4eO6Q/JE2yRxctR2B5N
         N8QnzMBrXd1N6ywOt7iFb9U9bwXgRBqecC/4sl/c8Fupt1zUeJL+9Eg0lWlncvVp4bry
         E04g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Um9PhsyBd9Bs+88noZN0PnApfZgcLF0N2YhndOSlCds=;
        b=tC8yV4RDvGfJdHjnqF7BUIQ1hLIwBMyErQHOvxW8C8U3S7pG9ObKqrxH2flLUz48oa
         UMIDey1WOj0nL4w2qVl8HQFteVPkLMpsKIhRVdaYp9f5MGhASAM3AucQsO5rciSvNdwx
         BA3SDDb/O/20FBCzPE+yeE8idFHUVv6fA/xkGXJAXEysCuEhEBecRo82qlWff+eERdqK
         M0hdzo9rxRJZljmKC5qLBbZB0WY1zLDO36YIIy9wrXQ+XUcMkeUB0tuwaQ5YOp9LEARF
         qTufk47jluOK0jaMkO2XQCzdUzg/XBigq9wWkzNHaMgal7DDFm+UMVrf4IEoGOF8QVsV
         vucA==
X-Gm-Message-State: AOAM533zB5zvWTqj2OnpNYFyL7M2hPRaUImKMDPMzrfkjosMmfJ32kq+
        9+xm5vHwOup6/mU127YzucSCg0C5BPg73A==
X-Google-Smtp-Source: ABdhPJxF3g5RvKM+SrffykoF4jKWzksEyqrTqrCGO2lzoyAKu+fx+YFdoIDHWS9GsSJJ8cyjbzJIFg==
X-Received: by 2002:adf:f089:: with SMTP id n9mr6259844wro.98.1613174624848;
        Fri, 12 Feb 2021 16:03:44 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id h12sm15360485wru.18.2021.02.12.16.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:03:44 -0800 (PST)
Date:   Sat, 13 Feb 2021 00:03:42 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Sergey.Semin@baikalelectronics.ru, heikki.krogerus@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: dwc3: ulpi: Replace CPU-based
 busyloop with" failed to apply to 4.9-stable tree
Message-ID: <YCcXXkH5Oz5p718j@debian>
References: <1610354220102122@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Jyiob6+tyUuBJziy"
Content-Disposition: inline
In-Reply-To: <1610354220102122@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Jyiob6+tyUuBJziy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 11, 2021 at 09:37:00AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, along with 2a499b452952 ("usb: dwc3: ulpi: fix checkpatch warning")
which makes backporting easy.

--
Regards
Sudip

--Jyiob6+tyUuBJziy
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-usb-dwc3-ulpi-fix-checkpatch-warning.patch"

From 03e926afc1a65c54c8b90825e005c5cce0ca5407 Mon Sep 17 00:00:00 2001
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
index bd86f84f3790..df890a5a9fd3 100644
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


--Jyiob6+tyUuBJziy
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-usb-dwc3-ulpi-Replace-CPU-based-busyloop-with-Protoc.patch"

From 12646bcfce19d05086135f1a385611453d377c24 Mon Sep 17 00:00:00 2001
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
index df890a5a9fd3..3862edf59f7d 100644
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
@@ -44,7 +56,7 @@ static int dwc3_ulpi_read(struct device *dev, u8 addr)
 	reg = DWC3_GUSB2PHYACC_NEWREGREQ | DWC3_ULPI_ADDR(addr);
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
 
-	ret = dwc3_ulpi_busyloop(dwc);
+	ret = dwc3_ulpi_busyloop(dwc, addr, true);
 	if (ret)
 		return ret;
 
@@ -62,7 +74,7 @@ static int dwc3_ulpi_write(struct device *dev, u8 addr, u8 val)
 	reg |= DWC3_GUSB2PHYACC_WRITE | val;
 	dwc3_writel(dwc->regs, DWC3_GUSB2PHYACC(0), reg);
 
-	return dwc3_ulpi_busyloop(dwc);
+	return dwc3_ulpi_busyloop(dwc, addr, false);
 }
 
 static const struct ulpi_ops dwc3_ulpi_ops = {
-- 
2.30.0


--Jyiob6+tyUuBJziy--
