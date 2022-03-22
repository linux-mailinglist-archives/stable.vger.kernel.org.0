Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D874E36B8
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 03:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbiCVChD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 22:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235438AbiCVChC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 22:37:02 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A07E1CFDE
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:35:34 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id k14so658805pga.0
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=S6Jgc7aBpf/768ixumeVgNXvWvNNM1HOkw4ChK7eyOU=;
        b=cWSkwhuYJYaUCVyPKabZS1UmBl8TGIAsCdJTxM9L/Dwa6n5dXcdNP8fPJFKAywOD0y
         pJtxfqHE3uPeZk/6FMlZpo4ElzCqfpZTvqZfzGoSJq8od4d0WvILtx46rZZwn8yDMCs6
         O0a7dw/ZEsJKjH0cKiWPAJxtnzOxV4ibCrM9Z7O8+08/RlBQabarw/PB34I1Iyt+7+U1
         bGbScdeOCtsWZEUDKPSLdH2bG6eo9TYBoZzrlCKQmLjfXoG1ChnvQ+TntVHOWW50dYnW
         G8xSEBjPSmiK6A3NPDLVVc9vex/uGlZHxbN4IpN9li0X3AqMnZxp1HE6BItQznA0egxa
         3VWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=S6Jgc7aBpf/768ixumeVgNXvWvNNM1HOkw4ChK7eyOU=;
        b=Wugxe5118NfYnxxflr/BmFMQXK6FGMaHbF44uKMSQ4XXw02C8xyIta3ZE7TsXJo8x6
         iVB12tgsocnmcDY8UhQd6mZN5mnTDJ68sssGzGOJ3RwQ2pbJhBAsO230+Qx/esO3E04l
         20IkogWuhU07K7wJ84WwuJ8Yz6Z7Z8PLQhunTRcBWAzwCd9o8Vp8BuTJhc2CyBBPGv6H
         iUjQ9ilAAsbtT8FjZd5RhkE8NQMdkgY6FQ0TPqdfCVjpFXWfWR5nD0LxgjXccgjZchgf
         v3nsbsnFsxUVL/XErOLprUXFeg6fh1IzP9q8GMTPVUsYRSGOLaeGTYy2UzFFq3o/kUbZ
         gZgA==
X-Gm-Message-State: AOAM532trBwZZPR9HLyVP6wlZHYhAIDNdBOvaKM3YLKZYBi1jlYwrMqr
        c2Mi0kUxf0uYeMIzTnGwYU13XsAhhGk=
X-Google-Smtp-Source: ABdhPJw08jv8M3tj1bPH9+gUQguR+QaoKHdufedTGDoWJ5e0ZuZNBBLGgC0iD0Bx3PXqtJttuw2yoA==
X-Received: by 2002:a63:520c:0:b0:382:2953:a338 with SMTP id g12-20020a63520c000000b003822953a338mr15311991pgb.610.1647916533793;
        Mon, 21 Mar 2022 19:35:33 -0700 (PDT)
Received: from [192.168.122.100] (133-175-21-116.tokyo.ap.gmo-isp.jp. [133.175.21.116])
        by smtp.gmail.com with ESMTPSA id my18-20020a17090b4c9200b001c75aeac7fdsm337258pjb.27.2022.03.21.19.35.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 19:35:33 -0700 (PDT)
Message-ID: <22f5c9f7-2fbd-902b-ca9b-c14d92a9b045@gmail.com>
Date:   Tue, 22 Mar 2022 11:35:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v4 1/3] mtd: cfi_cmdset_0002: Move and rename
 chip_check/chip_ready/chip_good_for_write
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     linux-mtd@lists.infradead.org, stable@vger.kernel.org
References: <20220316155455.162362-1-ikegami.t@gmail.com>
 <20220316155455.162362-2-ikegami.t@gmail.com> <20220316181519.0ec5bc97@xps13>
From:   Tokunori Ikegami <ikegami.t@gmail.com>
In-Reply-To: <20220316181519.0ec5bc97@xps13>
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

Hi Miquèl-san,

