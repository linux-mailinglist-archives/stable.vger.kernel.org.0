Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C768E3833C8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239444AbhEQPCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242641AbhEQPAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:00:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01F5A619D5;
        Mon, 17 May 2021 14:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261605;
        bh=DykbBS9B3GBNT6APzCYhnEXR7x69pcyvFvShwrP/fRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRZvzngCcV8MP2KGVxtlsUvoSZN/FfJ7dQ0ftACoOPG3JzTh87EfLw0ROMWn0/OAw
         Y9E8O7nmfiD7Z0VRD/ZRdAYiyHh/XJ0myB55HXDHtKTfgdIJMv/uehLDsbCdnZlUiz
         YhSkeQSJHr8K2kG3tZ5fyGCfH4xQ5t8M+jZ1Q8PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "mark-yw.chen" <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/289] Bluetooth: btusb: Enable quirk boolean flag for Mediatek Chip.
Date:   Mon, 17 May 2021 15:59:24 +0200
Message-Id: <20210517140306.514717016@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: mark-yw.chen <mark-yw.chen@mediatek.com>

[ Upstream commit 27e554a4fcd84e499bf0a82122b8c4c3f1de38b6 ]

Adding support LE scatternet and WBS for Mediatek Chip

Signed-off-by: mark-yw.chen <mark-yw.chen@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 2953b96b3ced..175cb1c0d569 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -392,7 +392,9 @@ static const struct usb_device_id blacklist_table[] = {
 
 	/* MediaTek Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0e8d, 0xe0, 0x01, 0x01),
-	  .driver_info = BTUSB_MEDIATEK },
+	  .driver_info = BTUSB_MEDIATEK |
+			 BTUSB_WIDEBAND_SPEECH |
+			 BTUSB_VALID_LE_STATES },
 
 	/* Additional Realtek 8723AE Bluetooth devices */
 	{ USB_DEVICE(0x0930, 0x021d), .driver_info = BTUSB_REALTEK },
-- 
2.30.2



