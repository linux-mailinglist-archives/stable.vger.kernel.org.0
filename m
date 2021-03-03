Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4E732BC4F
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447215AbhCCNsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:48:17 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16970 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352990AbhCCLzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 06:55:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603f569f0000>; Wed, 03 Mar 2021 01:27:59 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 3 Mar
 2021 09:27:58 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Wed, 3 Mar 2021 09:27:58 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/175] 4.14.223-rc4 review
In-Reply-To: <20210302192539.408045707@linuxfoundation.org>
References: <20210302192539.408045707@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <018e8d2bf5664c739acc48d5130c7e31@HQMAIL109.nvidia.com>
Date:   Wed, 3 Mar 2021 09:27:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614763679; bh=5F/+B+uIGaARSRCN3hblC5jGcmnoI5w/KCi9DLZ6Sis=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=n9Ye3njyoP9+7nI9TbkhSriwZhQYC6m4DohSJEwf0n2qsUdCnlXG740CW2FAkXZMi
         +m0p1kSP+kfmcuxhd0H4IwffO7lp5mHRElHuOGIMz1t0AqUlpzQPUGl677UKSbQPuT
         CLnUXazs0PLIAPtBPvs8NG+9Iq35Xh1N+a+2DmkE/loxmjW3vqe9Hvi/KbBcz7h/3t
         DBPVEYtiDdHh0DiReY/Jjl1YRjRs0AMy6grdz/3Dc1XyOMs6EztYWDm4SSxHxEwy+2
         8JKAc6HHsX0/IaHUePJTT79757QPT3QbMmv76CuGWTxHiR7cWaG/dwbfxJ18Kmr6UP
         S9s5NBZSlGSZQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 02 Mar 2021 20:28:05 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.223 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.223-rc4.gz
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

Linux version:	4.14.223-rc4-g451d68c3cf2f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
