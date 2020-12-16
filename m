Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA682DBFED
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 12:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbgLPL6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 06:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgLPL6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 06:58:42 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1022BC061794
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 03:58:02 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id r3so22947456wrt.2
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 03:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i6L0wcN/v6BV1OjCau+a4mcjFW707Cfnvj17BxFD93A=;
        b=SepKeRTkXawehkpJHtpFhwBdBY5iIJTZXGyuvnAP96iDuW0N0w5HC0Tjjm/CnJrys3
         8JMjKjxCRxmV5YeCAUEpuZWonNZYBRRuw+2+XVP81S/2yWVqRMTdlaXaiGKumFqTLjlS
         7q9nN5xOdxBQcVxdpqGPHtIcC3TVeJbgdUVWew+JusgSU48q2htxYteIW4LrmOYgVj7x
         Mghwrt80JxveQaYYMCLC/N2O1LW8JNiDkxAtW45E8w4Rcu73w0c9Lr6+pYb1DwEatGNj
         /UNzhqC10V4hKT3XCrqHb4woPYgfhxqDNYlsS9P4BlaDo2SAn0GhAWea+Xn11iKeHOtk
         utuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i6L0wcN/v6BV1OjCau+a4mcjFW707Cfnvj17BxFD93A=;
        b=HcNecxorMaDr/GjaOwEuqXhlXNZVCh0aFSV7QaRiUBoV7AI0c70rnJfOE2BcCheJfG
         sSDcipAiCAyVTyI+V2kRpuBjwpNXi1H1fuMWPh5Pn0PhBGKKl9NdNfv1/gMiFS4srd2P
         5EznwFYDAaRlvIxBkCWEDbE5YdgyZdQEukRwLuF30Dvj9EKO8DfpZZLrpltMFBlRe5yn
         GfwXmzhjFKpX1uGffaRH8tLO1XArFwQWhHxqfFaHV1SVNEHJPxUv8dANUdjZgQLi+/oV
         wv01uxSAi5JUzWgZGHrHWpczKjn/0GXhv5NzI/ENZT2+cuI1wX5YIW5vibHCDSkaTEIK
         QTgA==
X-Gm-Message-State: AOAM530+6ZU48+ywQF48xhmJ2Jf5CsjoUgvMKrkSDg4OusOqGDHItjBT
        ITZJkBLhUyxBP5Q4u4All7o=
X-Google-Smtp-Source: ABdhPJyDxyrR4Mjk1Tfn05wbo+rHXpircsljh9F7wgS2kWdQpDUpAMEL1GTrZheVm1+qUP91hr9rLg==
X-Received: by 2002:a5d:620a:: with SMTP id y10mr38051171wru.236.1608119880744;
        Wed, 16 Dec 2020 03:58:00 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id h5sm2952437wrp.56.2020.12.16.03.57.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Dec 2020 03:58:00 -0800 (PST)
Date:   Wed, 16 Dec 2020 11:57:58 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     brant.merryman@silabs.com, johan@kernel.org, phu.luu@silabs.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] USB: serial: cp210x: enable usb generic
 throttle/unthrottle" failed to apply to 4.4-stable tree
Message-ID: <20201216115758.7gfz5oxcfghsbftx@debian>
References: <159765869110835@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sfnxgt663vwb5656"
Content-Disposition: inline
In-Reply-To: <159765869110835@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sfnxgt663vwb5656
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Aug 17, 2020 at 12:04:51PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--sfnxgt663vwb5656
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-USB-serial-cp210x-enable-usb-generic-throttle-unthro.patch"

From 51b1f86f8eb5d4f0aa7653fee5cf70555a5e6b85 Mon Sep 17 00:00:00 2001
From: Brant Merryman <brant.merryman@silabs.com>
Date: Fri, 26 Jun 2020 04:22:58 +0000
Subject: [PATCH] USB: serial: cp210x: enable usb generic throttle/unthrottle

commit 4387b3dbb079d482d3c2b43a703ceed4dd27ed28 upstream

Assign the .throttle and .unthrottle functions to be generic function
in the driver structure to prevent data loss that can otherwise occur
if the host does not enable USB throttling.

Signed-off-by: Brant Merryman <brant.merryman@silabs.com>
Co-developed-by: Phu Luu <phu.luu@silabs.com>
Signed-off-by: Phu Luu <phu.luu@silabs.com>
Link: https://lore.kernel.org/r/57401AF3-9961-461F-95E1-F8AFC2105F5E@silabs.com
[ johan: fix up tags ]
Fixes: 39a66b8d22a3 ("[PATCH] USB: CP2101 Add support for flow control")
Cc: stable <stable@vger.kernel.org>     # 2.6.12
Signed-off-by: Johan Hovold <johan@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/usb/serial/cp210x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 205f31200264..13c718ebaee5 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -252,6 +252,8 @@ static struct usb_serial_driver cp210x_device = {
 	.close			= cp210x_close,
 	.break_ctl		= cp210x_break_ctl,
 	.set_termios		= cp210x_set_termios,
+	.throttle		= usb_serial_generic_throttle,
+	.unthrottle		= usb_serial_generic_unthrottle,
 	.tiocmget		= cp210x_tiocmget,
 	.tiocmset		= cp210x_tiocmset,
 	.attach			= cp210x_startup,
-- 
2.11.0


--sfnxgt663vwb5656--
