Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E6E342C92
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCTLxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:53:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhCTLxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:53:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F41A361938;
        Sat, 20 Mar 2021 09:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616233923;
        bh=EeVHD219Vu3BLdFwAjIJBYjx7SLJ+5LQkRHLmmay2cc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e4cLWZ8md+MLxd+dMXXjEm0xj9nGSicLyNU04RNKdT3013drAncXT6aznEdcD7mhB
         aJpuSVJnxmXoNv3KZBXKqF24Zp9e6cT8KRb9pRy2dXGPCWOYXOZPfIXA/lzpTo5dPZ
         Y4G7m8s/ojKHWZvlVxBTse9hRkAP1zcoXf/Fud38=
Date:   Sat, 20 Mar 2021 10:52:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.11 00/31] 5.11.8-rc1 review
Message-ID: <YFXFwbZMfToTDL8Z@kroah.com>
References: <20210319121747.203523570@linuxfoundation.org>
 <CA+G9fYs6BxWn=Myx=RvjTqpR9cwAnJ5qfgC2xdEhg-3sfYf2EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYs6BxWn=Myx=RvjTqpR9cwAnJ5qfgC2xdEhg-3sfYf2EA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 20, 2021 at 01:08:52AM +0530, Naresh Kamboju wrote:
> On Fri, 19 Mar 2021 at 17:51, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.11.8 release.
> > There are 31 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.8-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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

thanks for testing them all.

greg k-h
