Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815AA4C040D
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 22:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbiBVVsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 16:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbiBVVsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 16:48:21 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9129249267
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 13:47:52 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id w13so11985164wmi.2
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 13:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9QQnsRUMkzBxbntcbaQr/CKWSNfNjtZcg2RIv+XvffM=;
        b=bDCapg36buAqNTHUq8ua+XA3/QLthar1O+Cb2aziuhTyI32h5zCaeks+xwR0CbZ2Ds
         9B7MwOvGx7274J+WhDsnUlpi2M6M2dwZD0VYbAB35GAlrQnNRxDZlErRpW29TdxEEux1
         8yzhKCNyKccKTWUuk7kzIDN8/BfNw82yD0/finccNGKag/9SbdV61YYKeRH1MrMnoIcw
         8XpDB++Ja4SY5P38rSNUurIeUUNrGMD6mYpQXDn8jJ2x8zBRwPuWjClye4th0jFQXej5
         eUSsN6u0LU5WDJuDBd6JnpMF9QmwuB3VE4IDebnshcSnk3/+bpFl/2v0qHDkzNZv2T+3
         Gq+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9QQnsRUMkzBxbntcbaQr/CKWSNfNjtZcg2RIv+XvffM=;
        b=rTMWVJpaDx2rqVJI87kVuWGCk5wEElp7ydtSH1fL/mhzNgpqnPRQXS1dqTWbZ7ccWc
         zjOZkRDTFDpLQAqsXvp7lFzg0fqq0Pldu8WT0jzCHeh/sAIWY3Oiz6PUJkJuEoSLxc/t
         TKT8GO1iuKhe0ROT95T/z21bhqz2pCOuYZEzDPHVcDiWKpOxoSbAV369sc3uzJwF034B
         gj57z0G6nec8n+7zmTJ+NC9HAWCONOrimYvJCqxKOsKnv/fTIofi72PnwGI8OE8Yy5em
         FG2wEwvvjytJ7u4T91eCuzXxLiF+h4x6Rnfa40q2OMpfNsptm0ikhhtVRYvEQDYB6TT+
         HnXg==
X-Gm-Message-State: AOAM531ZNaks5z/ZgretASeFfhR2atW/626wexnSBEYz2IdUV/wAvhue
        edFtSu9sSXGi24hcC1T9NCI=
X-Google-Smtp-Source: ABdhPJwqM210ATJF58KaxJGF8X38x6xQ9FEM5UXIf2T6wELoTl/mIJEqeIM7ya1dC9FJrYT07tAmOA==
X-Received: by 2002:a05:600c:384c:b0:37b:c771:499c with SMTP id s12-20020a05600c384c00b0037bc771499cmr4902535wmr.141.1645566471075;
        Tue, 22 Feb 2022 13:47:51 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id c17sm3361030wmh.31.2022.02.22.13.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 13:47:50 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:47:48 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     robert.hancock@calian.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] serial: 8250: of: Fix mapped region size
 when using" failed to apply to 4.9-stable tree
Message-ID: <YhVaBJiGRUA7A5bF@debian>
References: <16434717774226@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="kXIfseZlNZcrElJw"
Content-Disposition: inline
In-Reply-To: <16434717774226@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kXIfseZlNZcrElJw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sat, Jan 29, 2022 at 04:56:17PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport along with the backport of fa9ba3acb557 ("serial:
8250: fix error handling in of_platform_serial_probe()") which will be
needed before this.


--
Regards
Sudip

--kXIfseZlNZcrElJw
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-serial-8250-fix-error-handling-in-of_platform_serial.patch"

From 0a074dc3e0271c267797332baccaf7b3c1c9a218 Mon Sep 17 00:00:00 2001
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Wed, 19 Jul 2017 11:32:37 +0300
Subject: [PATCH 1/2] serial: 8250: fix error handling in
 of_platform_serial_probe()

commit fa9ba3acb557e444fe4a736ab654f0d0a0fbccde upstream.

clk_disable_unprepare(info->clk) is missed in of_platform_serial_probe(),
while irq_dispose_mapping(port->irq) is missed in of_platform_serial_setup().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/tty/serial/8250/8250_of.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_of.c b/drivers/tty/serial/8250/8250_of.c
index f89dfde934a3..8440c92ff20c 100644
--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -86,7 +86,7 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
 	ret = of_address_to_resource(np, 0, &resource);
 	if (ret) {
 		dev_warn(&ofdev->dev, "invalid address\n");
-		goto out;
+		goto err_unprepare;
 	}
 
 	spin_lock_init(&port->lock);
@@ -132,7 +132,7 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
 			dev_warn(&ofdev->dev, "unsupported reg-io-width (%d)\n",
 				 prop);
 			ret = -EINVAL;
-			goto out;
+			goto err_dispose;
 		}
 	}
 
