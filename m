Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B74FAE42
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 11:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbfKMKOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 05:14:12 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46620 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKMKOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 05:14:11 -0500
Received: by mail-wr1-f66.google.com with SMTP id b3so1613930wrs.13
        for <stable@vger.kernel.org>; Wed, 13 Nov 2019 02:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RP3pP9qx8PCTjW6ZCkvepli+qjDt0nMAodv/R1yDn3Y=;
        b=nV/2ekFOhvDZZSXzQJJzLLvSkxSf4msK6zLARVltWW9El0bV4nyNyPCkKPS7uup+Gd
         UR1ekr9/fINRBfnnbZObfgKMnmW7qT0WeUDgbw4L50gAZH6X9tsqtHc5FeEZhpo65Cdi
         GbEK8aR4hcPeCwbvyHvGgLBZKxoCMiOYCEKaXZ8EiBUqGKsu3rvb9mzo9vxDLma+VJVP
         TG0y42fEhoOWmDId0RtrhvAl+ZPGLL3uB+u5i2asAT2nQ+Vsx5o236mhM3i4nSLPrz44
         n8LL+HTZw3d0mThUW6Sw0i4iXdp9qFVdfYFuZBzCGeyP2S9oWCJHRU1B8cWa+5v4kye5
         CIcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RP3pP9qx8PCTjW6ZCkvepli+qjDt0nMAodv/R1yDn3Y=;
        b=NFhODmWKDIwEElFfoG5cmvs5Ds4FWRu1RqXCAsRdn8qp3Oqp56Q/L21aI8ECoKcsuv
         2r2HMczyNZ0SuthMzEsh3LncoinBgNvktofnDxIVcJ0AK2marZ7Bv/hzppyTMCiivfIh
         lU1kFbUDtBIKahJ8wpDnhtJ7NtDNviSrbYl9jI1c0yPsjXmX5HSFj3agZrsUmrPkuCvc
         BWyL9ItSPd5eRY+t9jRhSMSQNKJJ1tBzJ+rwgPzDb8gw4iSi1SG3iIDm4mtMi86lkbY2
         RqGKwaVkeLkhSuizW81fucFRflI3Yw8ZeY4BVBE+XK5cSyl6Wa+2+gqqzjOu60VrFN3N
         OreA==
X-Gm-Message-State: APjAAAUq0t/AmvvAKkHsOlnQSPP6Ja/FjU1ubMKADKGDaMD+smbRtuCM
        JXS9GBszHU6QCpkd3RxBFNAgAg==
X-Google-Smtp-Source: APXvYqw6qY0JTtU1D/gprl/kp1t6XQ7/cafR+AroSkVG2viQcXV2oyOneg4YQkBIFPHZcD5jWwhJ3Q==
X-Received: by 2002:adf:d18b:: with SMTP id v11mr2135670wrc.308.1573640049846;
        Wed, 13 Nov 2019 02:14:09 -0800 (PST)
Received: from ares.lan (232.red-88-3-18.dynamicip.rima-tde.net. [88.3.18.232])
        by smtp.gmail.com with ESMTPSA id y15sm2076324wrh.94.2019.11.13.02.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 02:14:09 -0800 (PST)
From:   Aleksander Morgado <aleksander@aleksander.es>
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>
Subject: [PATCH] USB: serial: option: add support for Foxconn T77W968 LTE modules
Date:   Wed, 13 Nov 2019 11:14:05 +0100
Message-Id: <20191113101405.496557-1-aleksander@aleksander.es>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These are the Foxconn-branded variants of the Dell DW5821e modules,
same USB layout as those. The device exposes AT, NMEA and DIAG ports
in both USB configurations.

P:  Vendor=0489 ProdID=e0b4 Rev=03.18
S:  Manufacturer=FII
S:  Product=T77W968 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 6 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option

P:  Vendor=0489 ProdID=e0b4 Rev=03.18
S:  Manufacturer=FII
S:  Product=T77W968 LTE
S:  SerialNumber=0123456789ABCDEF
C:  #Ifs= 7 Cfg#= 2 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=0e Prot=00 Driver=cdc_mbim
I:  If#=0x1 Alt= 1 #EPs= 2 Cls=0a(data ) Sub=00 Prot=02 Driver=cdc_mbim
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#=0x5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
I:  If#=0x6 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)

Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
---
 drivers/usb/serial/option.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 2023f1f4edaf..787f004f24fc 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -555,6 +555,11 @@ static void option_instat_callback(struct urb *urb);
 #define WETELECOM_PRODUCT_6802			0x6802
 #define WETELECOM_PRODUCT_WMD300		0x6803
 
+/* Foxconn products */
+#define FOXCONN_VENDOR_ID			0x0489
+#define FOXCONN_PRODUCT_T77W968			0xe0b4
+#define FOXCONN_PRODUCT_T77W968_ESIM		0xe0b5
+
 
 /* Device flags */
 
@@ -1999,6 +2004,10 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(4) | RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0105, 0xff),			/* Fibocom NL678 series */
 	  .driver_info = RSVD(6) },
+	{ USB_DEVICE(FOXCONN_VENDOR_ID, FOXCONN_PRODUCT_T77W968),
+	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
+	{ USB_DEVICE(FOXCONN_VENDOR_ID, FOXCONN_PRODUCT_T77W968_ESIM),
+	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
-- 
2.24.0

