Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E5332B1ED
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240905AbhCCAuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:50:25 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1621 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449404AbhCBQqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 11:46:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603e6b860001>; Tue, 02 Mar 2021 08:44:54 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 16:44:54 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Mar 2021 16:44:54 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/176] 4.14.223-rc3 review
In-Reply-To: <20210302122237.974772983@linuxfoundation.org>
References: <20210302122237.974772983@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <6e4feb6269a8494981bf4c9d1d9d17cb@HQMAIL111.nvidia.com>
Date:   Tue, 2 Mar 2021 16:44:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614703494; bh=/f9jjVrPiALidgAKTi4iQ+bGk6QUDqp0bO4GpmnEpo4=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=UXUaDBO5UvFnYIc81HxJLouOgmf12Ad8Z9XNvki5E/CKXDQpm7wnKNLtzKazZE5nh
         KWilZqBg0w8Pme1SmAdzsI2FAriChiuzBDK00IBPp/JGmJaBIUFw41PNFx/J13acDL
         ablfObFh0IYql2lMDx5orRFbKiANSHkpEVCjJetN4rtoTw/d8qTm1BCqaMhY8H2kJS
         zEkdpdXxIw4HSnbwx1dyXcpPN4h3SsrXdFGIwQ5EonUMVZNV8PqOvvfuoc0AWJGfoE
         YM2PffCO94jZM8gBD+y8uYdqY61W2YWUaphZTk/L1gIk9AJNd5QmdpgYKBMaN3lQO1
         Nv6WSlw2tyYqg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Mar 2021 13:26:45 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.223 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 12:22:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.223-rc3.gz
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

Linux version:	4.14.223-rc3-ga03a0d1d4a21
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
