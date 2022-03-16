Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A5E4DB592
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 17:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbiCPQGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 12:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234921AbiCPQGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 12:06:50 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6855F8C0
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:05:36 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id s11so4309132pfu.13
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=a9E401mDl8ftw84F8S7wyTJtD/ZrOgIHvw36pVuG6Pk=;
        b=eDocAUHtjFp8OnmNFOZV+ASnUF7zs/aRn4XMVbZMeaUdxAmS52Yt+qeLvrS+H7kSOg
         JpZRUE1QZ6HqbzRat3psSeSYtP4Po6pEeNyxytZ8T0dvBJLouOxUYmaBYKMMXjeBrvdL
         2ySpZ+zzlTcKaG1kUMWHDzDiawn5G7OibYouhxJZiPd554RsfjXsz0+jhm1B+nieo7GO
         KIe4vGuufnXSdufnasQCFqGBxdyFyTh6IwOB6FJAobZGh5SlV6Feh2J1QsklzwNmMTKm
         9R7IiAJelaFHpzzkjGaRkqiqNY1hRb8PAcCHmXty+gfCGdUdPqmh2QbYmbfUE/GKBi4s
         P2dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=a9E401mDl8ftw84F8S7wyTJtD/ZrOgIHvw36pVuG6Pk=;
        b=vEEksg2VaMK9/Z1lU39jVgKgfi8Lr5c6iJi+ZGstsEPP35Q2UTwx9IDsPMqJo5c6Pk
         JbG42l7LFOP0sfQcOwVG+jc9aiBf6/yUtKRW3MWdQFpUQpXJkweZU3rAw23S4IfBKtri
         IQuWWeKQ7kebAcRTHKJ32XxR16ADqhOGtzO5aQOjupuHoZFu72gXzZywaW+CjWmBMNcm
         1qQC5SuqY0iYcOILXLt4DXhHnOmAwhkrWTiQQZjv7S0srY8G7KgMnL/N14cHIhM0zw6m
         meHoWgaP1yFyQNmdLx85t+tBxl/8jo0MxWua8ef0GZFaV/Jzi/UAMU6ZWOJrN4hUy2pY
         4fVg==
X-Gm-Message-State: AOAM532evhZkWmSRL+3U5Q9GH8jTJVJXvLDcJYfgwXtIPh1sTSdAgKqA
        mguTh8Uv7RNCcxJ8MTEgsXo=
X-Google-Smtp-Source: ABdhPJylR0bz6ztGHZ1y8sNvmcqhIJbgUUaRkaTn1Sk+ZDKzxCmxqvQIFp6aK4CV5nOkTwS8p5iabQ==
X-Received: by 2002:a05:6a00:18a3:b0:4f7:260b:2954 with SMTP id x35-20020a056a0018a300b004f7260b2954mr34679230pfh.33.1647446735834;
        Wed, 16 Mar 2022 09:05:35 -0700 (PDT)
Received: from ?IPV6:240b:10:2720:5500:9500:ad27:b03f:5499? ([240b:10:2720:5500:9500:ad27:b03f:5499])
        by smtp.gmail.com with ESMTPSA id o5-20020a655bc5000000b00372f7ecfcecsm2916174pgr.37.2022.03.16.09.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 09:05:35 -0700 (PDT)
Message-ID: <b26d67c6-0b35-42ff-18cc-ce998de8bf3a@gmail.com>
Date:   Thu, 17 Mar 2022 01:05:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 3/3] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     linux-mtd@lists.infradead.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org
References: <20220315165607.390070-1-ikegami.t@gmail.com>
 <20220315165607.390070-4-ikegami.t@gmail.com> <20220315195137.6e371f8f@xps13>
From:   Tokunori Ikegami <ikegami.t@gmail.com>
In-Reply-To: <20220315195137.6e371f8f@xps13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2022/03/16 3:51, Miquel Raynal wrote:
> Hi Tokunori,
>
> ikegami.t@gmail.com wrote on Wed, 16 Mar 2022 01:56:07 +0900:
>
>> As pointed out by this bug report [1], the buffered write is now broken on
>                                         , buffered writes are now broken
>
>> S29GL064N. The reason is that changed the buffered write to use chip_good
>> instead of chip_ready.
> "This issue comes from a rework which switched from using chip_good()
> to chip_ready(), because <explain the difference here>."
>
> [please note I am just trying to understand what the root cause is,
> please rephrase if I'm wrong].
Fixed by the version 4 patches.
>
>> One way to solve the issue is to revert the change
>> partially to use chip_ready for S29GL064N since the way of least surprise.
> s/since the way of least surprise//
Fixed by the version 4 patches.
>
>
>> [1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
>>
>> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
>> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
>> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
>> Cc: Miquel Raynal <miquel.raynal@bootlin.com>
>> Cc: Richard Weinberger <richard@nod.at>
>> Cc: Vignesh Raghavendra <vigneshr@ti.com>
>> Cc: linux-mtd@lists.infradead.org
> I think you can get rid of all the above Cc: tags and just copy all 3
> of us + the mailing list when sending your v4.
Fixed by the version 4 patches.
>
>> Cc: stable@vger.kernel.org
>> ---
> Please also include a Fixes/stable tag in the patch before (2/3) to explain
> that both patches are required in order to fix the issue and the current patch alone won't apply.
>
> You should mention that with a nice comment below the three dashes ("---") in patch 2/3 as well.
>
>>   drivers/mtd/chips/cfi_cmdset_0002.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
>> index 8f3f0309dc03..fa11db066c99 100644
>> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
>> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>> @@ -867,10 +867,20 @@ static int __xipram chip_good(struct map_info *map, struct flchip *chip,
>>   	return chip_check(map, chip, addr, &expected);
>>   }
>>   
>> +static bool __xipram cfi_use_chip_ready_for_write(struct map_info *map)
>> +{
>> +	struct cfi_private *cfi = map->fldrv_priv;
>> +
>> +	return cfi->mfr == CFI_MFR_AMD && cfi->id == S29GL064N_MN12;
>> +}
>> +
>>   static int __xipram chip_good_for_write(struct map_info *map,
>>   					struct flchip *chip, unsigned long addr,
>>   					map_word expected)
>>   {
>> +	if (cfi_use_chip_ready_for_write(map))
>> +		return chip_ready(map, chip, addr);
>> +
>>   	return chip_good(map, chip, addr, expected);
>>   }
>>   
> This is much more understandable.
>
> Vignesh, perhaps it would be better to provide a way for manufacturers
> to overload certain callbacks instead of applying quirks like this in
> the code. But that will come in a second time of course.
>
>
> Thanks,
> Miquèl
