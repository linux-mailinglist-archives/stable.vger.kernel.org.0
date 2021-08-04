Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608433E03B3
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 16:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237674AbhHDOu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 10:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbhHDOu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 10:50:56 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7ABC0613D5;
        Wed,  4 Aug 2021 07:50:42 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id u10so3147550oiw.4;
        Wed, 04 Aug 2021 07:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xjhXqDv89gv/dmeYWyjG/9OwcWvBCCDPKyVL8UAE5T4=;
        b=Eb2X41BtoHACnVuiIH/Ll9V2N09j3Fsood9FnFMo9cdAo5zM0fx9720SqNTMS5NMq9
         PQwu8ecYoJBeK+uRb52inaQ6imeLI2ng89sXHL7ab/HyO46ltVfc52IelwiMct7NUSUL
         ByWu/7e/qE8+gDlW2B+efxPQDAvLFznK9J+W4XfGIbvJNt59erJxu1ZOzYCxKEo91URH
         +e6RXpQOHXR3VBOgocJHAJ4FTHOR87HvwiZit0lKlVIrAi3S7oZZV3q6XcJh5EnolydP
         5F2GHSWWSctarm0O4M6Ht3zW4zmshD06qIVvPBt9hmMXI3w5KiPL7WtIOHHg9BYCx2VB
         vmXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=xjhXqDv89gv/dmeYWyjG/9OwcWvBCCDPKyVL8UAE5T4=;
        b=UVovcSB9yl66JAXfD12Z+EH7MnZw/NjmNGb+2hpPwe9dLqJXI1CrGZCf8bMS+hRw40
         6FeoadEBWguJyruQKApFJKm55dhiSNBkNvFltrj3Cb6+hFrCeiZrj9/4x2UXgv5AoV4V
         5AHAYDKz86sV6wzglEjGSy3icTYhFBYcuXIRGLKf58+QU+PjTREsX05lb9+7fT1Fsf9x
         6Lo+NtPOOoaEKR3b/KpQN+XWBreOVB3sXmw2r7hGkpjIqSRheUXjpQbj5eH0bdk5WnXj
         A0KwjshtMqkYZ4jaMpbARGZ3i9DbKmk93wGvipNrKKE+m/IFGJ63OMbx2AqclWFsLWgZ
         ax8Q==
X-Gm-Message-State: AOAM5338TaNWH9CXC2F1eLNk452zOmL3xXuD84M2fQuD0uKV4gJk+Sbz
        0R85MUrJvuO2kToSnQDYN5A=
X-Google-Smtp-Source: ABdhPJxjhedbGh662fn0dmudJ2wAm6IbA1uI/W3/raSOLWOOo972+gjoxGaH1hxUCKX5SdqPItuJMg==
X-Received: by 2002:a05:6808:f8e:: with SMTP id o14mr6127166oiw.34.1628088642392;
        Wed, 04 Aug 2021 07:50:42 -0700 (PDT)
Received: from 2603-8090-2005-39b3-0000-0000-0000-100a.res6.spectrum.com.com (2603-8090-2005-39b3-0000-0000-0000-100a.res6.spectrum.com. [2603:8090:2005:39b3::100a])
        by smtp.gmail.com with ESMTPSA id w27sm364870ooc.17.2021.08.04.07.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 07:50:41 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     linux-bluetooth@vger.kernel.org, Hilda Wu <hildawu@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH v2] bluetooth: Add additional Bluetooth part for Realtek 8852AE
Date:   Wed,  4 Aug 2021 09:50:33 -0500
Message-Id: <20210804145033.4340-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This Realtek device has both wifi and BT components. The latter reports
a USB ID of 04ca:4006, which is not in the table.

The portion of /sys/kernel/debug/usb/devices pertaining to this device is

T:  Bus=02 Lev=01 Prnt=01 Port=12 Cnt=04 Dev#=  4 Spd=12   MxCh= 0
D:  Ver= 1.00 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=04ca ProdID=4006 Rev= 0.00
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
v2 - add /sys/kernel/debug/usb/devices output
---
 drivers/bluetooth/btusb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index a9855a2dd561..2a3f953172f3 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -452,6 +452,10 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Additional Realtek 8822CE Bluetooth devices */
 	{ USB_DEVICE(0x04ca, 0x4005), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	/* Bluetooth component of Realtek 8852AE device */
+	{ USB_DEVICE(0x04ca, 0x4006), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	{ USB_DEVICE(0x04c5, 0x161f), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0b05, 0x18ef), .driver_info = BTUSB_REALTEK |
-- 
2.32.0

