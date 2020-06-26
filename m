Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657BE20BAC4
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 22:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgFZU5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 16:57:01 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:49579 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFZU5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 16:57:01 -0400
X-Originating-IP: 86.202.110.81
Received: from localhost (lfbn-lyo-1-15-81.w86-202.abo.wanadoo.fr [86.202.110.81])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 0016520002;
        Fri, 26 Jun 2020 20:56:58 +0000 (UTC)
Date:   Fri, 26 Jun 2020 22:56:58 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 09/10] mfd: atmel-smc: Add missing colon(s) for 'conf'
 arguments
Message-ID: <20200626205658.GV131826@piout.net>
References: <20200625064619.2775707-1-lee.jones@linaro.org>
 <20200625064619.2775707-10-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625064619.2775707-10-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/06/2020 07:46:18+0100, Lee Jones wrote:
> Kerneldoc valication gets confused if syntax isn't "@.*: ".
> 
> Adding the missing colons squashes the following W=1 warnings:
> 
> drivers/mfd/atmel-smc.c:247: warning: Function parameter or member 'conf' not described in 'atmel_smc_cs_conf_apply'
> drivers/mfd/atmel-smc.c:268: warning: Function parameter or member 'conf' not described in 'atmel_hsmc_cs_conf_apply'
> 
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> Cc: <stable@vger.kernel.org>
> Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
> Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/atmel-smc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/atmel-smc.c b/drivers/mfd/atmel-smc.c
> index 17bbe9d1fa740..4aac96d213369 100644
> --- a/drivers/mfd/atmel-smc.c
> +++ b/drivers/mfd/atmel-smc.c
> @@ -237,7 +237,7 @@ EXPORT_SYMBOL_GPL(atmel_smc_cs_conf_set_cycle);
>   * atmel_smc_cs_conf_apply - apply an SMC CS conf
>   * @regmap: the SMC regmap
>   * @cs: the CS id
> - * @conf the SMC CS conf to apply
> + * @conf: the SMC CS conf to apply
>   *
>   * Applies an SMC CS configuration.
>   * Only valid on at91sam9/avr32 SoCs.
> @@ -257,7 +257,7 @@ EXPORT_SYMBOL_GPL(atmel_smc_cs_conf_apply);
>   * @regmap: the HSMC regmap
>   * @cs: the CS id
>   * @layout: the layout of registers
> - * @conf the SMC CS conf to apply
> + * @conf: the SMC CS conf to apply
>   *
>   * Applies an SMC CS configuration.
>   * Only valid on post-sama5 SoCs.
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
