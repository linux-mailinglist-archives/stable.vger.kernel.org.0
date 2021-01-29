Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C08A308D20
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 20:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbhA2TKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 14:10:30 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12438 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbhA2TJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 14:09:33 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60145d420003>; Fri, 29 Jan 2021 11:08:50 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 Jan
 2021 19:08:50 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 29 Jan 2021 19:08:50 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/30] 4.9.254-rc1 review
In-Reply-To: <20210129105910.583037839@linuxfoundation.org>
References: <20210129105910.583037839@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7002f2eaccbe4822ace69408bdf67448@HQMAIL105.nvidia.com>
Date:   Fri, 29 Jan 2021 19:08:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611947330; bh=g5eCi/8QPOpm1X2xJPxF1UWsFsdH9tgQBsoapFzwrqs=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=WMupgGVpeBgXJcSvA/8XVWjqXGvPmbWJVVg2nRkZsjErF4D4nAWmQw6UKpPf/C9oj
         P/eWPQBsLR3jYGq4ErTUGvFj1yAsuxTK4yvkAiPwzh/vtEGuALxOaX7uNzvz5OYpw7
         WecdjV9zRD7UeLMGhixPKTH/8ralOJxETmmbNYUlTpaSV/kV0QNwtRauwfp6cau61+
         oNDLoDrc3VYVFtBA+9SKhUOLYYFgzq0mLoYwbIecsmymwdhyTq34pzvlwjr1Jh/FlP
         6aTJpUzVEDNS7kkHlDP/8HZk+k7vTcwJmka6NzSbzcA+dVsyZrpAOKCJRi7lHMCLob
         pnZdmbxs7NZXg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 29 Jan 2021 12:06:36 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.254 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.254-rc1.gz
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
    16 boots:	16 pass, 0 fail
    30 tests:	30 pass, 0 fail

Linux version:	4.9.254-rc1-g1aa322729224
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
