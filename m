Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19698218AEF
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 17:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbgGHPPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 11:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729022AbgGHPPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jul 2020 11:15:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F103206DF;
        Wed,  8 Jul 2020 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594221304;
        bh=k+/PyAEzlmPrVB6eVQ5iEPosf+CPVaKBpAALEd84mWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z+fRuTcjTJoLSK1xhza1Z4PI4IrxS70ODpo1AnpPvwzQzR1x/7uozfzWuKdCq4qPy
         vqnosGIpgbdx6XrqsLXqRtp5IIURg84PJaryHAHE9uJMOoxDELN4NdNIwZrifewr70
         gKmpKmBFX54T7Q/DCO8iC/cup6xOdkO9dT4vXNlo=
Date:   Wed, 8 Jul 2020 17:15:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/65] 5.4.51-rc1 review
Message-ID: <20200708151500.GA710412@kroah.com>
References: <20200707145752.417212219@linuxfoundation.org>
 <6fbcdd30-68d3-e8c5-d762-7b8a8c48d112@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fbcdd30-68d3-e8c5-d762-7b8a8c48d112@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 08, 2020 at 09:41:33AM +0100, Jon Hunter wrote:
> 
> On 07/07/2020 16:16, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.51 release.
> > There are 65 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.51-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.4:
>     11 builds:	11 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     56 tests:	56 pass, 0 fail
> 
> Linux version:	5.4.51-rc1-g47d410b54275
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
