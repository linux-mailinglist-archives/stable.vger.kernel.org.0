Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89CD2D1457
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 16:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgLGPEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 10:04:45 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2077 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgLGPEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 10:04:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fce44650001>; Mon, 07 Dec 2020 07:04:05 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Dec
 2020 15:04:05 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 7 Dec 2020 15:04:05 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.14 00/20] 4.14.211-rc1 review
In-Reply-To: <20201206111555.569713359@linuxfoundation.org>
References: <20201206111555.569713359@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <040b47c8b372449c8669642e6f202362@HQMAIL111.nvidia.com>
Date:   Mon, 7 Dec 2020 15:04:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607353445; bh=Jnp3KWraTodT3PmmwP69uY2iIr921v2kZKt34/dbIMM=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=myDYwYVRQ4teD9BGcYfxvTh7ToDredJPHsqYH+zytU0vZoc7cZLkVzElPB2EfcUCq
         hBwMLrG2nWWNE/SD+5DvS5N1GEjN1p78gXC7IyPN3Wk257upuJBpGatDyzrY2WlwxC
         +pq4/wA/Yn8MjIuh7kACNhajJ6MWl1yg9YHT6IB6obckOrM8amfc+TAZr5oWRm2VfH
         SO/jP/7F9jorVpJ+aKiwqjNKRuiPnJ2wT1GWvwzWf+2amrPtKsDoFOznzV8tADg+og
         ky+DMm41cNQUZhfByBDBMNrmAS8igIC7PTHABUuC5yvHmy51e2hQvumz/i1yHcftpu
         B/m0YKN9Xav5A==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 06 Dec 2020 12:17:03 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.211 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.211-rc1.gz
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

Linux version:	4.14.211-rc1-geea918eb2691
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
