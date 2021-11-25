Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C837645D906
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhKYLUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238538AbhKYLTj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:19:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 571586104F;
        Thu, 25 Nov 2021 11:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637838988;
        bh=VJ1qwSVDgj9hVvTEuWtO8t8LX7VUgn9kTYaYnEyXmDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JY+/DqXGnNWnXLmTMpc6v5fxh5rADdP4gRVwHqBX33ri/qc8+mLUmoYxgFMlQu3nO
         yXhguqfF5t+BlWUF4U7GrX/a2QYQ8bm5uD70C/xDmZs9NaI8u1+U52shE3Dg/zD9z7
         A8PLxKNcuDDXmayUa8YtEiJqENI23BSBNf2sF+/k=
Date:   Thu, 25 Nov 2021 12:16:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 4.9 000/207] 4.9.291-rc1 review
Message-ID: <YZ9wh9ItjvU9vaQ4@kroah.com>
References: <20211124115703.941380739@linuxfoundation.org>
 <CA+G9fYvXKXWMQY_X6NCBT41kGKszi3oRBw1HCfg+BN6GOWoRhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvXKXWMQY_X6NCBT41kGKszi3oRBw1HCfg+BN6GOWoRhg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 09:06:11AM +0530, Naresh Kamboju wrote:
> On Wed, 24 Nov 2021 at 17:44, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.9.291 release.
> > There are 207 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.291-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> FYI,
> New warnings noticed,
> 
> Linux 4.9.291-rc1 on arm (defconfig) with gcc-11
> 
> drivers/soc/tegra/pmc.c: In function 'tegra_powergate_power_up':
> drivers/soc/tegra/pmc.c:412:1: warning: label 'powergate_off' defined
> but not used [-Wunused-label]
>   412 | powergate_off:
>       | ^~~~~~~~~~~~~
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Now fixed up, thanks.

greg k-h
