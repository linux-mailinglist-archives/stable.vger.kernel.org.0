Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA352B6E28
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 20:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgKQTLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 14:11:21 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13611 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgKQTLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 14:11:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb4205c0000>; Tue, 17 Nov 2020 11:11:24 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 19:11:20 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 17 Nov 2020 19:11:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/64] 4.4.244-rc1 review
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8e1c6d9035784ea0b4d73d3afc02a194@HQMAIL101.nvidia.com>
Date:   Tue, 17 Nov 2020 19:11:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605640284; bh=AAg3cJakkXhNTeRlH+i7/RjlVt2i1hdzZ6ZoQV/PUsU=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=jfCo7aQkJwRiPBodHWlpez05UD/C0/2R/TU6xlCpKDSsVRPZKHM23bD5TNAOxojN9
         qrn2IoB9NJ8l8qmuktx1LRtr3UhgHCf2UM7vdF9K1ejFlZQ9U9JhpiZpJWZWw7MqfS
         B2AyyDp4bYkFjLjyRCaBug6BzmMRxhZC8WDpay4hH8l22oqbPDtVLD78ryFNF1G/xL
         SFb/eH4G8huLW4DwbO8m0Pxtr2hD7vHjoHpysBMAr5mkI/e9lFgVK7956352Hr4sBP
         mdlY9OCPDjjxXqi2Nf1e4IkcIaGu2AlpwEYQChtUcE36rAs8DerRyOto/GjFnjT6eS
         M+aOt+mHzBX6A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Nov 2020 14:04:23 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.244 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.244-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    25 tests:	25 pass, 0 fail

Linux version:	4.4.244-rc1-g5c64a4febafe
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
