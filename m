Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE376827FC
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjAaJEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjAaJDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 04:03:34 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AB34ABD8
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 01:00:15 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id hx15so19994314ejc.11
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 01:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YVhZ75/1BJntMwjdrWXFKhLK+whyj6nKMsfuAvUzboE=;
        b=QVwvwXTnU7c2WB1/81AcFN4NiLnQrf9SjNaNbW6HbX5JZjkJMXg+ORQKFmXSMcGVqL
         K79XySAjUSt9XroiSimmqEtQ4K1S5M0NijaM+AIR0M+Z7qP4SqZFZkkcDgrprfx1E/GN
         PUOkxkf2emS9jHkXCbngFdh+6tK2g/81/H5J6hsKU3BHrBLXZGkAFmO/2NaaTv7ZOelb
         Vq25C1De8UWo/dxbuzHk/WE4G/scq3jynYA8t0JOURy+dt4PClv53luID3brCjPbwMh6
         VCHmToi7mQZ4Fr2fnH5K5gQvrN4sRP0Z329tE7h3HLfbEse1KReUrT3oLpENuJ8E8V1M
         xoKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YVhZ75/1BJntMwjdrWXFKhLK+whyj6nKMsfuAvUzboE=;
        b=7/UNMQJkq25K7F4CYL09x5jIdUXu5rMTVA5JqKNxDw9ZFpZ83fXoVZbltXTlEF6+/W
         bSQFxskFVQze2O4AdwdMiOHrzROHm1rDs26rf8gm4EviswC/2ScAK/J++gvAPh2LX/RP
         E0Se3BBDBffx7G06lZ9ekFUGumVaemaCUANffC9p9/LbMHDdBsduNWmmrIKeNh/7AIV+
         RwX0v6ar4qv9jxJMoL3/r3PJ/njyWjVgnvCIOsW2R0V1yOTo60omZ26oznbJiTQTwMA3
         cI2T8U+UuAFayheLMQqUTmKNLN8XCLuQQCQQbjk6f/pTbeBi/MZYaS0p5Xsy+cjmBwZq
         ObGw==
X-Gm-Message-State: AO0yUKXDhgDfxsVI4EONmreTYwK6ULGveoT9FZO1i/Swem2NPYnplvtT
        UFE2nIfdJuMCk+WTMT3G+6ER3w==
X-Google-Smtp-Source: AK7set/BgNNTwTxtqlRMF5Dt4dYOU5e8i5JGgeI+wqXcMG90Q7nmUS1+2KDhWKptOR6NUy7N7ALRnQ==
X-Received: by 2002:a17:906:a2d0:b0:883:c829:fc5e with SMTP id by16-20020a170906a2d000b00883c829fc5emr11787487ejb.68.1675155613196;
        Tue, 31 Jan 2023 01:00:13 -0800 (PST)
Received: from [192.168.2.104] ([79.115.63.122])
        by smtp.gmail.com with ESMTPSA id 11-20020a170906318b00b0088a161c232esm1475453ejy.172.2023.01.31.01.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 01:00:12 -0800 (PST)
Message-ID: <9224dca4-561d-d492-0b09-3629c95acea7@linaro.org>
Date:   Tue, 31 Jan 2023 11:00:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 1/2] mtd: spi-nor: spansion: Consider reserved bits in
 CFR5 register
Content-Language: en-US
To:     Takahiro.Kuwano@infineon.com, tkuw584924@gmail.com
Cc:     linux-mtd@lists.infradead.org, pratyush@kernel.org,
        michael@walle.cc, miquel.raynal@bootlin.com, richard@nod.at,
        Bacem.Daassi@infineon.com, stable@vger.kernel.org
References: <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
 <20230110164703.83413-1-tudor.ambarus@linaro.org>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20230110164703.83413-1-tudor.ambarus@linaro.org>
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



On 10.01.2023 18:47, Tudor Ambarus wrote:
> CFR5[6] is reserved bit and must be always 1. Set it to comply with flash
> requirements. While fixing SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_{EN, DS}
> definition, stop using magic numbers and describe the missing bit fields
> in CFR5 register. This is useful for both readability and future possible
> addition of Octal STR mode support.
> 
> Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
> Cc:stable@vger.kernel.org
> Reported-by: Takahiro Kuwano<Takahiro.Kuwano@infineon.com>
> Signed-off-by: Tudor Ambarus<tudor.ambarus@linaro.org>
> ---
>   drivers/mtd/spi-nor/spansion.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)


both applied, thanks!
