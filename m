Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E143328E408
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 18:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730693AbgJNQJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 12:09:08 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:30565 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgJNQJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 12:09:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602691748; x=1634227748;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=nYxnxg2+RQprtzLlI6wg7jfBRlbQ4KTtTqP8g1Qf1KE=;
  b=e4TzfwWEXT0MjldBfZdNndVNSt2pAIs5/ee52i1IbUX8fdeu69N0/FMD
   vtJFGDvALtumEileHYJQQrXKh7S1gA4iJdGAAZhtqQrADl7CHtnMvALKQ
   FPSAVjEpsu27t9xIgkOe+JzBpLVS+SPpc9EsQ+JX14hQIGC3dZDCn+lOy
   tjE7xXjZliEfnW+bCScemRnQO1wLjqVzHs71KW0qd2DqXkir1I2nI947d
   +dEewSTFq4yYJme2gBE8Vky7iic+fLnULDR8iMKEZ+II/RI+xEPa5y0nO
   Kv/WEHvWnlL3Py+iIrAhQDE2ZxWMtHxEEUn7ksvDuuT+7Sab1kpHRXx+K
   A==;
IronPort-SDR: /gXAgu2LkaNngK04jDWy1kDKIp56+nZeSl6zQwVRwBp1HE690GUFLX2hIY9A7kImXPZwsq7P2E
 APBMdLjPosxrrhDbg+HFkm7VgAhfv0oUGnxM0lrfqFzuvIlv36SoD95UTGpeSUv9Iil3vUGgp5
 YSwuMQMr7+Q+FPuj+SlCIKsDA/BusDtuSVxvMFdGZC8JpM1ZGjTSGloZyEA5tZhzIjOdZOy18+
 IFGhTtu3hHkXYikFjrTsSxoTThDg2bOFbVV3gOsHQAvsLOWcnQJSr/WcD72VxiSdM+G8aerq28
 3i0=
X-IronPort-AV: E=Sophos;i="5.77,375,1596524400"; 
   d="scan'208";a="99507189"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Oct 2020 09:09:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 14 Oct 2020 09:09:07 -0700
Received: from [10.171.246.17] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 14 Oct 2020 09:09:04 -0700
Subject: Re: [PATCH] clk: at91: sam9x60: support only two programmable clocks
To:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        <mturquette@baylibre.com>, <sboyd@kernel.org>,
        <alexandre.belloni@bootlin.com>, <ludovic.desroches@microchip.com>
CC:     <linux-clk@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <1602686072-28296-1-git-send-email-claudiu.beznea@microchip.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <1b6f29c9-c9b1-fc1e-7f08-ec4da720accc@microchip.com>
Date:   Wed, 14 Oct 2020 18:09:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1602686072-28296-1-git-send-email-claudiu.beznea@microchip.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/10/2020 at 16:34, Claudiu Beznea wrote:
> According to datasheet (Chapter 29.16.13, PMC Programmable Clock Register)
> there are only two programmable clocks on SAM9X60.
> 
> Fixes: 01e2113de9a5 ("clk: at91: add sam9x60 pmc driver")
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

This is a fix:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Cc: <stable@vger.kernel.org> # v5.2+

> ---
>   drivers/clk/at91/sam9x60.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/at91/sam9x60.c b/drivers/clk/at91/sam9x60.c
> index ab6318c0589e..3c4c95603595 100644
> --- a/drivers/clk/at91/sam9x60.c
> +++ b/drivers/clk/at91/sam9x60.c
> @@ -279,7 +279,7 @@ static void __init sam9x60_pmc_setup(struct device_node *np)
>   	parent_names[3] = "masterck";
>   	parent_names[4] = "pllack_divck";
>   	parent_names[5] = "upllck_divck";
> -	for (i = 0; i < 8; i++) {
> +	for (i = 0; i < 2; i++) {
>   		char name[6];
>   
>   		snprintf(name, sizeof(name), "prog%d", i);
> 


-- 
Nicolas Ferre
