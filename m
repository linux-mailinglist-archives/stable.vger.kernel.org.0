Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB63331367F
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhBHPLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:11:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233199AbhBHPHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:07:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41D3C64EEC;
        Mon,  8 Feb 2021 15:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796754;
        bh=9bE04pjD2ZQka+V2J2Hx2Y63OIDquVprUhtW8LOj05Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpWbuSfCCMf1sLkfXY5rb0TYSdKFOcVuDkbOTNDDzxVPgGf/NppZo6hz3i3IGC4Co
         5a8bIdbOHfSpuXkTQ5J3HxT/Xme8mrD3N8fARKHlUHqvEuBmKPy1gJMogUVn+MeLch
         1Oa7u08i5C9CnyVFa26v7pnp9r66x9fS6GNPZoSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pho Tran <pho.tran@silabs.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 01/30] USB: serial: cp210x: add pid/vid for WSDA-200-USB
Date:   Mon,  8 Feb 2021 16:00:47 +0100
Message-Id: <20210208145805.313945239@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.239714726@linuxfoundation.org>
References: <20210208145805.239714726@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pho Tran <Pho.Tran@silabs.com>

commit 3c4f6ecd93442f4376a58b38bb40ee0b8c46e0e6 upstream.

Information pid/vid of WSDA-200-USB, Lord corporation company:
vid: 199b
pid: ba30

Signed-off-by: Pho Tran <pho.tran@silabs.com>
[ johan: amend comment with product name ]
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -204,6 +204,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1901, 0x0194) },	/* GE Healthcare Remote Alarm Box */
 	{ USB_DEVICE(0x1901, 0x0195) },	/* GE B850/B650/B450 CP2104 DP UART interface */
 	{ USB_DEVICE(0x1901, 0x0196) },	/* GE B850 CP2105 DP UART interface */
+	{ USB_DEVICE(0x199B, 0xBA30) }, /* LORD WSDA-200-USB */
 	{ USB_DEVICE(0x19CF, 0x3000) }, /* Parrot NMEA GPS Flight Recorder */
 	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
 	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */


