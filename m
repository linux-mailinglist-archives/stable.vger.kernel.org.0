Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B87C23C9C2
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 12:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgHEKHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 06:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgHEKGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 06:06:48 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37326C06174A;
        Wed,  5 Aug 2020 03:06:21 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id a14so15105371edx.7;
        Wed, 05 Aug 2020 03:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o31JkXgtZ4KmGQwREdAQtnazhwrTeZbjodMq4WKIsR8=;
        b=jqaR06xc5HtUs7MVw/5Go/HLs96oAV0bc+H9PNL0c4dqzWihlBfFj2W0bBeN4pyIXg
         smJeD9YmR9+XlUd8J/Ei0PdM3Ze4oSzB7TokvOG9Tr3rKMQgurDOVBM+nULiBDNoYh1b
         YMnM5huvG3CTVU502QwXy5/tjiRaXd9o0lm2tohK/oTvWzfJnSWQcIA61P5mg2ZxLkls
         jooEmRS9H8oD+rAMH+C6x22hMIjQqciHjoxhFiDlfUhtkl9StEtwPxy2xmj1IeQILcFz
         JOqTFlHe/Rh3kvmPTwXbN8iLy6kB7r80CSXYYS9Y8SHgndKnBHkXqPRmkFjQ4gg+zaYe
         QbtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o31JkXgtZ4KmGQwREdAQtnazhwrTeZbjodMq4WKIsR8=;
        b=TCtbq0hrYjY8WBPa/k+6+K6sMT6NzAGNy81pOHd/3Hj6p35+7LYnNn123YOqi1rL/y
         fX0gbXug0U2lh0u9MEdQX8xy1/zkqT4OENO6D6Tw+Uqp2exyk2vrRJ8hWR9kqk8CVKpQ
         dUWQQN2sp2S4GO06SUBv8fP3J52IhPreXa4V7y6SX2xZOQiUpQ+Vq5naPgAHg3PS60J+
         qtm2Lde3ks3sBk5gU0/Jq6kpQ1qUxtyea2T1ppG97ObtCkcL/19EDpAEU2ai2ZVHpfPb
         9n5YMKqTNpmg35C779PIcvSyLZJH7nhkOjipJzb+KV/YF7/HkEmdN09wP1J4MOMYeEWP
         wN3w==
X-Gm-Message-State: AOAM533TS60ZUUaRDxmqhh+vpZz21upe/0xUQ7zh1wqBUSNFvpT3fG3C
        Fvm+ZXRBxQnoP/mdPUBwzng7eXD3mczJUaOW
X-Google-Smtp-Source: ABdhPJwnKcUuCTNXc5gdVniToDxdlNfB7kNhTTGfx/JjK3WYYdgxPAcKRikC/CVdFUlzK7zOtFz24w==
X-Received: by 2002:a05:6402:1758:: with SMTP id v24mr2110733edx.274.1596621979408;
        Wed, 05 Aug 2020 03:06:19 -0700 (PDT)
Received: from ci00583-linux.xsens-tech.local (2001-1c06-0702-ba00-8940-6ad0-42ef-6a6f.cable.dynamic.v6.ziggo.nl. [2001:1c06:702:ba00:8940:6ad0:42ef:6a6f])
        by smtp.googlemail.com with ESMTPSA id f20sm1194723ejq.60.2020.08.05.03.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 03:06:18 -0700 (PDT)
From:   Patrick Riphagen <ppriphagen@gmail.com>
X-Google-Original-From: Patrick Riphagen <patrick.riphagen@xsens.com>
To:     stable@vger.kernel.org
Cc:     patrick.riphagen@xsens.com, Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: serial: ftdi_sio: add IDs for Xsens Mti USB converter
Date:   Wed,  5 Aug 2020 12:05:57 +0200
Message-Id: <20200805100558.18593-1-patrick.riphagen@xsens.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The device added has an FTDI chip inside.
The device is used to connect Xsens USB Motion Trackers.

Signed-off-by: Patrick Riphagen <patrick.riphagen@xsens.com>
---
 drivers/usb/serial/ftdi_sio.c     | 1 +
 drivers/usb/serial/ftdi_sio_ids.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 9ad44a96dfe3..2c08cad32f1d 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -713,6 +713,7 @@ static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(XSENS_VID, XSENS_AWINDA_STATION_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_CONVERTER_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_MTDEVBOARD_PID) },
+	{ USB_DEVICE(XSENS_VID, XSENS_MTIUSBCONVERTER_PID) },
 	{ USB_DEVICE(XSENS_VID, XSENS_MTW_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_OMNI1509) },
 	{ USB_DEVICE(MOBILITY_VID, MOBILITY_USB_SERIAL_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index e8373528264c..b5ca17a5967a 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -160,6 +160,7 @@
 #define XSENS_AWINDA_DONGLE_PID 0x0102
 #define XSENS_MTW_PID		0x0200	/* Xsens MTw */
 #define XSENS_MTDEVBOARD_PID	0x0300	/* Motion Tracker Development Board */
+#define XSENS_MTIUSBCONVERTER_PID	0x0301	/* MTi USB converter */
 #define XSENS_CONVERTER_PID	0xD00D	/* Xsens USB-serial converter */
 
 /* Xsens devices using FTDI VID */
-- 
2.25.1