@@ -162,7 +162,9 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
 		port->handle_irq = fsl8250_handle_irq;
 
 	return 0;
-out:
+err_dispose:
+	irq_dispose_mapping(port->irq);
+err_unprepare:
 	if (info->clk)
 		clk_disable_unprepare(info->clk);
 	return ret;
@@ -194,7 +196,7 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
 	port_type = (unsigned long)match->data;
 	ret = of_platform_serial_setup(ofdev, port_type, &port, info);
 	if (ret)
-		goto out;
+		goto err_free;
 
 	switch (port_type) {
 	case PORT_8250 ... PORT_MAX_8250:
@@ -228,15 +230,18 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
 		break;
 	}
 	if (ret < 0)
-		goto out;
+		goto err_dispose;
 
 	info->type = port_type;
 	info->line = ret;
 	platform_set_drvdata(ofdev, info);
 	return 0;
-out:
-	kfree(info);
+err_dispose:
 	irq_dispose_mapping(port.irq);
+	if (info->clk)
+		clk_disable_unprepare(info->clk);
+err_free:
+	kfree(info);
 	return ret;
 }
 
-- 
2.30.2


--kXIfseZlNZcrElJw
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-serial-8250-of-Fix-mapped-region-size-when-using-reg.patch"

From c72c17cd65920f119eeb38406c90cae2540e8e0d Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Wed, 12 Jan 2022 13:42:14 -0600
Subject: [PATCH 2/2] serial: 8250: of: Fix mapped region size when using
 reg-offset property

commit d06b1cf28297e27127d3da54753a3a01a2fa2f28 upstream.

8250_of supports a reg-offset property which is intended to handle
cases where the device registers start at an offset inside the region
of memory allocated to the device. The Xilinx 16550 UART, for which this
support was initially added, requires this. However, the code did not
adjust the overall size of the mapped region accordingly, causing the
driver to request an area of memory past the end of the device's
allocation. For example, if the UART was allocated an address of
0xb0130000, size of 0x10000 and reg-offset of 0x1000 in the device
tree, the region of memory reserved was b0131000-b0140fff, which caused
the driver for the region starting at b0140000 to fail to probe.

Fix this by subtracting reg-offset from the mapped region size.

Fixes: b912b5e2cfb3 ([POWERPC] Xilinx: of_serial support for Xilinx uart 16550.)
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220112194214.881844-1-robert.hancock@calian.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/tty/serial/8250/8250_of.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_of.c b/drivers/tty/serial/8250/8250_of.c
index 8440c92ff20c..54ed7675e447 100644
--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -94,8 +94,17 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
 	port->mapsize = resource_size(&resource);
 
 	/* Check for shifted address mapping */
-	if (of_property_read_u32(np, "reg-offset", &prop) == 0)
+	if (of_property_read_u32(np, "reg-offset", &prop) == 0) {
+		if (prop >= port->mapsize) {
+			dev_warn(&ofdev->dev, "reg-offset %u exceeds region size %pa\n",
+				 prop, &port->mapsize);
+			ret = -EINVAL;
+			goto err_unprepare;
+		}
+
 		port->mapbase += prop;
+		port->mapsize -= prop;
+	}
 
 	/* Compatibility with the deprecated pxa driver and 8250_pxa drivers. */
 	if (of_device_is_compatible(np, "mrvl,mmp-uart"))
-- 
2.30.2


--kXIfseZlNZcrElJw--
