Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65E14D39EC
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 20:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbiCITTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233951AbiCITTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:19:30 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062491168F4
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 11:18:26 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id w3-20020a4ac183000000b0031d806bbd7eso4029972oop.13
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 11:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=RTkHcVtz6Xj+gST8HDWpAZrHsZcT5ReHhL3eO1pEfMs=;
        b=z4Oq8hg5oMUC/28l4I7mskqErza640vBkufG2k65W2hvzZ7DIoDp3bIAvrMNmm5Cv/
         slGBQW64NT9dnHPHly3gphqYVHfaBpsn9o/EKnAcayNpZtN4V09r5V5ibuQlNIY062YR
         KoAEffvGuuHIF/I/Kk3owWwANF2DW1ZrB191OuewOirfI/0ZxbxFx0QJPEQx7rM5Znpz
         H7eVzsNkZ1+wWexOG7Kfq79Kjk7H1FmFlm3XlENVb5KqGjlLodYVRh8RG0FwRKnwlEFu
         HiUmlfblpD1d7oViQwfrKtwcg6N35SKPVQE2Npbpskwei4/bvTnzpI4WxHR4lyCuW5ZF
         idBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=RTkHcVtz6Xj+gST8HDWpAZrHsZcT5ReHhL3eO1pEfMs=;
        b=kKP+t1BUEbWIfZo4JvSV6+R5ujHBxrcqvTYCdj4SPES1NvduEwW04xoFhIAvQTaKKl
         sOzdJikkG9DJe8n9e56AEi2h91qkhuPuEdjvf6EW6mzb4vvMHdVBuuElzahUxbJRTBA/
         QLYCe++K8CvP03mZuqj7i+US+M4JdCTMUfhAZNF8pEIJn83wmkpZhgyW/N4lWlQwYx7b
         XVANHtTY8AZO3Osuv0x8RMFY/TPJb1khbRNV2ctWsWe+idEepTiusqBQ0Q1uIQ7Px89V
         4/PeOBXCmBO25emNXGizoLs3SZfoxKb8FW9zHTCX/Ha9OtxJeAimZ8Mht0Kqysm53/Ua
         nR7g==
X-Gm-Message-State: AOAM533QvZNiFDnAsB38Mm4QblvgU7AmcS/ij70uIkMlJFNndgQwqX4T
        l2QjS9pNfHFUhK6DhdNOfdw86w==
X-Google-Smtp-Source: ABdhPJzDE/5CGA3LZQsgx1FDGKFVh6iantpGNAhQgr1CqxPTN17zW+Uucq3WVOE6mYNTtMFU5jp3nQ==
X-Received: by 2002:a4a:907:0:b0:320:f948:a8dc with SMTP id 7-20020a4a0907000000b00320f948a8dcmr591034ooa.61.1646853505295;
        Wed, 09 Mar 2022 11:18:25 -0800 (PST)
Received: from [192.168.17.16] ([189.219.74.147])
        by smtp.gmail.com with ESMTPSA id m21-20020a056820051500b0031d0841b87esm1403489ooj.34.2022.03.09.11.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 11:18:24 -0800 (PST)
Message-ID: <322280c2-8673-949c-ffd4-4e804a030b89@linaro.org>
Date:   Wed, 9 Mar 2022 13:18:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.9 00/24] 4.9.306-rc1 review
Content-Language: en-US
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220309155856.295480966@linuxfoundation.org>
 <2f501345-e847-668e-7ca3-23af49b69224@linaro.org>
