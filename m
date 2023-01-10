Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0FC663842
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 05:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjAJEjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 23:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjAJEj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 23:39:29 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6554B3F455
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 20:39:28 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id s8so3634583plk.5
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 20:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1imcIUxiMQK2StXdAmtpGIOjso+zqyOr795AM8rgSAY=;
        b=puZZzShrqSF2jvA8xcJNuiS35DXQJ3lAizr5R6dAuuLzwoJH3K5TZ5uDfIg3AFDvgJ
         +wjsDofC+B1TpwcwTadIZM04B2W7moY0WRUN+9+z25EO9es3gVRrjVPWtLtMwp5lzrl6
         AopC+FXSiBXCVhvYMv9R4TM/KHukDE7/ui1cbYCKtu4szds8EKNg2FsGfWk90hRjZW3Z
         7aFlE0ZToCLLmRG23JqIdIfwywRp2OhmXyinU/VBYXVrId4e+MpEEPG+0SV1TqiOYWnG
         m2C1N/WBfaJulf2gbM8VvZBR7lXynmcnc+03qHUKbzTbkCX0K1LXoLITHdokWAiG8WgW
         ASFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1imcIUxiMQK2StXdAmtpGIOjso+zqyOr795AM8rgSAY=;
        b=xounLA8j17tsphS5Q1T87rIikE++8oRLgLOdoYAt0k97AJGNjEVFXfjf2RHagazr40
         CWq2zhAMG7nSJ+EooTmxefQILgznfAe6T5YYOTRCITKp+5kTtWpZ2zcAQb8dw576iw2U
         2Kbn0VHOG2yR8cYpmHebeM6XrvxJBQeaO9kEWf5pbvv29GPS+UAZaH6A/xWX5Hno0UBw
         QYF0HvU2hzk6/NKrAQ/Q4DXhbHagn5U0w3B3jx6TJpqhTJv0dGS7kMnThcD/MeZkoCAL
         Glv79BaFxICpSFj83qc5IKFe88kub1bZ2sfpqG+ecdnVyMQRyu76gVqt0AuTilWV8T16
         lWEQ==
X-Gm-Message-State: AFqh2kpsp7uYJPao6ZpA3XFQbjYe1brdYiKDeTQrAr3KytRtEntm+CoU
        BAMVCyIzvRvTMdUT+yl9cPY=
X-Google-Smtp-Source: AMrXdXtny4wVCEM5H+2LZfffSy5HfgCB2j6BuBdpu9KWUj+J7cjyrA7HcdeJ1y4a2SUhvs+310Gb+g==
X-Received: by 2002:a17:903:41cf:b0:192:a69d:11f7 with SMTP id u15-20020a17090341cf00b00192a69d11f7mr52036904ple.27.1673325567909;
        Mon, 09 Jan 2023 20:39:27 -0800 (PST)
Received: from [192.168.0.10] (KD106168128197.ppp-bb.dion.ne.jp. [106.168.128.197])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902eec600b001811a197797sm5787820plb.194.2023.01.09.20.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 20:39:27 -0800 (PST)
Message-ID: <eb25673a-3f84-7231-8503-e38514056116@gmail.com>
Date:   Tue, 10 Jan 2023 13:39:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] mtd: spi-nor: spansion: Keep CFR5V[6] as 1 in Octal DTR
 enable/disable
To:     Tudor Ambarus <tudor.ambarus@linaro.org>,
        linux-mtd@lists.infradead.org
Cc:     pratyush@kernel.org, michael@walle.cc, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, Bacem.Daassi@infineon.com,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        stable@vger.kernel.org
References: <20230106030601.6530-1-Takahiro.Kuwano@infineon.com>
 <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
Content-Language: en-US
From:   Takahiro Kuwano <tkuw584924@gmail.com>
In-Reply-To: <493d9a10-aaf3-70f6-36c3-9a2cf39f0759@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/6/2023 6:47 PM, Tudor Ambarus wrote:
> Hey, Takahiro,
> 
> On 06.01.2023 05:06, tkuw584924@gmail.com wrote:
>> From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
>>
>> CFR5V[6] is reserved bit and must always be 1.
> 
> have you seen some strange behavior?
No, just to follow the datasheet.

>>
>> Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
>> Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
>> Cc: stable@vger.kernel.org
>> ---
>>   drivers/mtd/spi-nor/spansion.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
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
I understand read-modify-write is the right thing in general. Actually
CFR5V[7] and CFR5V[5:2] are reserved and must be 0 so I preferred a simple
fix for this particular case.

Thanks,
Takahiro
