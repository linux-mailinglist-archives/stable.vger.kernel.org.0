Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE842F12E4
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbhAKNB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:01:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728101AbhAKNB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:01:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A113225AB;
        Mon, 11 Jan 2021 13:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370023;
        bh=1LrTAo30UoxfvSG5Zl26OAxd/3iOnNwjAik6c8Pum60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wybgc33ughduDrPT2iwEqNp+kXU+/XzQxYGn9y5kMwYBjagR3NZDD67eNkKGwiChY
         NohIe6gWEaFfvZ3h2eDgTH70huQhhNbc3pVUkwK6A/hwMHbfxPMWYslXwZeM0aOH7e
         FxySGsd6ViI03VW6FuNCnggOtR2yqHkE/+Tju5NI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Georgi Bakalski <georgi.bakalski@gmail.com>,
        Sean Young <sean@mess.org>, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.4 17/38] USB: cdc-acm: blacklist another IR Droid device
Date:   Mon, 11 Jan 2021 14:00:49 +0100
Message-Id: <20210111130033.294090516@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130032.469630231@linuxfoundation.org>
References: <20210111130032.469630231@linuxfoundation.org>
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
@@ -1894,6 +1894,10 @@ static const struct usb_device_id acm_id
 	{ USB_DEVICE(0x04d8, 0x0083),	/* Bootloader mode */
 	.driver_info = IGNORE_DEVICE,
 	},
+
+	{ USB_DEVICE(0x04d8, 0xf58b),
+	.driver_info = IGNORE_DEVICE,
+	},
 #endif
 
 	/*Samsung phone in firmware update mode */


