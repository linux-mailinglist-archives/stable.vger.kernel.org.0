Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FB5303E09
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 14:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392446AbhAZM6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 07:58:36 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6704 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728772AbhAZM6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 07:58:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601011850000>; Tue, 26 Jan 2021 04:56:37 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 12:56:37 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 26 Jan 2021 12:56:37 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/87] 5.4.93-rc3 review
In-Reply-To: <20210126111748.320806573@linuxfoundation.org>
References: <20210126111748.320806573@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <5d19171556ee4ce0b200619816c33b50@HQMAIL111.nvidia.com>
Date:   Tue, 26 Jan 2021 12:56:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611665797; bh=YKqiQju3M4VkPwOkvzZI6P+anZS5e2jrMxMnBN9Ae+8=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=akYhW1ceDREzX+HVulUs2cQm7oo7qntP384AlRzNosSoZgxtt1yehDeDiSPbjJE4w
         0rG9F/yBJQcjG0ERiBs5yDfRwGnGm4Ihfzo1uQqWGHTxuGXoeWN1vgCdlEAA01GQWw
         b01thWinkC6gSTPaI1yp4Zr8rsxRqPoecdoqrJOvJdw38M7wWUkjxmg9z026AqxsNG
         OEsg0z7TxlXY9nIC+GR43guVsH5jqAFDjacYCua+e6sx58eAIDvg9odQ5FQgUqT+i9
         bR62IujImIGa4SVHIXMiAY/jf26734r0VI2qjAt9bHEKLC488vqq1zcMvjDwA16Hb6
         5dsD0+44mQCGw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Jan 2021 12:22:10 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.93 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Jan 2021 11:17:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.93-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    57 tests:	57 pass, 0 fail

Linux version:	5.4.93-rc3-ga2ea77508efe
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
