Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA7246B593
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 09:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhLGIWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 03:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhLGIWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 03:22:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65743C061746;
        Tue,  7 Dec 2021 00:19:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D6E9B816CE;
        Tue,  7 Dec 2021 08:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F5FC341C1;
        Tue,  7 Dec 2021 08:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638865144;
        bh=jUXDPMh/eBReCTtw48rq87Ap3LdHbIvNbJM9Uv0wwic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WaqYIz6UHSEijsz1g8oJoXpCytwq+MFZWHkifuuFZcBQJls/jQQvheHlT2Ix+5Jac
         7dhJpe0A6Exw7t08YogkSXpSU3arGifiCC9dfgqKAEHkv0K8YSEN0JhgCbOrbKr6Td
         yASTs5uqN2Xo5WMgMhkcyYV3YJO69IVBSQl50dWU=
Date:   Tue, 7 Dec 2021 09:19:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 5.10 000/130] 5.10.84-rc1 review
Message-ID: <Ya8Y9iakiVlBtMZi@kroah.com>
References: <20211206145559.607158688@linuxfoundation.org>
 <CA+G9fYtYmZY-m1ZCaF3qJeGtn=8CJR_4K8EB_T4W+wuh31CNjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtYmZY-m1ZCaF3qJeGtn=8CJR_4K8EB_T4W+wuh31CNjg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 07, 2021 at 08:07:11AM +0530, Naresh Kamboju wrote:
> On Mon, 6 Dec 2021 at 20:46, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.84 release.
> > There are 130 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.84-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Regression found while building allmodconfig for the following arch
> 
>  - i386 (allmodconfig) with gcc-10 / gcc-11
>  - mips (allmodconfig) with gcc-10 / gcc-11
>  - powerpc (allmodconfig) with gcc-10 / gcc-11
>  - parisc (allmodconfig) with gcc-10 / gcc-11
>  - riscv (allmodconfig) with gcc-10 / gcc-11
>  - sh (allmodconfig) with gcc-10 / gcc-11
>  - s390 (allmodconfig) with gcc-10 / gcc-11
> 
> 
> metadata:
>   git branch: linux-5.10.y
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git commit: ea2293709b3cac4bdfcb88ad67605c58264608df
>   git describe: v5.10.83-131-gea2293709b3c
>   toolchain: gcc-10 / gcc-11
>   kernel-config: https://builds.tuxbuild.com/21vHJb50DPJcjJuLnT8DzL6vvkn/config
>   build location: https://builds.tuxbuild.com/21dB06iPvDP58giSGHdE5W3Qc68/
> 
> build error:
> --------------
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=i386
> CROSS_COMPILE=i686-linux-gnu- 'CC=sccache i686-linux-gnu-gcc'
> 'HOSTCC=sccache gcc'
> ERROR: modpost: "kgd2kfd_resume_iommu"
> [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
> make[2]: *** [/builds/linux/scripts/Makefile.modpost:124:
> modules-only.symvers] Error 1
> make[2]: *** Deleting file 'modules-only.symvers'
> make[2]: Target '__modpost' not remade because of errors.
> make[1]: *** [/builds/linux/Makefile:1413: modules] Error 2
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> step to reproduce:
> ------------------
> tuxmake --runtime podman --target-arch i386 --toolchain gcc-11
> --kconfig allmodconfig
> 
> --
> Linaro LKFT
> https://lkft.linaro.org


Thanks for the report, should be fixed in -rc2

greg k-h
