Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F94E382E9B
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236460AbhEQOJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238081AbhEQOHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:07:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2989E61364;
        Mon, 17 May 2021 14:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260365;
        bh=vwUpeB1vgOiMO5h7q4PTSqXlj01aCiDWEzW9M/4srSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xa+Au7Wg89zUg2UphuszR0UL7v587EDajirGfvNGOLwDIHc34bsH5Sxs5w5XRoU8x
         t0xow091D+Bx1TQRN2TbqwxnLRahBho2QwZvAKBAWQawqdu3zHeoeMPVo0zvOnboC4
         DV4G9klWaAbCufZLJIrVmnmlQILSofzJH7jG2IOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "mark-yw.chen" <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 048/363] Bluetooth: btusb: Enable quirk boolean flag for Mediatek Chip.
Date:   Mon, 17 May 2021 15:58:34 +0200
Message-Id: <20210517140304.230981606@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
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
index 5cbfbd948f67..4a901508e48e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -399,7 +399,9 @@ static const struct usb_device_id blacklist_table[] = {
 
 	/* MediaTek Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0e8d, 0xe0, 0x01, 0x01),
-	  .driver_info = BTUSB_MEDIATEK },
+	  .driver_info = BTUSB_MEDIATEK |
+			 BTUSB_WIDEBAND_SPEECH |
+			 BTUSB_VALID_LE_STATES },
 
 	/* Additional MediaTek MT7615E Bluetooth devices */
 	{ USB_DEVICE(0x13d3, 0x3560), .driver_info = BTUSB_MEDIATEK},
-- 
2.30.2



