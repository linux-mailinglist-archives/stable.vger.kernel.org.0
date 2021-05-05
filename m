Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497663743F0
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhEEQxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236711AbhEEQuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:50:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D276B6195E;
        Wed,  5 May 2021 16:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232655;
        bh=KCjB9enV4AE4OEYByO7y+YDqkSX5uicmLY/QjLm9rog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxU+eOeImqnkVDNljkHpYr0cOPo1XGRDAFek06Et8tgMoUc8W13jLk3aSYaqR137L
         ea2nQgdy2VEzcZ/loD8UI80bU3gMrF9XWcn4S4mf5V2GI87W0xXN2FDX+cjtK2Vb09
         wn3EVzg7i/YqY62o2clb1QjE3JvW83n0Un06Nk6UHKSxa5Q9pDFfDV9EyXCEWBHU+T
         GQTEXkcaOxtso8kQ3hJvSOBHpa9Vxwg/7Mx3+dHYw8+wK9yvrbbSeI/xPPV93czKkT
         hcAid5jTfZoe1Rdnh3kUiKj/f07huu6/8QJolVG8injcmsCu13X5sKND0ijXUYPknb
         f2s5vUohKXd6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "mark-yw.chen" <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 32/85] Bluetooth: btusb: Enable quirk boolean flag for Mediatek Chip.
Date:   Wed,  5 May 2021 12:35:55 -0400
Message-Id: <20210505163648.3462507-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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

