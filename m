Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D5439E291
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhFGQRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231994AbhFGQQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E853E61467;
        Mon,  7 Jun 2021 16:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082429;
        bh=UqhJ3SIEBL8LVZzYQuYX/Sxg3qd2Hxfplf+mP7Pmmsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDMrnFsP3yQCIjJl1z+usPOgsk6G7xXxobROEabu3sdPrCyUWBwNAna3SRVOrdY/k
         XArp1iHVDm/DzVXjsZXIY1cNf1a2JA/6WlGzMC6vDvZIC5zOG7VQJd1PJn3Yur7pZl
         bovTf9VszeVvLb7A2ZvAMh8V2ln4FEsTnS5v/Tw8lMkOeWwxpzCwVmFHt0fwdtgdMA
         pLM8ydDf7GdIznJ10ErzV0dyCoqaydNHJdubGG3Kh1Aa/vzU1/mFPvf6xZTg5pq2jp
         5Qtyy7hDeRqMfMof4HD1z1Ue1lNrajRwx7+dSpBLUDvrDYR3di8KxDyejThLkeFcHo
         aP1TpikQ8EHcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 24/39] Bluetooth: Add a new USB ID for RTL8822CE
Date:   Mon,  7 Jun 2021 12:13:03 -0400
Message-Id: <20210607161318.3583636-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
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
index 175cb1c0d569..b1f0b13cc8bc 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -385,6 +385,8 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Realtek 8822CE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xb00c), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0bda, 0xc822), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0bda, 0xe0, 0x01, 0x01),
-- 
2.30.2

