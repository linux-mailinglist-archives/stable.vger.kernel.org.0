Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0752B6AFAD6
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 01:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjCHAB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 19:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjCHABs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 19:01:48 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2079AE105
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:01:44 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id y184so10983194oiy.8
        for <stable@vger.kernel.org>; Tue, 07 Mar 2023 16:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678233704;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gp5ksp/tysG8+d5KykH4cu77+0Kh4J8KV752xYRk5No=;
        b=c08INiNViJ8tYRuoNRc6bC2exreDd5cZQxqOTujemRAGZymzjp8mlmmfcj3w4/19k+
         OqUNrM9U1TXrwZ3cLDOJqxTtYpWZmEzUtTregTOFVnkg2JVgR0cGknnAFuOSvuqK+CHL
         bhH3nV4efgkLtzMu5NDir5GJcTWlMcNK7QzzsitPgjjBEhFCEGCCHg5bCY1uoXp/abmn
         xz/u/fZbJAjLe6zrf6Z+dRmpF+mYKa2z9j1gJbFeHPWxmX6lR2+6r9XrNfiYbmgSZKTM
         8UwzCa1n1fVgOcxfpXD/2NHRQRZcg+UFsSUPE5zRawKr8ZTMHgwpsWZtPGw1KY5G4y3x
         fswQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678233704;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gp5ksp/tysG8+d5KykH4cu77+0Kh4J8KV752xYRk5No=;
        b=3IrJns81t4T54UnozjDkI0g/isrZeplbfbkEm+/tMZPMBsItSo8ntZiUtB4nV1g2Lv
         TNyHet/TOPmZ+oS7MeE1s2QItb7QyjTxLCOJa5vyPXcf6IM+avCFyv81LDp2lWqRGVlL
         B2E7lAwsKD5PHUomB9UNItGFUJ1nfvvDNsZKKdiIY3RwTLUoJqtc9qL3jgUP3CvQA+82
         Fzqs47R1ckbyLqOhjR6hqiG26YYEkv7WTWy9FoMm2fRiyjWC7Ov1tH/GGCMTdINBIuJE
         j5HetKAa77tK2V6jSK9Ln0RN8r/6gHrv1D4GeppK71o3KkYCcqCDK/5M8XwXn6L40z75
         tgxQ==
X-Gm-Message-State: AO0yUKVNGicnwdbpz7dwnntFeGyotrxOCnXjJM6P4Atc4HuyVPEeppXe
        frxBLeYI1oavb0ML/jX7at0Tgg==
X-Google-Smtp-Source: AK7set86bb7gNMGeM3o1zRl3Vl4jsax9tlj4FdaQC216JIcwhuFq8FUYTFWGQvOSkvU/29O0HZRYMA==
X-Received: by 2002:a05:6808:274e:b0:37f:acd5:20ff with SMTP id eh14-20020a056808274e00b0037facd520ffmr6409040oib.43.1678233703945;
        Tue, 07 Mar 2023 16:01:43 -0800 (PST)
Received: from [192.168.17.16] ([189.219.75.19])
        by smtp.gmail.com with ESMTPSA id n4-20020acaef04000000b00383b8011881sm5763332oih.18.2023.03.07.16.01.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 16:01:43 -0800 (PST)
Message-ID: <81cd2720-0414-1213-3826-31bd240d5c75@linaro.org>
Date:   Tue, 7 Mar 2023 18:01:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.2 0000/1001] 6.2.3-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, pali@kernel.org,
        christophe.leroy@csgroup.eu, mpe@ellerman.id.au
References: <20230307170022.094103862@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 07/03/23 10:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1001 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Mar 2023 16:57:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We see a regression with PowerPC's ppc64e_defconfig, using GCC 8 and GCC 12:
-----8<-----
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crt0.o] Error 1
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crtsavres.o] Error 1
powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/cuboot.o] Error 1
[...]
make[2]: Target 'arch/powerpc/boot/zImage' not remade because of errors.
make[1]: *** [/builds/linux/arch/powerpc/Makefile:247: zImage] Error 2
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:242: __sub-make] Error 2
make: Target '__all' not remade because of errors.
----->8-----

Bisection points to "powerpc/boot: Don't always pass -mcpu=powerpc when building 32-bit uImage" (upstream ff7c76f66d8bad4e694c264c789249e1d3a8205d).

Reproducer:
   tuxmake \
     --runtime podman \
     --target-arch powerpc \
     --toolchain gcc-8 \
     --kconfig ppc64e_defconfig \
     config debugkernel dtbs kernel modules xipkernel

Greetings!

Daniel Díaz
daniel.diaz@linaro.org


