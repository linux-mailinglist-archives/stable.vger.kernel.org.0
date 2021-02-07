Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD6C31248A
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 14:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBGN0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 08:26:38 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9318 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhBGN0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 08:26:38 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601fea650000>; Sun, 07 Feb 2021 05:25:57 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 7 Feb
 2021 13:25:57 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sun, 7 Feb 2021 13:25:57 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/17] 4.19.174-rc1 review
In-Reply-To: <20210205140649.825180779@linuxfoundation.org>
References: <20210205140649.825180779@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <318103edd34f42a5bb0b8f69f72df5e9@HQMAIL101.nvidia.com>
Date:   Sun, 7 Feb 2021 13:25:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612704357; bh=DNVEuEcjD2E72iGaJvRm91AvVsH6Z444NXMICZViNcY=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=aUP0yW+Sopc+dk7IiHX2NHSxCtxeBGDfp0AOI5seXUzFHEFPDg5Et0OWnEp4cEOkZ
         7QgMp5+sgYR++89A158m53vO1YgCis4+sYSQJZmulv6BH2xalC2B9jIIsFyvP3WFpf
         YKxHkITo8xC3UZrB/ljpgDhjfubP/DaMh+c4GvqLBSE67Q7FJHz7usxdX4GPzKLEye
         sSFKnWasuorLn3BFLgw/H9V6R+G00x70GK5HOto/gMh/SEXyGrHePLGEr4OTxGHfw5
         j2SDmYGWLbvSnj1W6ulccDPFA+PAldbeS9TwGAiW1OKDkCfuu7jtyxX2OHhnOWi0gc
         kfy5N8VTa34dg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 05 Feb 2021 15:07:54 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.174 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.174-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	4.19.174-rc1-g7a4e5f94ac6c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
