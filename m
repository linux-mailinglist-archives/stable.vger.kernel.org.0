Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F55A26536C
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 23:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgIJVeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 17:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730968AbgIJNtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 09:49:45 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E21C061795;
        Thu, 10 Sep 2020 06:47:35 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id d189so5915301oig.12;
        Thu, 10 Sep 2020 06:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mfDlbY7gY4hRLiwC4XEB9WwxJ07KUMv374l5cGr0Et8=;
        b=e+KAOP7dzfcJ2TWuzTweheFwhiAtewKaO/z6qX6xiy2qvPz2R33Aq8KMRlJjNhB6NA
         t7/7/JNvSTNyEIkrXhMykuvx6pE3AVSA3UwoeT+fylozQmXxw3YCthVYmP6YS4PBwB8O
         mT2Ia28yh/TFGSkbQExASZJ9YoGu4cgSGxOI7Jihfw7vO01g3sDWxL72/zGaI4SdylsC
         bnp4NAUCXQsThn6pSeFOVsDb0ZW+yG4RtgsatNfYYri8FS1twbwHF40jYXHvy1wQtymM
         pDwMrvo3gEkV0cDHnccNwvZ+xsIJjUCZVajw5M3JIE74PNoRTmZkeBv8030wwOna39+7
         yO+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mfDlbY7gY4hRLiwC4XEB9WwxJ07KUMv374l5cGr0Et8=;
        b=GofuXsypHn2UXtTU28U9kOBW36998d8ZQ86j68JwvEcdlTMFXjNZdU/F3hu88tRI1Y
         IcZGVFrQ8CliI32J60AiqDx1Ek1sTbOIvaUcwLMD8/1H0XL5rpXIqOhUWzDTxSTreRpe
         kLcpz2I/WQO4CkGVvXBaAXdJuDtmsq4fy9lWBuUAz5kAJEmF2DyKwvvZtGGgVhEXdwKL
         YaOPIpnLMHiCTLcQ4XwpNIcfN9URS4kP36LM2Jlso5gghDOQTVf2TnIOKYDhmMxQkn61
         tmG5cBA72v64fGbo0zV/v+uzYuRbpKiS5QUH9vEZsM6vDVRZzvaxX9fU1z8qK0GVLaqR
         jmJQ==
X-Gm-Message-State: AOAM532X8RsfdUtuO29pWcb8/Q2/NI/OK7uHrsfq428nl74gkH74YgyC
        AM3tdV1HuMsaP7upHAm+NRsJrYHZ6LY=
X-Google-Smtp-Source: ABdhPJwpYIxbrheyPMr2nyJrPxXFwQRL0L78nZK8USAXE10vjLCER6cC1UDbejJJCpkLfcnJoMjuMg==
X-Received: by 2002:aca:d845:: with SMTP id p66mr30509oig.47.1599745654501;
        Thu, 10 Sep 2020 06:47:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n37sm824678ota.20.2020.09.10.06.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 06:47:34 -0700 (PDT)
Subject: Re: [PATCH 5.8 000/186] 5.8.8-rc1 review
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
References: <20200908152241.646390211@linuxfoundation.org>
 <20200909164705.GE1479@roeck-us.net> <20200909180121.GD1003763@kroah.com>
 <5ea4e73b-778d-e742-7ba7-f1cbe0307a0f@roeck-us.net>
 <CAMuHMdXwqC-B-CHQ0zzZ8YY+BDdq6ffqO6j85hsna-PUdwqz_g@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <23b60a5d-1d21-7fd3-a125-29e564d5b753@roeck-us.net>
Date:   Thu, 10 Sep 2020 06:47:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXwqC-B-CHQ0zzZ8YY+BDdq6ffqO6j85hsna-PUdwqz_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/9/20 11:36 PM, Geert Uytterhoeven wrote:
> Hi Günter,
> 
> On Wed, Sep 9, 2020 at 8:24 PM Guenter Roeck <linux@roeck-us.net> wrote:
>> On 9/9/20 11:01 AM, Greg Kroah-Hartman wrote:
>>> On Wed, Sep 09, 2020 at 09:47:05AM -0700, Guenter Roeck wrote:
>>>> On Tue, Sep 08, 2020 at 05:22:22PM +0200, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 5.8.8 release.
>>>>> There are 186 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>
>>>> Build results:
>>>>      total: 154 pass: 153 fail: 1
>>>> Failed builds:
>>>>      powerpc:allmodconfig
>>>> Qemu test results:
>>>>      total: 430 pass: 430 fail: 0
>>>>
>>>> The powerpc problem is the same as before:
>>>>
>>>> Inconsistent kallsyms data
>>>> Try make KALLSYMS_EXTRA_PASS=1 as a workaround
>>>>
>>>> KALLSYMS_EXTRA_PASS=1 doesn't help. The problem is sporadic, elusive, and all
>>>> but impossible to bisect. The same build passes on another system, for example,
>>>> with a different load pattern. It may pass with -j30 and fail with -j40.
>>>> The problem started at some point after v5.8, and got worse over time; by now
>>>> it almost always happens. I'd be happy to debug if there is a means to do it,
>>>> but I don't have an idea where to even start. I'd disable KALLSYMS in my
>>>> test configurations, but the symbol is selected from various places and thus
>>>> difficult to disable. So unless I stop building ppc:allmodconfig entirely
>>>> we'll just have to live with the failure.
>>>
>>> Ah, I was worried when I saw your dashboard orange for this kernel.
>>>
>>> I guess the powerpc maintainers don't care?  Sad :(
>>>
>>
>> Not sure if the powerpc architecture is to blame. Bisect attempts end up
>> all over the place, and don't typically include any powerpc changes.
>> I have no idea how kallsyms is created, but my suspicion is that it is
>> a generic problem and that powerpc just happens to hit it right now.
>> I have added KALLSYMS_EXTRA_PASS=1 to several architecture builds over
>> time, when they reported similar problems. Right now I set it for
>> alpha, arm, and m68k. powerpc just happens to be the first architecture
>> where it doesn't help.
> 
> This is a generic problem, cfr. scripts/link-vmlinux.sh:
> 
>         # kallsyms support
>         # Generate section listing all symbols and add it into vmlinux
>         # It's a three step process:
>         # 1)  Link .tmp_vmlinux1 so it has all symbols and sections,
>         #     but __kallsyms is empty.
>         #     Running kallsyms on that gives us .tmp_kallsyms1.o with
>         #     the right size
>         # 2)  Link .tmp_vmlinux2 so it now has a __kallsyms section of
>         #     the right size, but due to the added section, some
>         #     addresses have shifted.
>         #     From here, we generate a correct .tmp_kallsyms2.o
>         # 3)  That link may have expanded the kernel image enough that
>         #     more linker branch stubs / trampolines had to be added, which
>         #     introduces new names, which further expands kallsyms. Do another
>         #     pass if that is the case. In theory it's possible this results
>         #     in even more stubs, but unlikely.
>         #     KALLSYMS_EXTRA_PASS=1 may also used to debug or work around
>         #     other bugs.
> 
Ah, that explains a lot.

> Adding even more kallsyms_steps may help (or not, if you're really
> unlucky).  Perhaps the number of passes should be handled automatically
> (i.e. run until it succeeds, with a sane (16?) upper limit to avoid
>  endless builds, so it can still fail, in theory).
> 

Turns out it needs four steps. I prepared a patch to try up to 8 steps.
We'll see if it gets accepted.

Thanks,
Guenter
