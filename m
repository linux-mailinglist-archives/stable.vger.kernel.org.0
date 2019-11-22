Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3D0107370
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 14:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfKVNjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 08:39:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbfKVNjf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 08:39:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0F5020707;
        Fri, 22 Nov 2019 13:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574429974;
        bh=OaTkTRciIPDqoACUtaLVXQi7qarg4p4CSsxYidcVIPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x/Ds7kYOKh106g74lnHPE6OuxTJYaWK8rHydi2xbE5m/hA3iE8tOTqxWcOahH9+wZ
         kuMRsQKalNlmoBERfr/kC0NLexbxsTuswY4FvU+R7Yjzs8nV1JDNx3Bf9pNVqDhMC7
         En3x4RfYbe4p36H+Sw7JB2uqCmOeJxKVMmlEoZi4=
Date:   Fri, 22 Nov 2019 14:39:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/159] 4.4.203-stable review
Message-ID: <20191122133931.GA2033651@kroah.com>
References: <20191122100704.194776704@linuxfoundation.org>
 <f0f505ae-5113-1abd-d4f7-0c3535c83de4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0f505ae-5113-1abd-d4f7-0c3535c83de4@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 01:14:28PM +0000, Jon Hunter wrote:
> 
> On 22/11/2019 10:26, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.203 release.
> > There are 159 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.203-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> 
> > Marek Szyprowski <m.szyprowski@samsung.com>
> >     ARM: dts: exynos: Disable pull control for S5M8767 PMIC
> 
> The above commit is causing the following build error for ARM ...
> 
> Error: /dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/boot/dts/exynos5250-arndale.dts:560.22-23 syntax error
> FATAL ERROR: Unable to parse input tree
> scripts/Makefile.lib:293: recipe for target 'arch/arm/boot/dts/exynos5250-arndale.dtb' failed
> make[2]: *** [arch/arm/boot/dts/exynos5250-arndale.dtb] Error 1

Ugh. I'll go drop this from 4.4.y, is it also an issue in the 4.9.y
tree?

thanks,

greg k-h
