Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221FA32AEE2
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbhCCAHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:07:06 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16267 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378954AbhCBJXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 04:23:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603e03940001>; Tue, 02 Mar 2021 01:21:24 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 09:21:23 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Mar 2021 09:21:23 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/246] 4.19.178-rc2 review
In-Reply-To: <20210301193544.489324430@linuxfoundation.org>
References: <20210301193544.489324430@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <80686b97f4a943b6b8ac5a7ab585a3e3@HQMAIL107.nvidia.com>
Date:   Tue, 2 Mar 2021 09:21:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614676884; bh=Hrmy5yzkbaZj0xDb1UsD6d1cwp6GGsgT+MifhK5G4Do=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=kPXrdYc21LTQFspqu11pOdc/iCuYDO1xv5PSWL2rrwU6LG0AlhTCPp8AclTfLKuqv
         Psfaa2WovIcd6iAE8Zj3aRK8Ub0ovmZ5TyyIyDnlc9IhElNXTWvrr5SkD4Kd6nuA2M
         +hODCVeASPXCL3xTVPB16gIGlhVD3X+zsmNaSRceTBo4lDRRo/Wj5iDNuPg6eOO50f
         XiFO7ZlJUGakDhU0cdWcyojJfa9LLt6nV+aBMXIyc4l9vid93seEJWkCBci99ZvAm8
         m1AqaWZ74yMhF/I/MZXxJxp5wrDacClIcj1YYserjA/1PIgJScQwf7m9ALBoOaPVaP
         6RY1AeiDJvVdQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Mar 2021 20:36:40 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.178 release.
> There are 246 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 19:35:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.178-rc2.gz
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

Linux version:	4.19.178-rc2-g0e2d946bd3c8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
