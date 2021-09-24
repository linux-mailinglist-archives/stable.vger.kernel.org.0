Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34018417DAB
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 00:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345740AbhIXWNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 18:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347788AbhIXWNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 18:13:32 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D4EC061786;
        Fri, 24 Sep 2021 15:11:54 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id k26so5473404pfi.5;
        Fri, 24 Sep 2021 15:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FfH8lhELlbCk3djwYKIHgmWllSZaKRJ0hhr+YDTEAN0=;
        b=I+ISSNCpNMaW1hA4pb8MfQ6EByPDYcTOkA0bLrlSgIx3HNr6A03KI24SJakX/21UrA
         /KWQeC1YvR8/ns2mOGnnVY0jIPpNIBRYXB8HohlgW0mGtcR76s8q39vSeuNLoIw59bFR
         VKEAt8Fq/k/lkI6P2LwDo6urVDeD/v0AK8Mmli/U/hyeTez67+SnyxoLTxmd0DGuueNQ
         Ld87a80NK3LZ7xyuSW12b3eWS5XCGG29Z0rXTD26bd7PMLJcwMuH9+wXHu62If8E1GhN
         2Ticq3HEs3vvGFyxXJvdY0pE0+DRagnEbYPiFq9eR5PW/yRO8xsd+HoW4c/2Vu2EUVPM
         lpkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FfH8lhELlbCk3djwYKIHgmWllSZaKRJ0hhr+YDTEAN0=;
        b=bLtpVeEXKTg1KNhfkcfAmi/kIddbAeDZIkWwjI9sxCd2wiRBvtAz1J4DGXAAcdM4S7
         7lMXAFE9Wsk0QKt2qc3HXMnWcv9rlLdQIuIYorMsfE2QiaLk/FkP/gUeWrzUz4CI4saJ
         tD7btWSABAtVIZc7h/vWhKQjcZgEUgppXaGLKO4wv2HyjubhHtS4VBK03I9XNJxF4PU9
         qnjVxedhm657Kq1TBME45hKT9O5tN0gZNTjPvtJ2s9fBP88tK6arXNarF97vkVV4j5pB
         XuL09ce8PCja8mpckLduY3X77ie5UbB7XC6DDoNN3/GOBoDViDnrusu+IDV7Pxy/PP/1
         dxSQ==
X-Gm-Message-State: AOAM532Ug4AELi8P4ZMDdtPDtcp6bMtNy/2Zynyaw3sddbdpPGrzvVwf
        KvAhZiLbp22CgTL7PyhYPzA=
X-Google-Smtp-Source: ABdhPJyUN2P6h0s4erzCGCMBW+1t1Tb41jqYnjkw7XBmrFL083QnqcBbZoqaeM4aF58FNodFNT6qIA==
X-Received: by 2002:a05:6a00:43:b0:43d:f06e:4f4a with SMTP id i3-20020a056a00004300b0043df06e4f4amr11142400pfk.20.1632521513942;
        Fri, 24 Sep 2021 15:11:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u12sm9952092pjr.2.2021.09.24.15.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 15:11:53 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/63] 5.10.69-rc1 review
To:     =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210924124334.228235870@linuxfoundation.org>
 <c7a38a76-18b0-efaa-efed-f73e53e58277@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c8f6c650-8b6b-cfc2-c9f6-f32fce74aa3d@gmail.com>
Date:   Fri, 24 Sep 2021 15:11:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c7a38a76-18b0-efaa-efed-f73e53e58277@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/24/21 7:12 AM, Daniel Díaz wrote:
> Hello!
> 
> On 9/24/21 7:44 AM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.69 release.
>> There are 63 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.69-rc1.gz
>>
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>> linux-5.10.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Regressions detected.
> 
> While building Perf for arm, arm64, i386 and x86, all with GCC 11, the
> following error was encountered:
> 
>   util/dso.c: In function 'dso__build_id_equal':
>   util/dso.c:1345:26: error: implicit declaration of function
> 'memchr_inv'; did you mean 'memchr'?
> [-Werror=implicit-function-declaration]
>    1345 |                         !memchr_inv(&dso->bid.data[bid->size], 0,
>         |                          ^~~~~~~~~~
>         |                          memchr
>   cc1: all warnings being treated as errors
>   make[4]: *** [/builds/linux/tools/build/Makefile.build:96:
> /home/tuxbuild/.cache/tuxmake/builds/current/util/dso.o] Error 1

Confirmed, with GCC 8.3 the warning is not a fatal error but we will
fail linking eventually anyway:

/local/stbopt_p/toolchains_303/stbgcc-8.3-0.3/bin/../lib/gcc/aarch64-unknown-linux-gnu/8.3.0/../../../../aarch64-unknown-linux-gnu/bin/ld:
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/perf-in.o:
in function `dso__build_id_equal':
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/util/dso.c:1345:
undefined reference to `memchr_inv'
collect2: error: ld returned 1 exit status
make[4]: *** [Makefile.perf:655:
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/perf]
Error 1
make[3]: *** [Makefile.perf:229: sub-make] Error 2
make[2]: *** [Makefile:70: all] Error 2
make[1]: *** [package/pkg-generic.mk:271:
/local/users/fainelli/buildroot/output/arm64/build/linux-tools/.stamp_built]
Error 2
make: *** [Makefile:27: _all] Error 2

-- 
Florian
