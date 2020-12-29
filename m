Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038152E721C
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 17:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgL2QIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 11:08:24 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8302 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgL2QIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 11:08:24 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5feb54500000>; Tue, 29 Dec 2020 08:07:44 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 29 Dec
 2020 16:07:43 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 29 Dec 2020 16:07:43 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/450] 5.4.86-rc2 review
In-Reply-To: <20201229103747.123668426@linuxfoundation.org>
References: <20201229103747.123668426@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <b0b3a73052ed4b678dcba2306f1a6618@HQMAIL105.nvidia.com>
Date:   Tue, 29 Dec 2020 16:07:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609258064; bh=j6XyuKbJi9LI7pPoSJn3/bSfl843mUj78AZ6ZjY+Ze4=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=WXS1ygWbOKYrkwHgdcZxMXX2CoO7Pr8QVzZYFO3+bubxR49zH7S4djlrdlQfpmhbx
         udvuPPwkpHBSIzn8FZQ2ODmF5Ea4oN4jNz/PZdojMdZFemw0N3tM6sDbmzAoEU78Ax
         lY1W1q0aVhTuRUCJc+vsLHIwerAPn5Pqo/BDne9wtP2v+7TUkdAsNSXjsIAWMXs2nH
         +J3Kx52NwNwmA8vF70H4sndMl6JKMzUTDx/AcfFRxwVSsU68bQRwgw7mgjH1rE2CCv
         sljbnIyZWBHB3hsMFUp2vZ7rNrFiIl3134Vpgl74vgGB6D9O47JdMPRlFg9j3WSOOU
         m9v1L9niJScoA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Dec 2020 11:53:14 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.86 release.
> There are 450 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 31 Dec 2020 10:36:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.86-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    12 builds:	12 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.86-rc2-gd797ea26c431
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
