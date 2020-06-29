Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974AF20D0B8
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgF2SfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgF2SfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC3AA2463D;
        Mon, 29 Jun 2020 15:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443962;
        bh=agRQypckGCYSkFlC3kExSSvrt4mjZ/93NTQyMsU16ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+66mibu3tqVwziL4d/KoxdDhwCEmieu2O9ct3/MmkXILE0RxL0XblY8af+2UE9jH
         sMDDVe0o82f0nphFLJdVTsIjOs0FQSclBckFclJksm8QVEHcpNgk8ucpMwyQzAMqHA
         a/7LpqH3KGo7wLCKOrr2FaMZxYmJcAmfAWOu1J8g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Tomasz=20Meresi=C5=84ski?= <tomasz@meresinski.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 065/265] usb: add USB_QUIRK_DELAY_INIT for Logitech C922
Date:   Mon, 29 Jun 2020 11:14:58 -0400
Message-Id: <20200629151818.2493727-66-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomasz Meresiński <tomasz@meresinski.eu>

commit 5d8021923e8a8cc37a421a64e27c7221f0fee33c upstream.

The Logitech C922, just like other Logitech webcams,
needs the USB_QUIRK_DELAY_INIT or it will randomly
not respond after device connection

Signed-off-by: Tomasz Meresiński <tomasz@meresinski.eu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200603203347.7792-1-tomasz@meresinski.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 3e8efe759c3e6..e0b77674869ce 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -218,11 +218,12 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* Logitech HD Webcam C270 */
 	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME },
 
-	/* Logitech HD Pro Webcams C920, C920-C, C925e and C930e */
+	/* Logitech HD Pro Webcams C920, C920-C, C922, C925e and C930e */
 	{ USB_DEVICE(0x046d, 0x082d), .driver_info = USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x046d, 0x0841), .driver_info = USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x046d, 0x0843), .driver_info = USB_QUIRK_DELAY_INIT },
 	{ USB_DEVICE(0x046d, 0x085b), .driver_info = USB_QUIRK_DELAY_INIT },
+	{ USB_DEVICE(0x046d, 0x085c), .driver_info = USB_QUIRK_DELAY_INIT },
 
 	/* Logitech ConferenceCam CC3000e */
 	{ USB_DEVICE(0x046d, 0x0847), .driver_info = USB_QUIRK_DELAY_INIT },
-- 
2.25.1

