Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F88745D905
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238083AbhKYLUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238131AbhKYLTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:19:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0177060FC1;
        Thu, 25 Nov 2021 11:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637838963;
        bh=zFA5bt6BGF/qrfybB7ThfzxCZSJUKNeU5ktlN6DcfsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OWmB6W3WLMq4nsI9IpdEPk64NTWc98UgjGanXnpqwDpES01rYOpTE5k/ZHkcZ9WvY
         3MPtVHJvY3sLxiKTE+4/zP5/2gVpUzWwm1gGwoRQGZEYRnwtSY0vmtRERSuqf+9aAH
         WsJVAv7WV1TzS+U8lDrjWYe7EMu2Rv1cHV2ZdoBs=
Date:   Thu, 25 Nov 2021 12:16:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 4.14 000/251] 4.14.256-rc1 review
Message-ID: <YZ9wcEaa/m5qC6ML@kroah.com>
References: <20211124115710.214900256@linuxfoundation.org>
 <CA+G9fYu83b6_dJ8GOUTcsoUvkZdVWz9Q458f0vsRfXS7pdbXqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu83b6_dJ8GOUTcsoUvkZdVWz9Q458f0vsRfXS7pdbXqQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 09:11:53AM +0530, Naresh Kamboju wrote:
> On Wed, 24 Nov 2021 at 17:51, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.14.256 release.
> > There are 251 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.256-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> FYI,
> New warnings on Linux 4.14.256-rc1 on arm and arm64 (defconfig+7) with gcc-11.
> 
> drivers/soc/tegra/pmc.c: In function 'tegra_powergate_power_up':
> drivers/soc/tegra/pmc.c:423:1: warning: label 'powergate_off' defined
> but not used [-Wunused-label]
>   423 | powergate_off:
>       | ^~~~~~~~~~~~~
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Now fixed, thanks.

greg k-h
