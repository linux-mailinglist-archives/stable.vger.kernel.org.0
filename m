Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EA8595A22
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbiHPLbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234285AbiHPLbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:31:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A093C6FE4;
        Tue, 16 Aug 2022 03:49:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82F94B8165D;
        Tue, 16 Aug 2022 10:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA6AC433C1;
        Tue, 16 Aug 2022 10:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660646964;
        bh=budnNuo/YVw1jauWgOvfqZHp8K6KsLEb30LHoxMbwdg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kLxozVjJp5oRD1n34EC03cuQEdqumF4bFEZ6XWh0eKDLs2X/Af21GaqlXvcqZg8+M
         uPSlQoHkRMPoC0YHJWyF8HYOd6MokyaxH8PS5U361CEr4IBIt3p7zV4L5CA7bmg8XP
         hku2sD/pE/ZKyzXfjXT683ycHoEzWE99fql+COos=
Date:   Tue, 16 Aug 2022 12:49:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
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
Subject: Re: [PATCH 5.19 0000/1157] 5.19.2-rc1 review
Message-ID: <Yvt2MW6oH07qs8JM@kroah.com>
References: <20220815180439.416659447@linuxfoundation.org>
 <CA+G9fYtZP_rYnmRyLbMrxKPGtJuoOw4h412dJXBJnzab41CzUw@mail.gmail.com>
 <YvtNZuap/oCKVv9O@kroah.com>
 <CA+G9fYuqm1NzfhF2B8OXqcH8-c24ZA6UGv3Y94fYuyOKVgqaOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuqm1NzfhF2B8OXqcH8-c24ZA6UGv3Y94fYuyOKVgqaOQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 04:07:58PM +0530, Naresh Kamboju wrote:
> On Tue, 16 Aug 2022 at 13:57, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Aug 16, 2022 at 01:08:26PM +0530, Naresh Kamboju wrote:
> > > On Tue, 16 Aug 2022 at 00:58, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.19.2 release.
> > > > There are 1157 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.2-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > The arm64 clang-14 allmodconfig failed on stable-rc 5.19.
> > > This build failure got fixed on the mainline tree two weeks ago.
> > >
> > > * arm64, build
> > >   - clang-12-allmodconfig
> > >   - clang-13-allmodconfig
> > >   - clang-14-allmodconfig
> > >   - clang-nightly-allmodconfig
> > >
> > >
> > > make --silent --keep-going --jobs=8
> > > O=/home/tuxbuild/.cache/tuxmake/builds/2/build LLVM=1 LLVM_IAS=1
> > > ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang'
> > > 'CC=sccache clang' allmodconfig
> > > make --silent --keep-going --jobs=8
> > > O=/home/tuxbuild/.cache/tuxmake/builds/2/build LLVM=1 LLVM_IAS=1
> > > ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang'
> > > 'CC=sccache clang'
> > > sound/soc/intel/avs/path.c:815:18: error: stack frame size (2192)
> > > exceeds limit (2048) in 'avs_path_create'
> > > [-Werror,-Wframe-larger-than]
> > > struct avs_path *avs_path_create(struct avs_dev *adev, u32 dma_id,
> > >                  ^
> > > 1 error generated.
> > > make[5]: *** [/builds/linux/scripts/Makefile.build:249:
> > > sound/soc/intel/avs/path.o] Error 1
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > Steps to reproduce:
> > > -------------------------
> > > # See https://docs.tuxmake.org/ for complete documentation.
> > > # Original tuxmake command with fragments listed below.
> > > # tuxmake --runtime podman --target-arch arm64 --toolchain clang-14
> > > --kconfig allmodconfig LLVM=1 LLVM_IAS=1
> > >
> > > tuxmake --runtime podman --target-arch arm64 --toolchain clang-14
> > > --kconfig https://builds.tuxbuild.com/2DPEiUmdALSZq7DeNthZFYoPLaN/config
> > > LLVM=1 LLVM_IAS=1
> >
> > What is the commit on mainline that resolved this issue?
> 
> commit 1e744351bcb9c4cee81300de5a6097100d835386
> Author: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
> Date:   Fri Jul 22 13:19:59 2022 +0200
> 
>     ASoC: Intel: avs: Use lookup table to create modules
> 
>     As reported by Nathan, when building avs driver using clang with:
>       CONFIG_COMPILE_TEST=y
>       CONFIG_FORTIFY_SOURCE=y
>       CONFIG_KASAN=y
>       CONFIG_PCI=y
>       CONFIG_SOUND=y
>       CONFIG_SND=y
>       CONFIG_SND_SOC=y
>       CONFIG_SND_SOC_INTEL_AVS=y
> 
>     there are reports of too big stack use, like:
>       sound/soc/intel/avs/path.c:815:18: error: stack frame size
> (2176) exceeds limit (2048) in 'avs_path_create'
> [-Werror,-Wframe-larger-than]
>       struct avs_path *avs_path_create(struct avs_dev *adev, u32 dma_id,
>                        ^
>       1 error generated.
> 
>     This is apparently caused by inlining many calls to guid_equal which
>     inlines fortified memcpy, using 2 size_t variables.
> 
>     Instead of hardcoding many calls to guid_equal, use lookup table with
>     one call, this improves stack usage.
> 
>     Link: https://lore.kernel.org/alsa-devel/YtlzY9aYdbS4Y3+l@dev-arch.thelio-3990X/T/
>     Link: https://github.com/ClangBuiltLinux/linux/issues/1642
>     Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
>     Reported-by: Nathan Chancellor <nathan@kernel.org>
>     Build-tested-by: Nathan Chancellor <nathan@kernel.org>
>     Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
>     Link: https://lore.kernel.org/r/20220722111959.2588597-1-amadeuszx.slawinski@linux.intel.com
>     Signed-off-by: Mark Brown <broonie@kernel.org>

Thanks, now queued up to the 5.19 queue.

greg k-h
