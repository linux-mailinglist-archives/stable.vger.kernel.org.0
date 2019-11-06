Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFACDF144F
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 11:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfKFKtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 05:49:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:41578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726656AbfKFKtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 05:49:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E376217F4;
        Wed,  6 Nov 2019 10:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573037364;
        bh=YnATn4tTC8BKqPfswbJbw2vm2aawmuOV2Tuu1fxIS14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qVrFfwG12MpSovAW8TA2bMqTmfB0/wX1DYB44Oe+dlJMXiN41GSpyPfw2+PkTybni
         FFAqhDkommVGO3JhbBVcUwfpTWR3OzeZE8Bs9s6UrupaH8zlBO88hZwFpuHPn15RY4
         wbgmj5x9mfd0xgG2niCxsYj1VLDwHRpkfr2TM3zU=
Date:   Wed, 6 Nov 2019 11:49:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/149] 4.19.82-stable review
Message-ID: <20191106104921.GC2982490@kroah.com>
References: <20191104212126.090054740@linuxfoundation.org>
 <6e8b6e19-0d66-beb0-8e16-7975aa1d462a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e8b6e19-0d66-beb0-8e16-7975aa1d462a@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 11:46:05PM +0000, Jon Hunter wrote:
> 
> On 04/11/2019 21:43, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.82 release.
> > There are 149 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.82-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
> > Jose Abreu <jose.abreu@synopsys.com>
> >     net: stmmac: Fix NAPI poll in TX path when in multi-queue
> 
> The above commit is causing a boot regression on Tegra186. Bisect points
> to this commit and reverting fixes the issue.

Thanks for testing this.  I've dropped this patch now, so all shoudl be
good.

greg k-h
