Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4433D455F
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 08:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhGXGB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Jul 2021 02:01:26 -0400
Received: from out28-221.mail.aliyun.com ([115.124.28.221]:41631 "EHLO
        out28-221.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbhGXGBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Jul 2021 02:01:25 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07973208|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.248806-0.000424708-0.75077;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047206;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.Kpji6Es_1627108915;
Received: from 192.168.88.130(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.Kpji6Es_1627108915)
          by smtp.aliyun-inc.com(10.147.40.26);
          Sat, 24 Jul 2021 14:41:55 +0800
Subject: Re: [PATCH 1/3] pinctrl: ingenic: Fix incorrect pull up/down info
To:     Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-mips@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210717174836.14776-1-paul@crapouillou.net>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <29998863-e0b9-4aa8-318c-08da51d146a9@wanyeetech.com>
Date:   Sat, 24 Jul 2021 14:41:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20210717174836.14776-1-paul@crapouillou.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

On 2021/7/18 上午1:48, Paul Cercueil wrote:
> Fix the pull up/down info for both the JZ4760 and JZ4770 SoCs, as the
> previous values sometimes contradicted what's written in the programming
> manual.
>
> Fixes: b5c23aa46537 ("pinctrl: add a pinctrl driver for the Ingenic jz47xx SoCs")
> Cc: <stable@vger.kernel.org> # v4.12
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> ---
>   drivers/pinctrl/pinctrl-ingenic.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)


Tested-by: 周琰杰 (Zhou Yanjie)<zhouyanjie@wanyeetech.com>


>
> diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
> index 983ba9865f77..126ca671c3cd 100644
> --- a/drivers/pinctrl/pinctrl-ingenic.c
> +++ b/drivers/pinctrl/pinctrl-ingenic.c
> @@ -710,7 +710,7 @@ static const struct ingenic_chip_info jz4755_chip_info = {
>   };
>   
>   static const u32 jz4760_pull_ups[6] = {
> -	0xffffffff, 0xfffcf3ff, 0xffffffff, 0xffffcfff, 0xfffffb7c, 0xfffff00f,
> +	0xffffffff, 0xfffcf3ff, 0xffffffff, 0xffffcfff, 0xfffffb7c, 0x0000000f,
>   };
>   
>   static const u32 jz4760_pull_downs[6] = {
> @@ -936,11 +936,11 @@ static const struct ingenic_chip_info jz4760_chip_info = {
>   };
>   
>   static const u32 jz4770_pull_ups[6] = {
> -	0x3fffffff, 0xfff0030c, 0xffffffff, 0xffff4fff, 0xfffffb7c, 0xffa7f00f,
> +	0x3fffffff, 0xfff0f3fc, 0xffffffff, 0xffff4fff, 0xfffffb7c, 0x0024f00f,
>   };
>   
>   static const u32 jz4770_pull_downs[6] = {
> -	0x00000000, 0x000f0c03, 0x00000000, 0x0000b000, 0x00000483, 0x00580ff0,
> +	0x00000000, 0x000f0c03, 0x00000000, 0x0000b000, 0x00000483, 0x005b0ff0,
>   };
>   
>   static int jz4770_uart0_data_pins[] = { 0xa0, 0xa3, };
