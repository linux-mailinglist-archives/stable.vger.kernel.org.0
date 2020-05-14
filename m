Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9604E1D3B29
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgENSzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727977AbgENSzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:55:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80FCA2076A;
        Thu, 14 May 2020 18:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482554;
        bh=iLuAsSJvE6i3GAu2VngpWHDKjlxZjjxJRO/i/Yfus+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbr7vXoLkyHmv5ArR5OGfwuqz69D1L+BJb8aMpt3eAKpGBFQVfjfN7dUX26pQQhct
         6iOByCrXVfSCgEv6oH2CsRetLIeu4NTJLcIJ5lW2IKDIyJLxBEZ2ku/sKCbCCGl+y2
         tv9RQKFLCDuYEOlNPdYFRJ2JL2XaIXeAXsG1kQU8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 03/27] HID: multitouch: add eGalaxTouch P80H84 support
Date:   Thu, 14 May 2020 14:55:26 -0400
Message-Id: <20200514185550.21462-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185550.21462-1-sashal@kernel.org>
References: <20200514185550.21462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit f9e82295eec141a0569649d400d249333d74aa91 ]

Add support for P80H84 touchscreen from eGalaxy:

  idVendor           0x0eef D-WAV Scientific Co., Ltd
  idProduct          0xc002
  iManufacturer           1 eGalax Inc.
  iProduct                2 eGalaxTouch P80H84 2019 vDIVA_1204_T01 k4.02.146

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-multitouch.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 25c0063381008..4630b58634d87 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -353,6 +353,7 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7349	0x7349
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_73F7	0x73f7
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C002	0xc002
 
 #define USB_VENDOR_ID_ELAN		0x04f3
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index fba655d639af1..1207102823de3 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1332,6 +1332,9 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_EGALAX_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
+	{ .driver_data = MT_CLS_EGALAX,
+		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C002) },
 
 	/* Elitegroup panel */
 	{ .driver_data = MT_CLS_SERIAL,
-- 
2.20.1

