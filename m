Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981023345A2
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 18:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbhCJRsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 12:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233542AbhCJRsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 12:48:05 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75E1C061760
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 09:48:05 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id 81so18816471iou.11
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 09:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pjhY9oWxqLqIb5ufRBoTvobG2ljtmnnOM6d4fQirr8c=;
        b=vZPceUuDn68WpBRoiQ1Q2dEUjhbJJ9aHA6FfzCTmls8eD0M1QscdzTIHkQGfQAzX9C
         QWT9U1zuDksfaB4HaOSduoJt3g40b7DTzyN0vrPorA+jxz9wQ/h4obNX9UPznS1fpz3T
         yKNCFOLaYw3OtusVKZ0iroINJ05oflR0zDtpUGTLwmaIDafaD+lYCBNvypvHejcM9MII
         A/WQXlfzmAURAC/0YQzyBpHVmDzNHhFraT4zFMF0Emn5eXcqcq4LIw11pcEp+Cfpvbj/
         y5rHmNenLuA1Vzzmw0/g8LeAYKo3JmW2JueFmgaxr482b+dENHYocHPcnW4PYukypanS
         7VxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pjhY9oWxqLqIb5ufRBoTvobG2ljtmnnOM6d4fQirr8c=;
        b=L9/AVVxtCdVpS66mFp9Dxc0j3r9f7irXzLkpqSLE6+hF9JK3F4Q95AUa35nGvy3kl2
         WCe4PmUcXoCNjYiLpOaKYRi6SrWIAbzgdhOE357mv0s83csSutghn1gzamkHggC7PfCs
         WQ240nZXyGRa8AKXNGQizBIB2en94z89FIk+X6jis3fjwq9uGtU3f3kwqC4mQpPR9jsZ
         lpJZup0i8gAXP7nKR+qsVfroJT1Qoe4YiwAi/1GCVvnMQrgbbRtTZlGPqS/1q0+Rezay
         +oqyQco4hDAljZBbL9+AVsgYEK5dw4ghjbS3jUDujLLPIwmvgOMMCdip6kYYQMlBpclo
         JvXw==
X-Gm-Message-State: AOAM5327Ja6nGjIO3O/KPNZisveWywKazygYOqzJWHQBay/elsP6ChDZ
        IHENhTz8w1gfaxEMjErLiJ6rgQ==
X-Google-Smtp-Source: ABdhPJwPIjxdeFmd179IQqcFgl6sf8KYeOUkM67gX0Ij6062UpwuhOyLwgftQvxIgMlyjJOJSuPthg==
X-Received: by 2002:a05:6602:15cd:: with SMTP id f13mr3210274iow.173.1615398485006;
        Wed, 10 Mar 2021 09:48:05 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id s9sm122455iob.33.2021.03.10.09.48.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 09:48:04 -0800 (PST)
Subject: Re: [PATCH 5.10 14/49] net: ipa: ignore CHANNEL_NOT_RUNNING errors
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>, lkft-triage@lists.linaro.org
References: <20210310132321.948258062@linuxfoundation.org>
 <20210310132322.413240905@linuxfoundation.org>
 <CA+G9fYthEr7TtFBpAXxQfDtwxCe+qg=bbE74nPQ+mpGmSSJ2dw@mail.gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <a1d30ddd-2c2e-325b-f401-2e8461abba25@linaro.org>
Date:   Wed, 10 Mar 2021 11:48:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CA+G9fYthEr7TtFBpAXxQfDtwxCe+qg=bbE74nPQ+mpGmSSJ2dw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/21 11:36 AM, Naresh Kamboju wrote:
> On Wed, 10 Mar 2021 at 18:56, <gregkh@linuxfoundation.org> wrote:
>>
>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> From: Alex Elder <elder@linaro.org>
>>
>> [ Upstream commit f849afcc8c3b27d7b50827e95b60557f24184df0 ]

Upstream commit f849afcc8c3b27d7b5 is described as:
   v5.10-rc4-1094-gf849afcc8c3b2
Is this being "back-ported" to v5.10 stable?

Maybe I'm confused.

					-Alex

>> IPA v4.2 has a hardware quirk that requires the AP to allocate GSI
>> channels for the modem to use.  It is recommended that these modem
>> channels get stopped (with a HALT generic command) by the AP when
>> its IPA driver gets removed.
>>
>> The AP has no way of knowing the current state of a modem channel.
>> So when the IPA driver issues a HALT command it's possible the
>> channel is not running, and in that case we get an error indication.
>> This error simply means we didn't need to stop the channel, so we
>> can ignore it.
>>
>> This patch adds an explanation for this situation, and arranges for
>> this condition to *not* report an error message.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   drivers/net/ipa/gsi.c | 24 +++++++++++++++++++++++-
>>   1 file changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
>> index 2a65efd3e8da..48ee43b89fec 100644
>> --- a/drivers/net/ipa/gsi.c
>> +++ b/drivers/net/ipa/gsi.c
>> @@ -1052,10 +1052,32 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
>>          u32 result;
>>          u32 val;
>>
>> +       /* This interrupt is used to handle completions of the two GENERIC
>> +        * GSI commands.  We use these to allocate and halt channels on
>> +        * the modem's behalf due to a hardware quirk on IPA v4.2.  Once
>> +        * allocated, the modem "owns" these channels, and as a result we
>> +        * have no way of knowing the channel's state at any given time.
>> +        *
>> +        * It is recommended that we halt the modem channels we allocated
>> +        * when shutting down, but it's possible the channel isn't running
>> +        * at the time we issue the HALT command.  We'll get an error in
>> +        * that case, but it's harmless (the channel is already halted).
>> +        *
>> +        * For this reason, we silently ignore a CHANNEL_NOT_RUNNING error
>> +        * if we receive it.
>> +        */
>>          val = ioread32(gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
>>          result = u32_get_bits(val, GENERIC_EE_RESULT_FMASK);
>> -       if (result != GENERIC_EE_SUCCESS_FVAL)
>> +
>> +       switch (result) {
>> +       case GENERIC_EE_SUCCESS_FVAL:
>> +       case GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL:
> 
> 
> While building stable rc 5.10 for arm64 the build failed due to
> the following errors / warnings.
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> clang'
> drivers/net/ipa/gsi.c:1074:7: error: use of undeclared identifier
> 'GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL'
>          case GENERIC_EE_CHANNEL_NOT_RUNNING_FVAL:
>               ^
> 1 error generated.
> make[4]: *** [scripts/Makefile.build:279: drivers/net/ipa/gsi.o] Error 1
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log link,
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1086862412#L210
> 

