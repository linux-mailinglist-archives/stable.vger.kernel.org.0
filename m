Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7155595618
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 11:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiHPJYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 05:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiHPJXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 05:23:32 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4658912A1E8
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 00:38:40 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r4so12371293edi.8
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 00:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=7buQFKX9OZIlEB4+dje7yWbqm2+cxtfTWEbPmdc/htk=;
        b=KJkXLDKgTHvzZPCN7k9tf4IH4PPK6BZOH9uyrhPmryq0s9v9o5yRTJpg3ZhwM4oSdD
         G1BtDRWtVjT0ZJ2KU7Dx50eIBhZYqrr8p/NSQQjosU5iw16IRP0EGxn7LYrD8RqujJMi
         sITOw529kP/AGl2NAbicN/1Qv8NktRyOhCAGKAal9Prvk1g53LndsHnFy8YTZgCQC6Z4
         tRjZKpakYP2mAV6cEspfEhS2UsWTvBjb92s/WlftIMD+L5SqcjxGo8c39Yt+/r2BkMB5
         7YCAOStgM9VFC5N+HNEaaTjq7Y6p0aLoGWdTvgu1N1bNmvZy961yL04jo2VifDhybAh9
         YRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=7buQFKX9OZIlEB4+dje7yWbqm2+cxtfTWEbPmdc/htk=;
        b=4KVD5vfBKmX4e0C+hrSN4EJW72kLKNwAcEyanmi+vug/Y5Viu2TJ/BMicwqT94dpKV
         Kc0T8NOM1Z7/8czJ2qpD+zbSnOmRQsfhpUDnq20enIpsCGqdjQrrQWFqA/10kR6bCWmM
         t5tl+hQAaUiPk7hrSb6O33ILqpf0UYHcpUT/VPHVBJ37TdEcDrxhIvntUFvGipRyv3MK
         ae2LWkVUjalFtPqXSR5Td/UHpyc6j3d/ZJQgdTMnv4/TuYNl9RbGEU62tr5KpqxcoZpI
         lqBlKGD0hZMQghNS6pB6GKhpW3BEwSIbdZB4kKFwyal2BufQmFgS+ohOQeU5k4O3cUlj
         cvxQ==
X-Gm-Message-State: ACgBeo07m36YGhzOOKSRTs2W8IHwt84ysnHWaqNmJhRMX/8AUXezSCrH
        OgYB92QMZADbUGRD7fmvYn8bqRjPQgTyHXDfuegilA==
X-Google-Smtp-Source: AA6agR7GrSqc14k7wysKRF5azz/sO4eA/lQMi8CdCB/5NFWzRpqJa63cCRJbkUP0o2sMCyAsB3ZQJbasaU+jex0kD44=
X-Received: by 2002:a05:6402:2387:b0:43d:3e0:4daf with SMTP id
 j7-20020a056402238700b0043d03e04dafmr17756151eda.208.1660635518010; Tue, 16
 Aug 2022 00:38:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220815180439.416659447@linuxfoundation.org>
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 16 Aug 2022 13:08:26 +0530
Message-ID: <CA+G9fYtZP_rYnmRyLbMrxKPGtJuoOw4h412dJXBJnzab41CzUw@mail.gmail.com>
Subject: Re: [PATCH 5.19 0000/1157] 5.19.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
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

On Tue, 16 Aug 2022 at 00:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.2 release.
> There are 1157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The arm64 clang-14 allmodconfig failed on stable-rc 5.19.
This build failure got fixed on the mainline tree two weeks ago.

* arm64, build
  - clang-12-allmodconfig
  - clang-13-allmodconfig
  - clang-14-allmodconfig
  - clang-nightly-allmodconfig


make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/2/build LLVM=1 LLVM_IAS=1
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang'
'CC=sccache clang' allmodconfig
make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/2/build LLVM=1 LLVM_IAS=1
ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang'
'CC=sccache clang'
sound/soc/intel/avs/path.c:815:18: error: stack frame size (2192)
exceeds limit (2048) in 'avs_path_create'
[-Werror,-Wframe-larger-than]
struct avs_path *avs_path_create(struct avs_dev *adev, u32 dma_id,
                 ^
1 error generated.
make[5]: *** [/builds/linux/scripts/Makefile.build:249:
sound/soc/intel/avs/path.o] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Steps to reproduce:
-------------------------
# See https://docs.tuxmake.org/ for complete documentation.
# Original tuxmake command with fragments listed below.
# tuxmake --runtime podman --target-arch arm64 --toolchain clang-14
--kconfig allmodconfig LLVM=1 LLVM_IAS=1

tuxmake --runtime podman --target-arch arm64 --toolchain clang-14
--kconfig https://builds.tuxbuild.com/2DPEiUmdALSZq7DeNthZFYoPLaN/config
LLVM=1 LLVM_IAS=1

--
Linaro LKFT
https://lkft.linaro.org
