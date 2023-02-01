Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5E8686066
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 08:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjBAHOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 02:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBAHOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 02:14:39 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17295FD5
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 23:14:37 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id c10-20020a17090a1d0a00b0022e63a94799so1177124pjd.2
        for <stable@vger.kernel.org>; Tue, 31 Jan 2023 23:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R0g4NQe1aCHgCRTvEl02z86KS94f8ECDTiqslCJ76Lo=;
        b=YULnFVkEgbufS3L38Mpf7SDnHmMCfetj5/KjmgIKmRTuxlOpqYaBM2SfeMLHYl0OP8
         fFhc4SLcfe3MogXyMdUSPmSIrN7QrYlVy6HdtD8qpyxZlk/g2WdFv6IOE7XvG4bPrJYN
         fVsnXYqLRN7PXz2/P2O7R7zMdeYdZcrV4GoTzv+3zvAdmNLKw7a50Xs0P02ExSV1mM5G
         8EyZsDaJ71pkLi/W4jKih4GPxXe9JxRPHnxNzaySAP7lB7emK4/4gMg6zu07GlV7vi2/
         nB8+Jybf1zxkz5tVqk+sIXfCirmN9MJRX/MF0xO0r9bblKcBjQajQtpSezUGDC7RzWg8
         ybYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R0g4NQe1aCHgCRTvEl02z86KS94f8ECDTiqslCJ76Lo=;
        b=2eaAAJMK1ReUOpRkmAREG8NdXcYlKJwPYnvY2T7qs0tyyyDpuIxkH74zzVvQ5lw6tp
         9kXAyA/HMkO8VpKLN30RIZc//pjuLkGRQV9z/mBMpZgomGVvSr8NuCpLb3u8/Y6aGCJs
         yIKzPNMQHUR9FuBMBzBLjV2+SvgxmYtaT8oKDTRhaywdpBgk0jvBphvTz83UXufrvnfO
         t3WEOWXXHGtoGqMGl8xkQLSCH1haKB80cRkLX91qsnWo5EIifcpbCSwT3MS6aO+PLd1e
         LEF2ogp9v9wqBJQ2qG1t4PupKfZNF9g3pAET9LtoVv7CaRz4LNaht1LA/xEBFzS6b8SH
         Uu1A==
X-Gm-Message-State: AO0yUKWDvWSg6s7A3tDidNIswOqWr7wZmeTIR5+RncGsqZv5EIzWPq3y
        4Lsa3dw0pHYcK2jtZCL8NGw=
X-Google-Smtp-Source: AK7set+zX1I5Td1RK9VNQtrjF8E7cYW1MUA7eNsm8VbebFIOvlUVDRi+mpSspK9966f7RE8GqrVLrg==
X-Received: by 2002:a17:903:1108:b0:196:2124:c590 with SMTP id n8-20020a170903110800b001962124c590mr19429996plh.33.1675235677139;
        Tue, 31 Jan 2023 23:14:37 -0800 (PST)
Received: from [192.168.0.10] (KD106168128197.ppp-bb.dion.ne.jp. [106.168.128.197])
        by smtp.gmail.com with ESMTPSA id l16-20020a170903245000b0019896d29197sm2922480pls.46.2023.01.31.23.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 23:14:36 -0800 (PST)
Message-ID: <ac22752e-4251-b56b-bd86-06d7477d5565@gmail.com>
Date:   Wed, 1 Feb 2023 16:14:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/2] mtd: spi-nor: spansion: Consider reserved bits in
 CFR5 register
To:     Dhruva Gole <d-gole@ti.com>, Pratyush Yadav <ptyadav@amazon.de>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     Takahiro.Kuwano@infineon.com, linux-mtd@lists.infradead.org,
        pratyush@kernel.org, michael@walle.cc, miquel.raynal@bootlin.com,
        richard@nod.at, Bacem.Daassi@infineon.com, stable@vger.kernel.org
