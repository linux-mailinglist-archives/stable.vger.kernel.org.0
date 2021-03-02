Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D4032AEE7
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhCCAHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:07:37 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16865 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382415AbhCBJZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 04:25:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603e03960002>; Tue, 02 Mar 2021 01:21:26 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 2 Mar
 2021 09:21:25 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 2 Mar 2021 09:21:25 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/338] 5.4.102-rc2 review
In-Reply-To: <20210301194420.658523615@linuxfoundation.org>
References: <20210301194420.658523615@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <db0021fa7ef7484898f98242462fca73@HQMAIL111.nvidia.com>
Date:   Tue, 2 Mar 2021 09:21:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614676886; bh=FsqymYnICtIiGKMQ8UJTl0hJmQSXdjOY5qpEXEKuius=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=JXR4G/2FAqU8iPxawGzmE0ICigdrFXGrOmgagYfdAqnY3Ey38wiXcchIV79A8Owuz
         KtDr82mPgEXjWmb/8Re0bXW6RdlT5LCXwraEj3MYqUkx55iOiLyVNbhK4PweiBmD6d
         Njv9lTWyO2ZBhhzPr5Mwd4s0wCMzSG/VmGOVhedCa4UmAFa3ilkWYcFRnE6E4FCWlc
         By8QPKx5StuI9WOLtgemLp5Yv5s2ABvRaTudsViFYIhYrSj3V2yQkmJwQXpomrBeUS
         2od/d2iDqmOzv3nyXNv9+K8mtUUBAQcA9A5wCbr8VPdehx+e/+X2LBkdqWnuOMiW37
         zoA8sDAG1N5jA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 01 Mar 2021 20:47:07 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.102 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 19:43:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.102-rc2.gz
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
    57 tests:	57 pass, 0 fail

Linux version:	5.4.102-rc2-g325244caeb99
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
