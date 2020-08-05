Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B7323CF12
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgHETNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728621AbgHESYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 14:24:25 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F09C061575;
        Wed,  5 Aug 2020 11:24:25 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d19so1415585pgl.10;
        Wed, 05 Aug 2020 11:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sesb+iOajMrkthKitgXHyu1N3R51OJyrL241Xs6whr8=;
        b=chNJhfF7a+/eQFIbz8EN66bcNCKTFuLcvelW5TuPxN4hdyLi7eWIXZZSH2gBrk/JUo
         b7qK0y5fVrx1I1EYXGcnauESoF0La+GysDkT8s1uIo3y0AefGOvNE9c3CjYH65iWeD8/
         GC2VrsbKdQA6yDOO8FWZyncn9nXhB+C4UrlB67IWspLd5mz53EAbuMyPYIdwauunvOv4
         Map3/4Rq1W3FJSXXtqV4lsdkNdrJ/ovYxqQDuHs4tYBmPw/huOgtFJCOoLsnL33uZf32
         RdlUugTIw2kSTrpn6mda882UUKZ4seU/17PpirFgDaf5SV7J1DUZCgIQWhsTT76wGu2Y
         Oq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sesb+iOajMrkthKitgXHyu1N3R51OJyrL241Xs6whr8=;
        b=Yq0z9gABYNsu3F1Q0r2rO6l2ZSo+cF1GjgrLVc7ewUYjT4GnqOCtYueGID0735EwQ4
         CPsdMHQKnp+9IY37xIUEb2CIepPkW03VRKtd33eHBrgdftzJuxHoV0u6oPnWQ71CQ2xB
         x8CZZPCfxFSPl0rszCrKCRfztfdrQyiQSozBLPimsxlQo2bEaNtHsRrjDSBaaDeeaGJC
         xRKzp2mmCWp2rVaMlbHLPV/6n1PhGmWT50LzHPWBPwYKLkspSsfaMksMVdRB6lw2RGpA
         4NFPmdhzNSLEeeO15CYo5E0a1ZpEA5UHbNvVEK5YD9GcB8K7qYyexreT7f3vH6SUhEsm
         z7DQ==
X-Gm-Message-State: AOAM532ScrqlfD3D9oCVguPsgCe7g6saKeIYWtnjVU6MxPBvKhBRA5nT
        7dCHPxdus9LxgTDN2Frent6RhbgA
X-Google-Smtp-Source: ABdhPJwKLNOLC8w3MreF/H6NQ6gI/veJY+Itb1bCqCCkcsYAmS/VSOhslcfnVigCbZHx8w/cv0IZHw==
X-Received: by 2002:a62:1d1:: with SMTP id 200mr4409861pfb.161.1596651865244;
        Wed, 05 Aug 2020 11:24:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l16sm4493848pff.167.2020.08.05.11.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 11:24:24 -0700 (PDT)
Subject: Re: [PATCH 5.7 0/6] 5.7.14-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Zyngier <maz@kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, w@1wt.eu,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20200805153506.978105994@linuxfoundation.org>
 <CA+G9fYv_aX36Kq_RD5dAL_By4AFq=-ZY_qh7VhLG=HJQv5mDzg@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <71a132bf-5ddb-a97a-9b65-6767fd806ee9@roeck-us.net>
