Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5684D3905
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 19:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbiCISlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 13:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbiCISlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 13:41:22 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403AB1704FD
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 10:40:23 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id s35-20020a0568302aa300b005b2463a41faso2380107otu.10
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 10:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kUWAaoT3ile08MI4chxnqERo8GG6w/0gzaDEsvRM250=;
        b=OAtGSbEHa44wYcUZNP4X5WlWqTJdMp/QLLWd4Y+5Red4qDKQCfr/PvpGZyZW8Qhdn8
         sTJN9B1fyCctJwMWdfrjgoVQ+q+4nF9C68x5ES4PHFJbmWbWC01u1aIao42ZQ9wezhfV
         t/3Dp8s+HLk/2Q0KVeAXHD+jzDaX5XS7DHAjwnev8Mp/a+EbYPemZhQVR+uX1W/L+UOK
         kLSqrsbOmgFEIeietZjd8MT+FJ0ylqou1ivsc+TxDi9KrWPF4OLJZy4tvQmLhMXy4JIy
         BWCQOD6oPdaMQCKEUJtfYup4LCcoKawZSSXjL6nByruIj9fO8iDvu1OsVpVAo0kGEghM
         VsMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kUWAaoT3ile08MI4chxnqERo8GG6w/0gzaDEsvRM250=;
        b=NMVEiLIVHHGml7molGjbwMYq/cMPC9tTbJbdaSkrSkNSwmk9kNZjHHgdsYVi2ukvbj
         crYqolKC6eq5z7T+WIcjxSODooSOB0/rcMYy62ZMux6c9GmK4Yt3P7RWi7J/q6yhZAQ/
         HgC3JoASUr2gS9sQaCqA0RI1YVClf0du4t5WNEsQEUZevryt7/okembaKWAy7fAMhhi4
         C5fPIx8UmiNR4HMbWlPs1VlKEvaCOtYwxt3B6wWfniZ2Eh7itLdvuJX3D9vQP5n0Duxc
         6RzJon5LO4Z1hht2+ID0ypfFBbBihCfWlcxaizhP+cOIxzDrMU65gtyfX3mBfVf8UUsJ
         tPbQ==
X-Gm-Message-State: AOAM532qmnXi8wMFjDAzdhbhlOYEZnYpGWTyVt4NbN2Oc0vYqR+QKTeD
        2jL2quhNYO1WTqNBQhdb3/cUzQ==
X-Google-Smtp-Source: ABdhPJxjObLvRuZOU7BRvitvzfk0dqdAW7F+75UgxDZLmYDD0uEn1qyhVVBAlB5Xj1t+KlzyWXbeVQ==
X-Received: by 2002:a05:6830:314c:b0:5af:dc8a:d066 with SMTP id c12-20020a056830314c00b005afdc8ad066mr604467ots.28.1646851222563;
        Wed, 09 Mar 2022 10:40:22 -0800 (PST)
Received: from [192.168.17.16] ([189.219.74.147])
        by smtp.gmail.com with ESMTPSA id r23-20020a056830237700b005b2610517c8sm1318483oth.56.2022.03.09.10.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 10:40:22 -0800 (PST)
Message-ID: <2f501345-e847-668e-7ca3-23af49b69224@linaro.org>
Date:   Wed, 9 Mar 2022 12:40:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 4.9 00/24] 4.9.306-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220309155856.295480966@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220309155856.295480966@linuxfoundation.org>
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

On 09/03/22 09:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.306 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.306-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Regressions found.

The following Arm combinations fail to build:
- arm-gcc-8-bcm2835_defconfig
- arm-gcc-8-imx_v6_v7_defconfig
- arm-gcc-8-omap2plus_defconfig
- arm-gcc-9-bcm2835_defconfig
- arm-gcc-9-imx_v6_v7_defconfig
- arm-gcc-9-omap2plus_defconfig
- arm-gcc-10-bcm2835_defconfig
- arm-gcc-10-imx_v6_v7_defconfig
- arm-gcc-10-omap2plus_defconfig
- arm-gcc-11-bcm2835_defconfig
- arm-gcc-11-imx_v6_v7_defconfig
- arm-gcc-11-omap2plus_defconfig

Messages look like this:

   /builds/linux/arch/arm/kernel/entry-common.S: Assembler messages:
   /builds/linux/arch/arm/kernel/entry-common.S:155: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-common.S:164: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:407: arch/arm/kernel/entry-common.o] Error 1
   /builds/linux/arch/arm/kernel/entry-armv.S: Assembler messages:
   /builds/linux/arch/arm/kernel/entry-armv.S:1124: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1147: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1170: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1193: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/kernel/entry-armv.S:1232: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:407: arch/arm/kernel/entry-armv.o] Error 1
   /builds/linux/arch/arm/mm/cache-v7.S: Assembler messages:
   /builds/linux/arch/arm/mm/cache-v7.S:63: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:136: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:170: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/cache-v7.S:298: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:407: arch/arm/mm/cache-v7.o] Error 1
   /builds/linux/arch/arm/mm/tlb-v7.S: Assembler messages:
   /builds/linux/arch/arm/mm/tlb-v7.S:88: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:407: arch/arm/mm/tlb-v7.o] Error 1
   /builds/linux/arch/arm/mm/proc-v7-2level.S: Assembler messages:
   /builds/linux/arch/arm/mm/proc-v7-2level.S:58: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/proc-v7-2level.S:60: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   /builds/linux/arch/arm/mm/proc-v7.S:61: Error: co-processor register expected -- `mcr p15,0,r0,c7,r5,4'
   make[2]: *** [/builds/linux/scripts/Makefile.build:407: arch/arm/mm/proc-v7.o] Error 1
   make[2]: Target '__build' not remade because of errors.


Greetings!

Daniel Díaz
daniel.diaz@linaro.org
