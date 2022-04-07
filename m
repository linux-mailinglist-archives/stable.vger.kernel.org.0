Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEAD4F7E10
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 13:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244790AbiDGLbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 07:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240974AbiDGLbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 07:31:06 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1BD35DCB
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 04:29:06 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2eb680211d9so57893257b3.9
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 04:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YP4N8kQIQN8/YyHOBtiyCSukn6COHCxPe5RjI8eyTIU=;
        b=p307Ut0z+SmAm1cX12VxU9NJGKVhp5iaOJEZsH+IsD0U4PNAvGsY8sTSLkz/1zoUeF
         6B0KGS/OTKHbXkMJiZsaBwt4Mo6gFapZw+oOhN+59/GS2+yHJosYEvAV12SVcFVHvzHT
         ac6E2AKZGSTbzYnaBn69TtdOEt5GDp3/ilpvanpVz1gSyzotyc7zLp1v0NT+BlJZ9Mvs
         pE+aK2LSS8knSw2jsthihWlKXnCUbttvnxiETssWEtA4FfnHoRGiW0FZhJZVcBmzDWsk
         5ligtluKjQ2aVI2bmJvvYTepWJs8RFjrVWkY9n/kqg+B4Fe3YArpY4gn4nCxeaWDH9Pa
         wTIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YP4N8kQIQN8/YyHOBtiyCSukn6COHCxPe5RjI8eyTIU=;
        b=5mVByUdb6w7ErkjeCX7ScMIDgpbDgfX7nz1RBmjijoxyaUOrEjecEtUH57F4poqpVC
         AkiOLl0HXU7bF0KlT8n4Fp8X75psvP6eC5731dyyJI7U34gjGeiDbS5g5w1feMa4r/Ce
         A0yQZrumiBi32VgEaY9k4s+YI/+wqG1vzLwht66axfnmvVvb9suEnL7JZTvz0GwkoP65
         HgA51vo1rWeQ/jkwW/nhf8qzlr4GNfxWWg535AK2dy89GNLJcFBiZTYErNra7AqN6xQo
         fvXZWkPRW34cdeBXxGG0v8IuxEybzUIKIJZNE0PJf1sxatpofoP03Jvvr1XMXqIpzf3Q
         jYOw==
X-Gm-Message-State: AOAM530o6ietc4+AxTluFL4pVPBTue1oUJNNbSuVBRJ8izcOIwZ27WXN
        Eey7nYlHHyMw81XGJWmaNC6j5rSgClTP2+JSTMVb0i6bzEmV6qnt
X-Google-Smtp-Source: ABdhPJz6rb9FahBmnB1jlZ9O0IoEkkKDXbBiKJbq8wv+QbmKS6pT+wJa4BJDrAkMEdQENqVdMJRwglRjhPZa6iOCpGM=
X-Received: by 2002:a81:6f85:0:b0:2e5:bad1:cf35 with SMTP id
 k127-20020a816f85000000b002e5bad1cf35mr11121731ywc.199.1649330944107; Thu, 07
 Apr 2022 04:29:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220406182436.675069715@linuxfoundation.org>
In-Reply-To: <20220406182436.675069715@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 7 Apr 2022 16:58:52 +0530
Message-ID: <CA+G9fYvdA3DjgvmL3pnOHc7XdDcoD600sFQFZ34Y_AVdYNtQmQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/43] 4.9.310-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Robert Richter <rrichter@cavium.com>,
        Will Deacon <will.deacon@arm.com>,
        James Morse <james.morse@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 6 Apr 2022 at 23:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.310 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Apr 2022 18:24:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.310-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.

As Guenter reported,
On stable-rc 4.9 arm64 build configs allnoconfig and tinyconfig failed [1].

## Build
* kernel: 4.9.310-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: b5f0e9d665c30ceb3bee566518a1020e54d7bc1f
* git describe: v4.9.309-44-gb5f0e9d665c3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y-sanity/build=
/v4.9.309-44-gb5f0e9d665c3

