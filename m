Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6479316102
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 09:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhBJI3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 03:29:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230034AbhBJI33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 03:29:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94EB764E25;
        Wed, 10 Feb 2021 08:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612945726;
        bh=eT7rZ77FLbTB9DY1MARNVwGBfPimhor3rd8ZuhuFvHc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d6OSacDZz+d+RaWPE9R/HnSPvYz7hW4+6tNuzfBJWzpXffRSIsx/spZLRi9qq0eVa
         NIpTtQ9H2ZueF7qH/6e/JE4MFlp+ygQYgGykEvObOe/T9cd2KdELNLlmpY9wrV9UGg
         l1UrCvS2loegXSXsQ6Sy90P8023gtM6NMElJMGEg=
Date:   Wed, 10 Feb 2021 09:28:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/65] 5.4.97-rc1 review
Message-ID: <YCOZO0NTr0jEEl6w@kroah.com>
References: <20210208145810.230485165@linuxfoundation.org>
 <ca458ba2-8511-4566-fe69-846ffaf339a6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca458ba2-8511-4566-fe69-846ffaf339a6@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 09:39:52AM -0800, Florian Fainelli wrote:
> On 2/8/21 7:00 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.97 release.
> > There are 65 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.97-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> On ARCH_BRCMSTB using 32-bit ARM and 64-bit ARM kernels, no regressions
> observed, thanks!

Thanks for testing and letting me know.

greg k-h
