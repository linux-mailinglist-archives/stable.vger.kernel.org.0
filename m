Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7FF374248
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235374AbhEEQqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:46:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235307AbhEEQns (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:43:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 625AE6191A;
        Wed,  5 May 2021 16:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232508;
        bh=8MqLuJRpRtNfNTz+zPiLQpJ1Jfnmn5DyqkueYbf3VKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnszEe34mb8HCNinhtxXSwyMITuQOJtKWJVpXHGLcETbSgaHO+jgQoyD5zEweJUbm
         m64hpv9OANgPJLxcTzuhoy9KLTWRw/owX4/HT2SvkNlrsP5Cj0BVWYdfeqtD4+yoXH
         VXZkDPA5xsSnx2mlon4L4jycdFW7oKYaauCIFROSxncVpUeUiBxIj7Ie2yDBwjEj54
         7eDpTALbG2HBZ4uMYJWDJOZTGnlRWfFV1f5kqbIJbzEjKr32cEuQN8SLeuHjJjf1rt
         CztGHNTmWdl0mYgTzWiPSA0WV8g29TOihqFvjaCLXLzXzaGNAwxg0vFTv4OlE7K+hp
         UApirn6AcjsBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "mark-yw.chen" <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 038/104] Bluetooth: btusb: Enable quirk boolean flag for Mediatek Chip.
Date:   Wed,  5 May 2021 12:33:07 -0400
Message-Id: <20210505163413.3461611-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "mark-yw.chen" <mark-yw.chen@mediatek.com>

[ Upstream commit 27e554a4fcd84e499bf0a82122b8c4c3f1de38b6 ]

Adding support LE scatternet and WBS for Mediatek Chip

Signed-off-by: mark-yw.chen <mark-yw.chen@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index a4f834a50a98..3620981e8b1c 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -397,7 +397,9 @@ static const struct usb_device_id blacklist_table[] = {
 
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

