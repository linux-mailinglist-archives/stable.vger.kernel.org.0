Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D107645D904
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhKYLUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:20:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238089AbhKYLTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:19:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31D69604E9;
        Thu, 25 Nov 2021 11:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637838958;
        bh=+nlDCr33tM6VMDXQHq6SxjsYjvxna6uGWA4tVDZ/8lE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nyfXHJ4tnSwrBBpWRdqH137IQbTM2LuK6WiSEsFjnpEFyZv4oucj76kNQrJGnOW7s
         mw0Ht01hjIlMZw0k3bWLCK2pBKhso9X+K8+Q7Y1dvhq3geg/wZxE9kqU5d54AsUoRK
         dWeeB94BiBzoundliFjtBvNbIlHniuIoMlFFDqsc=
Date:   Thu, 25 Nov 2021 12:15:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
Subject: Re: [PATCH 4.19 000/323] 4.19.218-rc1 review
Message-ID: <YZ9wZpyENUCk6EE/@kroah.com>
References: <20211124115718.822024889@linuxfoundation.org>
 <CA+G9fYvxnPa4HXXqcF-2Y-dW2VEer3ZZ9Wa9P5fKy8b3qUB89g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvxnPa4HXXqcF-2Y-dW2VEer3ZZ9Wa9P5fKy8b3qUB89g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 09:15:27AM +0530, Naresh Kamboju wrote:
> On Wed, 24 Nov 2021 at 18:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.218 release.
> > There are 323 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.218-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> FYI,
> New warnings on Linux 4.19.218-rc1 arm and arm64 (defconfig+7) with gcc-11.
> 
> drivers/soc/tegra/pmc.c: In function 'tegra_powergate_power_up':
> drivers/soc/tegra/pmc.c:429:1: warning: label 'powergate_off' defined
> but not used [-Wunused-label]
>   429 | powergate_off:
>       | ^~~~~~
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Should now be fixed up, thanks.

greg k-h