## Test Regressions (compared to v4.9.309-163-geeae539a0d5c)
* arm64, build
  - arm64-clang-11-allnoconfig
  - arm64-clang-11-tinyconfig
  - arm64-clang-12-allnoconfig
  - arm64-clang-12-tinyconfig
  - arm64-clang-13-allnoconfig
  - arm64-clang-13-tinyconfig
  - arm64-clang-nightly-allnoconfig
  - arm64-clang-nightly-tinyconfig
  - arm64-gcc-10-allnoconfig
  - arm64-gcc-10-tinyconfig
  - arm64-gcc-11-allnoconfig
  - arm64-gcc-11-tinyconfig
  - arm64-gcc-8-allnoconfig
  - arm64-gcc-8-tinyconfig
  - arm64-gcc-9-allnoconfig
  - arm64-gcc-9-tinyconfig


Build error:
------------

arch/arm64/kernel/cpu_errata.c: In function 'is_spectrev2_safe':
arch/arm64/kernel/cpu_errata.c:829:39: error:
'arm64_bp_harden_smccc_cpus' undeclared (first use in this function);
did you mean 'arm64_bp_harden_el1_vectors'?
  829 |                                       arm64_bp_harden_smccc_cpus);
      |                                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                       arm64_bp_harden_el1_vectors
arch/arm64/kernel/cpu_errata.c:829:39: note: each undeclared
identifier is reported only once for each function it appears in
arch/arm64/kernel/cpu_errata.c: In function 'spectre_bhb_enable_mitigation'=
:
arch/arm64/kernel/cpu_errata.c:839:39: error: '__hardenbp_enab'
undeclared (first use in this function)
  839 |         if (!is_spectrev2_safe() &&  !__hardenbp_enab) {
      |                                       ^~~~~~~~~~~~~~~
In file included from include/asm-generic/percpu.h:6,
                 from arch/arm64/include/asm/percpu.h:279,
                 from include/linux/percpu.h:12,
                 from arch/arm64/include/asm/mmu.h:23,
                 from include/linux/mm_types.h:17,
                 from include/linux/sched.h:27,
                 from include/linux/ratelimit.h:5,
                 from include/linux/device.h:27,
                 from include/linux/node.h:17,
                 from include/linux/cpu.h:16,
                 from arch/arm64/include/asm/cpu.h:19,
                 from arch/arm64/kernel/cpu_errata.c:23:
arch/arm64/kernel/cpu_errata.c:879:42: error: 'bp_hardening_data'
undeclared (first use in this function)
  879 |                         __this_cpu_write(bp_hardening_data.fn, NULL=
);
      |                                          ^~~~~~~~~~~~~~~~~
include/linux/percpu-defs.h:236:54: note: in definition of macro
'__verify_pcpu_ptr'
  236 |         const void __percpu *__vpp_verify =3D (typeof((ptr) +
0))NULL;    \
      |                                                      ^~~
include/linux/percpu-defs.h:438:41: note: in expansion of macro
'__pcpu_size_call'
  438 | #define raw_cpu_write(pcp, val)
__pcpu_size_call(raw_cpu_write_, pcp, val)
      |                                         ^~~~~~~~~~~~~~~~
include/linux/percpu-defs.h:469:9: note: in expansion of macro 'raw_cpu_wri=
te'
  469 |         raw_cpu_write(pcp, val);
         \
      |         ^~~~~~~~~~~~~
arch/arm64/kernel/cpu_errata.c:879:25: note: in expansion of macro
'__this_cpu_write'
  879 |                         __this_cpu_write(bp_hardening_data.fn, NULL=
);
      |                         ^~~~~~~~~~~~~~~~
make[2]: *** [scripts/Makefile.build:307:
arch/arm64/kernel/cpu_errata.o] Error 1


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

steps to reproduce:

# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake

 tuxmake --runtime podman --target-arch arm64 --toolchain gcc-11
--kconfig tinyconfig


--
Linaro LKFT
https://lkft.linaro.org

[1] https://builds.tuxbuild.com/27R7yjNqw1ahQiOJ16BgcTn7BcZ/
