Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CDC2E9F5A
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 22:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbhADVKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 16:10:18 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4601 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbhADVKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 16:10:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff384110000>; Mon, 04 Jan 2021 13:09:37 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan
 2021 21:09:37 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 4 Jan 2021 21:09:37 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/35] 4.19.165-rc1 review
In-Reply-To: <20210104155703.375788488@linuxfoundation.org>
References: <20210104155703.375788488@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <702abb434946478fad437cfb0532303f@HQMAIL107.nvidia.com>
Date:   Mon, 4 Jan 2021 21:09:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609794577; bh=3NKzdzE9jSIbC32dmLsvsJ6Rbka/mGyDy5GlgJ4dz1s=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=IWOjVPBbfTKQ5A21AGwrF4yIxgbwzUHUSGYqBjZVdjHNbbDYkbYPzQ+U+8Cq9Sz/y
         BQeKUzn62OwzotzosbK3z01eDO01DRyOfwXWOwThg4C6PA/tHaj1b0kgXlctPR/Tts
         C3Sz69xtueixgIJomYn3OPx1u+3+gpqk8Z4nxu2bsENi575xSCom03qzSscX6Chhiv
         l9Ev8q2/vKE9bevHeZ9Ce/mr7aDbkx77yub5FKwliHP7N3xfgg5XbrIT4AR/wnab5H
         2Y4CBDw3gBn0jRyHoH0JfoFVsF8Ev68ewJ1icG0Is1D/VeMZhNTtJwFEWHMOFDy/cT
         cE7Jf5t8czb1A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 04 Jan 2021 16:57:03 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.165 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.165-rc1.gz
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

Linux version:	4.19.165-rc1-g32d98dff91da
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