In-Reply-To: <2f501345-e847-668e-7ca3-23af49b69224@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 09/03/22 12:40, Daniel Díaz wrote:
> Hello!
> 
> On 09/03/22 09:59, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.9.306 release.
>> There are 24 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.306-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Regressions found.
> 
> The following Arm combinations fail to build:
> - arm-gcc-8-bcm2835_defconfig
> - arm-gcc-8-imx_v6_v7_defconfig
> - arm-gcc-8-omap2plus_defconfig
> - arm-gcc-9-bcm2835_defconfig
> - arm-gcc-9-imx_v6_v7_defconfig
> - arm-gcc-9-omap2plus_defconfig
> - arm-gcc-10-bcm2835_defconfig
> - arm-gcc-10-imx_v6_v7_defconfig
> - arm-gcc-10-omap2plus_defconfig
> - arm-gcc-11-bcm2835_defconfig
> - arm-gcc-11-imx_v6_v7_defconfig
> - arm-gcc-11-omap2plus_defconfig
> 
> Messages look like this:
> 
>    /builds/linux/arch/arm/kernel/entry-common.S: Assembler messages:
>    /builds/linux/arch/arm/kernel/entry-common.S:155: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-common.S:164: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[2]: *** [/builds/linux/scripts/Makefile.build:407: arch/arm/kernel/entry-common.o] Error 1
>    /builds/linux/arch/arm/kernel/entry-armv.S: Assembler messages:
>    /builds/linux/arch/arm/kernel/entry-armv.S:1124: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-armv.S:1147: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-armv.S:1170: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-armv.S:1193: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/kernel/entry-armv.S:1232: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[2]: *** [/builds/linux/scripts/Makefile.build:407: arch/arm/kernel/entry-armv.o] Error 1
>    /builds/linux/arch/arm/mm/cache-v7.S: Assembler messages:
>    /builds/linux/arch/arm/mm/cache-v7.S:63: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/cache-v7.S:136: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/cache-v7.S:170: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/cache-v7.S:298: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[2]: *** [/builds/linux/scripts/Makefile.build:407: arch/arm/mm/cache-v7.o] Error 1
>    /builds/linux/arch/arm/mm/tlb-v7.S: Assembler messages:
>    /builds/linux/arch/arm/mm/tlb-v7.S:88: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[2]: *** [/builds/linux/scripts/Makefile.build:407: arch/arm/mm/tlb-v7.o] Error 1
>    /builds/linux/arch/arm/mm/proc-v7-2level.S: Assembler messages:
>    /builds/linux/arch/arm/mm/proc-v7-2level.S:58: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/proc-v7-2level.S:60: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    /builds/linux/arch/arm/mm/proc-v7.S:61: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
>    make[2]: *** [/builds/linux/scripts/Makefile.build:407: arch/arm/mm/proc-v7.o] Error 1
>    make[2]: Target '__build' not remade because of errors.

Here's what the bisection throws for this one:

# bad: [2ef7c55895217efa8183111969710960a529d3cd] Linux 4.9.306-rc1
# good: [41b13534ea8aa554d4e987650e24da5510258752] ARM: use LOADADDR() to get load address of sections
git bisect start '2ef7c55895217efa8183111969710960a529d3cd' '41b13534ea8aa554d4e987650e24da5510258752'
# bad: [fd723e642aacb60567beda736ebb062db44b8349] ARM: include unprivileged BPF status in Spectre V2 reporting
git bisect bad fd723e642aacb60567beda736ebb062db44b8349
# bad: [d0002ea56072220ddab72bb6e31a32350c01b44e] ARM: Spectre-BHB workaround
git bisect bad d0002ea56072220ddab72bb6e31a32350c01b44e
# first bad commit: [d0002ea56072220ddab72bb6e31a32350c01b44e] ARM: Spectre-BHB workaround
commit d0002ea56072220ddab72bb6e31a32350c01b44e
Author: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Date:   Thu Feb 10 16:05:45 2022 +0000
     ARM: Spectre-BHB workaround
     
     comomit b9baf5c8c5c356757f4f9d8180b5e9d234065bc3 upstream.
     
     Workaround the Spectre BHB issues for Cortex-A15, Cortex-A57,
     Cortex-A72, Cortex-A73 and Cortex-A75. We also include Brahma B15 as
     well to be safe, which is affected by Spectre V2 in the same ways as
     Cortex-A15.
     
     Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
     Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
     [changes due to lack of SYSTEM_FREEING_INITMEM - gregkh]
     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
  arch/arm/include/asm/assembler.h  | 10 +++++
  arch/arm/include/asm/spectre.h    |  4 ++
  arch/arm/kernel/entry-armv.S      | 79 ++++++++++++++++++++++++++++++++++++---
  arch/arm/kernel/entry-common.S    | 24 ++++++++++++
  arch/arm/kernel/spectre.c         |  4 ++
  arch/arm/kernel/traps.c           | 38 +++++++++++++++++++
  arch/arm/kernel/vmlinux-xip.lds.S | 18 +++++++--
  arch/arm/kernel/vmlinux.lds.S     | 18 +++++++--
  arch/arm/mm/Kconfig               | 10 +++++
  arch/arm/mm/proc-v7-bugs.c        | 76 +++++++++++++++++++++++++++++++++++++
  10 files changed, 269 insertions(+), 12 deletions(-)


Reverting made the build pass.

Greetings!

Daniel Díaz
daniel.diaz@linaro.org