Date:   Wed, 5 Aug 2020 11:24:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYv_aX36Kq_RD5dAL_By4AFq=-ZY_qh7VhLG=HJQv5mDzg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/5/20 10:39 AM, Naresh Kamboju wrote:
> On Wed, 5 Aug 2020 at 21:22, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.7.14 release.
>> There are 6 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.14-rc1.gz
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>> -------------
>> Pseudo-Shortlog of commits:
>>
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>     Linux 5.7.14-rc1
>>
>> Marc Zyngier <maz@kernel.org>
>>     arm64: Workaround circular dependency in pointer_auth.h
>>
>> Linus Torvalds <torvalds@linux-foundation.org>
>>     random32: move the pseudo-random 32-bit definitions to prandom.h
>>
>> Linus Torvalds <torvalds@linux-foundation.org>
>>     random32: remove net_rand_state from the latent entropy gcc plugin
>>
>> Willy Tarreau <w@1wt.eu>
>>     random: fix circular include dependency on arm64 after addition of percpu.h
>>
>> Grygorii Strashko <grygorii.strashko@ti.com>
>>     ARM: percpu.h: fix build error
>>
>> Willy Tarreau <w@1wt.eu>
>>     random32: update the net random state on interrupt and activity
>>
> 
> [ sorry if it is not interesting ! ]
> 
> While building with old gcc-7.3.0 the build breaks for arm64
> whereas build PASS on gcc-8, gcc-9 and gcc-10.
> 
> with gcc 7.3.0 build breaks log,
> 
Same with older versions of gcc. I don't see the problem with the
mainline kernel.

I think this is caused by more recursive includes.
arch/arm64/include/asm/archrandom.h includes include/linux/random.h
which includes arch/arm64/include/asm/archrandom.h to get the definition
of arch_get_random_seed_long_early (which it won't get because of
the recursion).

What I don't really understand is how this works with new versions
of gcc.

Guenter

> In file included from arch/arm64/include/asm/archrandom.h:9:0,
>                  from arch/arm64/kernel/kaslr.c:14:
> include/linux/random.h: In function 'arch_get_random_seed_long_early':
> include/linux/random.h:149:9: error: implicit declaration of function
> 'arch_get_random_seed_long'; did you mean
> 'arch_get_random_seed_long_early'?
> [-Werror=implicit-function-declaration]
>   return arch_get_random_seed_long(v);
>          ^~~~~~~~~~~~~~~~~~~~~~~~~
>          arch_get_random_seed_long_early
> include/linux/random.h: In function 'arch_get_random_long_early':
> include/linux/random.h:157:9: error: implicit declaration of function
> 'arch_get_random_long'; did you mean 'get_random_long'?
> [-Werror=implicit-function-declaration]
>   return arch_get_random_long(v);
>          ^~~~~~~~~~~~~~~~~~~~
>          get_random_long
> In file included from arch/arm64/kernel/kaslr.c:14:0:
> arch/arm64/include/asm/archrandom.h: At top level:
> arch/arm64/include/asm/archrandom.h:30:33: error: conflicting types
> for 'arch_get_random_long'
>  static inline bool __must_check arch_get_random_long(unsigned long *v)
>                                  ^~~~~~~~~~~~~~~~~~~~
> In file included from arch/arm64/include/asm/archrandom.h:9:0,
>                  from arch/arm64/kernel/kaslr.c:14:
> include/linux/random.h:157:9: note: previous implicit declaration of
> 'arch_get_random_long' was here
>   return arch_get_random_long(v);
>          ^~~~~~~~~~~~~~~~~~~~
> In file included from arch/arm64/kernel/kaslr.c:14:0:
> arch/arm64/include/asm/archrandom.h:40:33: error: conflicting types
> for 'arch_get_random_seed_long'
>  static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
>                                  ^~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from arch/arm64/include/asm/archrandom.h:9:0,
>                  from arch/arm64/kernel/kaslr.c:14:
> include/linux/random.h:149:9: note: previous implicit declaration of
> 'arch_get_random_seed_long' was here
>   return arch_get_random_seed_long(v);
>          ^~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from arch/arm64/kernel/kaslr.c:14:0:
> arch/arm64/include/asm/archrandom.h:72:1: error: redefinition of
> 'arch_get_random_seed_long_early'
>  arch_get_random_seed_long_early(unsigned long *v)
>  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from arch/arm64/include/asm/archrandom.h:9:0,
>                  from arch/arm64/kernel/kaslr.c:14:
> include/linux/random.h:146:27: note: previous definition of
> 'arch_get_random_seed_long_early' was here
>  static inline bool __init arch_get_random_seed_long_early(unsigned long *v)
> 
> 

