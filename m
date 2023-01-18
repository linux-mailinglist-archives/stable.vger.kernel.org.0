Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24B76715C4
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 09:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjARIDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 03:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjARH67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 02:58:59 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E708A5D902
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 23:34:35 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id y3-20020a17090a390300b00229add7bb36so1307776pjb.4
        for <stable@vger.kernel.org>; Tue, 17 Jan 2023 23:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9wbILlnDvL3M1wKEovzOwMxQbxbvumT2vGqmnM40UCM=;
        b=UKDnmgmuA6suxkwABCL1M9rykIcFf6DQK/PwSgOW/M8e18QIjmvGqwFdrTpbkOPAvM
         fRw1QieJwaWHHw6ZRcW1otxISQSuLNgIwU0heg0+f9Fs025Rrq1YpwTpFcTPRon5mSzt
         i3f474XfPfi0ggcrNsfrlYfay6bpio4QLyYXpmcxnPSnwU8bcWYpoD74aaOpWHrK2o1t
         kde5E9mLxpDm2GoxRzqqLjIA+7cIcsL+8ArEDd4Em6Ub4iWoVSY2mjo58ZWEa8UFOQ/p
         c4Arojwod0Y+rL4gyo0bUm8MSoisj4gb1y18vTublhCaLbOwVmwhKHHXsgb/TZdn5Fqe
         PbKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9wbILlnDvL3M1wKEovzOwMxQbxbvumT2vGqmnM40UCM=;
        b=DzYj5etfH06OZuBViabYER8grc4w+VY2Tb+kiCvqpxTccn4ZQBWZFDp0FebALenVsy
         RDadH6AtDWEzoxv/grKizq53gt5xkdY9BA7YEGTtsRuN9rKWR6TwMjV7tLMwgreGHAzS
         R9kjSo3etSpDMiNxRtKTbRGhg0yXk2rTtXVBhbrANtV6XLJWj98CaSByENFm+UTjFzAm
         53SvMtO44c66vaIypLW+ma5xhzhoaBTywD7sZ/pZuHslhHhs5ffHN7d2WFXBSFYujECy
         MWVTQemOGEl3m3b5nw5Wr3sLpJ3tJJBneWrT6rusSnFMWXxmnoSKAU8jAwLbnsb/ydBX
         BPaw==
X-Gm-Message-State: AFqh2kooWFSC9t0sF9jaJBGtTlPBYex8kpZYip/0i1ikCrjCLYWzks23
        7SPr/d8CmocNG03zKeuKkfI=
X-Google-Smtp-Source: AMrXdXuzWG1b/rb+Ewq4s4Y6XmcrE57FMXK2Xy9ueeGFYtf4TE3LKaIdZ4VsHZ/F81XltYfninD7Ng==
X-Received: by 2002:a17:902:e04c:b0:194:a706:49c9 with SMTP id x12-20020a170902e04c00b00194a70649c9mr4970365plx.9.1674027275052;
        Tue, 17 Jan 2023 23:34:35 -0800 (PST)
Received: from [192.168.0.10] (KD106168128197.ppp-bb.dion.ne.jp. [106.168.128.197])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b00180033438a0sm22440927pla.106.2023.01.17.23.34.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 23:34:34 -0800 (PST)
Message-ID: <30f99da3-6da7-e732-df5b-e8d61c4cde93@gmail.com>
Date:   Wed, 18 Jan 2023 16:34:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/2] mtd: spi-nor: spansion: Consider reserved bits in
 CFR5 register
Content-Language: en-US
To:     Tudor Ambarus <tudor.ambarus@linaro.org>,
        Takahiro.Kuwano@infineon.com
Cc:     linux-mtd@lists.infradead.org, pratyush@kernel.org,
        michael@walle.cc, miquel.raynal@bootlin.com, richard@nod.at,
        Bacem.Daassi@infineon.com, stable@vger.kernel.org
References: <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
 <20230110164703.83413-1-tudor.ambarus@linaro.org>
From:   Takahiro Kuwano <tkuw584924@gmail.com>
In-Reply-To: <20230110164703.83413-1-tudor.ambarus@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/2023 1:47 AM, Tudor Ambarus wrote:
> CFR5[6] is reserved bit and must be always 1. Set it to comply with flash
> requirements. While fixing SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_{EN, DS}
> definition, stop using magic numbers and describe the missing bit fields
> in CFR5 register. This is useful for both readability and future possible
> addition of Octal STR mode support.
> 
> Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
> Cc: stable@vger.kernel.org
> Reported-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
> ---
>  drivers/mtd/spi-nor/spansion.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
> index b621cdfd506f..07fe0f6fdfe3 100644
> --- a/drivers/mtd/spi-nor/spansion.c
> +++ b/drivers/mtd/spi-nor/spansion.c
> @@ -21,8 +21,13 @@
>  #define SPINOR_REG_CYPRESS_CFR3V		0x00800004
>  #define SPINOR_REG_CYPRESS_CFR3V_PGSZ		BIT(4) /* Page size. */
>  #define SPINOR_REG_CYPRESS_CFR5V		0x00800006
> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN	0x3
> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	0
> +#define SPINOR_REG_CYPRESS_CFR5_BIT6		BIT(6)
> +#define SPINOR_REG_CYPRESS_CFR5_DDR		BIT(1)
> +#define SPINOR_REG_CYPRESS_CFR5_OPI		BIT(0)
> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN				\
> +	(SPINOR_REG_CYPRESS_CFR5_BIT6 |	SPINOR_REG_CYPRESS_CFR5_DDR |	\
> +	 SPINOR_REG_CYPRESS_CFR5_OPI)
> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	SPINOR_REG_CYPRESS_CFR5_BIT6
>  #define SPINOR_OP_CYPRESS_RD_FAST		0xee
>  
>  /* Cypress SPI NOR flash operations. */

Thank you, Tudor!
I will fix u-boot in the same manner.

Takahiro
