Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93172DA9B5
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 10:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgLOJGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 04:06:52 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9997 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbgLOJGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 04:06:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd87c800005>; Tue, 15 Dec 2020 01:06:08 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Dec
 2020 09:06:08 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 15 Dec 2020 09:06:08 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/36] 5.4.84-rc1 review
In-Reply-To: <20201214172543.302523401@linuxfoundation.org>
References: <20201214172543.302523401@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1a4b40620cf44bc4904e30973a014d54@HQMAIL109.nvidia.com>
Date:   Tue, 15 Dec 2020 09:06:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608023168; bh=s0tZNAcsDtWpd01Nkbe3RfliG1axrFvUV7mWNZXDcOI=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=NiOkSzshOaLcmov6PMHg+K1TVORiCejoLbOPWfBMVHJxr9pvixwfgqHl8MZpSp4hS
         FijH8HcFi5vR6NajIXfJzNpEbrA0HwMri/2BJMPnS0YtVMPXr8nxGwlOe8fbKNyAc7
         /kklPZ1Aoj05DlGJKhuGLj6fwkpxjasrdWr6KLMsND7wX5RmzqCk6ZuiqSNtxnBJ/g
         myAr1k4xhZFy8XjGQ3iug6InGcB1tqzllLlfbldlM5GhJQ1C35ew4qDuhC5P09LJ8X
         hrCWzEGRstyvGP1fow/F0EJVRy68yN4Cd6eNJB/PHrCQ7Fo/Esz/IyYPcNhM+HftkQ
         RwISoPKbubr5w==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Dec 2020 18:27:44 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.84 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.84-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.84-rc1-gfbaf54ae613a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
