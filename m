Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46339345C9F
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 12:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhCWLR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 07:17:26 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:19224 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhCWLRV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 07:17:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616498241; x=1648034241;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=xkEtnj795OGz0YOCi1K5ZAUBjS8scZ1aflNvlUmjf0Q=;
  b=s7L/W9XO/FyaCx65CjCOqH+1iHlANCXMJL+jWxdTf6trkWdwcBK6KKpz
   GGBcFX45WShEmyCjaOWfJm1TvVsWj7r6bhomtvL+nYPwydvlr7maY/IQx
   6P6DtcKkIYX05ZPOd2UVEDG1S6FLKQW6Nff4TNvntnhis1eEWspZlaarV
   PI3vM29Kd292XGlS2GDasW6zJGax3xN9+5D9u8EvakM1fBV4vs3klXJNf
   hhGu8cmRAGUnid42OG+/Xs+V7TMyBI564aEHuDi7HNj4tlVGSPGsMD4FT
   uBXlAcwo3ODmSQ0cYAp+FYj/U1nMoFwpapi3nmJ+/fcu+Ra7K8HTuUkmp
   A==;
IronPort-SDR: dkIXIA6MiHaqQFqxXM+aBgCxFDlrG/dDsWufP43wMkKAC9OPqYPlBdKobBVSToJXsx6s2K1Aut
 sz0MegjHkRV9Sh6EAy5IadY5Ar+XYyl9Nk2ad0a3iHLSXGNsd0pTp2QALl3du/bS+iisCvV2nK
 q4dOs/DjHmCu1VpAt5vzqobV3EN8S6QDvtS1HwcLPL+ncCVnWUQLbgoNx/Y4cMh9Nz/F3HbAKa
 ksLey87/bqx2zosANHwA81EtVmG+J8yy2ahMFr7cOD/ElaD0EBjoiRmo4E+TQg8H5OVC/thrIt
 Ac8=
X-IronPort-AV: E=Sophos;i="5.81,271,1610434800"; 
   d="scan'208";a="48534067"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2021 04:17:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 23 Mar 2021 04:17:14 -0700
Received: from [10.12.80.255] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 23 Mar 2021 04:17:11 -0700
Subject: Re: [PATCH] ARM: dts: at91-sama5d27_som1: fix phy address to 7
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Alexander Dahl <ada@thorsis.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
CC:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        <stable@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        Oleksij Rempel <ore@pengutronix.de>
References: <20210217113808.21804-1-nicolas.ferre@microchip.com>
 <1732882030.11903.1616496356027@seven.thorsis.com>
 <ddedd53b-6087-f7a5-3c41-2b91fec35980@pengutronix.de>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <580984ef-41fe-62d0-ad30-f707a6669a13@microchip.com>
Date:   Tue, 23 Mar 2021 12:17:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <ddedd53b-6087-f7a5-3c41-2b91fec35980@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Alexander, Ahmad,

On 23/03/2021 at 11:55, Ahmad Fatoum wrote:
> Hello Alexander,
> 
> On 23.03.21 11:45, Alexander Dahl wrote:
>> Hei hei,
>>
>> I could not get ethernet to work on SAMA5D27-SOM1-EK1 with kernels v5.10 and v5.11 built by a recent ptxdist based DistroKit BSP, while it used to work with an older v4.19 kernel. Just applying this patch to the tree made ethernet working again, thus:
>>
>> Tested-by: Alexander Dahl <ada@thorsis.com>
>>
>> Not sure why it worked with that older kernel, though.
> 
> Thanks for investigating! Seems that somehow PHY broadcast worked on this
> board with older kernels (and current barebox), but no longer does with
> newer kernels.
> 
> A bisection could shed some light onto what broke this.
> 
> As the KSZ8081 driver disables broadcast in the phy config init, this change
> looks appropriate regardless. The fixes tag doesn't refer to an upstream
> commit though. This should probably read:
> Fixes: af690fa37e39 ("ARM: dts: at91: at91-sama5d27_som1: add sama5d27 SoM1 support")

I didn't noticed that on my side.

> With this addressed:
> 
> Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

Thanks a lot for your feedback.

> You could send a proper patch and stick your S-o-b under it.

Actually this patch is already in arm-soc tree here:

https://git.kernel.org/pub/scm/linux/kernel/git/soc/soc.git/commit/?h=arm/fixes&id=221c3a09ddf70a0a51715e6c2878d8305e95c558

So I cannot add tags anymore to it, sorry.

Best regards,
   Nicolas

>> I added Ahmad to Cc, he added board support to DistroKit for that board, and might want to know. And I added the devicetree list to Cc, I wondered why the patch was not there and get_maintainers.pl proposed it.
>>
>> Thanks for fixing this and greetings
>> Alex
>>
>>> nicolas.ferre@microchip.com hat am 17.02.2021 12:38 geschrieben:
>>>
>>>
>>> From: Claudiu Beznea <claudiu.beznea@microchip.com>
>>>
>>> Fix the phy address to 7 for Ethernet PHY on SAMA5D27 SOM1. No
>>> connection established if phy address 0 is used.
>>>
>>> The board uses the 24 pins version of the KSZ8081RNA part, KSZ8081RNA
>>> pin 16 REFCLK as PHYAD bit [2] has weak internal pull-down.  But at
>>> reset, connected to PD09 of the MPU it's connected with an internal
>>> pull-up forming PHYAD[2:0] = 7.
>>>
>>> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
>>> Fixes: 2f61929eb10a ("ARM: dts: at91: at91-sama5d27_som1: fix PHY ID")
>>> Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
>>> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
>>> Cc: <stable@vger.kernel.org> # 4.14+
>>> ---
>>>   arch/arm/boot/dts/at91-sama5d27_som1.dtsi | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm/boot/dts/at91-sama5d27_som1.dtsi b/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
>>> index 1b1163858b1d..e3251f3e3eaa 100644
>>> --- a/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
>>> +++ b/arch/arm/boot/dts/at91-sama5d27_som1.dtsi
>>> @@ -84,8 +84,8 @@ macb0: ethernet@f8008000 {
>>>                               pinctrl-0 = <&pinctrl_macb0_default>;
>>>                               phy-mode = "rmii";
>>>
>>> -                            ethernet-phy@0 {
>>> -                                    reg = <0x0>;
>>> +                            ethernet-phy@7 {
>>> +                                    reg = <0x7>;
>>>                                       interrupt-parent = <&pioA>;
>>>                                       interrupts = <PIN_PD31 IRQ_TYPE_LEVEL_LOW>;
>>>                                       pinctrl-names = "default";
>>> --
>>> 2.30.0
>>>
>>>
>>> _______________________________________________
>>> linux-arm-kernel mailing list
>>> linux-arm-kernel@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
> 
> --
> Pengutronix e.K.                           |                             |
> Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 


-- 
Nicolas Ferre
