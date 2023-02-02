Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3343688790
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 20:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbjBBTiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 14:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBBTiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 14:38:24 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F043B36FED
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 11:38:21 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id m7so2687369wru.8
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 11:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C2XOALXv/Lj/lmT5IZS4EM/O7xBhsu0gzTnxmxxQFEQ=;
        b=ai9z93zWh1nxHEkpgAWM67OPWJvM+Vu/PU636V4sK11yJK5hofcc+GRwN7jHMsJ6XR
         /zKW7doxAUt0kd1mATR0eqPJYI1nVtsEESa/7dRgW8TyvKurmbXBqgc87VH1O/vQeqm5
         01bc8AfORXvBuBtt8FB2MuskPcYUCZxiK2rfLdapeFSp5wW0wj8tKWC1IQmJYTPRLN1R
         wtezcpROIwmk/hmhr9qPtQ2FEEGxKCzsBR4MMyqbrxPBgnL5nXDJdT0pd1ApYpBMZiNw
         OKw6dQicHrecpnrLh6aHnBp9VHL1Cpulnoht+DAufVcxvY3IWsmfO7ieHqcK6AdEo7qh
         7heA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C2XOALXv/Lj/lmT5IZS4EM/O7xBhsu0gzTnxmxxQFEQ=;
        b=LI/7U4d1gOKxeb3DssLfgKzK3Sk+0AVfy/BbO+R+SHcJsO0VHzB3Gc/v/PrtYrZoMa
         kM9gcK63QkRqDawK5hSnKIQnvcjGUzgZ4s3X4rHXTla/awjIHxBXV6/mmj81WdZ/1lPQ
         fQyVpElmLjeUsI368lCwTHGCk5+ERgg72k9dDBP2Uk5AB27GJtldL64dkPsNyaWoJRBj
         D3gqr/Egq5WOlx5eGBiXfax5CjMDolQ9+SajAVjaiIpJt+PBgxSf4rd7HvJtbnu0WxyN
         XqP95AMIgdqJMZAdEO4hcmrVUq8jRPAQtjwsCKjvzaQJoLoANsmutMVG06nYXhuxsfUJ
         WOqQ==
X-Gm-Message-State: AO0yUKWc7REJb+lXH3oP798MfU2xsqaJW7tuDkHepZI6aUXoKCGr5gwY
        ekCbFJAgV9+Dk9oZpCEE4OCUDQ==
X-Google-Smtp-Source: AK7set8s31+8dJyviAqvWfgopAsB11o+t1DPesoqoYzMeakMwcxI34bHHjVpqWOgbQ1STdhN0+87TA==
X-Received: by 2002:adf:fe86:0:b0:2bf:f6b7:7a63 with SMTP id l6-20020adffe86000000b002bff6b77a63mr8081615wrr.0.1675366700524;
        Thu, 02 Feb 2023 11:38:20 -0800 (PST)
Received: from [192.168.2.104] ([79.115.63.122])
        by smtp.gmail.com with ESMTPSA id q6-20020adfab06000000b002bfcc940014sm265280wrc.82.2023.02.02.11.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 11:38:20 -0800 (PST)
Message-ID: <8757b9bc-c771-a612-1d6a-1a704e7a7688@linaro.org>
Date:   Thu, 2 Feb 2023 21:38:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] mtd: spi-nor: Fix shift-out-of-bounds in
 spi_nor_set_erase_type
Content-Language: en-US
To:     pratyush@kernel.org, michael@walle.cc,
        Alexander.Stein@tq-group.com, lrannou@baylibre.com
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20230202191451.35142-1-tudor.ambarus@linaro.org>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20230202191451.35142-1-tudor.ambarus@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
> index 247d1014879a..9b90d941d87a 100644
> --- a/drivers/mtd/spi-nor/core.c
> +++ b/drivers/mtd/spi-nor/core.c
> @@ -2019,10 +2019,22 @@ void spi_nor_set_erase_type(struct spi_nor_erase_type *erase, u32 size,
>   			    u8 opcode)
>   {
>   	erase->size = size;
> -	erase->opcode = opcode;
> -	/* JEDEC JESD216B Standard imposes erase sizes to be power of 2. */
> -	erase->size_shift = ffs(erase->size) - 1;
> -	erase->size_mask = (1 << erase->size_shift) - 1;
> +
> +	if (size) {

actually this is not needed now that spi_nor_mask_erase_type() is 
introduced. All the callers of spi_nor_set_erase_type() guarantee that
erase_size is not zero.

> +		erase->opcode = opcode;
> +		/* JEDEC JESD216B imposes erase sizes to be power of 2. */
> +		erase->size_shift = ffs(size) - 1;
> +		erase->size_mask = (1 << erase->size_shift) - 1;
> +	}
> +}
> +

So the fix should just contain the introduction of 
spi_nor_mask_erase_type(). Louis, do you want to authorship v3?

> +/**
> + * spi_nor_mask_erase_type() - mask out an SPI NOR erase type
> + * @erase:	pointer to a structure that describes a SPI NOR erase type

an SPI

> + */
> +void spi_nor_mask_erase_type(struct spi_nor_erase_type *erase)
> +{
> +	erase->size = 0;
>   }
>   
>   /**
> diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
> index f6d012e1f681..25423225c29d 100644
> --- a/drivers/mtd/spi-nor/core.h
> +++ b/drivers/mtd/spi-nor/core.h
> @@ -681,6 +681,7 @@ void spi_nor_set_pp_settings(struct spi_nor_pp_command *pp, u8 opcode,
>   
>   void spi_nor_set_erase_type(struct spi_nor_erase_type *erase, u32 size,
>   			    u8 opcode);
> +void spi_nor_mask_erase_type(struct spi_nor_erase_type *erase);
>   struct spi_nor_erase_region *
>   spi_nor_region_next(struct spi_nor_erase_region *region);
>   void spi_nor_init_uniform_erase_map(struct spi_nor_erase_map *map,
> diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
> index fd4daf8fa5df..298ab5e53a8c 100644
> --- a/drivers/mtd/spi-nor/sfdp.c
> +++ b/drivers/mtd/spi-nor/sfdp.c
> @@ -875,7 +875,7 @@ static int spi_nor_init_non_uniform_erase_map(struct spi_nor *nor,
>   	 */
>   	for (i = 0; i < SNOR_ERASE_TYPE_MAX; i++)
>   		if (!(regions_erase_type & BIT(erase[i].idx)))
> -			spi_nor_set_erase_type(&erase[i], 0, 0xFF);
> +			spi_nor_mask_erase_type(&erase[i]);
>   
>   	return 0;
>   }
> @@ -1089,7 +1089,7 @@ static int spi_nor_parse_4bait(struct spi_nor *nor,
>   			erase_type[i].opcode = (dwords[SFDP_DWORD(2)] >>
>   						erase_type[i].idx * 8) & 0xFF;
>   		else
> -			spi_nor_set_erase_type(&erase_type[i], 0u, 0xFF);
> +			spi_nor_mask_erase_type(&erase_type[i]);
>   	}
>   
>   	/*
