Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB47D52878F
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 16:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243046AbiEPOva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 10:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240692AbiEPOvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 10:51:25 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9852ED55
        for <stable@vger.kernel.org>; Mon, 16 May 2022 07:51:24 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n18so14659595plg.5
        for <stable@vger.kernel.org>; Mon, 16 May 2022 07:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9ILjHyAIIUvPIkL8gw9Y2opgc0fTj0MnOokGYowj0Rg=;
        b=HPW1lLGvgicxdIdZx7J6FbwBhdhc/E/k/7kHKn89BOmoeaDSgeHpnnjs8nqWACIkrr
         ksXHnX1pSxp3n29FSh3Pn+BH5hgRJjzsu2zn+w1VBZgeVihTe2yJC1rMoust4Jvydotl
         ChH6TGn7uq7uTIim+10hIsSIB/h/cAivTqAB0S0BcYdOrJWLFbNZAaEoRdG79mY53PrW
         hfIRLJbId9CzttGZmuIXsR+WtOO4n6/yyMrm+nj0mJeyLriKqQ+lSj4leGc3IRWq7NCu
         lSIeygFSQjFnFP6ur2hviyw6k4IIGChgtK/Jdf0rYjc35lv0En9ii84aw4OpXmBB0Y9E
         soHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9ILjHyAIIUvPIkL8gw9Y2opgc0fTj0MnOokGYowj0Rg=;
        b=PD3CkOtcQnZ4/H7Ckru32dVQeetvD50PDHOJOgtMLFzerGzzVwkv+ZRBy8Dt87z4C8
         YHtiFRRHjkRPlABPo44ngW2D6HikyPH0ihZKyFt4FvV9OaUlmyGMNCSa+w5K8zClPW9y
         j49PZ3V5nCdE5hUYoGW8tePRM1eCkGs8dkJyxra3d1nthp1eTQWsBdeKCg07gAZ9SKtl
         tRQ9GmUdPukkft+ptS5cd+wOSeDoYZ/0s0I94XL1ZSp2N3Fgsbn701OQP8SXjTFQldjo
         3+3bjoHCGxM1XRAzEKlAu5jl6IWwm6YkyqKnAo7CKLxVqF/VK2euEwVc872iv7eFOfwz
         rtfw==
X-Gm-Message-State: AOAM533i7DRFPYXl5vHVwJYIpHuExcly35dO9e+CgurXrUqkKK6XN4pc
        8HRbYcFAJR3+V9JXHpmqgNKo2Q==
X-Google-Smtp-Source: ABdhPJx5miUuYsn/qO3rSuAb1jzPXw7RaKWKRjd2bBzppVypLUjUx4PdgtMAga4y6yQ4W7Srwp1Xgw==
X-Received: by 2002:a17:902:ec88:b0:15e:c17d:b092 with SMTP id x8-20020a170902ec8800b0015ec17db092mr18075607plg.88.1652712684426;
        Mon, 16 May 2022 07:51:24 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id 74-20020a62174d000000b00512ee2f22acsm5531100pfx.97.2022.05.16.07.51.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 07:51:23 -0700 (PDT)
Message-ID: <c9ab0896-b19b-b8b8-cf63-ad437a123270@linaro.org>
Date:   Mon, 16 May 2022 07:51:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 2/2] exfat: check if cluster num is valid
Content-Language: en-US
To:     Sungjong Seo <sj1557.seo@samsung.com>, linkinjeon@kernel.org
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
References: <20220511185909.175110-1-tadeusz.struk@linaro.org>
 <CGME20220511185940epcas1p1e51c30e41ff82ae642f8f949ffa4b189@epcas1p1.samsung.com>
 <20220511185909.175110-2-tadeusz.struk@linaro.org>
 <000101d8686b$56d88750$048995f0$@samsung.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <000101d8686b$56d88750$048995f0$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/22 07:52, Sungjong Seo wrote:
>> Syzbot reported slab-out-of-bounds read in exfat_clear_bitmap.
>> This was triggered by reproducer calling truncute with size 0, which
>> causes the following trace:
>>
>> BUG: KASAN: slab-out-of-bounds in exfat_clear_bitmap+0x147/0x490
>> fs/exfat/balloc.c:174 Read of size 8 at addr ffff888115aa9508 by task syz-
>> executor251/365
>>
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]  dump_stack_lvl+0x1e2/0x24b
>> lib/dump_stack.c:118
>>   print_address_description+0x81/0x3c0 mm/kasan/report.c:233
>> __kasan_report mm/kasan/report.c:419 [inline]
>>   kasan_report+0x1a4/0x1f0 mm/kasan/report.c:436
>>   __asan_report_load8_noabort+0x14/0x20 mm/kasan/report_generic.c:309
>>   exfat_clear_bitmap+0x147/0x490 fs/exfat/balloc.c:174
>>   exfat_free_cluster+0x25a/0x4a0 fs/exfat/fatent.c:181
>>   __exfat_truncate+0x99e/0xe00 fs/exfat/file.c:217
>>   exfat_truncate+0x11b/0x4f0 fs/exfat/file.c:243
>>   exfat_setattr+0xa03/0xd40 fs/exfat/file.c:339
>>   notify_change+0xb76/0xe10 fs/attr.c:336
>>   do_truncate+0x1ea/0x2d0 fs/open.c:65
>>
>> Add checks to validate if cluster number is within valid range in
>> exfat_clear_bitmap() and exfat_set_bitmap()
>>
>> Cc: Namjae Jeon<linkinjeon@kernel.org>
>> Cc: Sungjong Seo<sj1557.seo@samsung.com>
>> Cc:linux-fsdevel@vger.kernel.org
>> Cc:stable@vger.kernel.org
>> Cc:linux-kernel@vger.kernel.org
>>
>> Link:https://protect2.fireeye.com/v1/url?k=24a746d8-45dcec51-24a6cd97-
>> 74fe48600034-8e4653a49a463f3c&q=1&e=0efc824d-6463-4253-9cd7-
>> ce3199dbf513&u=https%3A%2F%2Fsyzkaller.appspot.com%2Fbug%3Fid%3D50381fc738
>> 21ecae743b8cf24b4c9a04776f767c
>> Reported-by:syzbot+a4087e40b9c13aad7892@syzkaller.appspotmail.com
>> Fixes: 1e49a94cf707 ("exfat: add bitmap operations")
>> Signed-off-by: Tadeusz Struk<tadeusz.struk@linaro.org>
> Looks good.
> And it seems that WARN_ON() is no longer needed.

Right. Do you want me to send a follow up patch that drops the WARN_ONs?

> Reviewed-by: Sungjong Seo<sj1557.seo@samsung.com>
> 

Thank you.

-- 
Thanks,
Tadeusz
