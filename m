Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C2A49AC3B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 07:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiAYGST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 01:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S254362AbiAYFOF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 00:14:05 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701E9C068089
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 19:39:08 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id q186so28790589oih.8
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 19:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=Oy9GFdQG+i/uy7nSZPfjNKex4OropmmdyXnqD6sHR7Q=;
        b=Sr0MTFPKvLlYp1aCMiVa+wOnlhnvuGkKRot55/T5nlLy4fqG+mNDGW8e0qZCJkoGdJ
         knYSq02ywWQ3VHX0t5grRit4Cjl26lMLUQPuRI3Zjvt1omCrTjPRHN/6QQPSkTVRdiOM
         K9Ypb5BEaOSl8ZE5fq7a3zgp5YHtmYWZYlwvaZnBKL4wMRIqjSNXb+y7lYdFAsLZt6O7
         gVMxaFT4JPaQUThOJjtwPn4fFv8o9fQGjVRXLdJ77RO0Ymc+Jyr19L5QrcMs6sgSnC0D
         Fps8n1PrBwYUkJcTyDci4PdbXtYc7b5y4/2IlmwkIcAD5dwXs160NU3mwqDcH181LHLz
         nsYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=Oy9GFdQG+i/uy7nSZPfjNKex4OropmmdyXnqD6sHR7Q=;
        b=GCvLR1GvFoseirVYnsUsG8o5RJIYTtagrnhifszMQPhdtGiuPbjBkNzJSKnA7RblsF
         +yVAtc0KcPv08hoxS9CVbTazOKx5RoLAwyq64vg4WQ1LY9ji1AVD7WcYLRwKnl/G641j
         zxx6PbmYrplgDs1RM5F+sn0+jsrr/5A+VAEWBDm3B2BRvIv+qbyLyWj5bDeRqxt/eCpz
         hlpZf5fJLaKndmTgrqRMTod1PLEHFPFynK45rNaXppwOL73vEaBitUSAua6wfmYYoXyX
         +MZq27DaFpvykFN5+hzomrfFndfWMzAWCFyCjWYS+NO5jvrBfwFLIXZ/HlTKKY/GnZhY
         Ij1w==
X-Gm-Message-State: AOAM5317UllqKMdraaTSFHNROPhjYxUDgmXP4ASplWbU+wugVg9D04EL
        TvcneN0EzPJT8qUzslGx1pP/Hg==
X-Google-Smtp-Source: ABdhPJyto1uQdv7ys+altyklBUbZNp6mhQQCGnrZM9FFHj3jlaxdl3P7sk5GXa6ZtjUz+Qf/ENUfdQ==
X-Received: by 2002:aca:1c16:: with SMTP id c22mr3931833oic.83.1643081947335;
        Mon, 24 Jan 2022 19:39:07 -0800 (PST)
Received: from [192.168.17.16] ([189.219.72.83])
        by smtp.gmail.com with ESMTPSA id l16sm5141685oop.45.2022.01.24.19.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 19:39:06 -0800 (PST)
Message-ID: <ef6a4bcf-832b-3a5d-9643-827239293772@linaro.org>
Date:   Mon, 24 Jan 2022 21:39:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.15 000/846] 5.15.17-rc1 review
Content-Language: en-US
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
References: <20220124184100.867127425@linuxfoundation.org>
 <374e9357-35eb-3555-3fe5-7b72c3a77a39@linaro.org>
In-Reply-To: <374e9357-35eb-3555-3fe5-7b72c3a77a39@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 1/24/22 16:50, Daniel Díaz wrote:
> Hello!
> 
> On 1/24/22 12:31, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.17 release.
>> There are 846 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.17-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Regressions detected on arm, arm64, i386, x86.
> 
> This is one from arm64:
>    /builds/linux/arch/arm64/mm/extable.c: In function 'fixup_exception':
>    /builds/linux/arch/arm64/mm/extable.c:17:13: error: implicit declaration of function 'in_bpf_jit' [-Werror=implicit-function-declaration]
>       17 |         if (in_bpf_jit(regs))
>          |             ^~~~~~~~~~
>    cc1: some warnings being treated as errors
>    make[3]: *** [/builds/linux/scripts/Makefile.build:277: arch/arm64/mm/extable.o] Error 1

Bisection here pointed to "arm64/bpf: Remove 128MB limit for BPF JIT programs". Reverting made the build succeed.

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

