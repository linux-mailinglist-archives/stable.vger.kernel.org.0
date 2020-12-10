Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7842E2D6960
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393945AbgLJVFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:05:48 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5084 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393861AbgLJVFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:05:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd28d730000>; Thu, 10 Dec 2020 13:04:51 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 10 Dec
 2020 21:04:50 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 10 Dec 2020 21:04:50 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/31] 4.14.212-rc1 review
In-Reply-To: <20201210142602.099683598@linuxfoundation.org>
References: <20201210142602.099683598@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <c6d8e527d1a24287bd1d3cc41535bdf3@HQMAIL109.nvidia.com>
Date:   Thu, 10 Dec 2020 21:04:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607634291; bh=wwyMhzM9m9DEcrGhLhE+zBZlKNXrs8HHZRhRp4k8E4c=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=PUXHVRuQBP3v/+DP++jnTfr9nvFO+ZUK8f2RvX3vZNihAS4mjV2/K9u7bYP8jcULm
         +gQjeBcmzWfekNvk8rrnsmkTsvhsd49Eg+YTdD9mX+QNxOgqleSgh60fQjXXDvDRVJ
         SpfhGsD/FmMd16X9Zr/a8h6UZaYiJppY+CULDTHBiVJ6Xz/07NAP9eSXV6wA1ux0yn
         Dp3yuCMeEnjhPlTveJ2FhPrJQpUJ7mE16KTKoCgw8RnyFsO3pe6/vrSvtINLLdPP03
         6je+0yxqOZtlYirjysPKUMFoGObWB+rDg93e/CkuoznPQ+4tUdUyf+79AYMmzJPTwW
         AmnQRQjGfvQKg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Dec 2020 15:26:37 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.212 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.212-rc1.gz
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

Linux version:	4.14.212-rc1-gad2d75a4fc6e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
