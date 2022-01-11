Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2E548AE7E
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 14:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240559AbiAKNex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 08:34:53 -0500
Received: from mail.thorsis.com ([92.198.35.195]:53992 "EHLO mail.thorsis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239562AbiAKNex (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jan 2022 08:34:53 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.thorsis.com (Postfix) with ESMTP id DDD89F2A;
        Tue, 11 Jan 2022 14:34:50 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at mail.thorsis.com
Received: from mail.thorsis.com ([127.0.0.1])
        by localhost (mail.thorsis.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lbCcM9HzLLSi; Tue, 11 Jan 2022 14:34:50 +0100 (CET)
Received: by mail.thorsis.com (Postfix, from userid 109)
        id CB191357A; Tue, 11 Jan 2022 14:34:47 +0100 (CET)
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.2
X-Spam-Report: * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was
        *      blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [URIs: microchip.com]
        * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
        * -0.0 NO_RECEIVED Informational: message has no Received headers
From:   Alexander Dahl <ada@thorsis.com>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>
Cc:     Nicolas.Ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, robh+dt@kernel.org,
        bbrezillon@kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Alexander Dahl <ada@thorsis.com>
Subject: Re: [PATCH v2] ARM: dts: at91: sama5d2: Fix PMERRLOC resource size
Date:   Tue, 11 Jan 2022 14:34:41 +0100
Message-ID: <2950776.PjgfHZTfyB@ada>
In-Reply-To: <20220111132301.906712-1-tudor.ambarus@microchip.com>
References: <20220111132301.906712-1-tudor.ambarus@microchip.com>
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hei hei,

Am Dienstag, 11. Januar 2022, 14:23:01 CET schrieb Tudor Ambarus:
> PMERRLOC resource size was set to 0x100, which resulted in HSMC_ERRLOCx
> register being truncated to offset x = 21, causing error correction to
> fail if more than 22 bit errors and if 24 or 32 bit error correction
> was supported.
> 
> Fixes: d9c41bf30cf8 ("ARM: dts: at91: Declare EBI/NAND controllers")
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> Cc: <stable@vger.kernel.org> # 4.13.x

Acked-by: Alexander Dahl <ada@thorsis.com>

Greets
Alex

> ---
> v2:
> - update commit description
> - Cc stable@vger.kernel.org
> 
>  arch/arm/boot/dts/sama5d2.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d2.dtsi b/arch/arm/boot/dts/sama5d2.dtsi
> index 09c741e8ecb8..c700c3b19e4c 100644
> --- a/arch/arm/boot/dts/sama5d2.dtsi
> +++ b/arch/arm/boot/dts/sama5d2.dtsi
> @@ -415,7 +415,7 @@ hsmc: hsmc@f8014000 {
>  				pmecc: ecc-engine@f8014070 {
>  					compatible = "atmel,sama5d2-pmecc";
>  					reg = <0xf8014070 0x490>,
> -					      <0xf8014500 0x100>;
> +					      <0xf8014500 0x200>;
>  				};
>  			};



