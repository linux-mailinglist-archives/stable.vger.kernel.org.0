Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B132BB10C
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbgKTQ4g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:56:36 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4082 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730229AbgKTQ4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:56:35 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb7f5380000>; Fri, 20 Nov 2020 08:56:24 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 16:56:35 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 20 Nov 2020 16:56:35 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/17] 4.14.208-rc1 review
In-Reply-To: <20201120104540.414709708@linuxfoundation.org>
References: <20201120104540.414709708@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <909b2963ba634f4e9ace1060d98a6808@HQMAIL101.nvidia.com>
Date:   Fri, 20 Nov 2020 16:56:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605891384; bh=dXRff4dLtS399zyrPfHSC9fkTnhupePTY8NpG1omBzw=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=O2dOjoVJD2NxI4mma/E32Mqq4mmH7GQqRGPRPjbeleDfgy9HvonuMxy6BtyskXYh4
         UZlByDe6x1EtVOY34fv/avswB0XCsAGXgfqgItyRB3eMmZU1j4nFnzWqoHv7vRKSgG
         UlGJ7qltQaiuqnlPWGv56KkAbfOn1eT+S1NZ8eeF5amAEvRZJytFQiQlerm3DhiB2j
         5DjZQyefOC2/U3m01lWfnYl+MO+D0jF5nHf7BWe5I5ZrTo5/a3lH0wdGg0rrvZTnKt
         Kt+rMdbXuLynjYDALyUYR8obDg18kUoWea/OVJJb1H/k5+ZlAKnqckULTq0Xp2Pt8m
         SFvhrjMMoQhHg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Nov 2020 12:03:11 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.208 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.208-rc1.gz
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
    10 boots:	10 pass, 0 fail
    16 tests:	16 pass, 0 fail

Linux version:	4.14.208-rc1-g6334af4e5069
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
