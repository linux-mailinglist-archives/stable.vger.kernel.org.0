Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E6430CCFC
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhBBUYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:24:08 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15330 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhBBUVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 15:21:49 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019b4340001>; Tue, 02 Feb 2021 12:21:08 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 20:21:07 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 2 Feb 2021 20:21:07 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/30] 4.14.219-rc1 review
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
References: <20210202132942.138623851@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c82ebfcaa88a43dfb9d71cafde3a2e30@HQMAIL109.nvidia.com>
Date:   Tue, 2 Feb 2021 20:21:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612297268; bh=lcgK5yUU+ajmbpS1IDl/Z5DybwmXlHxLU7GGwbCPY6c=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=Ma6Ccz+q47vEXjUpZwj2Ki7fhhtSTpBmr6BiIbk+943e2Fh3CGtI5gLLXBz7ZX6GS
         zdI2qukbAr6Dk4xvj1zZkAyYYTNiZdrRbNweHt2GY/svym/KLYGRvcx/x63jaluKam
         XsaECY+lnaRGcDw77UQWCbsLEfys+N4wEXvCa4BpyKGxEYwCle1tI9DqtOw5bL6HNe
         WlppTMEfKQX1LtMXuBFcANkxNsTF0TH/mNRUGn64HstQF2KOoNX0iM8CpWTakoE47X
         uw9sW4fTf5L+HnL6CTGqBmEWAYr4QE67EwUAZWMxcVl27XNM9e429qwEKv6mg7wwrI
         xiQgWoy26rrzQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Feb 2021 14:38:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.219 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.219-rc1.gz
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

Linux version:	4.14.219-rc1-g17dd434cff6b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
