Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775D34CEC21
	for <lists+stable@lfdr.de>; Sun,  6 Mar 2022 16:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiCFPlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 10:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiCFPlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 10:41:36 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF4510FEB
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 07:40:44 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p17so11741843plo.9
        for <stable@vger.kernel.org>; Sun, 06 Mar 2022 07:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XkFiekSuEsRvws8ArAP4yxlQEE7v734dap3TegIlpwQ=;
        b=a39wlG/No0dhNRQWFNFuAUfEumNKWSV4cV+q+foU3jVz1jr86FyvBMGIC4xYgkCII5
         uD52+cJhgCdclXuu+vY+saUjx3voMhTGPyU1JKT/Z13m8Wd3t1mY1h9AWogJzr5ILuf0
         eTOaRFgTuNhEXhk3pQlIhNLH7G7+jTmR9UeKUuySIvwILSEABZz8ba4DOR3uo8nXqnAd
         C7N/jevDVsheacNCV2SGIMstBLhm8crif8SzDNxMISX1DVRcaoZQYiNHltvCnRCB15mh
         rqXj/cV0Bu9UkTjMojSrAd++k5L40o/lRWfpFxUhzJo6IhrLP/s0dGPBtUkEs69Lmbw7
         nXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XkFiekSuEsRvws8ArAP4yxlQEE7v734dap3TegIlpwQ=;
        b=7Z2eRiBunmr2P2ITL53ocVJHIrDfbjvRBT1oKHyM0xGl1T4GHAD4xu9BA577RQoY1k
         cTbZvP5nXMT5JPNnwgyYB7DlUQgV7xtlQ/w8/PDListtnf3G9yqVD/gCazPxElu2MR7A
         SXX9Ec3VnfaRzRhQeGD8ehuREJ53vqlC1LQ3KlSQss0I5Hu5VGexMmhUu4rIPo49mZyu
         zSBvrnjhuCG2TW4i1b6HiLO8wZ6U0ZN0dl/sCiPACJwLrzgV1C1M7Shcrh/teQRgVDOO
         LpbrBg2jkBY366AS75LJardemdjMfGCQmwEZ3VXpAmByJ/YuOaq4stCG7lO3L5xWUHLx
         vtKQ==
X-Gm-Message-State: AOAM531ifLw/yQ1kkLWzMBTfTWdmVWe8ZYidJznfEkJ2OzEf/yR9bdoU
        ABcFrPxzKAnEjo6U3lforfdZMxj3gVc=
X-Google-Smtp-Source: ABdhPJykHGHtbza1D3tzdz0cLl50m6i1zB5e9LohvutSSyby1fCjXo41Am5ELvhhuG1sao0wxZV0nw==
X-Received: by 2002:a17:90a:9dc6:b0:1bc:5c73:522b with SMTP id x6-20020a17090a9dc600b001bc5c73522bmr8707166pjv.35.1646581243513;
        Sun, 06 Mar 2022 07:40:43 -0800 (PST)
Received: from ?IPV6:240b:10:2720:5500:7cd8:5236:546e:2b2c? ([240b:10:2720:5500:7cd8:5236:546e:2b2c])
        by smtp.gmail.com with ESMTPSA id x29-20020aa79a5d000000b004f0ef1822d3sm12069519pfj.128.2022.03.06.07.40.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 07:40:43 -0800 (PST)
Message-ID: <4b6ca36d-6f9d-25f6-86ea-adc5fbe760d4@gmail.com>
Date:   Mon, 7 Mar 2022 00:40:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: Use chip_ready() for write on
 S29GL064N
Content-Language: en-US
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     linux-mtd@lists.infradead.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org
References: <20220214182011.8493-1-ikegami.t@gmail.com>
 <e9cb486d-b775-896c-93b5-3a1154bd9f3e@ti.com>
From:   Tokunori Ikegami <ikegami.t@gmail.com>
In-Reply-To: <e9cb486d-b775-896c-93b5-3a1154bd9f3e@ti.com>
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

Thanks  for your review and comments.

