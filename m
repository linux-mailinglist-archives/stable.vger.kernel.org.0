Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91811D0CFC
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 12:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfJIKnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 06:43:15 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41163 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfJIKnP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 06:43:15 -0400
Received: by mail-ed1-f66.google.com with SMTP id f20so1555295edv.8;
        Wed, 09 Oct 2019 03:43:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZH/t6Z5SKm0O+GF3c+jnCpiA2fHZKai+CXFJKmI0anE=;
        b=foNGsBUMMxcNRAm4b8gjo6ARjAE3C0mTF2iEdJzjkqR4UW0tgVi6q8qf/gcmA0pDOn
         FMIY52VVAYRu7/DGTAfcWsMWfpUuJZd+H7bwNqpyQ/CeywlWBSLr6t7tZNMLFXgG/yDH
         3WvNtKKn4Q/Iu95GBClEeYzQn6CFzIqKj9THxTy6wh44cwvvaUIWfvIZFQfSDfc7UPo8
         DH/aAJLTkMszWDrOevk9XZ/gN7GrBZu2/LxdINyTFw1AUBvCN0rajzx5M50z2p+2sfNp
         F+A7piHckxLqpa4ejujZ6Yw4+MVAeUjnkKJkDvV3jh6NRaztAwkixlU19DiPnWA2xVWd
         KE1A==
X-Gm-Message-State: APjAAAXMJkuybu6APl8L1x/rA4xc+1g4XydsN+W2iaDTWsWKqEmVtGvo
        Knj1bIxWvQSOjuUbb5WU6spuhTtZEwc=
X-Google-Smtp-Source: APXvYqyNrmyb6MX/tNGEjdMfBRcon/IjHUNxtV7X/50ybrVaIrAFeHEb0Rq/5QqQ03f9oNPdMt+syw==
X-Received: by 2002:a17:906:4748:: with SMTP id j8mr2143495ejs.210.1570617792769;
        Wed, 09 Oct 2019 03:43:12 -0700 (PDT)
Received: from [172.16.14.133] ([62.28.178.14])
        by smtp.gmail.com with ESMTPSA id t9sm202921eji.26.2019.10.09.03.43.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 03:43:11 -0700 (PDT)
To:     Hans de Goede <hdegoede@redhat.com>, devel@driverdev.osuosl.org
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bastien Nocera <hadess@hadess.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <jes.sorensen@gmail.com>, stable@vger.kernel.org
References: <20190930110141.29271-1-efremov@linux.com>
 <94af475e-dd7a-6066-146a-30a9915cd325@redhat.com>
From:   Denis Efremov <efremov@linux.com>
Autocrypt: addr=efremov@linux.com; keydata=
 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
Subject: Re: [PATCH] staging: rtl8723bs: hal: Fix memcpy calls
Message-ID: <996e0e51-019a-5d65-026a-9599f9228299@linux.com>
Date:   Wed, 9 Oct 2019 13:43:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <94af475e-dd7a-6066-146a-30a9915cd325@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 09.10.2019 12:35, Hans de Goede wrote:
> Hi Denis,
> 
> On 30-09-2019 13:01, Denis Efremov wrote:
>> memcpy() in phy_ConfigBBWithParaFile() and PHY_ConfigRFWithParaFile() is
>> called with "src == NULL && len == 0". This is an undefined behavior.
>> Moreover this if pre-condition "pBufLen && (*pBufLen == 0) && !pBuf"
>> is constantly false because it is a nested if in the else brach, i.e.,
>> "if (cond) { ... } else { if (cond) {...} }". This patch alters the
>> if condition to check "pBufLen && pBuf" pointers are not NULL.
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Hans de Goede <hdegoede@redhat.com>
>> Cc: Bastien Nocera <hadess@hadess.net>
>> Cc: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Jes Sorensen <jes.sorensen@gmail.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Denis Efremov <efremov@linux.com>
>> ---
>> Not tested. I don't have the hardware. The fix is based on my guess.
> 
> Thsnk you for your patch.
> 
> So I've been doing some digging and this code normally never executes.
> 
> For this to execute the user would need to change the rtw_load_phy_file module
> param from its default of 0x44 (LOAD_BB_PG_PARA_FILE | LOAD_RF_TXPWR_LMT_PARA_FILE)
> to something which includes 0x02 (LOAD_BB_PARA_FILE) as mask.
> 
> And even with that param set for this code to actually do something /
> for pBuf to ever not be NULL the following conditions would have to
> be true:
> 
> 1) Set the rtw_load_phy_file module param from its default of
>    0x44 (LOAD_BB_PG_PARA_FILE | LOAD_RF_TXPWR_LMT_PARA_FILE) to something
>    which includes 0x02 as mask; and
> 2) Set rtw_phy_file_path module parameter to say "/lib/firmware/"; and
> 3) Store a /lib/firmware/rtl8723b/PHY_REG.txt file in the expected format.
> 
> So I've come to the conclusion that all the phy_Config*WithParaFile functions
> (and a bunch of stuff they use) can be removed.
> 
> I will prepare and submit a patch for this.
> 

Thank you for perfect investigation! I can only agree with you, because this
code is buggy. It looks like no one faced this bug previously and the code
can be safely removed.

Best Regards,
Denis

> 
>>
>>   drivers/staging/rtl8723bs/hal/hal_com_phycfg.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
>> index 6539bee9b5ba..0902dc3c1825 100644
>> --- a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
>> +++ b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
>> @@ -2320,7 +2320,7 @@ int phy_ConfigBBWithParaFile(
>>               }
>>           }
>>       } else {
>> -        if (pBufLen && (*pBufLen == 0) && !pBuf) {
>> +        if (pBufLen && pBuf) {
>>               memcpy(pHalData->para_file_buf, pBuf, *pBufLen);
>>               rtStatus = _SUCCESS;
>>           } else
>> @@ -2752,7 +2752,7 @@ int PHY_ConfigRFWithParaFile(
>>               }
>>           }
>>       } else {
>> -        if (pBufLen && (*pBufLen == 0) && !pBuf) {
>> +        if (pBufLen && pBuf) {
>>               memcpy(pHalData->para_file_buf, pBuf, *pBufLen);
>>               rtStatus = _SUCCESS;
>>           } else
>>
> 
