Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEA63988AC
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 13:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhFBL5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 07:57:35 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:39583 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhFBL5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 07:57:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1622634951; x=1654170951;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=9uiXJbJdBlLB2FkzQ5AZnkPGhidX4FD6Ay+QSZ4ofxg=;
  b=OwOUjZhmrVFp0C3/xExx2ZqZh5Mgc+r9D5qS7DG55tFeruaL7hXN5Pci
   r1LDvywq8U8ZVZ7rSAHC5mfbjfN9t5UDKnUtDo1sA90kMDuJ75raoGrvL
   JMCwRJYpiIBGMtVabXkD6V5UGhuSti5amTuI/EFMj10LjL9T1jL06RQ98
   HPSF/3aFQAqc5bujsmY0saj+TVXZeZR4TUZdomg0Ndv7HTRacWUmyrL8G
   N5UBqcEpmIDar4Z85FXP3EKL3qlqLmQ24tfv1bTOt+CeA6ymXsflMahf2
   2v0N2A9pUItXItBB21gPTBlda/E0i6irKNhAOwKfQyYPM1SN6WzmgQuVr
   g==;
IronPort-SDR: GzEgCeEgQkzszr0GRguo55rdQ+3zBJPFZ2yA6FvyBVzguyEW8KtIJGV90mCa+csEv+Z3I2prLr
 XOld7nv2lBdXqMXaMVH1PB/5Cw9inq5CPr7+jMige1iGL30gSqJWxJ9sK36vx44aWNT4nxI+Ii
 ja6y2Ae5xhPm9htm/OkIsp1kvjsIrzATVCVRLTiKIlTzwe1qxdkrLo7xjlqXM8juez1vRNMRmi
 s8f5p3IoJpXD0d19MMjygPYDvf7YEJzv/6LEAwkutP8lVNvRvlP2saSGqUaq6+4yvZIDYDYdSb
 eUE=
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="130381472"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jun 2021 04:55:50 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 04:55:50 -0700
Received: from [10.12.72.115] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 2 Jun 2021 04:55:49 -0700
Subject: Re: [PATCH] ARM: dts: at91: sama5d4: fix pinctrl muxing
To:     <Claudiu.Beznea@microchip.com>, <Ludovic.Desroches@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>
CC:     <alexandre.belloni@bootlin.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20191025084210.14726-1-ludovic.desroches@microchip.com>
 <e2d81b87-408d-b50d-3e4c-b28367e4cb00@microchip.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <c3e7fa48-4105-2aea-a821-0f8b00591b41@microchip.com>
Date:   Wed, 2 Jun 2021 13:55:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <e2d81b87-408d-b50d-3e4c-b28367e4cb00@microchip.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/10/2019 at 11:15, Claudiu.Beznea@microchip.com wrote:
> On 25.10.2019 11:42, Ludovic Desroches wrote:
>> Fix pinctrl muxing, PD28, PD29 and PD31 can be muxed to peripheral A. It
>> allows to use SCK0, SCK1 and SPI0_NPCS2 signals.
>>
>> Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
>> Fixes: 679f8d92bb01 ("ARM: at91/dt: sama5d4: add pioD pin mux mask and enable pioD")
>> Cc: stable@vger.kernel.org

Added the version:
Cc: stable@vger.kernel.org # v4.4+

> Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Claudiu, Ludovic,

I've just realized that this patch was not integrated. Sorry for the 
delay. Now queued for 5.14 in at91-dt branch.

Thanks, best regards,
   Nicolas

> 
>> ---
>>   arch/arm/boot/dts/sama5d4.dtsi | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
>> index 6ab27a7b388d..a4cef07c38cb 100644
>> --- a/arch/arm/boot/dts/sama5d4.dtsi
>> +++ b/arch/arm/boot/dts/sama5d4.dtsi
>> @@ -914,7 +914,7 @@ /*   A          B          C  */
>>   					0xffffffff 0x3ffcfe7c 0x1c010101	/* pioA */
>>   					0x7fffffff 0xfffccc3a 0x3f00cc3a	/* pioB */
>>   					0xffffffff 0x3ff83fff 0xff00ffff	/* pioC */
>> -					0x0003ff00 0x8002a800 0x00000000	/* pioD */
>> +					0xb003ff00 0x8002a800 0x00000000	/* pioD */
>>   					0xffffffff 0x7fffffff 0x76fff1bf	/* pioE */
>>   					>;
>>   
>>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> 


-- 
Nicolas Ferre
