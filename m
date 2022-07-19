Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC80357A5E0
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 19:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiGSR5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 13:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbiGSR5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 13:57:32 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EF748EB2
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 10:57:31 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id e15so20692530edj.2
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 10:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oFg+kDyan5ddSymBF0EMsUgzOH5nKWk1cQ6VVJhI/2M=;
        b=av/ddA3bb218E+Bg4JEA7f0uvrDNhNtNK/TFkxQnvQO8M0eHqjyG+B8xpQ7Eqxci83
         TloZO7+qtso0g0Dl3rNYDGuqo5Z6vX6c+aJunx1aZh2GR60ILVISazJXm2R7qVckJejs
         d/aZYs5mTBr93E9tdxnUJ0HdfpALnLn6FC1f/3krRfSvPppEorot4KCyYoRsizsCsSsr
         +clRFc5N/kWX+e3aeHVk8bGCOupcGW9znHo9b4qD1h3c2uuSZ6B68v0EkR7TGpAU9mqL
         1/L1HMjuhVKhwJJLizPywNvGH7wLYu3wjy0ha8x5ZjW3A9kW3NVm1/hiC/O0RAF8K3dM
         FPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oFg+kDyan5ddSymBF0EMsUgzOH5nKWk1cQ6VVJhI/2M=;
        b=EfTCYuymTT/j9D9ihOUNf6WfszlxPgs7KySu8mUr6ojptkDiqivRURN0clE5SB0yUF
         tLa4UaJv/QGohAGgrKoECQHbHLbn9beRGl7YxwnWTD37ZDFUBYrBF1mpogLYUaabfEjR
         8qTYpr27p0bE7iruu0ZOIo1JuXVhHVrcUcnv4ayECxPNBhtLo8wGiEjjwaPZVMKAs3Bp
         D7L0tPMIxpfWkOuMmKaw7QEn2bJeekWwwuWg9hNGHR4bPaWpp/jvyXIkbvRAp1AOvaqP
         T7cuxptyZGdUWaniK9c+n/Re2RNmjJg8cQORHyy75lThLaxilXGo2ftRvJ1rUI8QdjvH
         YT2Q==
X-Gm-Message-State: AJIora92OkWVi4nUk3Cb0wpme/wE9jgST0psOy4mQYE8ma3fICG1iaa3
        JaL8LvntOD6Eyt9CcENw0gAR0KShBKkJ6+tCOMdmXg==
X-Google-Smtp-Source: AGRyM1v3uE2F4rCMVs6iLcHquSg3OHL4S0gXfebISCxg0kpchTvVAhBXJwK7tkCPBF6E66+pMztw5l3k7By+tkt+3dU=
X-Received: by 2002:a05:6402:1d53:b0:43a:9ba7:315b with SMTP id
 dz19-20020a0564021d5300b0043a9ba7315bmr45922981edb.350.1658253449854; Tue, 19
 Jul 2022 10:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220719114714.247441733@linuxfoundation.org>
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Jul 2022 23:27:18 +0530
Message-ID: <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, John Harrison <John.C.Harrison@intel.com>,
        Tejas Upadhyay <tejas.upadhyay@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Jul 2022 at 17:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.18.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


There are two regression found

1)
Build regression on i386 with clang-13 and clang-14,
I do not see this build error on mainline.

2) Too many build warnings x86 with gcc-11
I do not see these build warnings on mainline,

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Details log:
------------
1. i386 build failures with clang-13 and clang-14
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=1
ARCH=i386 CROSS_COMPILE=i686-linux-gnu- 'HOSTCC=sccache clang'
'CC=sccache clang'
ld.lld: error: undefined symbol: __udivdi3
>>> referenced by i915_scatterlist.c
>>>               gpu/drm/i915/i915_scatterlist.o:(i915_rsgt_from_mm_node) in archive drivers/built-in.a
make[1]: *** [/builds/linux/Makefile:1162: vmlinux] Error 1


steps to reproduce:
--------------------------
tuxmake --runtime podman --target-arch i386 --toolchain clang-14
--kconfig https://builds.tuxbuild.com/2CA3gjUTE2s74Bzp3G7q2hBxj1t/config
LLVM=1 LLVM_IAS=1
[1] https://builds.tuxbuild.com/2CA3gjUTE2s74Bzp3G7q2hBxj1t/


2. Large number of build warnings on x86 with gcc-11,
I do not see these build warnings on mainline,

Build link: https://builds.tuxbuild.com/2CA3fVEQKJXLNNGgHvoEmFEjyPq/

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/build ARCH=x86_64
CROSS_COMPILE=x86_64-linux-gnu- 'CC=sccache x86_64-linux-gnu-gcc'
'HOSTCC=sccache gcc'
init/calibrate.o: warning: objtool: calibrate_delay_is_known()+0xc:
'naked' return found in RETPOLINE build
init/initramfs.o: warning: objtool: wait_for_initramfs()+0x23: 'naked'
return found in RETPOLINE build
init/main.o: warning: objtool: __traceiter_initcall_level()+0x3a:
'naked' return found in RETPOLINE build
arch/x86/entry/vdso/vma.o: warning: objtool: vdso_mremap()+0x49:
'naked' return found in RETPOLINE build
arch/x86/events/amd/core.o: warning: objtool:
amd_pmu_event_map()+0x1e: 'naked' return found in RETPOLINE build
init/do_mounts.o: warning: objtool: match_dev_by_label()+0x2d: 'naked'
return found in RETPOLINE build
arch/x86/events/amd/iommu.o: warning: objtool:
perf_iommu_event_init()+0x57: 'naked' return found in RETPOLINE build
arch/x86/events/amd/ibs.o: warning: objtool: perf_ibs_init()+0x136:
'naked' return found in RETPOLINE build
certs/system_keyring.o: warning: objtool:
restrict_link_by_builtin_trusted()+0x16: 'naked' return found in REild
kernel/locking/mutex.o: warning: objtool: __mutex_init()+0x2b: 'naked'
return found in RETPOLINE build

steps to reproduce:
tuxmake --runtime podman --target-arch x86_64 --toolchain gcc-11
--kconfig https://builds.tuxbuild.com/2CA3fVEQKJXLNNGgHvoEmFEjyPq/config

--
Linaro LKFT
https://lkft.linaro.org
