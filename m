Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5020B2FC8DC
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbhATCaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730635AbhATB26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BBF3233FE;
        Wed, 20 Jan 2021 01:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106036;
        bh=FskA9qzo0lg/bwn8gw+ku1sTXg6bRVqfVAQZfhpjkn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+5UNtJEQ/tU1PS/gCvCAP6cv5rhiTIZv/f/LckzSDPcC1swd9NTYwmeO5/Q8RoHF
         60SolnbCnSHTGfMmREJRWgunARt6VtPJDQen7P32lbC4+zFysOJUGgV0c0WNXz+/Ss
         VVxfXNK9zoAtGUIIYkC6Kie1bw/B+JAFjPIrP6m/ov/trqoi/i7hTipr2TSniXbv4j
         ZyKh6ikRYIWp8OTCXZKSIXmOp4uuw3x/QrwbYzBrI7tp5vqT8R6sVYFn2BWFsT6u51
         ObuN4qTZDBDpVZl3L62XPMZxbPiyF6g9xpnQACT+LQd+qyqpOw88gzbR/tFWI90SVg
         51EzOqOSC1pTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@archlinux.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/26] HID: logitech-dj: add the G602 receiver
Date:   Tue, 19 Jan 2021 20:26:46 -0500
Message-Id: <20210120012704.770095-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012704.770095-1-sashal@kernel.org>
References: <20210120012704.770095-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Laíns <lains@archlinux.org>

[ Upstream commit e400071a805d6229223a98899e9da8c6233704a1 ]

Tested. The device gets correctly exported to userspace and I can see
mouse and keyboard events.

Signed-off-by: Filipe Laíns <lains@archlinux.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 54d811fdcdb44..e5550a5bf49d0 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1862,6 +1862,10 @@ static const struct hid_device_id logi_dj_receivers[] = {
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
 		0xc531),
 	 .driver_data = recvr_type_gaming_hidpp},
+	{ /* Logitech G602 receiver (0xc537) */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
+		0xc537),
+	 .driver_data = recvr_type_gaming_hidpp},
 	{ /* Logitech lightspeed receiver (0xc539) */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1),
-- 
2.27.0

