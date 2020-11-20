Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BD82BB113
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgKTQ5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:57:32 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4140 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbgKTQ5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:57:32 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb7f5710000>; Fri, 20 Nov 2020 08:57:21 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 16:57:31 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 20 Nov 2020 16:57:31 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 00/15] 4.4.245-rc1 review
In-Reply-To: <20201120104539.534424264@linuxfoundation.org>
References: <20201120104539.534424264@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <34b75ca20921414c9380573d2d371417@HQMAIL109.nvidia.com>
Date:   Fri, 20 Nov 2020 16:57:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605891441; bh=6FfTOxP59H9I9Z36aJ+Gwk55pRf3eBYElZOrybnNP14=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=i7hQ1fYBe0rs0hd7T4OjRF2L/b7h5IVSvtEGrm73eikx3of1Wqt8YsMKO1DtnSB8Y
         UBcMMJ+8olmjvLLYtLXvCtip5f9L3yaJYUY06gQZAsRivge6ctKqzzz+CErHIYIPGL
         bkR9Tdp15nZsak+YOumf+H24b+W1mYfOR2TJ6Tw+TCZGCCd8/s392Wh7rLQ1MyXowd
         j2bR+5AxoHWb/lninCktlkkg/1C3q3QX7dd7MilHm0tXzsBEV95s2NzCCbJ3N+Iiqi
         MVLR1HPlS9tLTjOmMjPoqDzzMRiXFbKX5UkzVyeNZxqJk/lmImJE30C0lpUXlN43CF
         4cNH+BSwnuR1A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 20 Nov 2020 12:02:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.245 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2020 10:45:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.245-rc1.gz
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

Linux version:	4.4.245-rc1-g11095ab90e22
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
