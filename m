Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063FA4C03FD
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 22:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbiBVVmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 16:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235836AbiBVVmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 16:42:38 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5176156C39
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 13:42:12 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d28so8206826wra.4
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 13:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QPKYeD4WBRBRNjeNGhOhg06NZJ9QS8XP426ENqNOm+U=;
        b=jIEJfwgCRh+VlmrZRB97EOibhEvyJob/bfbwR1R2IS43rt8KhgodalPMqOQ+BF5tTC
         7BkZEiNVM3uOwMtChzQRYtVJlaRRoyHll4uGbRhBq9jf8smcte0KRnL9V6Go25us378E
         vr4RHs/eMPSMfAiyNMhl9ak8P/qFRGSP+xHASzouNi8q37wmRYl3LjLrxlXoq0+sdPRw
         b7BfYGNCD6aemIqLop40Nfe92W4NakRAjI1Ez+biRNOg7l0v1xQJCRVLu34TaqGlLOUH
         Ie9Go7ApO7WEPFpKmFJD+XTP/TSufT82VHLt96Nc+te26M2KKcuTXDSl0lNpSUH59O0Z
         +Wgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QPKYeD4WBRBRNjeNGhOhg06NZJ9QS8XP426ENqNOm+U=;
        b=Sz0ionsnku6cPAbyRTiAimdnsTs9AWwp4M8KoGAqFuDWNSFzHqD6aNu2zioSLc7Uh6
         BruGLc5b5EhFeYZqFpgrBeWzzIHEW0nh+8/3Nt4v8+BFqIEVCNZ/Zb6OInghngZy6sPp
         IL0t3PUa/ch7mGE+SSDOt/6va6gA0/GIpuUltp/VuGUPD6esZs1gkIztE6ZG6hr/zzQk
         MnESWjwTao9+IpTeSIFPLTYKbxwQA5SHoQ8K3B1GgrY/4n1xPfUt/4hquvRqCgIj6IS/
         qXjSJ2Wpr3RyD4mSEotBh1tjG4XyYHhVqkr41j8xMZR9S3tVlGqIFol3glw4VjVYC49V
         fqUA==
X-Gm-Message-State: AOAM530814xbLQ99AdYB82G5SI6zduVI7nb0zpkyqk/O0k1rmTttlwqi
        MWzhtB0E2TTKHV1CJ55dOPAraKcp5FLxkQ==
X-Google-Smtp-Source: ABdhPJy4jTwOJKs12b24iJhBApN5J6M2Rx+oTH0eyKxu0e40iXi6Cj0jCScjD906SOpET2ImSjyxgg==
X-Received: by 2002:a5d:5987:0:b0:1e8:d8ad:abc9 with SMTP id n7-20020a5d5987000000b001e8d8adabc9mr20768464wri.413.1645566130794;
        Tue, 22 Feb 2022 13:42:10 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id q13sm2841232wmg.22.2022.02.22.13.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 13:42:10 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:42:08 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     robert.hancock@calian.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] serial: 8250: of: Fix mapped region size
 when using" failed to apply to 4.14-stable tree
Message-ID: <YhVYsOb8/Fnfp10W@debian>
References: <164347177650149@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="kVsIPW/v9Rmi7cQE"
Content-Disposition: inline
In-Reply-To: <164347177650149@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kVsIPW/v9Rmi7cQE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sat, Jan 29, 2022 at 04:56:16PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--kVsIPW/v9Rmi7cQE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-serial-8250-of-Fix-mapped-region-size-when-using-reg.patch"

From 51513bebad1b1d47f2ebbe52f52de971ad2835d3 Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Wed, 12 Jan 2022 13:42:14 -0600
Subject: [PATCH] serial: 8250: of: Fix mapped region size when using
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
index c51044ba503c..0e83ce81ca33 100644
--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -102,8 +102,17 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
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


--kVsIPW/v9Rmi7cQE--
