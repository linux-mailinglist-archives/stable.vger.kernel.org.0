Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96CA2DA9B3
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 10:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgLOJGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 04:06:51 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10008 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727881AbgLOJGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 04:06:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd87c810003>; Tue, 15 Dec 2020 01:06:09 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Dec
 2020 09:06:08 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 15 Dec 2020 09:06:09 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.9 000/105] 5.9.15-rc1 review
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c9257d9dd7a74ae1ba4cb25d4c1e7050@HQMAIL101.nvidia.com>
Date:   Tue, 15 Dec 2020 09:06:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608023169; bh=cuwO6nuUqcAyc5CYdb0OLzLFmlJaXaaoDSRLlJM56kA=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=qxF5XLalU/lxIBNPUCrgFg4TCMFAbWMD7/ZsVVPYGd/oDCPy4R0TsGWdywcBo+dO/
         Ui+2XGCCnGpU3LY/MqdTBYw0kQgUO1Jum2Bt1ES7DVtB2d3l45PT6jsr7y+apW6zZz
         DRjy20tWIg33rF7iNX+yOVUvobs0OxNoguipxQGa83IbKPm/QtZW5G9gMesHHFTS9V
         oZzsonCLvUWqPi0iWq6T6fh+ismej7woP/wNhlVtr07JryMuFfpKyMRBw/DnyXKBMK
         OWTOPITQeeqxGr5w/LR4FIQew8xw9kHtdrpLWzbFNunsHJjGOsHnD9na1U0+92aKA5
         2zhPmxEnj9axQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Dec 2020 18:27:34 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.15 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.9:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    64 tests:	64 pass, 0 fail

Linux version:	5.9.15-rc1-g609d95a95925
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
