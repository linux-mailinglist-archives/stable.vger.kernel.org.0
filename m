Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4233305913
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 12:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbhA0LB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 06:01:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234649AbhA0K72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 05:59:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3CFF20773;
        Wed, 27 Jan 2021 10:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611745003;
        bh=5Paldr9oHGW2PH6cXnch+wDTx8ucYUxFJpjlRHAQQT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KO5+Tv5JCLMhWr7e8oQnSfAanrRcyRI3bLlLIyC/Uis8cAp0fLHV8h8Oaw60r47Td
         1DT45cHo5oFXh/guc7o8+jLEz6QnS7ya8rZe4rzsycXylXFmWAXXAJh7CBg2hcanYu
         00XLcqOetXcrUp+kbA1pVt4c2DOUd+8Q7z4Ki83Y=
Date:   Wed, 27 Jan 2021 11:56:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 000/203] 5.10.11-rc2 review
Message-ID: <YBFG6NKt4LxnJLW8@kroah.com>
References: <20210126094313.589480033@linuxfoundation.org>
 <bf085f01d1eb42c6948fa25a6a70c15d@HQMAIL107.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf085f01d1eb42c6948fa25a6a70c15d@HQMAIL107.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 26, 2021 at 12:56:52PM +0000, Jon Hunter wrote:
> On Tue, 26 Jan 2021 11:03:12 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.11 release.
> > There are 203 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 28 Jan 2021 09:42:40 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.11-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.10:
>     12 builds:	12 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     65 tests:	65 pass, 0 fail
> 
> Linux version:	5.10.11-rc2-g460ab443f340
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing them all and letting me know.

greg k-h
