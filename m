Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF36300779
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 16:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbhAVPg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 10:36:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729169AbhAVPgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 10:36:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3542223A9A;
        Fri, 22 Jan 2021 15:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611329770;
        bh=7LaOeer6chAeQjGnD6VV2qVZxVZZ9WwWjinwdG3LDWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FLgQkzkeUwiEOoREWZY7v0nqVJFGI0yXpp2C5az8WgcIU1jsKDmv9bXUSHYtbBAtI
         dGBJ+Md4V6m/tCCDemjF7xoG1pFOqeiprn4mCUkL3/SPsuNeYs9PvXaabw9zEdoDtT
         FnXT5o/VWBs+grFPO5BWayrza4+7KWzUi9RmjtL/2caHiq/InOXIK5dQZUV1BFFBrR
         ZpQ71mSZmkNqtcZmgWfOZHLbvKDz+j30s6kz9YUoDbeoIr4cAlV/eGQxMptK+rBIHM
         fBlqehVfTCToHtboGBe+dFyjLl84pFoL9TP8XctGCXptwIQusNn/qx3rsFHe90Zhv5
         uDUMfWAxQRwsw==
Date:   Fri, 22 Jan 2021 15:36:04 +0000
From:   Will Deacon <will@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH 4.14 00/50] 4.14.217-rc1 review
Message-ID: <20210122153604.GA24972@willie-the-truck>
References: <20210122135735.176469491@linuxfoundation.org>
 <CA+G9fYso4QNbRWdrQiiOiMb5RUr8VtM3AkKEGLasgN+KsPSvDw@mail.gmail.com>
 <YArqULK9c1Cnt5gM@kroah.com>
 <CA+G9fYuzE9WMSB7uGjV4gTzK510SHEdJb_UXQCzsQ5MqA=h9SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuzE9WMSB7uGjV4gTzK510SHEdJb_UXQCzsQ5MqA=h9SA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 08:43:18PM +0530, Naresh Kamboju wrote:
> On Fri, 22 Jan 2021 at 20:38, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Jan 22, 2021 at 08:32:46PM +0530, Naresh Kamboju wrote:
> > > On Fri, 22 Jan 2021 at 19:45, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 4.14.217 release.
> > > > There are 50 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.217-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > arm64 clang-10 builds breaks due to this patch on
> > >    - stable-rc 4.14
> > >    - stable-rc 4.9
> > >    - stable-rc 4.4
> > >
> > > > Will Deacon <will@kernel.org>
> > > >     compiler.h: Raise minimum version of GCC to 5.1 for arm64
> > >
> > > arm64 (defconfig) with clang-10 - FAILED
> >
> > How is a clang build breaking on a "check what version of gcc is being
> > used" change?
> >
> > What is the error message?
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=arm64
> CROSS_COMPILE=aarch64-linux-gnu- 'HOSTCC=sccache clang' 'CC=sccache
> clang'
> In file included from <built-in>:1:
> include/linux/kconfig.h:74:
> include/linux/compiler_types.h:58:
> include/linux/compiler-gcc.h:160:3: error: Sorry, your version of GCC
> is too old - please use 5.1 or newer.
> # error Sorry, your version of GCC is too old - please use 5.1 or newer.
>   ^
> 1 error generated.
> 
> build error link:
> https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/980489003#L514

Urgh, looks like we need backports of 815f0ddb346c
("include/linux/compiler*.h: make compiler-*.h mutually exclusive") then.

Greg -- please drop my changes from 4.14, 4.9 and 4.4 for now and I'll
look at this next week.

Cheers,

Will