On 2022/03/17 2:15, Miquel Raynal wrote:
> Hi Tokunori,
>
> ikegami.t@gmail.com wrote on Thu, 17 Mar 2022 00:54:53 +0900:
>
>> This is a preparation patch for the functional change in preparation to a change
>> expected to fix the buffered writes on S29GL064N.
> This is a preparation patch for the S29GL064N buffer writes fix. There
> is no functional change.
Fixed this by the version 5 patch.
>
>> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
>> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
>> Cc: stable@vger.kernel.org
>> ---
>>   drivers/mtd/chips/cfi_cmdset_0002.c | 77 ++++++++++++-----------------
>>   1 file changed, 32 insertions(+), 45 deletions(-)
>>
>> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
>> index a761134fd3be..e68ddf0f7fc0 100644
>> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
>> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>> @@ -801,22 +801,12 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd_info *mtd)
>>   	return NULL;
>>   }
>>   
>> -/*
>> - * Return true if the chip is ready.
>> - *
>> - * Ready is one of: read mode, query mode, erase-suspend-read mode (in any
>> - * non-suspended sector) and is indicated by no toggle bits toggling.
>> - *
>> - * Note that anything more complicated than checking if no bits are toggling
>> - * (including checking DQ5 for an error status) is tricky to get working
>> - * correctly and is therefore not done	(particularly with interleaved chips
>> - * as each chip must be checked independently of the others).
>> - */
>> -static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
>> -			       unsigned long addr)
>> +static int __xipram chip_check(struct map_info *map, struct flchip *chip,
>> +			       unsigned long addr, map_word *expected)
>>   {
>>   	struct cfi_private *cfi = map->fldrv_priv;
>> -	map_word d, t;
>> +	map_word oldd, curd;
>> +	int ret;
>>   
>>   	if (cfi_use_status_reg(cfi)) {
>>   		map_word ready = CMD(CFI_SR_DRB);
>> @@ -826,17 +816,35 @@ static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
>>   		 */
>>   		cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
>>   				 cfi->device_type, NULL);
>> -		d = map_read(map, addr);
>> +		curd = map_read(map, addr);
>>   
>> -		return map_word_andequal(map, d, ready, ready);
>> +		return map_word_andequal(map, curd, ready, ready);
> A lot of the diff is just a rename. I am not against a rename if you
> feel it's better, but in this order:
> 1: prepare the fix
> 2: fix
> 3: rename/define id's, whatever
This is also fixed as same.
>
>>   	}
>>   
>> -	d = map_read(map, addr);
>> -	t = map_read(map, addr);
>> +	oldd = map_read(map, addr);
>> +	curd = map_read(map, addr);
>> +
>> +	ret = map_word_equal(map, oldd, curd);
>>   
>> -	return map_word_equal(map, d, t);
>> +	if (!ret || !expected)
>> +		return ret;
>> +
>> +	return map_word_equal(map, curd, *expected);
>>   }
>>   
>> +/*
>> + * Return true if the chip is ready.
>> + *
>> + * Ready is one of: read mode, query mode, erase-suspend-read mode (in any
>> + * non-suspended sector) and is indicated by no toggle bits toggling.
>> + *
>> + * Note that anything more complicated than checking if no bits are toggling
>> + * (including checking DQ5 for an error status) is tricky to get working
>> + * correctly and is therefore not done	(particularly with interleaved chips
>> + * as each chip must be checked independently of the others).
>> + */
>> +#define chip_ready(map, chip, addr) chip_check(map, chip, addr, NULL)
> I don't see the point of such a define. Just get rid of it.
Yes deleted the macro as changed the name chip_check to chip_ready and 
to use only chip_ready without the macro.
>
>> +
>>   /*
>>    * Return true if the chip is ready and has the correct value.
>>    *
>> @@ -852,32 +860,11 @@ static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
>>    * as each chip must be checked independently of the others).
>>    *
>>    */
>> -static int __xipram chip_good(struct map_info *map, struct flchip *chip,
>> -			      unsigned long addr, map_word expected)
>> -{
>> -	struct cfi_private *cfi = map->fldrv_priv;
>> -	map_word oldd, curd;
>> -
>> -	if (cfi_use_status_reg(cfi)) {
>> -		map_word ready = CMD(CFI_SR_DRB);
>> -
>> -		/*
>> -		 * For chips that support status register, check device
>> -		 * ready bit
>> -		 */
>> -		cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
>> -				 cfi->device_type, NULL);
>> -		curd = map_read(map, addr);
>> -
>> -		return map_word_andequal(map, curd, ready, ready);
>> -	}
>> -
>> -	oldd = map_read(map, addr);
>> -	curd = map_read(map, addr);
>> -
>> -	return	map_word_equal(map, oldd, curd) &&
>> -		map_word_equal(map, curd, expected);
>> -}
>> +#define chip_good(map, chip, addr, expected) \
>> +	({ \
>> +		map_word datum = expected; \
>> +		chip_check(map, chip, addr, &datum); \
>> +	})
> What is this for? Same here, I don't see the point. Please get rid of
> all these unnecessary helpers which do nothing, besides complicating
> user's life.

Fixed as same.

Regards,
Ikegami

>
>>   static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr, int mode)
>>   {
>
> Thanks,
> Miquèl
