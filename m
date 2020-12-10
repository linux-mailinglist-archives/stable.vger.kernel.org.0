Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB382D6965
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393975AbgLJVFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:05:52 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16975 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393966AbgLJVFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:05:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd28d820000>; Thu, 10 Dec 2020 13:05:06 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 10 Dec
 2020 21:05:06 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 10 Dec 2020 21:05:05 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/54] 5.4.83-rc2 review
In-Reply-To: <20201210164728.074574869@linuxfoundation.org>
References: <20201210164728.074574869@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <d1ac11c31347472ab297ba2694976c2f@HQMAIL107.nvidia.com>
Date:   Thu, 10 Dec 2020 21:05:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607634306; bh=HfVhVBbDhkHz9K1GPRRKR/1hqozS5pN9fa/3DmCV2ck=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=UtwYA43gsxXNCCyAJaP39oqowdfJSU3WvqekJg1dkYVHySUMknYst9jPfT7BLyQNx
         XCShwnxmUy+P2VOXD9cK1w/vqspHCNH8/FqvH+pSNVvQcFOBCu2d85UTaUm6taV5M5
         JA5/G0QPQ37qO0pJpOyGUOre1Af6U6Ed5hhTcWi7ZVAWS9p0vT2MfvcQ3mOAsduJ3h
         mOsdsistxm21RGBBbu63Dohd62c1MflT81rmjMWGBqRRlRbmzFGI+lgWFnZlbmn7dr
         +xjIFQ9InX1rcYX/LiK+WqbKFURaPps1s/o7fMGt1IqbHTQqNDdj5oxsyqOyrUYE9J
         HxRvWvYIKm2tA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Dec 2020 17:47:50 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.83 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Dec 2020 16:47:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.83-rc2.gz
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

Linux version:	5.4.83-rc2-gfc1de0dc4276
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
