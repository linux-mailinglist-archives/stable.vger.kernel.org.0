Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56808473EF9
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 10:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhLNJJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 04:09:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59110 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhLNJJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 04:09:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7529261389;
        Tue, 14 Dec 2021 09:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4AFC34606;
        Tue, 14 Dec 2021 09:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639472983;
        bh=llw7LsPX1mxgbByEATtQ7IKOogRD++SK1ta+hWTJ1bE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=grsuabsOg0F4YP4YndVEAH5Mcpw8s8+ms7TU5t+GnAf1Ykj6Yq0x3FDPshT4i8Sg2
         TAyOLQpWVXYSzDzqmOnezZM5ryhEl9QpnhzUvp63n4yMrLmo3TBqcNp42lJcw399Xx
         4dnBNpj9uI6l/BOf0ia5qxwuwqOn0QnbTfK0mpLU=
Date:   Tue, 14 Dec 2021 10:09:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 4.14 00/53] 4.14.258-rc1 review
Message-ID: <YbhfVe5j6reAR+hX@kroah.com>
References: <20211213092928.349556070@linuxfoundation.org>
 <CA+G9fYsEQCjOi_58WcMb4i-2t1Gv=KjPuWa6L792YAZF=zzinw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYsEQCjOi_58WcMb4i-2t1Gv=KjPuWa6L792YAZF=zzinw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 14, 2021 at 10:53:19AM +0530, Naresh Kamboju wrote:
> On Mon, 13 Dec 2021 at 15:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.14.258 release.
> > There are 53 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.258-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> NOTE:
> Following warnings noticed on x86_64 and i386 with defconfig
> building with gcc-8/9/10/11 and clang-11/12/13 and nightly.
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=x86_64
> CROSS_COMPILE=x86_64-linux-gnu- 'CC=sccache x86_64-linux-gnu-gcc'
> 'HOSTCC=sccache gcc' defconfig
> warning: (EFI) selects ARCH_USE_MEMREMAP_PROT which has unmet direct
> dependencies (AMD_MEM_ENCRYPT)
> warning: (EFI) selects ARCH_USE_MEMREMAP_PROT which has unmet direct
> dependencies (AMD_MEM_ENCRYPT)

I'll go drop the offending commit from all trees, thanks.

greg k-h
