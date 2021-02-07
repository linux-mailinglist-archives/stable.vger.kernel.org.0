Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1838B31248B
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 14:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhBGN1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 08:27:01 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18746 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhBGN1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 08:27:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601fea7c0000>; Sun, 07 Feb 2021 05:26:20 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 7 Feb
 2021 13:26:20 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sun, 7 Feb 2021 13:26:20 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/57] 5.10.14-rc1 review
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <361dc1da83e64a4d89e5c81487890f4e@HQMAIL101.nvidia.com>
Date:   Sun, 7 Feb 2021 13:26:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612704380; bh=6MUwDLKCsEN1i4ToRiMCkpX/XBE9PZvoJ46gRlvgzDc=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=OBbeWtzqJtJ6ztuWiJw9wj1UwSb8wfGNji3OekK2HLAzLj5RxUziWFCiy56Z0Mk55
         iKy2mT09lgVVqVjpV0aKGXY2oy/XyEkz9k/Ta8FM5VPmm+2AxfzlsJ7bG9OXYUHDm+
         75FxZ/0SdtUdvrBZ42yscF0YD+1C4WcnkZDT98RtKCr2Bsu9qNuVBMCd9Zj1P+EnBg
         9PipH71bkLTKeZi0N8kYr23oGqtCKnhosPva8JCtyZHX3E0+XZmlLGhJRmPK2MaL6y
         ns0okWd5kskxctrDPOOQkXReo1dx6AsF3FOq7MBSVarw7/93Ilk9KBPL/d9t70VfNA
         N/q5MGPFv2HTA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 05 Feb 2021 15:06:26 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.14 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.14-rc1.gz
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
    65 tests:	65 pass, 0 fail

Linux version:	5.10.14-rc1-g58d18d6d116a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
