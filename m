Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A522D304A9B
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbhAZFA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:00:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731132AbhAYSvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51D7222B3F;
        Mon, 25 Jan 2021 18:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600639;
        bh=JvIH/5lkdHXQCODBz/Zth687PtRqCjPoQeuwe5CdNoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=reGjNTsNn0uwv5AKJ2Sg0DpdI9+ZaTQkw0lbvbFsw9XeXGtv+gyvOWuNS0csirmuc
         32XMx/oWfNMxmqZAWjBliHwXuIRMMblbEaNJC3a/QLKoO5bvxUM2CfTjkS1nEwBple
         n7iDF1p+ag5GnalHLN1VWIabpU4fssFvsMK0yRvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Miell <nmiell@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/199] HID: logitech-hidpp: Add product ID for MX Ergo in Bluetooth mode
Date:   Mon, 25 Jan 2021 19:38:05 +0100
Message-Id: <20210125183218.934836342@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Miell <nmiell@gmail.com>

[ Upstream commit 7de843dbaaa68aa514090e6226ed7c6374fd7e49 ]

The Logitech MX Ergo trackball supports HID++ 4.5 over Bluetooth. Add its
product ID to the table so we can get battery monitoring support.
(The hid-logitech-hidpp driver already recognizes it when connected via
a Unifying Receiver.)

[jkosina@suse.cz: fix whitespace damage]
Signed-off-by: Nicholas Miell <nmiell@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 0ca7231195473..74ebfb12c360e 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4051,6 +4051,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	{ /* MX Master mouse over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb012),
 	  .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_X2121 },
+	{ /* MX Ergo trackball over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb01d) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb01e),
 	  .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_X2121 },
 	{ /* MX Master 3 mouse over Bluetooth */
-- 
2.27.0



