Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3B11E2D2E
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392078AbgEZTM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:12:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392074AbgEZTMY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:12:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DEFD208A7;
        Tue, 26 May 2020 19:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520344;
        bh=JaCI0EjPvxTb7zB7hY+YRwycZ6E2oVyJSR+v7NnznEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xgwrx0aKJQZjQqyi96wbxJhQMFcfSxndgG9a7Z1NM0IemQZMTOaqc+7x9xbhh28eF
         /Qtd3YN7hZwEtW8ymqs/bzbrvsU+vvPklBLPVcu+hDFew8leSdqI3VLAR5dxSJEvQQ
         m4GeeQIkhgEU9ejYUxTctkwdPtrLyU+vSmFhv3e4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 025/126] HID: multitouch: add eGalaxTouch P80H84 support
Date:   Tue, 26 May 2020 20:52:42 +0200
Message-Id: <20200526183939.830939599@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9f2213426556..309510a72c5e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -385,6 +385,7 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_7349	0x7349
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_73F7	0x73f7
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
+#define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C002	0xc002
 
 #define USB_VENDOR_ID_ELAN		0x04f3
 #define USB_DEVICE_ID_TOSHIBA_CLICK_L9W	0x0401
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 362805ddf377..03c720b47306 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1922,6 +1922,9 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_EGALAX_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
 			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001) },
+	{ .driver_data = MT_CLS_EGALAX,
+		MT_USB_DEVICE(USB_VENDOR_ID_DWAV,
+			USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_C002) },
 
 	/* Elitegroup panel */
 	{ .driver_data = MT_CLS_SERIAL,
-- 
2.25.1



