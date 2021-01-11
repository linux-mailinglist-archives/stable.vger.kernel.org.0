Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E552F136B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbhAKNIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:08:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:54966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731006AbhAKNIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:08:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC6E0227C3;
        Mon, 11 Jan 2021 13:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370487;
        bh=EZCG3g6PN/SBPzMjhODmEhS03K20r8C5hjtCXyWJrjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOfMIDthUirc43FjesEbRNi1e/izbID2BSPMYaK5UbLiMlNkAQvQkA9kGsfYW48+5
         gyylRz3zyVXMEivhYo27UKd+arLbbwYQQKLfgy4y4xZl6nBL2Hv7jRGEv3ObyIzqFY
         uJA/GtmyItE612vpBxppZGQcjDvS7BPxZGJtlJiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Georgi Bakalski <georgi.bakalski@gmail.com>,
        Sean Young <sean@mess.org>, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.19 44/77] USB: cdc-acm: blacklist another IR Droid device
Date:   Mon, 11 Jan 2021 14:01:53 +0100
Message-Id: <20210111130038.522290577@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
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
@@ -1939,6 +1939,10 @@ static const struct usb_device_id acm_id
 	{ USB_DEVICE(0x04d8, 0x0083),	/* Bootloader mode */
 	.driver_info = IGNORE_DEVICE,
 	},
+
+	{ USB_DEVICE(0x04d8, 0xf58b),
+	.driver_info = IGNORE_DEVICE,
+	},
 #endif
 
 	/*Samsung phone in firmware update mode */


