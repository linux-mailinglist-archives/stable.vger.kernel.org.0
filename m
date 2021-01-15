Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C7A2F8086
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 17:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbhAOQU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 11:20:26 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17742 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727383AbhAOQU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 11:20:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6001c0a10000>; Fri, 15 Jan 2021 08:19:45 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 Jan
 2021 16:19:45 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 15 Jan 2021 16:19:45 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/28] 4.14.216-rc1 review
In-Reply-To: <20210115121956.731354372@linuxfoundation.org>
References: <20210115121956.731354372@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <9bf94562aef044b1a03ffc59311a3f20@HQMAIL109.nvidia.com>
Date:   Fri, 15 Jan 2021 16:19:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610727585; bh=+uUSGYpUgG3Cyjluu/L/pf6HG6dWnjDMFL0E0IWzh7A=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=dAydXgFfbj6Y4sgPE2a5xFDtOrSKHvb6PRwYjhbyPOmN2qa12q/knd9s2py2iqpwQ
         bSJ2AUBCK4E5VRiqZe23vNZtYt466rG902YTTRd9T6ji7L7rg4WWJR5x3yNmxX7Zz4
         7SFf2sU2hBHpudstfds+AdLDk2UX6HRkYGT4ZSKvCgl0+nbrICJfCTi8ahZOBxXYFG
         1HFfSp7hw7Mz0eqLjV0aFLO1wgMmJ/W/6aCUzILoxbEuqdX9rf0Yqf2q4V842Y+CY0
         oAd8FJ2Bf/6/mu3AZjOwvy9U9WGPzyfb1vVAWRwXBJL2u5YU8NTk6StKovCHO1VLR9
         mp3f9rBdRo+nA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 15 Jan 2021 13:27:37 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.216 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.216-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.216-rc1-g4cfcf012355f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
