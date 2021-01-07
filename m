Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F03E2EE6B2
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 21:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbhAGUVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 15:21:10 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19567 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbhAGUVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 15:21:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff76d0e0001>; Thu, 07 Jan 2021 12:20:30 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 Jan
 2021 20:20:30 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 7 Jan 2021 20:20:30 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/29] 4.14.214-rc1 review
In-Reply-To: <20210107143052.973437064@linuxfoundation.org>
References: <20210107143052.973437064@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6597cb358bba43ba96d13e8cfb79f9e1@HQMAIL107.nvidia.com>
Date:   Thu, 7 Jan 2021 20:20:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610050830; bh=vwJcBcn6mSOa/Wd1zwiO8q9ZOSgIvvIpHyET1RxRGyk=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=ej5WlkU+6FoWJ/lz3XtSwOJobY2fMKWAleJRjZ0qNtI82KEHobYW9g7Ipt+Y4U1HY
         6nEGVDaaEUh0ulW8QUHpRrtB9aTeLLn2Q6smSMSv3sQOAPStmX/hpPdTvFD6tYW6+2
         YAHNKlJcHWKTnRwUNJNKKdswesaZj3vf+VN2IDJoD9rl1pfz1C8zVEilUzFVZlDYXx
         /bRScODPgS23VWlfuDn5cR4BA+gD5EMfTrCkhO7rNuV8eRNH5FjSuysctf+pP8nYFq
         1fiopeL0PBCpmkK4F91bNq6EGahxWL85jieaGAlFEUIeXAnV2uX0HSZuPUUdFjN4kN
         TqScvrWQFoX9A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 07 Jan 2021 15:31:15 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.214 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.214-rc1.gz
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
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.14.214-rc1-g78e4e5e07ab0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
