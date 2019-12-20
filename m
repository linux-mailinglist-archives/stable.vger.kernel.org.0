Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF599127BF3
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 14:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfLTNuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 08:50:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:52382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727344AbfLTNuQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 08:50:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC382206A5;
        Fri, 20 Dec 2019 13:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576849815;
        bh=d6Otj9t5sDgORz+jKTWMYY9dgD2Dh6hoeA2SKUDFRDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RcV4w7AKQSsbG8zDxMKA/epP9edP28ffbVS95LGza3y9xSmkPsf3/lV1d84BJgFns
         0CdbMV9W7u2n3zeCdBDjZoj4foEkfbihUUvE3lPOgx2NIwchcDp5BxV9j/MC722vQT
         SM8d6hd51HtdTaHFM1Oxvll7M3/ohoqVATfKmeJQ=
Date:   Fri, 20 Dec 2019 14:50:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/80] 5.4.6-stable review
Message-ID: <20191220135013.GC2268675@kroah.com>
References: <20191219183031.278083125@linuxfoundation.org>
 <ceff4a51-e936-7efb-1731-ef2afa340363@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ceff4a51-e936-7efb-1731-ef2afa340363@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 20, 2019 at 10:30:24AM +0000, Jon Hunter wrote:
> 
> On 19/12/2019 18:33, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.6 release.
> > There are 80 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.4:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.4.6-rc1-g2929dbca18db
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

thanks for testing all of these and letting me know.

greg k-h
