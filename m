Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF0432B1D1
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhCCAst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:48:49 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5410 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449405AbhCBQqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 11:46:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603e6b880000>; Tue, 02 Mar 2021 08:44:56 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 16:44:55 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Mar 2021 16:44:55 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/658] 5.10.20-rc3 review
In-Reply-To: <20210302123520.857524345@linuxfoundation.org>
References: <20210302123520.857524345@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <2baa4bc321c14f0f8687c0d6e7a44aa0@HQMAIL101.nvidia.com>
Date:   Tue, 2 Mar 2021 16:44:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614703496; bh=K2cqfXZer8F54Y6pVb5OJqTam2/hncUDdJK5t71b1D0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=L2r+zTSWKOFAYhTyQBcfFh3aUNfZxCw7oPQIHOM6nFXdI4rvhCMo9KjCyPxe3Wx+3
         bu6mKUI7wHs6yEVgp7o/ZGge42r/CXdxic9MXitT+r0b7HNpQ/N+zbrEwKAPOGqsoZ
         QYlgD+VnFbYVRPAotPgBB4du0muhbdYD6Lj/gHYEmHIU/MoyedHI0oI7YnJpPTNIOr
         wM8UPr56wzmL+LOwkgtt5k2znUIC3iEZtrl9RYbB9kLM/9qiMc814dqzb+5jK6t7jh
         /b8lBo4bgztal3YRsBvY5TVCe7sq/XajAjmWjO5aCl43Cd5bNau0hFsKAkcN12HnHq
         S8nfpu4YOH6VA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Mar 2021 13:38:33 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.20 release.
> There are 658 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 12:32:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc3.gz
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

Linux version:	5.10.20-rc3-gf16bfb3dbcd5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
