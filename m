Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84D223D83D
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 11:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgHFJC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 05:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgHFJC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 05:02:58 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C2CC061574;
        Thu,  6 Aug 2020 02:02:58 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id q4so31369837edv.13;
        Thu, 06 Aug 2020 02:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BtAZAsrc9ChZDBxja2M8CUkXA4o6z7WOsBQ2MhI4SX4=;
        b=bWG8V9GDjLuWRiYWSTn7UBWGgM/968UMS6O8Tx/mmYR0zmowlkn5MuKiikjhedAAB5
         EwBiDYLkx72AW0mhbdoONYQ7B3Yl7w4onYe9m8w7DaDtxpCDq5hsz4lD9Nto4OlYht/T
         dypSlXuWgeifRwRCBkxYgFQy4N3TDKcVgo3Fts6qp60UBmbGxw0arRxB9hil5LMmhnbx
         cp//gsQW5BEV+B/aEhBES/zY03mbQ5HotqnaIAgthtyR1uX182YIQHtr+U2HNZ7Oi/SI
         pB0xsCFbAZFQeuVHwHrxGqALp5Pm1zNY6JuYSRRil1rKwxfRtyc8KRa99ih456Qxaopz
         yUrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BtAZAsrc9ChZDBxja2M8CUkXA4o6z7WOsBQ2MhI4SX4=;
        b=BE9X0uRD8nmHJZCVScXpuE4FNO7gEsvAP/pUcce42vxqaYgIgwj+JBrDiHws0uFbtj
         R9bQF3VvPFZzC3KShU3GVisvTtx3tUcV5Ol8npdvTi8vBTPNIY1QolPY9n7D295i3kBU
         W8PlycnKOwunpKOyewKD5/hw4+LS/fU5uaDGb8HUlprRxBg5GHAaZEAIiXptxRsUnFjL
         EwnEdhD8DXyzVThjABu9wmxCfp5ebyzA7eDcgqtWV9y62akKeEZtnmL1/zS1MynQUPwW
         wC2c3y6TNn1q/hbcFDXzuF6XPe9YIXlm2ORU8h1Yo+Jp5yMwfy+5O0+ODvJXAo99cacy
         /o3w==
X-Gm-Message-State: AOAM531u+kaxrr01poqrXzegc3Tw4EB52xBXV3S+z/LzdMVpml4D5Hu+
        qLVM2sqH81auqbudyutVEGbLgnApAKxbYA==
X-Google-Smtp-Source: ABdhPJxnRKDEntM+utjGsoNw8ngGGR4vhSsivH2K+Uec6jZBXKU45aCp4ORW6Vexm5d+0N3LVteGDQ==
X-Received: by 2002:aa7:d1cc:: with SMTP id g12mr3172241edp.385.1596704570766;
        Thu, 06 Aug 2020 02:02:50 -0700 (PDT)
Received: from ci00583-linux.xsens-tech.local (2001-1c06-0702-ba00-88c2-8039-7a6c-c842.cable.dynamic.v6.ziggo.nl. [2001:1c06:702:ba00:88c2:8039:7a6c:c842])
        by smtp.googlemail.com with ESMTPSA id x1sm3188987ejc.119.2020.08.06.02.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 02:02:50 -0700 (PDT)
From:   Patrick Riphagen <ppriphagen@gmail.com>
X-Google-Original-From: Patrick Riphagen <patrick.riphagen@xsens.com>
To:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     patrick.riphagen@xsens.com, stable@vger.kernel.org
Subject: [PATCH] USB: serial: ftdi_sio: add IDs for Xsens Mti USB converter
Date:   Thu,  6 Aug 2020 11:02:34 +0200
Message-Id: <20200806090234.4130-1-patrick.riphagen@xsens.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The device added has an FTDI chip inside.
The device is used to connect Xsens USB Motion Trackers.

Cc: stable@vger.kernel.org
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

