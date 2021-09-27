Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8F841A054
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 22:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbhI0Uoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 16:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236818AbhI0Uoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 16:44:54 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3693C061575;
        Mon, 27 Sep 2021 13:43:15 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 24so27339458oix.0;
        Mon, 27 Sep 2021 13:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lDkezwqLjLnwHuvOL/9dDAYKvPWPnTDjSvsZp/DEcvA=;
        b=Fpp4rrJGmbpEQjUc4RDESo6JawFloekhVjAHTCymSHLMZTNmcHAFMqoxRmoRXC5jr9
         jWrldbvWva9Dhcd6E1Nxw5EXSKzhGzMEWPUF6+t2ODEtHzTTg1BLHaJwmtFbDiF8PRdT
         8+LXE+3P8L6r9P04YRTNMefQF0+LEHcTdqNFs7ThyDPN3oMIsxz9IrE+KVRutPnutoUJ
         5KHkwLxR58NQFlA7RYoQK0exrsPDQYU/6h50RgBslsMLvVsYLsnn6m2R4s62GqYs9Jja
         MisXtJEqZJ9Ru1FDKUz5VW5X287t5cly/sIqjmmynGbjOJ7YcGrHYsOEoNHN6H4fipN1
         lzYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=lDkezwqLjLnwHuvOL/9dDAYKvPWPnTDjSvsZp/DEcvA=;
        b=GWusl0b/4TWPWee8OwznCf2+NnmOkQbTlDOq6mtl1fM6Z4Y9tnFbEv8sWkTGpAmGrl
         prAvhJsNqB6XOSykG9r6zZsy2iZfD2APg9bNdBXusbP8ejCDCErMTWe5eMLzzgF/f1jV
         9FOiVC1jF0O1RFXn+NIOzbuurBBzX3kkzQsH280JPyfVfOurDa+fanAk5dTZve3DfQDu
         +gqTig9id6xDeerD+eQiUYf1ecVHOHNVjNrSc/WfkLUSQ9W7LEbsqRY+pW9zaJoBrZ6s
         tebw6lTbl4U/Al41oXgA7kR6JIs8UgowuEMRZ/5F2tZEd3jGnWo+Q/yyKpwLm8dTSncS
         tqbQ==
X-Gm-Message-State: AOAM530FykvNtca8QIxtLHce0ntSHEXbRxgq5rksHPzxwx1UtbKQgQ3T
        0f9jVKa8OPo7f46nTYoGot4=
X-Google-Smtp-Source: ABdhPJw34KCfO+uH/wW0TZcn95Cn00cMamiw43flV4HdHy5lVMi3khWNNrzGpNxZ9CDaml7D5KYssg==
X-Received: by 2002:aca:3555:: with SMTP id c82mr809101oia.29.1632775395178;
        Mon, 27 Sep 2021 13:43:15 -0700 (PDT)
Received: from 2603-8090-2005-39b3-0000-0000-0000-1014.res6.spectrum.com.com (2603-8090-2005-39b3-0000-0000-0000-1014.res6.spectrum.com. [2603:8090:2005:39b3::1014])
        by smtp.gmail.com with ESMTPSA id f61sm4206180otf.73.2021.09.27.13.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 13:43:14 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     linux-bluetooth@vger.kernel.org, Hilda Wu <hildawu@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] bluetooth: Add another Bluetooth part for Realtek 8852AE
Date:   Mon, 27 Sep 2021 15:43:02 -0500
Message-Id: <20210927204302.10871-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This Realtek device has both wifi and BT components. The latter reports
a USB ID of 0bda:4852, which is not in the table.

The portion of /sys/kernel/debug/usb/devices pertaining to this device is

T:  Bus=06 Lev=01 Prnt=01 Port=03 Cnt=02 Dev#=  3 Spd=12   MxCh= 0
D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=4852 Rev= 0.00
S:  Manufacturer=Realtek
S:  Product=Bluetooth Radio
S:  SerialNumber=00e04c000001
C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 60d2fce59a71..7e1e43c216ec 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -384,6 +384,8 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Realtek 8852AE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xc852), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0bda, 0x4852), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0bda, 0xe0, 0x01, 0x01),
-- 
2.33.0

