Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90C25FD72A
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 11:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiJMJhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 05:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJMJh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 05:37:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F931217F9
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 02:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665653846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rsi4Lk+z8q8AtuKdvp61jTbjG2RLIicZfW+0rKzKJto=;
        b=Ba3eKyU77y+atwCMwqCUeespGd8o7sEMASwnixespa+WHprCMs7uUyzUrXWJJWqFtTsGfZ
        MW6bV79YB2JqTmjPlffQ4OPtpbVD2POYu9vBtHRGehqXFFyNupQiI2Dm5y2TBNlKr67TRo
        CzKm0iT5+I6yfXe1FHd9wpqGBZsLOas=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-74-r-7TejLhMdSKMEjLUxhIUw-1; Thu, 13 Oct 2022 05:37:25 -0400
X-MC-Unique: r-7TejLhMdSKMEjLUxhIUw-1
Received: by mail-wm1-f71.google.com with SMTP id r81-20020a1c4454000000b003c41e9ae97dso2586950wma.6
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 02:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rsi4Lk+z8q8AtuKdvp61jTbjG2RLIicZfW+0rKzKJto=;
        b=F8UaCpXRyVbYpUqi1GEnout6dTCLP/5+9WyI9xSzhByMRmQd/1PQ61xCyu/qQT72e/
         DlQBBlJCk3eeiKjUaYF1iyV7WpIfbKObFCGO8BrD4PIdXzWfUN1i4pJZePlyKfcxZjUk
         PKRLRLtmHUm6o0KqpsSN1MqVO59RWTmYixr7VExlo7ke+kOnJkTjwkL1631LRR742l+M
         7RqlvX2/waG5qxjKdyXpbASCBo2z4i46z8QC5Iez53Jz0Ha1hwFFYpkKE+uZkjLw61eq
         ZyyAi3Y8ZuYOREf396ApHx6cyFv979YJaPDKu2Ez1F+vlGgpBrzn+sCLqlj5TN5wVXkC
         EFTg==
X-Gm-Message-State: ACrzQf2+Oa9KoEfHku8qMAnV4ZV79quEDmvAAupzsz7tB9Ya75ZcftED
        xnJpbtWUIMA86RJ03Iw995ia0fWR/jfPcEfTVXhk4vkYafKMh2GbCoFCJ4Nv76QPeZ88i2CPSeU
        1UZHJfQhhbNXfcIwf
X-Received: by 2002:adf:ef43:0:b0:22d:c507:dd48 with SMTP id c3-20020adfef43000000b0022dc507dd48mr20778865wrp.416.1665653844217;
        Thu, 13 Oct 2022 02:37:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5XZ/j3MSgkJXocGL5tRASQ0I9DPMwtOk/wMQIV0LJQylec4FXcsib9VWlSeBD+v4nVY4ZQVw==
X-Received: by 2002:adf:ef43:0:b0:22d:c507:dd48 with SMTP id c3-20020adfef43000000b0022dc507dd48mr20778847wrp.416.1665653843992;
        Thu, 13 Oct 2022 02:37:23 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:c:37e0:c13d:8f66:ffd1:f7f4? ([2a01:e0a:c:37e0:c13d:8f66:ffd1:f7f4])
        by smtp.gmail.com with ESMTPSA id bn13-20020a056000060d00b002286670bafasm1616877wrb.48.2022.10.13.02.37.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 02:37:23 -0700 (PDT)
Message-ID: <f2af0e1e-f4ed-ef4f-bad8-11e2dee132a7@redhat.com>
Date:   Thu, 13 Oct 2022 11:37:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4
Content-Language: en-US
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        dri-devel@lists.freedesktop.org, airlied@redhat.com
Cc:     lyude@redhat.com, michel@daenzer.net, stable@vger.kernel.org
References: <20221013082901.471417-1-jfalempe@redhat.com>
 <db634341-da68-e8a6-1143-445f17262c63@suse.de>
From:   Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <db634341-da68-e8a6-1143-445f17262c63@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/10/2022 11:05, Thomas Zimmermann wrote:
> Hi
> 
> Am 13.10.22 um 10:29 schrieb Jocelyn Falempe:
>> For G200_SE_A, PLL M setting is wrong, which leads to blank screen,
>> or "signal out of range" on VGA display.
>> previous code had "m |= 0x80" which was changed to
>> m |= ((pixpllcn & BIT(8)) >> 1);
>>
>> Tested on G200_SE_A rev 42
>>
>> This line of code was moved to another file with
>> commit 85397f6bc4ff ("drm/mgag200: Initialize each model in separate
>> function") but can be easily backported before this commit.
>>
>> Fixes: 2dd040946ecf ("drm/mgag200: Store values (not bits) in struct 
>> mgag200_pll_values")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
>> ---
>>   drivers/gpu/drm/mgag200/mgag200_g200se.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/mgag200/mgag200_g200se.c 
>> b/drivers/gpu/drm/mgag200/mgag200_g200se.c
>> index be389ed91cbd..4ec035029b8b 100644
>> --- a/drivers/gpu/drm/mgag200/mgag200_g200se.c
>> +++ b/drivers/gpu/drm/mgag200/mgag200_g200se.c
>> @@ -284,7 +284,7 @@ static void 
>> mgag200_g200se_04_pixpllc_atomic_update(struct drm_crtc *crtc,
>>       pixpllcp = pixpllc->p - 1;
>>       pixpllcs = pixpllc->s;
>> -    xpixpllcm = pixpllcm | ((pixpllcn & BIT(8)) >> 1);
>> +    xpixpllcm = pixpllcm | BIT(7);
> 
> Thanks for figuring this out. G200SE apparently is special compared to 
> the other models. The old MGA docs only list this bit as <reserved>. 
> Really makes me wonder why this is different.

I think it might be because of the "clock * 2" trick for this model.
(so N parameter is half of what it should be, and doesn't have BIT(8) 
set). But I don't have the G200SE A specific hardware spec either.


> 
> Please write it as
> 
>    BIT(7) | pixpllcm
> 
> so that bit settings are ordered MSB-to-LSB and include a one-line 
> comment that says that G200SE needs to set this bit unconditionally.

Thanks, I will send a v2 shortly.

> 
> Best regards
> Thomas
> 
> 
> 
>>       xpixpllcn = pixpllcn;
>>       xpixpllcp = (pixpllcs << 3) | pixpllcp;
> 

