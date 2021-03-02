Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0027132AEE6
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbhCCAH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:07:28 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16864 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382413AbhCBJZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 04:25:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603e03940003>; Tue, 02 Mar 2021 01:21:24 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 09:21:24 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Mar 2021 09:21:24 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/661] 5.10.20-rc2 review
In-Reply-To: <20210301193642.707301430@linuxfoundation.org>
References: <20210301193642.707301430@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <8f6b387f2a8f490e8bd062805cf936cd@HQMAIL101.nvidia.com>
Date:   Tue, 2 Mar 2021 09:21:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614676885; bh=znNcv8kGPDQtm6cRD20tvyvyLv5tEtGqIYjK5NFwfmg=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=j3gC7iLnKirGWoDeIPTUG6SYw1Lamwc+3+rvK6BFDg0d95tKHGjPZlsp9b/tyRo1F
         u5tSxrBrcyiAnhlzOg4k4Y+5pNd0J1U8qM1xznG/XuV7H5dOItMWT/vI+YHh64V86K
         9nVSciTantXPzSllgg8Vl8DLOkPcurGw2172sJ1T9XV2zlphzOIvvGJTexGZgMZ+Jx
         7OJfAOnEnE6IRz0q9NRzJBAFT79urEOEStHla0eC6fM1sROaUirnvpXnJfZCMvPpVT
         9WW4oUwQGRHTHkBgblh/Y3DDBOIMNu8a4MuZoCnAxar4lkdD/Xsn6SJ1IK7dwmpeCo
         OB4zqIKDoBiTg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Mar 2021 20:37:55 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.20 release.
> There are 661 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 19:34:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc2.gz
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

Linux version:	5.10.20-rc2-g92929e15cdc0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
