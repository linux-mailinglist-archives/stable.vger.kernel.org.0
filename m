Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C092F159B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731975AbhAKNma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:42:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730877AbhAKNMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:12:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDDB222B30;
        Mon, 11 Jan 2021 13:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370688;
        bh=uZWWJtDItxlbS+YzL0lejqaxMEfOhiAbgQ80tF0E51s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAjeCBygKPguIVbuCixkJLeQuqE0cXZfvd5meI1rdn3ERIongathA1P9Fl9HEpZm2
         5w16AmL/femtG4mbK7OCwySYpoKWkpTIP80Xpvc41Atw2j1zAf00FJTkOwZUQXhB4A
         /zCcUJLeuOPFVnSRJS9fDPEOvZu+CqwKmwBINtA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Georgi Bakalski <georgi.bakalski@gmail.com>,
        Sean Young <sean@mess.org>, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.4 54/92] USB: cdc-acm: blacklist another IR Droid device
Date:   Mon, 11 Jan 2021 14:01:58 +0100
Message-Id: <20210111130041.746189609@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 0ffc76539e6e8d28114f95ac25c167c37b5191b3 upstream.

This device is supported by the IR Toy driver.

Reported-by: Georgi Bakalski <georgi.bakalski@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201227134502.4548-2-sean@mess.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1907,6 +1907,10 @@ static const struct usb_device_id acm_id
 	{ USB_DEVICE(0x04d8, 0x0083),	/* Bootloader mode */
 	.driver_info = IGNORE_DEVICE,
 	},
+
+	{ USB_DEVICE(0x04d8, 0xf58b),
+	.driver_info = IGNORE_DEVICE,
+	},
 #endif
 
 	/*Samsung phone in firmware update mode */


