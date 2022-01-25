Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D9E49ABCB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 06:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiAYFf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 00:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbiAYFdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 00:33:46 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97584C06E01F;
        Mon, 24 Jan 2022 19:55:01 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c9so17905467plg.11;
        Mon, 24 Jan 2022 19:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nnMW+oRu4DVxVHkHPaguOniEjD4jPCA0ZR9hQdtETnc=;
        b=TL9TVAyK+MLuQCyGB3q+JDujoNxa48HahZSSiKFGi856DfVwSMIHz6O/rSgGzJt3+w
         qPFda++lJxb0CWbcSppe9Aq8DxpRj3slu2RBB+Aki14zYXX0qPaC/c3oeZpckDsAZ9Y/
         ei6sddRLsjm5pzEg44lKnvLCtYOaF2UJxLrlz5lGHJekLHogMzO7kEgSEockpTEYL3PP
         ox1VW8fusiGMQeP+mNX6zPqxh8eq1u10nSV1aK6zSoFVaNYJprPAIZB6Q4mAmKg8NGwk
         HuMdMkar0ePyQSoI9Jgx8TCqQqn6dLDnFouYAl0Xr08kWRkyiThEoMS+YeEicLjzzVpq
         KhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nnMW+oRu4DVxVHkHPaguOniEjD4jPCA0ZR9hQdtETnc=;
        b=wZTavnKUKHbf1g/rydP0RX2lYVGGS6Pn18xfughqxYPRwoqyHXrH9f/VxuzXd1rtyA
         fTh1H+7V+T7v6MIgYajPLEAVEEotpd3nJzoZuz7WB5bT+jdts0F/uD3bVqxGZmVBELnL
         UR0TLLJ/MM8gj6exGvo0hQj9iVABPDdMrC5dPIaXUMbWzeu+Hp7uV0BIFcq8zjPsEPtv
         yhv0LHp+G3xYtv23Oqb8H9++sgSsIOLorX4KNWthzTiKResdBYT/a5ufJCBteauWzBXp
         2gtZOIn9eLeUJFKfo2Ww2Grr56J71COEu6y5Yb3ufArFqnCE6KA+2TvwL/DF0H/zYLwi
         sbWg==
X-Gm-Message-State: AOAM533YpqoMDBM2S10OVBU99/imuOeVCTq4dO62XEtckBdijcx+KH6A
        q0x25vWQxO8yVlEx0Hzx8IQ=
X-Google-Smtp-Source: ABdhPJzed9KGNQAqFKexv+5574X1JYThuPt97H/wcHkIGwuoucIUEJSvN0FgsYjnN4o+6z74CMmPPw==
X-Received: by 2002:a17:902:d712:b0:14a:d880:f20 with SMTP id w18-20020a170902d71200b0014ad8800f20mr17460544ply.41.1643082900979;
        Mon, 24 Jan 2022 19:55:00 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s12sm4935544pfk.65.2022.01.24.19.54.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 19:55:00 -0800 (PST)
Message-ID: <67b47645-016c-2d23-4710-b3743b073766@gmail.com>
Date:   Mon, 24 Jan 2022 19:54:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.10 000/563] 5.10.94-rc1 review
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, stable@vger.kernel.org
References: <20220124184024.407936072@linuxfoundation.org>
 <12c8fd1e-431e-9a59-9e7a-e8d856c088b9@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <12c8fd1e-431e-9a59-9e7a-e8d856c088b9@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/24/2022 3:00 PM, Daniel Díaz wrote:
> Hello!
> 
> On 1/24/22 12:36, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.94 release.
>> There are 563 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.94-rc1.gz 
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
> Regressions detected on arm, arm64, i386, x86.
> 
> This is from arm64:
>    /builds/linux/arch/arm64/mm/extable.c: In function 'fixup_exception':
>    /builds/linux/arch/arm64/mm/extable.c:17:13: error: implicit 
> declaration of function 'in_bpf_jit' 
> [-Werror=implicit-function-declaration]
>       17 |         if (in_bpf_jit(regs))
>          |             ^~~~~~~~~~
>    cc1: some warnings being treated as errors
>    make[3]: *** [/builds/linux/scripts/Makefile.build:280: 
> arch/arm64/mm/extable.o] Error 1
> 
> And from Perf on arm, arm64, i386, x86:
>    libbpf.c: In function 'bpf_object__elf_collect':
>    libbpf.c:2873:31: error: invalid type argument of '->' (have 
> 'GElf_Shdr' {aka 'Elf64_Shdr'})
>     2873 |                         if (sh->sh_type != SHT_PROGBITS)
>          |                               ^~
>    libbpf.c:2877:31: error: invalid type argument of '->' (have 
> 'GElf_Shdr' {aka 'Elf64_Shdr'})
>     2877 |                         if (sh->sh_type != SHT_PROGBITS)
>          |                               ^~
>    make[4]: *** [/builds/linux/tools/build/Makefile.build:97: 
> /home/tuxbuild/.cache/tuxmake/builds/current/staticobjs/libbpf.o] Error 1
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Same here.
-- 
Florian
