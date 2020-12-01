Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8766E2CA406
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 14:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390786AbgLANkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 08:40:01 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4872 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387823AbgLANkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 08:40:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc647890000>; Tue, 01 Dec 2020 05:39:21 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 13:39:21 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 1 Dec 2020 13:39:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/42] 4.9.247-rc1 review
In-Reply-To: <20201201084642.194933793@linuxfoundation.org>
References: <20201201084642.194933793@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <13fa51af55bb4dc099a437d771633fbd@HQMAIL107.nvidia.com>
Date:   Tue, 1 Dec 2020 13:39:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606829961; bh=wKqIFbK0D6fRHgAwJDm4aoiFDtsrwOqLNS9dgnYWBgI=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=avWVarWiU7xdQryvLJdDKqhbHcLHF5xAhvwCLyluP/YOoPvriBi0L+sw06gfqubTI
         jZvLufTnNotkDsjQKqebjuEOr0KiIcPaXVGgW7JKQtRsMV5vWoeFtIt1Z92FrK5Cdu
         3+l8J0ydnULAgMzkN5O7DGfNy5sPXe8bZlhCqKabme5shJMOfVeft/akOQf+CfX2yh
         l059+3V5pyWVEXKWSLjbbQDyOY6vpdc5rk5Axr1U8KI47sck/ZBXxmABNo4bVV7jwN
         pVoZ1MimU7LOBUo4N7aB6xMB84y1Fw6fKNYrFu0XB45ht6HbJl+xZFBw86DGve/RFQ
         y0BVJLz1i5i/g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 01 Dec 2020 09:52:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.247 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Dec 2020 08:46:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.247-rc1.gz
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
    10 boots:	10 pass, 0 fail
    16 tests:	16 pass, 0 fail

Linux version:	4.9.247-rc1-gc2b4ff37ba1a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
