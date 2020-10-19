Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB6B292C2B
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 19:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbgJSRCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 13:02:49 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:32856 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730817AbgJSRCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 13:02:48 -0400
Date:   Mon, 19 Oct 2020 17:02:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603126966;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U+GeVhEnceiZLZ5xoly4nse1k1K2fqiY9er0KngAi9o=;
        b=I5w1gN3j/RC4TKrr/yB27PM2LGSMbLtocY/nZvNTvQrf3SGMiwqY6jGPuSLvROtiTRrJUC
        ZMr9X3FR8mxi0dGkGaBKjZdyc9OMVun9AW9GOEVnF1pQEZvr085fo41RT5QU0NqwvLVFCu
        O8kB8QjnhGQ8VDPGnZCGlEADX/Dsjr6Nydg5nojiSdY/4Z340JA9Pq8ro9JiEKqxAddz8l
        8GwXpyuzqTPocSi5Y2GiFMCspwJ0Mh3fzG8OX88QX8Nq+owcecqKbwTFk3E4oWS0oRyEFi
        mbvjqRBQ1vqhDyfFda1C0Q38+YHSmOmORQLc16ExlxoxH8mOs4ZRykFaZLLr+Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603126966;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U+GeVhEnceiZLZ5xoly4nse1k1K2fqiY9er0KngAi9o=;
        b=vyka8NYgk8iD1rRO+Cc6+EvEpKZwyTzd/eSKybgseJWBemtrzWZYNY8LGjgb5lRzE7Bs6g
        bLi4kMCXrUSNAEBQ==
From:   "tip-bot2 for Wilken Gottwalt" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] USB: serial: option: add Cellient MPL200 card
Cc:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: =?utf-8?q?=3C3db5418fe9e516f4b290736c5a199c9796025e3c=2E16017?=
 =?utf-8?q?15478=2Egit=2Ewilken=2Egottwalt=40mailbox=2Eorg=3E?=
References: =?utf-8?q?=3C3db5418fe9e516f4b290736c5a199c9796025e3c=2E160171?=
 =?utf-8?q?5478=2Egit=2Ewilken=2Egottwalt=40mailbox=2Eorg=3E?=
MIME-Version: 1.0
Message-ID: <160312696536.7002.16506934025691806768.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     a016619f0587848b1bd7178e935956d95b41e07e
Gitweb:        https://git.kernel.org/tip/a016619f0587848b1bd7178e935956d95b41e07e
Author:        Wilken Gottwalt <wilken.gottwalt@mailbox.org>
AuthorDate:    Sat, 03 Oct 2020 11:40:29 +02:00
Committer:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitterDate: Sat, 17 Oct 2020 08:31:21 +02:00

USB: serial: option: add Cellient MPL200 card

commit 3e765cab8abe7f84cb80d4a7a973fc97d5742647 upstream.

Add usb ids of the Cellient MPL200 card.

Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/3db5418fe9e516f4b290736c5a199c9796025e3c.1601715478.git.wilken.gottwalt@mailbox.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 0c6f160..a65e620 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -528,6 +528,7 @@ static void option_instat_callback(struct urb *urb);
 /* Cellient products */
 #define CELLIENT_VENDOR_ID			0x2692
 #define CELLIENT_PRODUCT_MEN200			0x9005
+#define CELLIENT_PRODUCT_MPL200			0x9025
 
 /* Hyundai Petatel Inc. products */
 #define PETATEL_VENDOR_ID			0x1ff4
@@ -1982,6 +1983,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x02, 0x01) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(MEDIATEK_VENDOR_ID, MEDIATEK_PRODUCT_DC_4COM2, 0xff, 0x00, 0x00) },
 	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MEN200) },
+	{ USB_DEVICE(CELLIENT_VENDOR_ID, CELLIENT_PRODUCT_MPL200),
+	  .driver_info = RSVD(1) | RSVD(4) },
 	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600A) },
 	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T_600E) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TPLINK_VENDOR_ID, TPLINK_PRODUCT_LTE, 0xff, 0x00, 0x00) },	/* TP-Link LTE Module */
