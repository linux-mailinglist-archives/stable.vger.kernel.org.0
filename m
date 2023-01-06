Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2368665FE6A
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 10:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjAFJz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 04:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjAFJz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 04:55:56 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB4B10FA
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 01:55:55 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id fy8so2320597ejc.13
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 01:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MR+/NWA8p6VYz8uv/82PDoV9JZ8XB9MwZrQb5jkWV0Q=;
        b=Gma/Ht/dQqftf/LiR6DcQta3AYBsESePrvrSgiVzPE2pgxhQdPw/lqfhTD+y8qDejO
         QfSjvkKint4HPGmTKSTRWInv5nFkTbpOWmU0VtnVtzcYpir/ijafCrg951eo15GIAIQY
         GfNYHzacOjUQ2hcgk/wJyUN/izI2rO/zubQQPTgYjz0/YwUjnJAZQUN+Fht00s1KEso4
         v/BqfXIod2yXdwkyDlKGiClUAiYZMZEgncM+H//hJIJAB7brmlSdBw+uPeTUEB0yJzPc
         0tTx9DwXPzKPPfIkOcu4TbowfBY+i8IjFchX53w8SaYcaeO15aIMifhMy9jmyg1Yy8y0
         ltAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MR+/NWA8p6VYz8uv/82PDoV9JZ8XB9MwZrQb5jkWV0Q=;
        b=MMcFotWUAuVEzcJXZ5n/i6w/pzx/UP4miifOA+m3vU0UGdkDOsf0lGcefZajhF8PAS
         N5cjpK0e3QcsYU8K90eEgtl32zgnLDLMwQnY6UrQuiCicdRNPmmblLrechOTHQ4nXjO3
         r/QNQxI6yfp6z0fcZTL5DVmkVjDI4BYRGXFHTTmecBOupovv2eXoKZ2GTT7HOMgHLy/3
         1TfL6ff6FyJ+WJcSZQSN8Lcoosq/4SUK7q6IkwwMQuLsksj3Cm2j3FNKbE5E8Md2f/db
         ggjk5xKWBqDfs1uxNilW/+EnY1eHMizJg8pC3PwqrceWdqPkhGhOjPeg92ERCRVThCGY
         +uzg==
X-Gm-Message-State: AFqh2kpPULX0/tagJu0O7WhTlC6RUhr4mEMrTx8gImQ2Lt80nSnxyuxr
        kv7dJMYbt0CSyZUonbKv9dDE+A==
X-Google-Smtp-Source: AMrXdXscYlLtCHAq3/z9+5Df9Wjc/Ll9rYmx2DDunqCMB/61SovKITfnbg0PAHfiDTY+HRdzbnKOLQ==
X-Received: by 2002:a17:907:80ce:b0:7c1:26b9:c556 with SMTP id io14-20020a17090780ce00b007c126b9c556mr50183303ejc.15.1672998953767;
        Fri, 06 Jan 2023 01:55:53 -0800 (PST)
Received: from [192.168.0.104] ([82.77.81.242])
        by smtp.gmail.com with ESMTPSA id l10-20020a1709063d2a00b0078db18d7972sm248340ejf.117.2023.01.06.01.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 01:55:53 -0800 (PST)
Message-ID: <ebfec54e-f82e-4560-9a4a-7c02ed4c841b@linaro.org>
Date:   Fri, 6 Jan 2023 11:55:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] mtd: spi-nor: spansion: Keep CFR5V[6] as 1 in Octal DTR
 enable/disable
Content-Language: en-US
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     tkuw584924@gmail.com, linux-mtd@lists.infradead.org
Cc:     pratyush@kernel.org, michael@walle.cc, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, Bacem.Daassi@infineon.com,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        stable@vger.kernel.org
References: <20230106030601.6530-1-Takahiro.Kuwano@infineon.com>
 <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
In-Reply-To: <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 06.01.2023 11:47, Tudor Ambarus wrote:
> Hey, Takahiro,
> 
> On 06.01.2023 05:06, tkuw584924@gmail.com wrote:
>> From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
>>
>> CFR5V[6] is reserved bit and must always be 1.
> 
> have you seen some strange behavior?
>>
>> Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress 
>> Semper flash")
>> Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
>> Cc: stable@vger.kernel.org
>> ---
>>   drivers/mtd/spi-nor/spansion.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mtd/spi-nor/spansion.c 
>> b/drivers/mtd/spi-nor/spansion.c
>> index b621cdfd506f..4e094a432d29 100644
>> --- a/drivers/mtd/spi-nor/spansion.c
>> +++ b/drivers/mtd/spi-nor/spansion.c
>> @@ -21,8 +21,8 @@
>>   #define SPINOR_REG_CYPRESS_CFR3V        0x00800004
>>   #define SPINOR_REG_CYPRESS_CFR3V_PGSZ        BIT(4) /* Page size. */
>>   #define SPINOR_REG_CYPRESS_CFR5V        0x00800006
>> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN    0x3
>> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS    0
>> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN    0x43
>> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS    0x40
> 
> No, this looks bad. Instead of overwriting CFR5V with whatever value, we
> should instead first read it and then update only the bit that we're
> interested in. If it happens to write CFR5V before octal enable/disable,
> you'll overwrite the previous set values.
> 

other idea is to keep some sort of cache register values in the code, to
avoid reading repeatedly register values at each update. But we probably
don't do so many updates for now, and maybe we can leave this for later.
