Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6120F39E221
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbhFGQPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:15:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231707AbhFGQOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85970613CA;
        Mon,  7 Jun 2021 16:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082378;
        bh=n0qypTD4bUxG/tpPZRl4lP3zf6bhg7tf8aDMqqAWjSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZoT+Ul+nsQ0iKUc9Ah7fbcZzOKhglgck1eibC0CcDWIOpib4za1UbOVN7Wc1Dt6C
         aIpbZOQDeW+C4A3Yehe/D0KOwZGFOWGlap2unLTjupotfKzTp3pI0WEwp5gfjF+Sc6
         gL8lAYFldUbCcu2+zK4W12soqJoygqP+N1Hrvfn+YRgjXB0fww9Kf8lBUPJsNCiPLV
         pILgPf1BXTFJf7DMSlfj/D3xr5NDE8US74zhOSi3etFWv0Wi0UxxPzNbXklg+HlNNz
         SYkeRUyV40ChfAL9IgE+V4iMpkCdn2P8BANcJSrr8keTDBegBMy0mzLxFzt+OvWfKR
         tCk7ew32+PVBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 34/49] Bluetooth: Add a new USB ID for RTL8822CE
Date:   Mon,  7 Jun 2021 12:12:00 -0400
Message-Id: <20210607161215.3583176-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

[ Upstream commit 4d96d3b0efee6416ef0d61b76aaac6f4a2e15b12 ]

Some models of the RTL8822ce utilize a different USB ID. Add this
new one to the Bluetooth driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 4a901508e48e..ddc7b86725cd 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -388,6 +388,8 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Realtek 8822CE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xb00c), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0bda, 0xc822), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek 8852AE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xc852), .driver_info = BTUSB_REALTEK |
-- 
2.30.2

