Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A46595859
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbiHPKbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbiHPKbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:31:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01490EF9DC;
        Tue, 16 Aug 2022 01:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91E66611EA;
        Tue, 16 Aug 2022 08:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62648C433D7;
        Tue, 16 Aug 2022 08:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660638440;
        bh=obWd8LHyjUz6HAn1zvUeZVyW4fXbYD54xEC0S6zE2+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F3a6Lur4sVvnK5fFie94HDOKySHW/PVNBZ913vVTNmSNi1J5Ndl8MC6oViQfkvLxR
         CC9ncYonSznVX8CiGtrMtm8AUUiL6wmwrSK6XVfIbdf9WbpJNn0UrmY0UuiTmT1DvY
         6T326dK3KG4bgXqoTaDI+lXhtNuWmX9t01yNuNog=
Date:   Tue, 16 Aug 2022 09:55:18 +0200
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
Message-ID: <YvtNZuap/oCKVv9O@kroah.com>
References: <20220815180439.416659447@linuxfoundation.org>
 <CA+G9fYtZP_rYnmRyLbMrxKPGtJuoOw4h412dJXBJnzab41CzUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtZP_rYnmRyLbMrxKPGtJuoOw4h412dJXBJnzab41CzUw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 01:08:26PM +0530, Naresh Kamboju wrote:
> On Tue, 16 Aug 2022 at 00:58, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.19.2 release.
> > There are 1157 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 17 Aug 2022 18:01:29 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.2-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The arm64 clang-14 allmodconfig failed on stable-rc 5.19.
> This build failure got fixed on the mainline tree two weeks ago.
> 
> * arm64, build
>   - clang-12-allmodconfig
>   - clang-13-allmodconfig
>   - clang-14-allmodconfig
>   - clang-nightly-allmodconfig
> 
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/2/build LLVM=1 LLVM_IAS=1
> ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang'
> 'CC=sccache clang' allmodconfig
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/2/build LLVM=1 LLVM_IAS=1
> ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang'
> 'CC=sccache clang'
> sound/soc/intel/avs/path.c:815:18: error: stack frame size (2192)
> exceeds limit (2048) in 'avs_path_create'
> [-Werror,-Wframe-larger-than]
> struct avs_path *avs_path_create(struct avs_dev *adev, u32 dma_id,
>                  ^
> 1 error generated.
> make[5]: *** [/builds/linux/scripts/Makefile.build:249:
> sound/soc/intel/avs/path.o] Error 1
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Steps to reproduce:
> -------------------------
> # See https://docs.tuxmake.org/ for complete documentation.
> # Original tuxmake command with fragments listed below.
> # tuxmake --runtime podman --target-arch arm64 --toolchain clang-14
> --kconfig allmodconfig LLVM=1 LLVM_IAS=1
> 
> tuxmake --runtime podman --target-arch arm64 --toolchain clang-14
> --kconfig https://builds.tuxbuild.com/2DPEiUmdALSZq7DeNthZFYoPLaN/config
> LLVM=1 LLVM_IAS=1

What is the commit on mainline that resolved this issue?

thanks,

greg k-h
