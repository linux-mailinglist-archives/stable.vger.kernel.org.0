Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C83532BC3B
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444569AbhCCNqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:46:38 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17683 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357409AbhCCKtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 05:49:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603f569e0000>; Wed, 03 Mar 2021 01:27:58 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 3 Mar
 2021 09:27:57 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 3 Mar 2021 09:27:57 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/134] 4.9.259-rc3 review
In-Reply-To: <20210302192532.615945247@linuxfoundation.org>
References: <20210302192532.615945247@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <ecc1d79d54eb4e2481060c4b0f9fc90f@HQMAIL101.nvidia.com>
Date:   Wed, 3 Mar 2021 09:27:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614763678; bh=fLL/Tx52LwtfgRwr90+b5A3UHkVG8d4+wwISRB1VaJ0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=im2W3KtdN4bHYNCwZJLB9x0oVAtrp2356e4tiue+kFEJ7sZq9yOBWSDFb9RqFxk0J
         56oVWQq0yp6eyPbWsqXs1CEhkvNNMh0nlGweGTiOhO8Du2JSLdLl5aWhOxKcGg8UZ5
         A1DoLoaLCzrFvBflrYyhEY/SicDHZtASkGkN2HdsGUl04XULVg4mXA7OcySb/fXeKM
         vdbzVyBwYP8ZN5iauUzxbFcm8BVhGggqbWTAApEIkNF1tN48dGGu/sAXI0picN77WM
         ZRto7kKRUZodR9HEXZ3vMMFScpI/mOe21njZLzrsc/ceDYIU59iUCCydMF02QTWYOd
         faZuCViaJ9RBw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Mar 2021 20:27:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.259 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.259-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.259-rc3-g90d5aacad5cf
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
