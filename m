Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9720F41A635
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 05:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238852AbhI1Dwb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 27 Sep 2021 23:52:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:45703 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238850AbhI1Dwa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 23:52:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="285625770"
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="285625770"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 20:50:50 -0700
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="518824827"
Received: from msaber-mobl.amr.corp.intel.com (HELO [10.209.117.154]) ([10.209.117.154])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 20:50:50 -0700
User-Agent: Microsoft-MacOutlook/16.53.21091200
Date:   Mon, 27 Sep 2021 20:50:49 -0700
Subject: Re: [PATCH] bluetooth: Add another Bluetooth part for Realtek 8852AE
From:   Tedd An <tedd.an@linux.intel.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
CC:     <linux-bluetooth@vger.kernel.org>, Hilda Wu <hildawu@realtek.com>,
        Stable <stable@vger.kernel.org>
Message-ID: <16103760-4979-45E1-9BEF-09618B584F1C@linux.intel.com>
Thread-Topic: [PATCH] bluetooth: Add another Bluetooth part for Realtek 8852AE
References: <20210927204302.10871-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20210927204302.10871-1-Larry.Finger@lwfinger.net>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Larry

﻿On 9/27/21, 1:43 PM, "Larry Finger" <larry.finger@gmail.com on behalf of Larry.Finger@lwfinger.net> wrote:

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

Not able to apply patch to the bluetooth-next thus cannot run CI.
Please rebase to the tip and submit again.

     	/* Realtek Bluetooth devices */
     	{ USB_VENDOR_AND_INTERFACE_INFO(0x0bda, 0xe0, 0x01, 0x01),
    -- 
    2.33.0

Regards,
Tedd