References: <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
 <20230110164703.83413-1-tudor.ambarus@linaro.org>
 <mafs0v8kxb9mb.fsf_-_@amazon.de>
 <e02d6aa5-2189-4afb-2521-6034feaa3460@ti.com>
Content-Language: en-US
From:   Takahiro Kuwano <tkuw584924@gmail.com>
In-Reply-To: <e02d6aa5-2189-4afb-2521-6034feaa3460@ti.com>
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

Hi Dhruva and Pratyush,

On 1/24/2023 1:31 AM, Dhruva Gole wrote:
> Hi Pratyush,
> 
> On 23/01/23 20:07, Pratyush Yadav wrote:
>> +Cc Dhruva
> I had already reviewed this, but now I have locally applied the patches,
> to linux master and built and tested - seems okay,
I had tested on my side as well. Sorry for the late reply.

>> Hi Tudor,
>>
>> On Tue, Jan 10 2023, Tudor Ambarus wrote:
>>
>>> CFR5[6] is reserved bit and must be always 1. Set it to comply with flash
>>> requirements. While fixing SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_{EN, DS}
>>> definition, stop using magic numbers and describe the missing bit fields
>>> in CFR5 register. This is useful for both readability and future possible
>>> addition of Octal STR mode support.
>>>
>>> Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
>>> Cc: stable@vger.kernel.org
>>> Reported-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
>>> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
>>> ---
>>>  drivers/mtd/spi-nor/spansion.c | 9 +++++++--
>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
>>> index b621cdfd506f..07fe0f6fdfe3 100644
>>> --- a/drivers/mtd/spi-nor/spansion.c
>>> +++ b/drivers/mtd/spi-nor/spansion.c
>>> @@ -21,8 +21,13 @@
>>>  #define SPINOR_REG_CYPRESS_CFR3V               0x00800004
>>>  #define SPINOR_REG_CYPRESS_CFR3V_PGSZ          BIT(4) /* Page size. */
>>>  #define SPINOR_REG_CYPRESS_CFR5V               0x00800006
>>> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN    0x3
>>> -#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS    0
>>> +#define SPINOR_REG_CYPRESS_CFR5_BIT6           BIT(6)
>> Perhaps comment here that this bit is reserved. Otherwise it is not
>> obvious what this does and why we are setting it without going through
>> git-blame. No need for a re-roll, I think it is fine if you add this
>> when applying.
>>
>>> +#define SPINOR_REG_CYPRESS_CFR5_DDR            BIT(1)
>>> +#define SPINOR_REG_CYPRESS_CFR5_OPI            BIT(0)
>>> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN                            \
>>> +       (SPINOR_REG_CYPRESS_CFR5_BIT6 | SPINOR_REG_CYPRESS_CFR5_DDR |   \
>>> +        SPINOR_REG_CYPRESS_CFR5_OPI)
>>> +#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS    SPINOR_REG_CYPRESS_CFR5_BIT6
>> I would say don't fix what isn't broken. But if you do, test it. Do you
>> or Takahiro have a Cypress S28* flash to test this change on? If no,
>> then perhaps Dhruva can help here since TI uses this flash on a bunch of
>> their boards?
>>
>> The change looks fine to me with the above comment added, I just would
>> like someone to test it once.
> Tested OSPI_S_FUNC_DD_RW_ERASESIZE_UBIFS from ltp-ddt and test seemed to pass on my
> AM625 SK EVM having an OSPI NOR S28HS512T Flash.
>>
>> Reviewed-by: Pratyush Yadav <ptyadav@amazon.de>
> For this series,
> 
> Tested-by: Dhruva Gole <d-gole@ti.com>
> 
Thank you!

>>>  #define SPINOR_OP_CYPRESS_RD_FAST              0xee
>>>
>>>  /* Cypress SPI NOR flash operations. */
>>> --
>>> 2.34.1
>>>
>>>
> 
Takahiro
