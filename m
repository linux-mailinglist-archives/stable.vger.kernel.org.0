Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C2E301692
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 17:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbhAWQE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 11:04:26 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10566 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbhAWQEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 11:04:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600bf35d0000>; Sat, 23 Jan 2021 01:58:58 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 23 Jan
 2021 09:58:52 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sat, 23 Jan 2021 09:58:53 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/22] 4.19.170-rc1 review
In-Reply-To: <20210122135731.921636245@linuxfoundation.org>
References: <20210122135731.921636245@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8213502c5b0842b9b1885c9930c92b5e@HQMAIL109.nvidia.com>
Date:   Sat, 23 Jan 2021 09:58:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611414147; bh=h9b1XLI130xU8/te4ciI+TrYVhdUS+oPVh/2q32hSyY=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=CA5xlW2KrnOzadpUh52qBdflTKOV0/44eytYOpDFtljR/Dh44GAb7t84lXPsP7xNj
         u/OHQh012xv9o0Fsic7XlcJsSRON2BWDWIEaPvcEd9zhk3ClY72EvLfXeTMM4Y/X2W
         UeJKf9mJHZYQHTztPFLR1Dq7G6gjRmILEO4MjYpsV74jdQ2liPVKSEYZ6XB757C7/Y
         MHVXkWXzjZI1/Ti/rZrXEoPS8Q1qwbA0bQbarMgGpR1LIrIpQ23Ld6ry5NhF9C+Wzw
         YoJy2rPefSXithoH82gCpeILjj1Z2y+cGUeiAtn5mr4a9ghZcV1bDGHlo9oRzr2uGS
         CUUSw3+8Xy7Rw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Jan 2021 15:12:18 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.170 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.170-rc1.gz
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

Linux version:	4.19.170-rc1-g6cb90163efb7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
