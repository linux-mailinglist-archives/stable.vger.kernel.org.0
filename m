Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79ABD30CD02
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbhBBUZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:25:57 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15388 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhBBUWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 15:22:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019b44c0000>; Tue, 02 Feb 2021 12:21:32 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 20:21:32 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 2 Feb 2021 20:21:32 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/61] 5.4.95-rc1 review
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6b0fb08a2abd4d92a114919320c30f3e@HQMAIL101.nvidia.com>
Date:   Tue, 2 Feb 2021 20:21:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612297292; bh=it7LwPdKsAvGDnxU1Sg8ooBo9/q6Tta8K3vdKoFnYgk=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=Au/hgx3/2jeKyTBHW3YIwCTBUFHcdxn6CQkI496EMyP8O/oWrqUNbddIy97cLWpuF
         o+Bwp9Bc3KZ7cWR5BhdgQNBqJjN6aC4FYjWCRvTivQ+yX1IP1EQh+7saP/fH3HaZ4K
         p8qtYyp/ysluzXe1Rs7E9NOs6SSdN28JpzoZyfYkHCsZCSAIznPSgYQeIuc/qV6UOj
         ClPHM6/pLNquKk10x3ZOIyYBxZ7Tltx9U0vQDRcoJhjVY3VMbiuYPgTi/Zz/mQ9K/q
         Z0dw+nH5FxWNbXyLzCs3pkJGO+RSWxsh2zs8jyBdW2I9gWCOslOuwPB87QiZb7ASkl
         taysgWgAum26Q==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Feb 2021 14:37:38 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.95 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.95-rc1.gz
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

Linux version:	5.4.95-rc1-g339dd34feba5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
