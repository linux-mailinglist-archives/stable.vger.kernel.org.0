Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9DD3006D3
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 16:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbhAVPNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 10:13:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728606AbhAVPIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 10:08:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A61923AA1;
        Fri, 22 Jan 2021 15:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611328083;
        bh=ye4fDbpuVVem7KdwZzwys4Ap+1pmYfc4KCLpV60+vr8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WDgeuQvf3hyJYzJA2i5YLOFJZrqS8QP/cesINt//TvaoWwVewnLnxsT8EZwVH69FY
         YQUFaA8B/3g30fkbj+Qjp2U/ROUW3eIbGWAKp/IIRZDMGIeBOcg3f/vvaoUOxdh/Wc
         9Ks6YaJgyPfhokd/MmkYPZ7M2v29Ei++ln2sQTWw=
Date:   Fri, 22 Jan 2021 16:08:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Will Deacon <will@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Arnd Bergmann <arnd@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH 4.14 00/50] 4.14.217-rc1 review
Message-ID: <YArqULK9c1Cnt5gM@kroah.com>
References: <20210122135735.176469491@linuxfoundation.org>
 <CA+G9fYso4QNbRWdrQiiOiMb5RUr8VtM3AkKEGLasgN+KsPSvDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYso4QNbRWdrQiiOiMb5RUr8VtM3AkKEGLasgN+KsPSvDw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 08:32:46PM +0530, Naresh Kamboju wrote:
> On Fri, 22 Jan 2021 at 19:45, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.14.217 release.
> > There are 50 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.217-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> arm64 clang-10 builds breaks due to this patch on
>    - stable-rc 4.14
>    - stable-rc 4.9
>    - stable-rc 4.4
> 
> > Will Deacon <will@kernel.org>
> >     compiler.h: Raise minimum version of GCC to 5.1 for arm64
> 
> arm64 (defconfig) with clang-10 - FAILED

How is a clang build breaking on a "check what version of gcc is being
used" change?

What is the error message?

thanks,

greg k-h
