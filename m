Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B8C32AEE3
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhCCAHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:07:07 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7998 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377973AbhCBJXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 04:23:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603e03770000>; Tue, 02 Mar 2021 01:20:55 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 09:20:54 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Mar 2021 09:20:54 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 000/134] 4.9.259-rc1 review
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a41d12501a0a4971bd716461c88e1f43@HQMAIL109.nvidia.com>
Date:   Tue, 2 Mar 2021 09:20:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614676855; bh=BK3aZfeK/ssJq0qAMuLka+R3Ivryo21r0iABrZKLYxA=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=i+mpF3E2W+V9uiXXCEX3Ax1Zsa/fqL7gWgiMwr9eMZG52TdBkhJMoeVtzhXDzLInd
         zzc/wkg5bQhpixD9uiWoZNr3QyAJKLWx8VuUhU9qVacDrD9cVy5+wwB2Z223UvhjsR
         xokThelaR2kQPgr3zlkt7MWxiWtG3kW3cvm2xaiivL02d/2lrvCFqzTUQ0gmQq+k66
         2g5zMoFPJEnHRGtXrZ/iylr03dc4HB+aUS4IB59yTlX2Fn3Hr2FYEHQ7/UKFTEKqdw
         H8EWCm8T4F1PIoB3HBXSxj0oQ3aGJuc4nu+fJu4EBCyXmjV1LO06BvOOm8oLyo/TBR
         bxjuhvpl1FaHA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Mar 2021 17:11:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.259 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 16:09:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.259-rc1.gz
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

Linux version:	4.9.259-rc1-g5d97ed0c85ad
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
