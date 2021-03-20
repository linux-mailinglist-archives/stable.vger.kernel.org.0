Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8E7342C7F
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCTLtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:32860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229748AbhCTLsn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:48:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 427A261967;
        Sat, 20 Mar 2021 09:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616233974;
        bh=3f8/2PqSkqDMVA67TW3WxPBdFspwHXmhHZBF29u3oCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DVFUcj6YOxqRGM6BcdEDMhmQzCGtWm5uLNdpLqIWJarJ2Egzzp+bTPG4NIXpERn4n
         CE00udGfa3UZIVjs0hcb1Ju8alX7DMh0KCErGOsa9CtOXYslKL8vSFeSFcb/9oVj2T
         or3ra6dARWRuwmnrPDPy3/QHpVYDO0Cn7/nbg214=
Date:   Sat, 20 Mar 2021 10:52:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/13] 5.10.25-rc1 review
Message-ID: <YFXF9PfJTzTvw92S@kroah.com>
References: <20210319121745.112612545@linuxfoundation.org>
 <7761fa50-3964-1d96-c478-9c65fc4aca11@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7761fa50-3964-1d96-c478-9c65fc4aca11@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 01:06:36PM -0700, Florian Fainelli wrote:
> 
> 
> On 3/19/2021 5:18 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.25 release.
> > There are 13 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.25-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:
> 
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

thanks for testing 2 of these and letting me know.

greg k-h
