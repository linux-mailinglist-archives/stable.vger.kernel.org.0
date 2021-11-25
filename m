Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193AF45D983
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239705AbhKYLtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:49:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232753AbhKYLrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:47:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 116C160FBF;
        Thu, 25 Nov 2021 11:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637840638;
        bh=JNAvp0d48GJY6heYg3QVPsruIjM8EwRa0v8wQzOybb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fd5B09pgAULni1Er4wXgWx4KvTLkQd4cnVdonVdrcNsn2Yvy/vQyDtVCL2vV5crbh
         ZC5uFTI26oUB0KWELFYDT+T99O7OW4b+pbIZ0xR0EVtlfP6rQHkA4nUvxz9LqKsv0p
         /NkiuqMmbwF4a671TWLzjYWuEAVDdWrtnIKsj5TA=
Date:   Thu, 25 Nov 2021 12:43:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Pavel Machek <pavel@denx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/154] 5.10.82-rc1 review
Message-ID: <YZ929M6+fNYMZ0fg@kroah.com>
References: <20211124115702.361983534@linuxfoundation.org>
 <20211124135311.GA29193@duo.ucw.cz>
 <CADVatmPhw41K9Eg75_7w89bgXLMnuGcJDNcsP0KMVxhkTQmTxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmPhw41K9Eg75_7w89bgXLMnuGcJDNcsP0KMVxhkTQmTxw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 11:37:14AM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Nov 24, 2021 at 1:57 PM Pavel Machek <pavel@denx.de> wrote:
> >
> > Hi!
> >
> > > This is the start of the stable review cycle for the 5.10.82 release.
> > > There are 154 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> >
> > CIP is running tests here:
> >
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> >
> > And there's a build failure in CIP testing there:
> >
> >   CC      drivers/mmc/core/sdio_ops.o
> > 5040drivers/cpuidle/cpuidle-tegra.c: In function 'tegra_cpuidle_probe':
> > 5041drivers/cpuidle/cpuidle-tegra.c:349:38: error: 'TEGRA_SUSPEND_NOT_READY' undeclared (first use in this function); did you mean 'TEGRA_SUSPEND_NONE'?
> > 5042  if (tegra_pmc_get_suspend_mode() == TEGRA_SUSPEND_NOT_READY)
> 
> I also having the same build failures for arm.
> 
> drivers/cpuidle/cpuidle-tegra.c: In function 'tegra_cpuidle_probe':
> drivers/cpuidle/cpuidle-tegra.c:349:45: error:
> 'TEGRA_SUSPEND_NOT_READY' undeclared (first use in this function); did
> you mean 'TEGRA_SUSPEND_NONE'?
>   349 |         if (tegra_pmc_get_suspend_mode() == TEGRA_SUSPEND_NOT_READY)
> 
> And it should be for 4d895b601038 (\"cpuidle: tegra: Check whether PMC
> is ready\").

Should be fixed -rc2.

thanks,

greg k-h
