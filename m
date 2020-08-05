Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE98B23CFBF
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgHETY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgHETYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 15:24:49 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC108C061575;
        Wed,  5 Aug 2020 12:24:49 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id r4so15322318pls.2;
        Wed, 05 Aug 2020 12:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VQk2DE8avolZijFqnOzRkxO7oPadCQ4Zxis6hex09H0=;
        b=DniCM0Sa9c+4Qjv3DCMwExE/k2athsvY2rE9KwrQjDosLNqFaRAU1LK9N43LWlOKSg
         6Uxby3pUoqbkk/cqTpD+kQNTjQ9QXK4bt3B4TVBsg0ErZTNLOJK4eHIxRVvd8qyJlSON
         n3hdoY8rOh4VK5XpojNx/XZ3hH0M1osWoD4BE4PT2rsx3RNZfSy9CUresU3Va4bsn5G9
         dsBRTT9epgWFsFD/JUVDIhAKSla5SkpBSHXc41GlEDyYilLZxrNcNc3f9DcGBhaS6bAy
         pvZg23FzRyZgaxTw4J0GxpaMk1lvxuxebQrXc2bRX4fHnmQBeP6DpU2KRkjt0dYIfJ/8
         uIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VQk2DE8avolZijFqnOzRkxO7oPadCQ4Zxis6hex09H0=;
        b=AEkBHWvSGxKzCopVZQBm8Jx2q14n3xJcJRd8ZpkAc0ogUWjFS1tT4tYp2iKOL/djLc
         s6zHFCdfdKEHytN+hE2X/kAfL+HEFzBkNjD4oRT0pE01gqqx/g0stZLG8gTrOXc58HTV
         myVmOOshle61C4smvGQi4mSQdjTfYiJ1viZrLpxLgkx9dyIJ/LzwL8YSNy+d/ukcpGe/
         qM6eYBmgamR75n2b3c2LVFu+XRSOCJmR8QfNvOz3iNP/CqooJUyIN9E8gj+hX1x2W+Uy
         8R7y9EDynBngTzLlhSricCeb9PHPiVR/XaGFoFsum0GTH8cuTLmugB18zQXNXxFae/u1
         Zo1w==
X-Gm-Message-State: AOAM533Qr+383T3c9FyZhsGGfuoNSK7jG5c/F0N6+MP8vFUWuL8Ivovq
        7NJAvpVLh2kLIxNKSkyWMtI=
X-Google-Smtp-Source: ABdhPJzmj+0EsSkKJcZtqzWECOx71kSHd4uiGRQ0Uh4Loh86usB1DEZU7ReHMtYzl7i9ac9uiEViBg==
X-Received: by 2002:a17:902:9a81:: with SMTP id w1mr4448324plp.186.1596655489178;
        Wed, 05 Aug 2020 12:24:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f3sm4974816pfj.206.2020.08.05.12.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 12:24:48 -0700 (PDT)
Subject: Re: [PATCH 5.7 0/6] 5.7.14-rc1 review
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Zyngier <maz@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20200805153506.978105994@linuxfoundation.org>
 <CA+G9fYv_aX36Kq_RD5dAL_By4AFq=-ZY_qh7VhLG=HJQv5mDzg@mail.gmail.com>
 <71a132bf-5ddb-a97a-9b65-6767fd806ee9@roeck-us.net>
 <CAHk-=wi0WGMs6+Jz6rXbQO4mfzf8LGVc3TwmCdz0OwRtj7GgMQ@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <7e1c9df5-d334-461d-56fc-53625c6ca163@roeck-us.net>
Date:   Wed, 5 Aug 2020 12:24:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wi0WGMs6+Jz6rXbQO4mfzf8LGVc3TwmCdz0OwRtj7GgMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/20 11:37 AM, Linus Torvalds wrote:
> On Wed, Aug 5, 2020 at 11:24 AM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> Same with older versions of gcc. I don't see the problem with the
>> mainline kernel.
> 
>   https://www.youtube.com/watch?v=-b5aW08ivHU
> 
>> I think this is caused by more recursive includes.
>> arch/arm64/include/asm/archrandom.h includes include/linux/random.h
>> which includes arch/arm64/include/asm/archrandom.h to get the definition
>> of arch_get_random_seed_long_early (which it won't get because of
>> the recursion).
>>
>> What I don't really understand is how this works with new versions
>> of gcc.
> 
> Is that the only place it triggers?
> 
> Because the trivial fix would be something like the appended, which is
> the right thing to do anyway.
> 

Correct.

gcc-7.x and older don't support CONFIG_ARM64_PTR_AUTH. Result is that
./arch/arm64/include/asm/pointer_auth.h doesn't include <linux/random.h>
for those compiler versions, which results in the problem.

In the mainline kernel, ./arch/arm64/include/asm/pointer_auth.h
always includes <linux/random.h>, so the problem isn't seen (or, rather,
it is hidden) there.

The problem is caused (exposed) by Marc's commit ("arm64: Workaround
circular dependency in pointer_auth.h"), which makes the include of
linux/random.h conditional.

Guenter

>               Linus
> 
> diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
> index 07c4c8cc4a67..9ded4237e1c1 100644
> --- a/arch/arm64/kernel/kaslr.c
> +++ b/arch/arm64/kernel/kaslr.c
> @@ -11,8 +11,8 @@
>  #include <linux/sched.h>
>  #include <linux/types.h>
>  #include <linux/pgtable.h>
> +#include <linux/random.h>
> 
> -#include <asm/archrandom.h>
>  #include <asm/cacheflush.h>
>  #include <asm/fixmap.h>
>  #include <asm/kernel-pgtable.h>
> 

