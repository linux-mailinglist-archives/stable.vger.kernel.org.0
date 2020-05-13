Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD89D1D1684
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 15:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387669AbgEMNya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 09:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387593AbgEMNya (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 09:54:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E94652054F;
        Wed, 13 May 2020 13:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589378069;
        bh=OaCIyJaknHnXL4A2CM7xPhFVRnnkmUrAQr7NCYr0ZWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FujL5I+sarhZUbmaL7dIqwNkRuJxH0NKNVktbQbYiAkWVKnFDX/BibiUV+JYONJZ2
         GydfOikgiNggwDWrjauLcDc6XuWV84EfdkhQD68FTDmK2KkOPfpFQ9Qvg35Yf9Jvbo
         +WngV9Nk5Uky9RIrV6ktKwruTgCOBPHiatH2PP2Q=
Date:   Wed, 13 May 2020 15:54:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.6 000/118] 5.6.13-rc1 review
Message-ID: <20200513135427.GB1309267@kroah.com>
References: <20200513094417.618129545@linuxfoundation.org>
 <12592104-9a83-5b19-be42-5bbf92198ad7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12592104-9a83-5b19-be42-5bbf92198ad7@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 13, 2020 at 02:46:31PM +0100, Jon Hunter wrote:
> 
> On 13/05/2020 10:43, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.13 release.
> > There are 118 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 15 May 2020 09:41:20 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.13-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.6:
>     13 builds:	13 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     42 tests:	42 pass, 0 fail
> 
> Linux version:	5.6.13-rc1-gf1d28d1c7608
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Wonderful, thanks for testing all of these and letting me know.

greg k-h
