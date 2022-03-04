Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8CD4CD294
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 11:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbiCDKlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 05:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234714AbiCDKlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 05:41:15 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F771AA4A3;
        Fri,  4 Mar 2022 02:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646390427; x=1677926427;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MWHad0oWvKdIlSW1yZteYqB1ECrM7vqKBkt0Z55LL/M=;
  b=RY8fCTR1tDhQ8CEixF2j2uHnXoR/7HDyPAj79zaCuFGEclP0lWfy6VZw
   dgIPAlfMRB4jwMjF2+X8ISzMxPW7n33gmPAW45pmOdENPcTt8bEQ4kXLZ
   Zp8P3iCLBonBw2ikpJpvREaEidsG4lAV4Ambz6jLJddHhm3uLl1oGMFek
   xcbybYM9XFKxghprzb+dR/cqbmiywWQhZcAs5AcAR6VYinZ9Ci5V0UNgI
   rZjfQSSQ/66katabP8QM3fOifpP8Zgor92wBmc+2CKDlH3oM4AWd+U4uI
   puRZoa3rsrt/rl5FEj/V/eJQQG3/PvelLnAev9VCpEe/ifs0cmi+phmxu
   g==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="148086332"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 03:40:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 03:40:26 -0700
Received: from [10.12.72.98] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 4 Mar 2022 03:40:23 -0700
Message-ID: <03c0ed9e-73b6-5325-3034-ae9930ffd063@microchip.com>
Date:   Fri, 4 Mar 2022 11:40:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] ARM: dts: at91: sama7g5: Remove unused properties in i2c
 nodes
Content-Language: en-US
To:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        <claudiu.beznea@microchip.com>, <alexandre.belloni@bootlin.com>
CC:     <robh+dt@kernel.org>, <eugen.hristev@microchip.com>,
        <codrin.ciubotariu@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sergiu.moga@microchip.com>, <stable@vger.kernel.org>
References: <20220302161854.32177-1-tudor.ambarus@microchip.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20220302161854.32177-1-tudor.ambarus@microchip.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/03/2022 at 17:18, Tudor Ambarus wrote:
> The "atmel,use-dma-rx", "atmel,use-dma-rx" dt properties are not used by
> the i2c-at91 driver, nor they are defined in the bindings file, thus remove
> them.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Added in at91-dt for 5.18 as a 2nd batch of DT patches.
Thanks, best regards,
   Nicolas

> ---
>   arch/arm/boot/dts/sama7g5.dtsi | 6 ------
>   1 file changed, 6 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/sama7g5.dtsi b/arch/arm/boot/dts/sama7g5.dtsi
> index 1dc0631e9fd4..e626f6bd920a 100644
> --- a/arch/arm/boot/dts/sama7g5.dtsi
> +++ b/arch/arm/boot/dts/sama7g5.dtsi
> @@ -591,8 +591,6 @@ i2c1: i2c@600 {
>   				dmas = <&dma0 AT91_XDMAC_DT_PERID(7)>,
>   					<&dma0 AT91_XDMAC_DT_PERID(8)>;
>   				dma-names = "rx", "tx";
> -				atmel,use-dma-rx;
> -				atmel,use-dma-tx;
>   				status = "disabled";
>   			};
>   		};
> @@ -778,8 +776,6 @@ i2c8: i2c@600 {
>   				dmas = <&dma0 AT91_XDMAC_DT_PERID(21)>,
>   					<&dma0 AT91_XDMAC_DT_PERID(22)>;
>   				dma-names = "rx", "tx";
> -				atmel,use-dma-rx;
> -				atmel,use-dma-tx;
>   				status = "disabled";
>   			};
>   		};
> @@ -804,8 +800,6 @@ i2c9: i2c@600 {
>   				dmas = <&dma0 AT91_XDMAC_DT_PERID(23)>,
>   					<&dma0 AT91_XDMAC_DT_PERID(24)>;
>   				dma-names = "rx", "tx";
> -				atmel,use-dma-rx;
> -				atmel,use-dma-tx;
>   				status = "disabled";
>   			};
>   		};


-- 
Nicolas Ferre
