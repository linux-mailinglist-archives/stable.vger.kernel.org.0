Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7E12DC115
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 14:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgLPNUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 08:20:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgLPNUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 08:20:34 -0500
Date:   Wed, 16 Dec 2020 14:20:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608124794;
        bh=IA9/3sTBNDJ2f58eicxcEi2F2KiYi9lKUku7OZlWqbA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=b6YBn4QN0RUC1HJQ7WdC9Zt0V90g9is0Xc+LgD6pOmxXQGGK0rzZXmFUz8TbRR1k8
         m22wvKHCVegpWYvaQaxvzbCXYFCw+mynKKWwBXWNdYZVtSFhzLcT7uQ1LglgnhsAre
         3OhG2OBuNlbnqDXaAIfj4CyIlDYJTVooxVLq+qt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.9 000/105] 5.9.15-rc1 review
Message-ID: <X9oJt8y7cMlZ84o/@kroah.com>
References: <20201214172555.280929671@linuxfoundation.org>
 <CA+G9fYvMqG_ai-_sfPGuxxjyZ=3QiabPZhFFY=m_=Qa1aKAL+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvMqG_ai-_sfPGuxxjyZ=3QiabPZhFFY=m_=Qa1aKAL+Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 15, 2020 at 07:57:08AM +0530, Naresh Kamboju wrote:
> On Mon, 14 Dec 2020 at 23:06, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.9.15 release.
> > There are 105 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.15-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
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
> Following warning(s) reported on arm64 Juno-r2 device.
> sched: core.c:7270 Illegal context switch in RCU-bh read-side critical section!
> https://lore.kernel.org/stable/CA+G9fYtu1zOz8ErUzftNG4Dc9=cv1grsagBojJraGhm4arqXyw@mail.gmail.com/T/#u
> 
> Summary
> ------------------------------------------------------------------------
> 

Thanks for testing and letting me know.

greg k-h
