Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EE72F808A
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 17:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbhAOQU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 11:20:27 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10218 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbhAOQU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 11:20:26 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6001c0a10000>; Fri, 15 Jan 2021 08:19:45 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 Jan
 2021 16:19:44 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 15 Jan 2021 16:19:44 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/43] 4.19.168-rc1 review
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <135e1780594a42af811d720b5143b802@HQMAIL111.nvidia.com>
Date:   Fri, 15 Jan 2021 16:19:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610727585; bh=vrhMhIzdzV2KneMLgT4xSAqN6ry4uZ0oLvJXi6H8u2s=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=pg+EKDFiblzV50Re1syqu29gAbHdYQA4xlUc7VI2ZLe+agYMDOpvW4CDSz0Pa4tGT
         8/gMXxW73rcY2Mowpr6Xq3XZgy6KBTQvG7510pVwEDGzf3U8oCiuHMtkAH2GM5hc4g
         LYvhj6mfwTXnz0oPiKsNo2Q4eLYOgL8jk5eTK2duPU0RdTDGfpTqibob10UAwCAiwa
         YxFYmda/uLKh4RcrwebAqcKjr8T8GXLopgyIXV8/BSjkbslWwSsJB889qN+Aoo0wdD
         N8FXp2tzIgxSy97BM0aNGin5jk2Zwvo0fDyOWvq/hs4EzwQeBUYUogqs+7ft8WbD9T
         q57QnV4dTQtbw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 15 Jan 2021 13:27:30 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.168 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.168-rc1.gz
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

Linux version:	4.19.168-rc1-g710affe26b43
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
