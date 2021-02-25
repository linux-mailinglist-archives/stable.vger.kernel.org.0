Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D61F324F67
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 12:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhBYLsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 06:48:15 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12925 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbhBYLsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 06:48:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60378e530000>; Thu, 25 Feb 2021 03:47:31 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Feb
 2021 11:47:30 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Feb 2021 11:47:30 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/23] 5.10.19-rc1 review
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
References: <20210225092516.531932232@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <f34e35522eb9444dbafab12a9049636b@HQMAIL109.nvidia.com>
Date:   Thu, 25 Feb 2021 11:47:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614253651; bh=JEy/ADcfnVzm4UMRHnngK6RhSYinQ47Vv1AkQdVAyrI=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=Z6LE6LfQUdExkg/Vy4dYvltUYr0lT0sRl6t4WN/7OcmCRUE/7cEQm37SbuC6oyA9/
         SzDIaO6SCwl45bcsEyC2IXNggA5luaOMApGSsgLOHr33v80KPi34/9fGS4RtwS/Lq6
         JroUzfnyuZbqZxFGmWfHqWoR81GCenX93H+wmuwM2NoLB+o5rkyV/IsVR6KGCbgRaY
         NRFvAUsXfKc5aScg8mC7lZB2sPkC2hhSsrJ2/kGysvCogZhArkhhRaCgJrsIs+Ns6F
         p3SYmYGm+E0NIx9lXGnPvzYWC8JSPbwfsBgQFCdxquGvrTEyqBQMIS1APsayqeGqDX
         sTzWdQ7TctqFg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 25 Feb 2021 10:53:31 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.19 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.10.19-rc1-g6ffb943c0e01
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
