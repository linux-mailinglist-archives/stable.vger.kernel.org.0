Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E0B2AC02A
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 16:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgKIPoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 10:44:54 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18232 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729897AbgKIPoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 10:44:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa963f90000>; Mon, 09 Nov 2020 07:44:57 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Nov
 2020 15:44:53 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 9 Nov 2020 15:44:53 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/85] 5.4.76-rc1 review
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <796bc1790a4e40d89414cabc5f35ac1b@HQMAIL105.nvidia.com>
Date:   Mon, 9 Nov 2020 15:44:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604936697; bh=KWnkD4vxGeVqxuY4d4D3dlSG4WGC1C2RfG/U/AqT+18=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=ikwdmjknksjj/Ims5+IcpKjG2WNkB6BAzew5GwFipoRmzyQncRonjUEHVSL7AVWVC
         rSWgc80OHIFwgZkSFgtC8PKHp+75VFy9O5S+xYkQoteGGJrrLjFT95x4v6dCYk7O9H
         Va9rSxbOYd/VWaELOTsPAoTbhtcaNkD/vwubS03yJCUbAR+V5nOsMi0fuhaw5cr+k9
         gbHkxkoo9DWHXFyqBbL4D4TgllKZ5NFYDhUWK+CDSGmCiMYoMa8qfmjWpTPU4n2Stn
         EpkelVAryDkVppOcPpqB7yMW0Z2Mq2o/wiWWyD+Q4e/9WOOWFTkbCg4zZf2ABE8YLp
         alm7h87biZxpg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 09 Nov 2020 13:54:57 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.76 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.76-rc1.gz
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

Linux version:	5.4.76-rc1-g0972a1f5fd7d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
