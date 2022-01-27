Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205CB49DA7C
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 07:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbiA0GQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 01:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiA0GQO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 01:16:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1966C061714;
        Wed, 26 Jan 2022 22:16:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF551618A2;
        Thu, 27 Jan 2022 06:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C5FC340E4;
        Thu, 27 Jan 2022 06:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643264172;
        bh=lZwYG95eO5pFfWBmdFU1ZY9Kd3lJ8UcCCL1Hab9kqU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FX7HotymwouOw0UD7ZtvX0IunYJmLQYGYVGklVmrX4ny6UFtnDdNCgl9Ma78UeYeY
         bJ9t8Uo0DKKgMdI3fXEBJPqMA2GdV12rb5JMLd4gN7TfahJoX5y1QzQ6MZV84dgQcz
         U82iLis1Je9k6VUNl2vZzJoYTMUrSpNFHGliOdGw=
Date:   Thu, 27 Jan 2022 07:16:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        lkft-triage@lists.linaro.org, linux@roeck-us.net
Subject: Re: [PATCH 5.16 0000/1033] 5.16.3-rc2 review
Message-ID: <YfI4oDEY7W4lxWZP@kroah.com>
References: <20220125155447.179130255@linuxfoundation.org>
 <ddd3f2e1-ed1d-82ce-cc8e-562be2ae5152@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ddd3f2e1-ed1d-82ce-cc8e-562be2ae5152@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 11:11:47PM -0600, Daniel Díaz wrote:
> Hello!
> 
> We didn't get the notification for this release candidate. Thanks for the heads up, Guenter!

Yes, as I responded to Guenter, no one did, that was a bug in my scripts
due to the size of this series :(

> On 1/25/22 10:33, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.16.3 release.
> > There are 1033 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.3-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Results from Linaro's test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> ## Build
> * kernel: 5.16.3-rc2
> * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> * git branch: linux-5.16.y
> * git commit: 39cb7e05eaf4fd55c6445fe8fe9ffa7f8d329205
> * git describe: v5.16.2-1034-g39cb7e05eaf4
> * test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.16.y/build/v5.16.2-1034-g39cb7e05eaf4
> 
> ## No test Regressions (compared to v5.16.2)
> 
> ## No metric Regressions (compared to v5.16.2)
> 
> ## No test Fixes (compared to v5.16.2)
> 
> ## No metric Fixes (compared to v5.16.2)
> 
> ## Test result summary
> total: 105828, pass: 89914, fail: 1186, skip: 13585, xfail: 1143
> 
> ## Build Summary
> * arc: 10 total, 10 passed, 0 failed
> * arm: 263 total, 261 passed, 2 failed
> * arm64: 42 total, 42 passed, 0 failed
> * dragonboard-410c: 1 total, 1 passed, 0 failed
> * hi6220-hikey: 1 total, 1 passed, 0 failed
> * i386: 40 total, 37 passed, 3 failed
> * juno-r2: 1 total, 1 passed, 0 failed
> * mips: 37 total, 35 passed, 2 failed
> * parisc: 14 total, 14 passed, 0 failed
> * powerpc: 56 total, 50 passed, 6 failed
> * riscv: 28 total, 24 passed, 4 failed
> * s390: 22 total, 20 passed, 2 failed
> * sh: 26 total, 24 passed, 2 failed
> * sparc: 14 total, 14 passed, 0 failed
> * x15: 1 total, 1 passed, 0 failed
> * x86: 1 total, 1 passed, 0 failed
> * x86_64: 42 total, 42 passed, 0 failed

<snip>

No Tested-by: line?