On 2022/03/01 0:34, Vignesh Raghavendra wrote:
> Hi,
>
> On 14/02/22 11:50 pm, Tokunori Ikegami wrote:
>> The regression issue has been caused on S29GL064N and reported it.
>> Also the change mentioned is to use chip_good() for buffered write.
>> So disable the change on S29GL064N and use chip_ready() as before.
>>
>> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
>> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
>> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
>> Cc: linux-mtd@lists.infradead.org
>> Cc: stable@vger.kernel.org
>> ---
> Thanks for working on the fix.
>
> Please CC maintainers from
>
> ./scripts/get_maintainer.pl -f drivers/mtd/chips/cfi_cmdset_0002.c
>
> Else, patch would not get attention in time.
Just added the maintainers as CC by the version 2 patch.
>
>>   drivers/mtd/chips/cfi_cmdset_0002.c | 105 ++++++++++++++++------------
>>   1 file changed, 59 insertions(+), 46 deletions(-)
>>
>> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
>> index a761134fd3be..a0dfc8ace899 100644
>> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
>> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>> @@ -48,6 +48,7 @@
>>   #define SST49LF040B		0x0050
>>   #define SST49LF008A		0x005a
>>   #define AT49BV6416		0x00d6
>> +#define S29GL064N_MN12		0x0c01
>>   
>>   /*
>>    * Status Register bit description. Used by flash devices that don't
>> @@ -109,6 +110,8 @@ static struct mtd_chip_driver cfi_amdstd_chipdrv = {
>>   	.module		= THIS_MODULE
>>   };
>>   
>> +static bool use_chip_good_for_write;
>> +
> Can we use per device private flag? Else this wont work on systems with
> multiple CFI flashes with one of them being S29GL064N_MN12.
Yes fixed the patch to check the cfi mfr and id values directly instead 
of the static variable.
>
>>   /*
>>    * Use status register to poll for Erase/write completion when DQ is not
>>    * supported. This is indicated by Bit[1:0] of SoftwareFeatures field in
>> @@ -283,6 +286,17 @@ static void fixup_use_write_buffers(struct mtd_info *mtd)
>>   }
>>   #endif /* !FORCE_WORD_WRITE */
>>   
>> +static void fixup_use_chip_good_for_write(struct mtd_info *mtd)
>> +{
>> +	struct map_info *map = mtd->priv;
>> +	struct cfi_private *cfi = map->fldrv_priv;
>> +
>> +	if (cfi->mfr == CFI_MFR_AMD && cfi->id == S29GL064N_MN12)
>> +		return;
>> +
>> +	use_chip_good_for_write = true;
>> +}
>> +
>>   /* Atmel chips don't use the same PRI format as AMD chips */
>>   static void fixup_convert_atmel_pri(struct mtd_info *mtd)
>>   {
>> @@ -462,7 +476,7 @@ static struct cfi_fixup cfi_fixup_table[] = {
>>   	{ CFI_MFR_AMD, 0x0056, fixup_use_secsi },
>>   	{ CFI_MFR_AMD, 0x005C, fixup_use_secsi },
>>   	{ CFI_MFR_AMD, 0x005F, fixup_use_secsi },
>> -	{ CFI_MFR_AMD, 0x0c01, fixup_s29gl064n_sectors },
>> +	{ CFI_MFR_AMD, S29GL064N_MN12, fixup_s29gl064n_sectors },
>>   	{ CFI_MFR_AMD, 0x1301, fixup_s29gl064n_sectors },
>>   	{ CFI_MFR_AMD, 0x1a00, fixup_s29gl032n_sectors },
>>   	{ CFI_MFR_AMD, 0x1a01, fixup_s29gl032n_sectors },
>> @@ -474,6 +488,7 @@ static struct cfi_fixup cfi_fixup_table[] = {
>>   #if !FORCE_WORD_WRITE
>>   	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_use_write_buffers },
>>   #endif
>> +	{ CFI_MFR_ANY, CFI_ID_ANY, fixup_use_chip_good_for_write },
>>   	{ 0, 0, NULL }
>>   };
>>   static struct cfi_fixup jedec_fixup_table[] = {
>> @@ -801,42 +816,61 @@ static struct mtd_info *cfi_amdstd_setup(struct mtd_info *mtd)
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
>> +
> Unrelated change?
Yes deleted the empty line added.
>
>>   		/*
>>   		 * For chips that support status register, check device
>>   		 * ready bit
>>   		 */
>>   		cfi_send_gen_cmd(0x70, cfi->addr_unlock1, chip->start, map, cfi,
>>   				 cfi->device_type, NULL);
>> -		d = map_read(map, addr);
>> +		curd = map_read(map, addr);
>>   
>> -		return map_word_andequal(map, d, ready, ready);
>> +		return map_word_andequal(map, curd, ready, ready);
>>   	}
>>   
>> -	d = map_read(map, addr);
>> -	t = map_read(map, addr);
>> +	oldd = map_read(map, addr);
>> +	curd = map_read(map, addr);
>> +
>> +	ret = map_word_equal(map, oldd, curd);
>> +
>> +	if (!ret || !expected)
>> +		return ret;
> Why even read oldd and curd if !expected ?

Since required this for chip ready that checks the oldd and curd if 
equal or not.

Regards,
Ikegami

>
>> +
>> +	return map_word_equal(map, curd, *expected);
>> +}
>> +
>> +static int __xipram chip_good_for_write(struct map_info *map,
>> +					struct flchip *chip, unsigned long addr,
>> +					map_word expected)
>> +{
>> +	if (use_chip_good_for_write)
>> +		return chip_check(map, chip, addr, &expected);
>>   
>> -	return map_word_equal(map, d, t);
>> +	return chip_check(map, chip, addr, NULL);
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
>> +
>>   /*
>>    * Return true if the chip is ready and has the correct value.
>>    *
>> @@ -855,28 +889,7 @@ static int __xipram chip_ready(struct map_info *map, struct flchip *chip,
>>   static int __xipram chip_good(struct map_info *map, struct flchip *chip,
>>   			      unsigned long addr, map_word expected)
>>   {
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
>> +	return chip_check(map, chip, addr, &expected);
>>   }
>>   
>>   static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr, int mode)
>> @@ -1699,7 +1712,7 @@ static int __xipram do_write_oneword_once(struct map_info *map,
>>   		 * "chip_good" to avoid the failure due to scheduling.
>>   		 */
>>   		if (time_after(jiffies, timeo) &&
>> -		    !chip_good(map, chip, adr, datum)) {
>> +		    !chip_good_for_write(map, chip, adr, datum)) {
>>   			xip_enable(map, chip, adr);
>>   			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
>>   			xip_disable(map, chip, adr);
>> @@ -1707,7 +1720,7 @@ static int __xipram do_write_oneword_once(struct map_info *map,
>>   			break;
>>   		}
>>   
>> -		if (chip_good(map, chip, adr, datum)) {
>> +		if (chip_good_for_write(map, chip, adr, datum)) {
>>   			if (cfi_check_err_status(map, chip, adr))
>>   				ret = -EIO;
>>   			break;
>> @@ -1979,14 +1992,14 @@ static int __xipram do_write_buffer_wait(struct map_info *map,
>>   		 * "chip_good" to avoid the failure due to scheduling.
>>   		 */
>>   		if (time_after(jiffies, timeo) &&
>> -		    !chip_good(map, chip, adr, datum)) {
>> +		    !chip_good_for_write(map, chip, adr, datum)) {
>>   			pr_err("MTD %s(): software timeout, address:0x%.8lx.\n",
>>   			       __func__, adr);
>>   			ret = -EIO;
>>   			break;
>>   		}
>>   
>> -		if (chip_good(map, chip, adr, datum)) {
>> +		if (chip_good_for_write(map, chip, adr, datum)) {
>>   			if (cfi_check_err_status(map, chip, adr))
>>   				ret = -EIO;
>>   			break;
