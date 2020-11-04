Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F5E2A6012
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgKDJE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:04:27 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3944 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbgKDJDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 04:03:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa26e760001>; Wed, 04 Nov 2020 01:03:50 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Nov
 2020 09:03:48 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 4 Nov 2020 09:03:48 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/214] 5.4.75-rc1 review
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <727c3455ecae48c891cfbdc1cbd30509@HQMAIL101.nvidia.com>
Date:   Wed, 4 Nov 2020 09:03:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604480630; bh=5eKjzNfq29q6uulNSITXGoqiOXHMrsRpJujOQYUoOII=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=T+NioGRZHHYDoP3kJGTVFz+xMDhn7CfX1Ob6H30438MHyTTljI83qeMv9QWSZYVk5
         PJkeYWQW4EnZ0MszPbiN6W2jaJHFmah2amWeO323Qe3zxEv0H0zwlWqxUgQ+IjuLYm
         SmvyTk4J0i+YPdgDbsqbSCIIFTChy9sJ0/WEdwuMUIl/Qal/D25iRn2GstaJVm5fgh
         XZ46mJAysPyjEsaHOxyRNJwsKItWoHLMx6QgGgEZZ3uHohdetShixqpYx6q4gPBnlD
         n/o6VLxPZBD1Aso8Fc294MjsSrF6FhwI2rBnW3Hpw+gfIIQeROd43eokQQhetaNtl0
         MhDLZrNmcIOkQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 03 Nov 2020 21:34:08 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.75 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.75-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.75-rc1-g1b513bf28609
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
