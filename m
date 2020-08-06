Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CEC23DEAE
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 19:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbgHFR2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 13:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729701AbgHFRA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 13:00:58 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B37C0611E2;
        Thu,  6 Aug 2020 04:55:55 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id bo3so27355717ejb.11;
        Thu, 06 Aug 2020 04:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i/S5/6ro5vnkPW0QsQGxfYyHXJsq3PWIkSz7FKePTT4=;
        b=unzLLfAH+rZML4MlQOvgwH6d4GmVqwjYK94T/kAmj17VHRJbmSeKf/ii0FBScS+rEB
         GtPClBQgD6vTvW1tdb+J6xefIU2V2MSKTCSADqI0Di9xNpW07VzYSJMdPsJrT7eCxKjG
         llef3L6bbJ34pmh1ji9vZQ1aBz4YR0nRjbSgUQvBtIWY9E+HhUP+8zkqRW+cC8TBW0t0
         g7Jov0HEYjz3WohDLrpA4AhI4LvFouGU7QSJc6rVD9lSVjjXj0iwuo18wMQtESw7w5+x
         GOsw85vFQjlZGCMuDZXm1ESOhYU/fbs5+/gBLpNQgV1bCsIfDINaa1a7zLGNvR2MMt4j
         WcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i/S5/6ro5vnkPW0QsQGxfYyHXJsq3PWIkSz7FKePTT4=;
        b=MhAd2NRGr0h4cjvD6MOE4B8qGBZjGGXPLzx9BqPefxDxkCjolv+jkiE6y/t1nEjkT2
         2nlfbHkMbETW9+ZrovKpjo/pxc8yUctFU0MIFaRx8oJSrD2sgIuHG4RUWsZb4d+50CTy
         zzipvH7hrCjXH2/Lf6yu35FZcCWnef+Gm9PXhGqUvhglRpZGF/Z8PbrjWIH+6GEVYQQ8
         8y/Td4q7MkZB0vRgXY+b/Rk0P0loDqkhdRviuZcuYAjmULuG8he6C0o1NQbri+HP8yQG
         ppU4caq66P8QNzXYMYJT99Ip2uuwK/DmgwZpeNA9Cl85pK7Q+Kzd3n+j1GWCc0P6b8uS
         YePQ==
X-Gm-Message-State: AOAM530X4PSPhTrRTXVhC8c+5hRcsmsSNyCU6d1xDvVabNbY41IYkBlS
        BrIkqJQhp3AUIP9u+PpZ1pE=
X-Google-Smtp-Source: ABdhPJweP3zqc4d6VrXhoiDQpQN9FYCJdIjzjviNT+ke6aNdM34mOc0oCp9NcnOOzpKpooZ8wA4puw==
X-Received: by 2002:a17:907:94ce:: with SMTP id dn14mr3816428ejc.351.1596714954327;
        Thu, 06 Aug 2020 04:55:54 -0700 (PDT)
Received: from ci00583-linux.xsens-tech.local (2001-1c06-0702-ba00-2186-bbad-ad24-4c2a.cable.dynamic.v6.ziggo.nl. [2001:1c06:702:ba00:2186:bbad:ad24:4c2a])
        by smtp.googlemail.com with ESMTPSA id gh24sm3628420ejb.45.2020.08.06.04.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 04:55:53 -0700 (PDT)
From:   Patrick Riphagen <ppriphagen@gmail.com>
X-Google-Original-From: Patrick Riphagen <patrick.riphagen@xsens.com>
To:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     patrick.riphagen@xsens.com, stable@vger.kernel.org
Subject: [PATCH V2] USB: serial: ftdi_sio: add IDs for Xsens Mti USB converter
Date:   Thu,  6 Aug 2020 13:55:47 +0200
Message-Id: <20200806115547.8007-1-patrick.riphagen@xsens.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Riphagen <patrick.riphagen@xsens.com>

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
V2: Added CC to stable, From line to match SoB and version in subject

