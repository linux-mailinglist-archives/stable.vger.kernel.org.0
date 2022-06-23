Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFA2557566
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 10:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiFWI0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 04:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiFWI0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 04:26:37 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729BB48883;
        Thu, 23 Jun 2022 01:26:31 -0700 (PDT)
X-UUID: fb55d257849d41a2a97ea1a6b12931bc-20220623
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.6,REQID:38e7695c-074a-4db0-9de9-83513716d3a5,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:45
X-CID-INFO: VERSION:1.1.6,REQID:38e7695c-074a-4db0-9de9-83513716d3a5,OB:0,LOB:
        0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,RULE:Release_Ham,ACTIO
        N:release,TS:45
X-CID-META: VersionHash:b14ad71,CLOUDID:b938d82d-1756-4fa3-be7f-474a6e4be921,C
        OID:f395d47c0c6c,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: fb55d257849d41a2a97ea1a6b12931bc-20220623
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 875172891; Thu, 23 Jun 2022 16:26:24 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 23 Jun 2022 16:26:22 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Thu, 23 Jun 2022 16:26:22 +0800
Subject: Re: [PATCH] USB: serial: option: add Quectel RM500K module support
To:     Johan Hovold <johan@kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, <stable@vger.kernel.org>,
        Ballon Shi <ballon.shi@quectel.com>
References: <20220623035214.20124-1-macpaul.lin@mediatek.com>
 <YrQKApkdi//0ysiP@hovoldconsulting.com>
From:   Macpaul Lin <macpaul.lin@mediatek.com>
Message-ID: <8da94613-17b1-bcad-9dce-a8dd401d2e38@mediatek.com>
Date:   Thu, 23 Jun 2022 16:26:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YrQKApkdi//0ysiP@hovoldconsulting.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RDNS_NONE,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/23/22 2:36 PM, Johan Hovold wrote:
> On Thu, Jun 23, 2022 at 11:52:14AM +0800, Macpaul Lin wrote:
>> Add usb product id of the Quectel RM500K module.
>>
>> RM500K provides 2 maindatory interfaces to Linux host after enumeration.
> 
> typo: mandatory

Will be fixed on patch v2.

>>   - /dev/ttyUSB5: this is a serial interface for control path. User needs
>>     to write AT commands to this device node to query status, set APN,
>>     set PIN code, and enable/disable the data connection to 5G network.
>>   - ethX: this is the data path provided as a RNDIS devices. After the
>>     data connection has been established, Linux host can access 5G data
>>     network via this interface.
>>
>> The following kernel settings is required for RM500K.
>>   - CONFIG_USB_SERIAL_GENERIC
>>   - CONFIG_USB_SERIAL_CONSOLE

Double checked: no need confirmed.

> You shouldn't need either of those.
> 
>>   - CONFIG_USB_NET_RNDIS_HOST
>>   - CONFIG_USB_SERIAL_WWAN
>>   - CONFIG_USB_SERIAL_OPTION

Will remove this paragraph in patch v2.

> And OPTION selects WWAN so no need to mention that.
> 
> But you can probably just drop this paragraph.
> 
>> usb-devices output for 0x7001:
>> T:  Bus=05 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  3 Spd=480 MxCh= 0
>> D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
>> P:  Vendor=2c7c ProdID=7001 Rev=00.01
>> S:  Manufacturer=MediaTek Inc.
>> S:  Product=USB DATA CARD
>> S:  SerialNumber=869206050009672
>> C:  #Ifs=10 Cfg#= 1 Atr=a0 MxPwr=500mA

RDNIS interface, will be enumerated as ethX.
>> I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=02 Prot=ff Driver=rndis_host
>> E:  Ad=82(I) Atr=03(Int.) MxPS=  64 Ivl=125us
>> I:  If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_host
>> E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

COM port.
>> I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>> E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> I:  If#= 3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>> E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> I:  If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>> E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=85(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Debug interface (will be disabled with mass-production shipping).
>> I:  If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
>> E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

COM port.
>> I:  If#= 6 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>> E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=87(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> I:  If#= 7 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>> E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> I:  If#= 8 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>> E:  Ad=08(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> I:  If#= 9 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
>> E:  Ad=09(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=8a(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> 
> Can you say something about what the other interfaces are for?

The others COM ports are MODEM related interface but I'm not sure the 
exactly purpose and how they are used.

I'll summarize the part I know in patch v2.

>> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
>> Signed-off-by: Ballon Shi <ballon.shi@quectel.com>
> 
> The submitters SoB always goes last (to reflect how the patch was
> forwarded).

Will be fixed in patch v2.

> If Ballon is the primary author you need to add a From line at the
> beginning of mail body.

No need for this patch.

> Otherwise you should add a Co-developed-by tag before the co-author's
> SoB.
> 
> More details in
> 
> 	Documentation/process/submitting-patches.rst
> 

Will be fixed in patch v2.

>> Cc: stable@vger.kernel.org
>> ---
>>   drivers/usb/serial/option.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
>> index e7755d9cfc61..e2587a3c7600 100644
>> --- a/drivers/usb/serial/option.c
>> +++ b/drivers/usb/serial/option.c
>> @@ -253,6 +253,7 @@ static void option_instat_callback(struct urb *urb);
>>   #define QUECTEL_PRODUCT_BG96			0x0296
>>   #define QUECTEL_PRODUCT_EP06			0x0306
>>   #define QUECTEL_PRODUCT_EM12			0x0512
>> +#define QUECTEL_PRODUCT_RM500K			0x7001
> 
> Please keep the defines sorted by PID here.

Will be fixed in patch v2.

> 
>>   #define QUECTEL_PRODUCT_RM500Q			0x0800
>>   #define QUECTEL_PRODUCT_EC200S_CN		0x6002
>>   #define QUECTEL_PRODUCT_EC200T			0x6026
>> @@ -1135,6 +1136,7 @@ static const struct usb_device_id option_ids[] = {
>>   	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, 0x0620, 0xff, 0, 0) },
>>   	{ USB_DEVICE_INTERFACE_CLASS(QUECTEL_VENDOR_ID, 0x0700, 0xff), /* BG95 */
>>   	  .driver_info = RSVD(3) | ZLP },
>> +	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500K, 0xff, 0x00, 0x00) },
>>   	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0xff, 0x30) },
>>   	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0, 0) },
>>   	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_RM500Q, 0xff, 0xff, 0x10),
> 
> Johan
> 

Thanks for the quick review.
I'll fix them all and send patch v2.

Macpaul Lin
