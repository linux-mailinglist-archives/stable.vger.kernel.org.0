Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10EC2FC958
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731628AbhATC3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:29:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:47346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729054AbhATB2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0E1E23159;
        Wed, 20 Jan 2021 01:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105984;
        bh=zKb5H06GpRQDY5QCgEVf4RPqkwLCkUsm81D+OU6n8gA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X63s4W76EgVP8RqpKoNnn/SqPfGeD2+oza2IzCIZ7gfPeWU/EOWC1i+afdPzr075E
         cBm2cXC7pHAQyxhoc+ZBPywutJXDtOW4tYUqiLewzN7yDGiKEg6GhgDJo0u6nhwvnD
         xHT2oklPXdIkr2Rb7KEB9K53Z0W++K25L4aIy8//wTg+bKuMMywr67Zu4IUroUopBM
         PLsGNzuduUerL3ujS1r1hR6S8jLSuGAdP5FURzRphEK4/Ce5ZogheGYImpIi9tfr7a
         owXoSVlOnUvPMBnJQfRYmIsPbv5j/C4+ZkL3rkwLRPnHnyOUOc82vi6ng32UxQen8v
         GXPfKG/e2RdLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@archlinux.org>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/45] HID: logitech-dj: add the G602 receiver
Date:   Tue, 19 Jan 2021 20:25:34 -0500
Message-Id: <20210120012602.769683-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
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
index 1ffcfc9a1e033..45e7e0bdd382b 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1869,6 +1869,10 @@ static const struct hid_device_id logi_dj_receivers[] = {
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

