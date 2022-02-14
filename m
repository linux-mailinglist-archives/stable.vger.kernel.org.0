Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FF94B4E10
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 12:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350245AbiBNLYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 06:24:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351256AbiBNLYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 06:24:00 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7DB6CA76
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 02:59:56 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id c6so44873856ybk.3
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 02:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tSvkUxAWqaJyF4gpEgS5w4YFZfn9R8g1UyzR4KbX0y8=;
        b=NUPC+F603/mADdiuvtTD8yuUBHvS3mFO/t99+p2ii+I1JrqK+WeB+iLnKCcLgQMAql
         4EnJbqHUSDpGONN29PSMCLf/oXrgUAZXPAwuJt6LR9yRfmO6rspPqEpZllkgjZS4o2as
         hBq2eAR2SKobpeT+Y4ds3LOWup3nHW6tC+vOZFKdAfAluBI5Tos+3pKoreSnnFdbwCPh
         3/K+efGrryiCz0JBmm7Gb5Cbrmu6041PAhlPVhCHvo8NzyjjXHDTkaa2E5WMApUmUYQv
         YxgBV317/0DA52nI9/duIyMBMYoBdqHq+8u+ifdjXe93sg6lRYwO5TBx88DTGZhsUlfU
         OXwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tSvkUxAWqaJyF4gpEgS5w4YFZfn9R8g1UyzR4KbX0y8=;
        b=TG7eJOkvBq0N7Njy6bFSf5bA3ASlALhIIoS8MDtZopggaHxJJZ0SMv2gKpUI94yBxg
         5gswEhylaBU1sAmOB4GSqAB01DBKo9rOWN9C0u8P2gUCJh5dlY5PkWmls+gVKjWbd3QO
         fVYL/My8HWiQcxdanlqkTJPCJGOLQesS534bKqFChYpWRehGneY48lW0Ku597M1Aj5lr
         k4oFiCzmfnAcBKvOd1Z0bu9Lyi4i6NvTlNyzggjMzLgjivN0J6VfQqh3CWnG5mTVnhxc
         8w8aBld4qruh1+sksH4fbKNrpLBWu29ULjJJvm/h9O+/vSqOdvSDlt73xFS3RKVmwOA9
         RaMw==
X-Gm-Message-State: AOAM532UqvkRYPSoMkZpCN38gcXHVdEXnvFHacDFTVTho0Dp6KN3dbGK
        Paz01XX+XQUtUnLojj4v5sk12FWq4ZVy2D4RDy1nwA==
X-Google-Smtp-Source: ABdhPJyn3EB7X/eUQXQ6uJnjqPqie/m6r5EE+EDezLUD9EJJ+dKSm66GD6Mt05vPNLzD/a2FWFEizipzB/6Dhf/2qXY=
X-Received: by 2002:a25:f404:: with SMTP id q4mr11597189ybd.146.1644836395586;
 Mon, 14 Feb 2022 02:59:55 -0800 (PST)
MIME-Version: 1.0
References: <20220214092510.221474733@linuxfoundation.org>
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 14 Feb 2022 16:29:43 +0530
Message-ID: <CA+G9fYvfx2jRPnU6zVK8v9vNbwXc4wV0KX0JfGWeNsAbL72y-g@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/203] 5.16.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Feb 2022 at 15:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.10 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

On Linux mainline master branch with arm64 clang-nigtly build failed
due to following errors and warnings.
Now it is also noticed on stable-rc 5.15 and 5.16.

net/ipv4/tcp_input.c: clang: error: clang frontend command failed with
exit code 139 (use -v to see invocation)
https://github.com/llvm/llvm-project/issues/53811


make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current LLVM=1 LLVM_IAS=1
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
CROSS_COMPILE_COMPAT=arm-linux-gnueabihf- HOSTCC=clang CC=clang
PLEASE submit a bug report to
https://github.com/llvm/llvm-project/issues/ and include the crash
backtrace, preprocessed source, and associated run script.
Stack dump:
0. Program arguments: clang -Wp,-MMD,net/ipv4/.tcp_input.o.d -nostdinc
-I/builds/linux/arch/arm64/include -I./arch/arm64/include/generated
-I/builds/linux/include -I./include
-I/builds/linux/arch/arm64/include/uapi
-I./arch/arm64/include/generated/uapi -I/builds/linux/include/uapi
-I./include/generated/uapi -include
/builds/linux/include/linux/compiler-version.h -include
/builds/linux/include/linux/kconfig.h -include
/builds/linux/include/linux/compiler_types.h -D__KERNEL__
-mlittle-endian -DCC_USING_PATCHABLE_FUNCTION_ENTRY
-DKASAN_SHADOW_SCALE_SHIFT= -Qunused-arguments
-fmacro-prefix-map=/builds/linux/= -Wall -Wundef
-Werror=strict-prototypes -Wno-trigraphs -fno-strict-aliasing
-fno-common -fshort-wchar -fno-PIE
-Werror=implicit-function-declaration -Werror=implicit-int
-Werror=return-type -Wno-format-security -std=gnu89
--target=aarch64-linux-gnu -fintegrated-as
-Werror=unknown-warning-option -Werror=ignored-optimization-argument
-mgeneral-regs-only -DCONFIG_CC_HAS_K_CONSTRAINT=1 -Wno-psabi
-fno-asynchronous-unwind-tables -fno-unwind-tables
-mbranch-protection=pac-ret+leaf+bti -Wa,-march=armv8.5-a
-DARM64_ASM_ARCH=\"armv8.5-a\" -DKASAN_SHADOW_SCALE_SHIFT=
-fno-delete-null-pointer-checks -Wno-frame-address
-Wno-address-of-packed-member -O2 -Wframe-larger-than=2048
-fstack-protector-strong -Wimplicit-fallthrough -Wno-gnu
-mno-global-merge -Wno-unused-but-set-variable
-Wno-unused-const-variable -fno-omit-frame-pointer
-fno-optimize-sibling-calls -ftrivial-auto-var-init=zero
-enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang
-fno-stack-clash-protection -fpatchable-function-entry=2
-Wdeclaration-after-statement -Wvla -Wno-pointer-sign
-Wcast-function-type -Wno-array-bounds -fno-strict-overflow
-fno-stack-check -Werror=date-time -Werror=incompatible-pointer-types
-Wno-initializer-overrides -Wno-format -Wno-sign-compare
-Wno-format-zero-length -Wno-pointer-to-enum-cast
-Wno-tautological-constant-out-of-range-compare -Wno-unaligned-access
-mstack-protector-guard=sysreg -mstack-protector-guard-reg=sp_el0
-mstack-protector-guard-offset=1408 -I /builds/linux/net/ipv4 -I
./net/ipv4 -DKBUILD_MODFILE=\"net/ipv4/tcp_input\"
-DKBUILD_BASENAME=\"tcp_input\" -DKBUILD_MODNAME=\"tcp_input\"
-D__KBUILD_MODNAME=kmod_tcp_input -c -o net/ipv4/tcp_input.o
/builds/linux/net/ipv4/tcp_input.c
1. <eof> parser at end of file
2. Code generation
3. Running pass 'Function Pass Manager' on module
'/builds/linux/net/ipv4/tcp_input.c'.
4. Running pass 'Live Interval Analysis' on function '@tcp_ack'
 #0 0x00007fcc9438ce91 llvm::sys::PrintStackTrace(llvm::raw_ostream&,
int) (/usr/lib/x86_64-linux-gnu/libLLVM-15.so.1+0xe93e91)


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
