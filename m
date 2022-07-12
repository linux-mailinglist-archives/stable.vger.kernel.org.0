Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650285712DE
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 09:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbiGLHNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 03:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiGLHNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 03:13:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB21974A6;
        Tue, 12 Jul 2022 00:13:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58B17B8121C;
        Tue, 12 Jul 2022 07:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB3CC3411E;
        Tue, 12 Jul 2022 07:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657609985;
        bh=q2L4dbPk0338Ca9+RyDAS0dRcVivRtQV2s6baz1iriA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UW3Fg3LL3L5IHHFYxsA4SA1fuILkoLvPCTJEJj6j/Z6iLCAwSg5XXgJEKZoPs1/wg
         FemWDUce1MM5jmuu2JTW+hNCKbGVds5wbBQLcQa7BoVIlhFe0vAP+MRAMm9qy3SNBb
         d9hxHpobh/HWeLPLqQyKe5ksGuL0uA3xnv69paec=
Date:   Tue, 12 Jul 2022 09:12:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/229] 5.15.54-rc2 review
Message-ID: <Ys0e+4B+IFUDroFX@kroah.com>
References: <20220711145306.494277196@linuxfoundation.org>
 <CA+G9fYsvtJu832j-1NmJ00ZOvGLAxAHUkNWo8PDztT--oO0_Ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsvtJu832j-1NmJ00ZOvGLAxAHUkNWo8PDztT--oO0_Ng@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022 at 09:14:21AM +0530, Naresh Kamboju wrote:
> On Mon, 11 Jul 2022 at 20:24, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.54 release.
> > There are 229 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 13 Jul 2022 14:51:35 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.54-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> Regressions found while building for powerpc.
> 
> Following powerpc builds failed.
> 
> * powerpc, build
>   - clang-13-defconfig
>   - clang-13-ppc64e_defconfig
>   - clang-14-defconfig
>   - clang-14-ppc64e_defconfig
>   - gcc-10-cell_defconfig
>   - gcc-10-defconfig
>   - gcc-10-maple_defconfig
>   - gcc-10-ppc64e_defconfig
>   - gcc-11-cell_defconfig
>   - gcc-11-defconfig
>   - gcc-11-maple_defconfig
>   - gcc-11-ppc64e_defconfig
>   - gcc-8-cell_defconfig
>   - gcc-8-defconfig
>   - gcc-8-maple_defconfig
>   - gcc-8-ppc64e_defconfig
>   - gcc-9-cell_defconfig
>   - gcc-9-defconfig
>   - gcc-9-maple_defconfig
>   - gcc-9-ppc64e_defconfig
>   - gcc-11-allmodconfig
>   - gcc-10-allmodconfig
>   - clang-13-allmodconfig
>   - clang-14-allmodconfig
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=0
> LD=powerpc64le-linux-gnu-ld ARCH=powerpc
> CROSS_COMPILE=powerpc64le-linux-gnu- 'HOSTCC=sccache clang'
> 'CC=sccache clang'
> arch/powerpc/kernel/vdso64/gettimeofday.S: Assembler messages:
> arch/powerpc/kernel/vdso64/gettimeofday.S:25: Error: unrecognized
> opcode: `cvdso_call'
> arch/powerpc/kernel/vdso64/gettimeofday.S:36: Error: unrecognized
> opcode: `cvdso_call'
> arch/powerpc/kernel/vdso64/gettimeofday.S:47: Error: unrecognized
> opcode: `cvdso_call'
> arch/powerpc/kernel/vdso64/gettimeofday.S:57: Error: unrecognized
> opcode: `cvdso_call_time'
> clang: error: assembler command failed with exit code 1 (use -v to see
> invocation)
> make[2]: *** [scripts/Makefile.build:390:
> arch/powerpc/kernel/vdso64/gettimeofday.o] Error 1
> make[2]: Target 'include/generated/vdso64-offsets.h' not remade
> because of errors.
> make[1]: *** [arch/powerpc/Makefile:427: vdso_prepare] Error 2
> 
> Build : https://builds.tuxbuild.com/2BnsQzulG0EbhdbiIORptHZwacG/
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks, let me push out a -rc3 with the powerpc vdso patches removed.

greg k-h
