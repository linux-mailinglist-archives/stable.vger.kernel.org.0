Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9332744F464
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 19:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhKMSHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 13:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhKMSHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 13:07:13 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB606C061766
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 10:04:20 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so11384046otj.7
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 10:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=gzDUbHxeqe88LMFvm92mDFWHAJf+HKOgnN/jSHXyL6Q=;
        b=iiiRMdOI9dG/xLRzMcWaAEYGD+SsgQygnR1Cwm44IgThZowbStFUvWgatp8wF8f5Q3
         k7tgsuy2ZcXFilxda2QC+tTW0oQqows8grvl1WioftuQsJJ4SrHYWMqK/83mLC3TcU3Y
         XzwuvDIqk5saUAUV9a0hevymKRyhtRdXYb63ZXE4T62a+pJZ0iSQzmtfi8M16y93W51+
         jDgqmZSqe/mTQVSTH+Ma4VE2PlhzED/U25lNiq/fykB4nvKuiV7HT2DEynlQsy5Gjzct
         s0oOaNYjuPnt5a+3fds0T9mp2ySzof7Kjn4uvhyz9zxcqPMZTn6lAhdszN8VeMnYAGkm
         BLAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to;
        bh=gzDUbHxeqe88LMFvm92mDFWHAJf+HKOgnN/jSHXyL6Q=;
        b=tETk9hGxOap2DK5oEmm7EKEhIJIfWTV62k6wtLnR/JrEfdYll2roZKFfpKNTqqLocO
         hz6DCKtygOCeeOL0A78Sk/vEcG2+gv/S6J9w/yXTrN6a1sH5B97K3G2H1NIxVHBdhrAZ
         74YpKCSFacQgIbrIIvsvzJz7jao/jj+o/zTCBere837/7bMwlyHNfdPRUvjN5ok9j5c0
         hANkDq/yaC0wbefL081CVslAZkiMLZL5Prt9/Cq+r1JJGnQas3ryzf+/00y8k/uRC+HR
         3LY+uLaku3HNzU1dICS47OGtm+JMxdZYfQpZm1UDNuZWMOzbqSnkHzM1IYtX/fVdUlLd
         mqNg==
X-Gm-Message-State: AOAM531rKgDFlySG9I4Fnl3o83DVOx8BRVg7MdkP9veAsv4dWrbWtj6R
        A3QEMsH2JTBpCW3dzL/GPZZbwRP69I9hdQ==
X-Google-Smtp-Source: ABdhPJwvV0aBl8R03jR1iXbe9bSmka/mtZ+OrGAqd5yyUn0RTuUz9BYppRfBNbXhr1k6fNbvh4/upQ==
X-Received: by 2002:a9d:2c43:: with SMTP id f61mr19982293otb.255.1636826659977;
        Sat, 13 Nov 2021 10:04:19 -0800 (PST)
Received: from [192.168.1.103] (cpe-24-31-246-181.kc.res.rr.com. [24.31.246.181])
        by smtp.gmail.com with ESMTPSA id u28sm2042337oth.52.2021.11.13.10.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Nov 2021 10:04:19 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Content-Type: multipart/mixed; boundary="------------OHq1hCbwXi0VauoJ9vQf63h2"
Message-ID: <a34b2eec-ce6d-de1d-7a2f-56a9fa9958be@lwfinger.net>
Date:   Sat, 13 Nov 2021 12:04:18 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: FAILED: patch "[PATCH] Bbluetooth: btusb: Add another Bluetooth
 part for Realtek" failed to apply to 5.15-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, marcel@holtmann.org,
        stable@vger.kernel.org
References: <1636807836194180@kroah.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1636807836194180@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------OHq1hCbwXi0VauoJ9vQf63h2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/21 06:50, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to<stable@vger.kernel.org>.

Greg,

The repaired patch is attached. Sorry for any inconvenience.

Larry
--------------OHq1hCbwXi0VauoJ9vQf63h2
Content-Type: message/rfc822; name="failed_patch.patch.eml"
Content-Disposition: attachment; filename="failed_patch.patch.eml"
Content-Transfer-Encoding: 7bit

>From d1dcbf615af6c3d743fed00833b409259feb540a Mon Sep 17 00:00:00 2001
From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Tue, 28 Sep 2021 13:45:20 -0500
Subject: [PATCH] Bluetooth: btusb: Add another Bluetooth part for Realtek
 8852AE

This Realtek device has both wifi and BT components. The latter reports
a USB ID of 0bda:4852, which is not in the table.

When adding the new device, I noticed that the RTL8852AE was mentioned in
two places. These are now combined.

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

Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index da85cc14f931..34363d3c85e5 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -384,8 +384,12 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Realtek 8852AE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xc852), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0bda, 0x4852), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x04c5, 0x165c), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x04ca, 0x4006), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Realtek Bluetooth devices */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0bda, 0xe0, 0x01, 0x01),
@@ -456,10 +460,6 @@ static const struct usb_device_id blacklist_table[] = {
 	/* Additional Realtek 8822CE Bluetooth devices */
 	{ USB_DEVICE(0x04ca, 0x4005), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
-	/* Bluetooth component of Realtek 8852AE device */
-	{ USB_DEVICE(0x04ca, 0x4006), .driver_info = BTUSB_REALTEK |
-						     BTUSB_WIDEBAND_SPEECH },
-
 	{ USB_DEVICE(0x04c5, 0x161f), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0b05, 0x18ef), .driver_info = BTUSB_REALTEK |

--------------OHq1hCbwXi0VauoJ9vQf63h2--

