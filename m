Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CFF2C073C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732131AbgKWMis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732127AbgKWMiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:38:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E233C221FB;
        Mon, 23 Nov 2020 12:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135126;
        bh=c4g0HOfMIti52aMBYC1jjrK12V24D2HoGPGU31+DZD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8ZSwsbSaVMXN8EF3hvkQCShx6nS3speP0phg/F74aStE5/VCHBdsivZ5ZS7nowq+
         l0wrRihTn9obOfAKIPESd2SwOPzzD5PfmbwWNhEAelA981l9Y87wh4yCsLXxaEYLdb
         R679qsfeDJNRMXfVXPLXNd10Ea6pfc8tt845k0h4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Cutts <hcutts@chromium.org>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/158] HID: logitech-hidpp: Add PID for MX Anywhere 2
Date:   Mon, 23 Nov 2020 13:22:21 +0100
Message-Id: <20201123121825.393302038@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Cutts <hcutts@chromium.org>

[ Upstream commit b59f38dbfd5d19eb7e03d8b639f0c0d385ba8cc5 ]

It seems that the PID 0x4072 was missing from the list Logitech gave me
for this mouse, as I found one with it in the wild (with which I tested
this patch).

Fixes: 4435ff2f09a2 ("HID: logitech: Enable high-resolution scrolling on Logitech mice")
Signed-off-by: Harry Cutts <hcutts@chromium.org>
Acked-by: Peter Hutterer <peter.hutterer@who-t.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 60cf806062821..c85070d631da5 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3741,6 +3741,7 @@ static const struct hid_device_id hidpp_devices[] = {
 	  LDJ_DEVICE(0x405e), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_X2121 },
 	{ /* Mouse Logitech MX Anywhere 2 */
 	  LDJ_DEVICE(0x404a), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_X2121 },
+	{ LDJ_DEVICE(0x4072), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_X2121 },
 	{ LDJ_DEVICE(0xb013), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_X2121 },
 	{ LDJ_DEVICE(0xb018), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_X2121 },
 	{ LDJ_DEVICE(0xb01f), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_X2121 },
-- 
2.27.0



