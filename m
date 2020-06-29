Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEEC20DDE0
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732453AbgF2UUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732607AbgF2TZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B502825444;
        Mon, 29 Jun 2020 15:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445395;
        bh=GGxbJOfbtAE6e03+LO15Vu7dDc/n1vkzpcClBCmxWjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6JstPm1+ayriWKp21pgJJz14qxUqwNdo+ID1iCGRo13hZ7mF4ObgIb603x+1eYWu
         JOSF6S79efW3EoxockqrnKxsURBYa8fQsTEyouV8s/l4cf3FCymSliCby7iR6z/yYH
         Ey775wzScawAtqyJf6aFV289BXvEcg5qXIXNrZ28=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Tomasz=20Meresi=C5=84ski?= <tomasz@meresinski.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 148/191] usb: add USB_QUIRK_DELAY_INIT for Logitech C922
Date:   Mon, 29 Jun 2020 11:39:24 -0400
Message-Id: <20200629154007.2495120-149-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
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
index 27d05f0134de8..e6e0f786547bf 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -73,11 +73,12 @@ static const struct usb_device_id usb_quirk_list[] = {
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

