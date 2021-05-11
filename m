Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367B537AC43
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 18:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbhEKQrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 12:47:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230315AbhEKQrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 May 2021 12:47:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AE2C61182;
        Tue, 11 May 2021 16:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620751562;
        bh=F8BGR6j49ixjR/v9I+J3FJp99JvGLqznTDTsYVAXsfI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x/5hMCMoiIHhcuWVE5hhEhSkBLFkjRvM+ceZRJn59hENeVUlTxNgAD2lg4lFHEKwA
         Rty44pc0p/EXFGrlyEb3zCsqAgPfzGsOWdMK3VYSlUEReSaECaVOQGMTO26kR+8Ccm
         Ju7P4XHY6xsEatT/0xSrddIc6PsxhJblBukFq9rk=
Date:   Tue, 11 May 2021 18:46:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/342] 5.11.20-rc1 review
Message-ID: <YJq0yCirpEV+bgC/@kroah.com>
References: <20210510102010.096403571@linuxfoundation.org>
 <396382a7-9a50-7ea1-53a9-8898bf640c46@linuxfoundation.org>
 <YJqIOajso0EyqgjO@kroah.com>
 <3244bd40-3afa-8386-3378-220ff2e2527d@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3244bd40-3afa-8386-3378-220ff2e2527d@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 11, 2021 at 10:16:00AM -0600, Shuah Khan wrote:
> On 5/11/21 7:35 AM, Greg Kroah-Hartman wrote:
> > On Mon, May 10, 2021 at 04:48:01PM -0600, Shuah Khan wrote:
> > > On 5/10/21 4:16 AM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.11.20 release.
> > > > There are 342 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.20-rc1.gz
> > > > or in the git tree and branch at:
> > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > 
> > > Compiled and doesn't boot. Dies in kmem_cache_alloc_node() called
> > > from alloc_skb_with_frags()
> > > 
> > > I will start bisect.
> > > 
> > > Tested-by: Shuah Khan <skhan@linuxfoundation.org>
> > 
> > It might be due to 79fcd446e7e1 ("drm/amdgpu: Fix memory leak") which I
> > have reverted from 5.12 and 5.11 queues now and pushed out a -rc2.  If
> > you could test those to verify this or not, that would be great.
> > 
> 
> I am seeing other display issues as well. This might be it.
> 
> I couldn't find rc2. Checking out
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> linux-5.11.y

Ah, sorry, pushed the -rc2 patch out now, but the -rc git tree has it as
well.

greg k-h
