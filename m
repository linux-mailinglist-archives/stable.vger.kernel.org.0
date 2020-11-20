Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB692BB104
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbgKTQ4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:56:33 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17052 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730221AbgKTQ4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:56:33 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb7f5450000>; Fri, 20 Nov 2020 08:56:37 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 16:56:32 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 20 Nov 2020 16:56:32 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/16] 4.9.245-rc1 review
In-Reply-To: <20201120104539.706905067@linuxfoundation.org>
References: <20201120104539.706905067@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <12bb9543bce344ebae294e0ea49eeff8@HQMAIL109.nvidia.com>
Date:   Fri, 20 Nov 2020 16:56:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605891397; bh=NUyA7qK2mjtdmEVm+LPZVG4l0XOCIw/DoOsuAc2V6iA=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=qg5IFCdm8awy+0Maog2qlzbFVgB7XS2IzKGCb3uM9FHuTJCltX3RRNyF0xVREJiPQ
         TSQ38j9OHp1/l+p6gjoBaLI+2MxlkrTpk7yAqU9A1mpViopSWATpsJaJBxX7Y0M9Uv
         xX+hkvvBhiOsXyL8M1fwEmCUT2O3AKVToqxclQp2oT0z3O8HVmUUShtmBIXN/D4lih
         vDuv6bmNVtcmnfZdS3n9Y8vh/D7n+uzQYRnQvKOTM7PDAng1s9wcCaJ/yHlBuJTbiy
         i23pUjNd0kPVEOhx7+3cZTSUKBypP1Yqtd2goJLpjXaP1cg8ySESjKN89Twt5xjRDQ
         cu9qKSiGtiebw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Nov 2020 12:03:05 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.245 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.245-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    10 boots:	10 pass, 0 fail
    16 tests:	16 pass, 0 fail

Linux version:	4.9.245-rc1-gb75776b03db0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
