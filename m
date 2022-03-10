Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1C64D3FB7
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 04:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbiCJDdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 22:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbiCJDdI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 22:33:08 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B6812A74A;
        Wed,  9 Mar 2022 19:32:07 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id bx5so4076151pjb.3;
        Wed, 09 Mar 2022 19:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uEzfYKrkUiSUZiLxkjKmRqHqrldmDcpf9Ohtn+jgtVY=;
        b=cSOybwmq5y5t+94vF1tCdcr3lug3rZb9g1rhlydm45rPe4RuidLuzzPx0XNvYAQz9w
         hFMROK/CqhBwPUbl/sL0zNZoHRuscTkQYnpJh61f9+kxLcHv0ufd6/eQKVPP1cyKdBvy
         1Q35T28dtj25LS5xNhVf2DmFvfjPQzV7FjqngybXwJhwm4n5ReKX3rmgIqigJty1DoCK
         waaFl4M7F3l/I7nKSqBJo/GewX3cvzsIccqkm1xdK23UH70piDgxA3O/gSGnMEI3hwpj
         snIYVHLcG0yQTBB4bbm6GyDuONL677KBhcKNCXYVBZ+GEzvwYeT/0KmxsTnpUhJOgzSm
         PjTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uEzfYKrkUiSUZiLxkjKmRqHqrldmDcpf9Ohtn+jgtVY=;
        b=p6jrqVeCHbSFl8eD7wlVKLiN1u8MTRapHiem8DDSXIurvbdv0zq4rOdyhMuBasKOHF
         6iy8IKhkfjU6nUpy79e+uqrH1ZwodtYlkvWRmYf8uxPJm60lzuKe6qox+o5zpnRu0ZrT
         PlOAihac4nSNXKr8PYVxsKZepE3s9mCP3L1oG5uLHdRfQhSwqiMTCrs9+f6vbFSZm7zp
         lBOLxp6ygLD5228o5PZFtIeRGAX3ips26xYSBVjJqNID0gn9PqmjN0O+cfJ5R080WIgG
         ZArosh08/wQ0mvu7VWU7sQPWEmrxpLyKxSMzhWbEV2QcTjUhXTiSkys5qFXY2rCDczSy
         95mQ==
X-Gm-Message-State: AOAM532hQg1W2PQStq6HZ4Zb250Ra9GzVpp8nM5tXo36BDTmXuT0sjxS
        xK8MLrYgtoZ+SaNSufOh+D8=
X-Google-Smtp-Source: ABdhPJzBDQ9gtOyl14AR9UAFm8wMwkyg8Cv6ntMvo+TAGMn7OBXfNQ9/wQRwf1TAc4Cn9f0Hvf5wjg==
X-Received: by 2002:a17:902:ea0e:b0:152:7cf:1b8a with SMTP id s14-20020a170902ea0e00b0015207cf1b8amr3114128plg.4.1646883127242;
        Wed, 09 Mar 2022 19:32:07 -0800 (PST)
Received: from [10.230.24.186] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id z18-20020aa78892000000b004e19bd62d8bsm4890868pfe.23.2022.03.09.19.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 19:32:06 -0800 (PST)
Message-ID: <917e2fb6-d91a-8ef6-62c0-920271ca2cd4@gmail.com>
Date:   Wed, 9 Mar 2022 19:32:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 4.9 00/24] 4.9.306-rc1 review
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220309155856.295480966@linuxfoundation.org>
 <2f501345-e847-668e-7ca3-23af49b69224@linaro.org>
 <322280c2-8673-949c-ffd4-4e804a030b89@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <322280c2-8673-949c-ffd4-4e804a030b89@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/9/2022 11:18 AM, Daniel Díaz wrote:
> Hello!
> 
> On 09/03/22 12:40, Daniel Díaz wrote:
>> Hello!
>>
>> On 09/03/22 09:59, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 4.9.306 release.
>>> There are 24 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.306-rc1.gz 
>>>
>>> or in the git tree and branch at:
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>>> linux-4.9.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Regressions found.
>>
>> The following Arm combinations fail to build:
>> - arm-gcc-8-bcm2835_defconfig
>> - arm-gcc-8-imx_v6_v7_defconfig
>> - arm-gcc-8-omap2plus_defconfig
>> - arm-gcc-9-bcm2835_defconfig
>> - arm-gcc-9-imx_v6_v7_defconfig
>> - arm-gcc-9-omap2plus_defconfig
>> - arm-gcc-10-bcm2835_defconfig
>> - arm-gcc-10-imx_v6_v7_defconfig
>> - arm-gcc-10-omap2plus_defconfig
>> - arm-gcc-11-bcm2835_defconfig
>> - arm-gcc-11-imx_v6_v7_defconfig
>> - arm-gcc-11-omap2plus_defconfig
>>
>> Messages look like this:
>>
>>    /builds/linux/arch/arm/kernel/entry-common.S: Assembler messages:
>>    /builds/linux/arch/arm/kernel/entry-common.S:155: Error: 
>> co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>>    /builds/linux/arch/arm/kernel/entry-common.S:164: Error: 
>> co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>>    make[2]: *** [/builds/linux/scripts/Makefile.build:407: 
>> arch/arm/kernel/entry-common.o] Error 1
>>    /builds/linux/arch/arm/kernel/entry-armv.S: Assembler messages:
>>    /builds/linux/arch/arm/kernel/entry-armv.S:1124: Error: 
>> co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>>    /builds/linux/arch/arm/kernel/entry-armv.S:1147: Error: 
>> co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>>    /builds/linux/arch/arm/kernel/entry-armv.S:1170: Error: 
>> co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>>    /builds/linux/arch/arm/kernel/entry-armv.S:1193: Error: 
>> co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>>    /builds/linux/arch/arm/kernel/entry-armv.S:1232: Error: 
>> co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>>    make[2]: *** [/builds/linux/scripts/Makefile.build:407: 
>> arch/arm/kernel/entry-armv.o] Error 1
>>    /builds/linux/arch/arm/mm/cache-v7.S: Assembler messages:
>>    /builds/linux/arch/arm/mm/cache-v7.S:63: Error: co-processor 
>> register expected -- `mcr p15,0,r0,c7,r5,4'
>>    /builds/linux/arch/arm/mm/cache-v7.S:136: Error: co-processor 
>> register expected -- `mcr p15,0,r0,c7,r5,4'
>>    /builds/linux/arch/arm/mm/cache-v7.S:170: Error: co-processor 
>> register expected -- `mcr p15,0,r0,c7,r5,4'
>>    /builds/linux/arch/arm/mm/cache-v7.S:298: Error: co-processor 
>> register expected -- `mcr p15,0,r0,c7,r5,4'
>>    make[2]: *** [/builds/linux/scripts/Makefile.build:407: 
>> arch/arm/mm/cache-v7.o] Error 1
>>    /builds/linux/arch/arm/mm/tlb-v7.S: Assembler messages:
>>    /builds/linux/arch/arm/mm/tlb-v7.S:88: Error: co-processor register 
>> expected -- `mcr p15,0,r0,c7,r5,4'
>>    make[2]: *** [/builds/linux/scripts/Makefile.build:407: 
>> arch/arm/mm/tlb-v7.o] Error 1
>>    /builds/linux/arch/arm/mm/proc-v7-2level.S: Assembler messages:
>>    /builds/linux/arch/arm/mm/proc-v7-2level.S:58: Error: co-processor 
>> register expected -- `mcr p15,0,r0,c7,r5,4'
>>    /builds/linux/arch/arm/mm/proc-v7-2level.S:60: Error: co-processor 
>> register expected -- `mcr p15,0,r0,c7,r5,4'
>>    /builds/linux/arch/arm/mm/proc-v7.S:61: Error: co-processor 
>> register expected -- `mcr p15,0,r0,c7,r5,4'
>>    make[2]: *** [/builds/linux/scripts/Makefile.build:407: 
>> arch/arm/mm/proc-v7.o] Error 1
>>    make[2]: Target '__build' not remade because of errors.
> 
> Here's what the bisection throws for this one:

Here is the fix:

https://lore.kernel.org/linux-arm-kernel/E1nS1fu-00GcNN-24@rmk-PC.armlinux.org.uk/
-- 
Florian
