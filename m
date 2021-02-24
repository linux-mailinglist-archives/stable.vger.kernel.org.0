Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8248323BCE
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 13:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhBXMQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:16:37 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7414 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbhBXMQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 07:16:36 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6036437c0002>; Wed, 24 Feb 2021 04:15:56 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Feb
 2021 12:15:55 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 24 Feb 2021 12:15:55 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.11 00/12] 5.11.1-rc1 review
In-Reply-To: <20210222121013.586597942@linuxfoundation.org>
References: <20210222121013.586597942@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c38a6ba670854c5e80160872b12fb5a0@HQMAIL107.nvidia.com>
Date:   Wed, 24 Feb 2021 12:15:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614168956; bh=ubQXNKBjBdT50uTBmfGvF/XeQm4mQAjg8RhnOs70Pqc=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=kHMWzQQ2j/v+l5ZOfJk+8J8ZD3/n4qINDBdYGqXoJIpHeNPHQGDJ36I39zm4BVd1p
         vjJCh7ZXOUgO0wg46xiqzt1ekc21l3X/7GFD6RyOtm+zeFOADrg3nHt5sMguChFfkh
         kVAe8FxVyTioYCDjcP6PRodUToIVhtr6H2MRnZY1aBs/SjnVJ5EBDd73fsO729wPMa
         jcs7FuHBeUR+Upvm2MzwWxmJCF6rhqmEG3CbczLti3evoJKYsnZlKgr3EAKkmD83wm
         gZKCY2bJvGnwvhFWHyC0YW/ffQ2wCFsLlCutwniSZi8Oxu2plThEHOX+RI8IUz6EIH
         S5cm5x55t8F1g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 22 Feb 2021 13:12:52 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.11:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    65 tests:	65 pass, 0 fail

Linux version:	5.11.1-rc1-g6380656c9227
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
