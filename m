Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB26292C36
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 19:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730498AbgJSRDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 13:03:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:32896 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730926AbgJSRCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 13:02:47 -0400
Date:   Mon, 19 Oct 2020 17:02:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603126965;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e8ek/MHNvjx+EwcgMnr8LVpLx35mWzxIKmXstJ4BxBs=;
        b=t8sui3wly760BKOGst8dqKX/nLV1W6MCRg7ZsnKsrkGObhmN8pywSQE1kmp+MyZXyrHyHC
        0gTMJDsDZ/MJOReKFmK60plXh6u85aUQZiUHjG7DjR/bPwpnWx4MZt8FjtX1asZ7nkGkWr
        Vc4DqfOepN0KTvmgCwpuy3UE8CL4dlPmbcnit5zpzaoUK1pgJ4Ljc2N12omH3Jek2kQU6S
        FfllJxUyWbSNQDp4p7tCltMkL9QRIBEqnthDFfYGOI/IAXmjbQnAmO3PhOJSd1r0qJ7Hfa
        fahwbVe0OwD1O2Ice9gMMzqiHo3OQBugTzy/QeMPQJ+S3jVwzFVBstb8PyMYnA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603126965;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e8ek/MHNvjx+EwcgMnr8LVpLx35mWzxIKmXstJ4BxBs=;
        b=Cg5y6AEKfqmK1ZTL82W8+0z/HqlROmevVjEYnVOmU8ei8p1ERSq+ByItnPb54iUtROYk7A
        7HlBQk2szjKzzbAQ==
From:   "tip-bot2 for Leonid Bloch" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] USB: serial: option: Add Telit FT980-KS composition
Cc:     Leonid Bloch <lb.workbox@gmail.com>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ce86bc05-f4e2-b199-0cdc-792715e3f275@asocscloud.com>
References: <ce86bc05-f4e2-b199-0cdc-792715e3f275@asocscloud.com>
MIME-Version: 1.0
Message-ID: <160312696484.7002.7375378127471146676.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     da6f40842515774026d5bfad297491eb513c40cc
Gitweb:        https://git.kernel.org/tip/da6f40842515774026d5bfad297491eb513c40cc
Author:        Leonid Bloch <lb.workbox@gmail.com>
AuthorDate:    Sun, 04 Oct 2020 18:58:13 +03:00
Committer:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitterDate: Sat, 17 Oct 2020 08:31:21 +02:00

USB: serial: option: Add Telit FT980-KS composition

commit 924a9213358fb92fa3c3225d6d042aa058167405 upstream.

This commit adds the following Telit FT980-KS composition:

0x1054: rndis, diag, adb, nmea, modem, modem, aux

AT commands can be sent to /dev/ttyUSB2.

Signed-off-by: Leonid Bloch <lb.workbox@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/ce86bc05-f4e2-b199-0cdc-792715e3f275@asocscloud.com
Link: https://lore.kernel.org/r/20201004155813.2342-1-lb.workbox@gmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index a65e620..2a3bfd6 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1187,6 +1187,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1053, 0xff),	/* Telit FN980 (ECM) */
 	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1054, 0xff),	/* Telit FT980-KS */
+	  .driver_info = NCTRL(2) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),
