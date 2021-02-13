Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06AE31AB73
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 14:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBMM7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 07:59:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhBMM6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 07:58:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3F4164E43;
        Sat, 13 Feb 2021 12:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613221095;
        bh=wQwgdhXBHvScTv0xckg2yNIO5jxqpK+MGNQYpLPHEK0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LBXOw1HmnVne6IwYYwyrINeWugPS7luYJt7ckiR2obS1gifdXbMlSoJmu53aHjaJY
         Q7wwmMjG9DtqHfbUwY5Y21X+djyeJF8zBuv01xoDOc/G0At3usXBQx+ZjVMlezD1v7
         TJarbij3Za/US3ghTftJIgQkODgbQa+MJ4mOiIxE=
Date:   Sat, 13 Feb 2021 13:58:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/54] 5.10.16-rc1 review
Message-ID: <YCfM5PBdvtB2D+5x@kroah.com>
References: <20210211150152.885701259@linuxfoundation.org>
 <6d521b40-3b84-decf-a137-daf4299af2ef@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d521b40-3b84-decf-a137-daf4299af2ef@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 11:21:26AM -0800, Florian Fainelli wrote:
> 
> 
> On 2/11/2021 7:01 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.16 release.
> > There are 54 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 13 Feb 2021 15:01:39 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.16-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> On ARCH_BRCMSTB, 32-bit and 64-bit ARM, thanks!

Thanks for testing.

greg k-h
