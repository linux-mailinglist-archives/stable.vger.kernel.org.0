Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229B32A600B
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 10:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgKDJE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 04:04:26 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3931 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbgKDJDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 04:03:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa26e740000>; Wed, 04 Nov 2020 01:03:48 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Nov
 2020 09:03:45 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 4 Nov 2020 09:03:45 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 000/125] 4.14.204-rc1 review
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <38cf8c97840f4fc1a299512a0ba65f1d@HQMAIL107.nvidia.com>
Date:   Wed, 4 Nov 2020 09:03:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604480628; bh=uqyk5EsAm3JS+SAUJkYeBNbkFjqvqgLZzLQWHe1FHEg=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=chFo0XBA+QZr5Rb+nMSf9wOdCn/9AEmpVVEgg/RmC09rU1Jf0iXjSzd4vj3n+BUJ1
         WCk1uYmKb8ImXFxeC5mgGAL4OZjjuYHw9ea8Vf9jmK2UGSYCt4no1sp8sgL9RyG+DV
         PbE4tJBnuiHtBPfD3+07OsdCHBkfgbNd2BLxlQNbhYF4HusmA0eR2a5rT6UaKCMPpS
         OCaaVvOhorzwZlR2EGJBrY5wfS3WwskcjtP3sNWPPEZ12Fe2wQV32vIXKI1tbKQBgM
         srb1SqXX7x0CgrJHdmThvymeqa9zDCqIXoqG9aa0fyYYApVTyB9ijJ2tBf7kFkVfXs
         l+0CcwxafEvDw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 03 Nov 2020 21:36:17 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.204 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.204-rc1.gz
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
    10 boots:	10 pass, 0 fail
    16 tests:	16 pass, 0 fail

Linux version:	4.14.204-rc1-g8c25e7a92b2f
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
