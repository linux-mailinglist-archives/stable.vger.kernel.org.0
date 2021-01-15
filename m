Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDE42F8091
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 17:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbhAOQU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 11:20:28 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17751 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbhAOQU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 11:20:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6001c0a30000>; Fri, 15 Jan 2021 08:19:47 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 Jan
 2021 16:19:46 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 15 Jan 2021 16:19:46 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/103] 5.10.8-rc1 review
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a9195879679a4280b4c666be8d573617@HQMAIL105.nvidia.com>
Date:   Fri, 15 Jan 2021 16:19:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610727587; bh=p5DHC9MgvTaensLWO813Ow0/ksxYac8TYsKds531TZo=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=E5sV5Lmqv4fWVnPNC/00ejkh2WPNy8HR02S9HiUAzDb3DF9Dwy49dtFhyKJ+2skDj
         DA21mO7xm3FkeVSA2HuYL+ciCjAmx42nRCTn3uYlqHolANaqqCfTru8IWvq+9vKrUG
         ZdpaPnbqCVJ1mPg/odHHjD6niJkGtQeAYeXgPUJQ8Q2lMEwn1bWrEMz+cfelg28SdK
         UE8adSE6Ra9/E9aXCgDPXtZLB7Ue8aP959T1HC0Ac7ZtZksJeDPbs4kci2PjKotDq7
         vT3B+Sza5JJUMJGXOzJNqBQaGeu9gjGnWc+4A9ITb9EyjMcvWT6rJHXgqVfjkahsKm
         MyesWxD5goahw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 15 Jan 2021 13:26:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.8 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    64 tests:	64 pass, 0 fail

Linux version:	5.10.8-rc1-gc6e710bf849b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
